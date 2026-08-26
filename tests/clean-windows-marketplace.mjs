import assert from 'node:assert/strict';
import { spawn, spawnSync, execFileSync } from 'node:child_process';
import { createInterface } from 'node:readline';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';

// Run only in the disposable Windows acceptance runner, never a developer profile.
assert.equal(process.platform, 'win32');
assert.equal(process.env.HAPATLAS_DISPOSABLE_ACCEPTANCE, '1', 'Disposable-profile opt-in required');
const root = path.resolve(import.meta.dirname, '..');
const metadata = JSON.parse(fs.readFileSync(path.join(root, 'plugin.metadata.json'), 'utf8'));
const pin = metadata.runtime.release;
const codexJs = process.env.HAPATLAS_CODEX_JS;
assert.ok(codexJs && fs.existsSync(codexJs));
const local = process.env.LOCALAPPDATA;
const installRoot = path.join(local, 'HAPAtlas', 'bin');
const cacheRoot = path.join(local, 'HAPAtlas', 'PluginCache');
assert.equal(fs.existsSync(installRoot), false, 'Runner must not have HAPAtlas installed');
assert.equal(fs.existsSync(cacheRoot), false, 'Runner must not have a HAPAtlas download cache');
const checks = [];
const check = name => { checks.push(name); console.log(`PASS ${name}`); };

class Rpc {
  constructor(command, args) {
    this.next = 1;
    this.pending = new Map();
    this.stderr = '';
    this.startupErrors = [];
    this.process = spawn(command, args, { cwd: os.tmpdir(), windowsHide: true, stdio: ['pipe', 'pipe', 'pipe'],
      env:{...process.env, RUST_LOG:'codex_core::mcp_connection_manager=debug,codex_rmcp_client=debug,rmcp=debug'} });
    this.process.stderr.on('data', chunk => { this.stderr = (this.stderr + chunk).slice(-12000); });
    createInterface({ input: this.process.stdout }).on('line', line => {
      let frame;
      try { frame = JSON.parse(line); }
      catch { this.fail(new Error(`Non-JSON stdout: ${line.slice(0,200)}`)); return; }
      if (frame.method === 'mcpServer/startupStatus/updated' && frame.params?.status === 'failed') {
        this.startupErrors.push(frame.params);
      }
      const item = this.pending.get(frame.id);
      if (!item) return;
      clearTimeout(item.timer);
      this.pending.delete(frame.id);
      if (frame.error) item.reject(new Error(JSON.stringify(frame.error)));
      else item.resolve(frame.result);
    });
    this.process.on('error', error => this.fail(error));
    this.process.on('exit', code => this.fail(new Error(`RPC process exited ${code}: ${this.stderr}`)));
  }
  fail(error) {
    for (const item of this.pending.values()) { clearTimeout(item.timer); item.reject(error); }
    this.pending.clear();
  }
  request(method, params = {}, timeout = 420000) {
    const id = this.next++;
    return new Promise((resolve, reject) => {
      const timer = setTimeout(() => {
        this.pending.delete(id);
        reject(new Error(`Timeout ${method}: ${this.stderr}`));
      }, timeout);
      this.pending.set(id, { resolve, reject, timer });
      this.process.stdin.write(JSON.stringify({ jsonrpc: '2.0', id, method, params }) + '\n');
    });
  }
  notify(method, params = {}) { this.process.stdin.write(JSON.stringify({ jsonrpc:'2.0', method, params }) + '\n'); }
  async close() {
    this.process.stdin.end();
    if (this.process.exitCode === null) {
      await Promise.race([new Promise(resolve => this.process.once('exit', resolve)), new Promise(resolve => setTimeout(resolve, 3000))]);
    }
    if (this.process.exitCode === null) {
      // Only the process tree this test spawned, in a disposable runner.
      spawnSync('taskkill.exe', ['/PID', String(this.process.pid), '/T', '/F'], { windowsHide: true, stdio: 'ignore' });
    }
  }
}

async function appServer() {
  const rpc = new Rpc(process.execPath, [codexJs, 'app-server', '--enable', 'plugins']);
  await rpc.request('initialize', { clientInfo: { name:'hapatlas_acceptance', version:'1.0.0' }, capabilities:{ experimentalApi:true } });
  rpc.notify('initialized');
  return rpc;
}
function body(response) {
  const result = response.result ?? response;
  if (result.structuredContent?.ok !== undefined) return result.structuredContent;
  return JSON.parse(result.content.find(item => item.type === 'text').text);
}
function findInstalledPlugin() {
  const candidates = [];
  const base = path.join(os.homedir(), '.codex', 'plugins', 'cache');
  function walk(dir, depth) {
    if (depth > 6 || !fs.existsSync(dir)) return;
    const manifest = path.join(dir, '.codex-plugin', 'plugin.json');
    if (fs.existsSync(manifest) && JSON.parse(fs.readFileSync(manifest, 'utf8')).name === 'hapatlas') candidates.push(dir);
    for (const entry of fs.readdirSync(dir, { withFileTypes:true })) if (entry.isDirectory() && !entry.isSymbolicLink()) walk(path.join(dir, entry.name), depth + 1);
  }
  walk(base, 0);
  assert.equal(candidates.length, 1, 'Exactly one installed HAPAtlas plugin');
  return candidates[0];
}
function runBootstrap(installed, ...args) {
  return spawnSync('powershell.exe', ['-NoLogo','-NoProfile','-NonInteractive','-ExecutionPolicy','Bypass','-File',path.join(installed,'scripts','runtime-bootstrap.ps1'),...args],
    { cwd:os.tmpdir(), windowsHide:true, encoding:'utf8', timeout:420000 });
}
function active() { return fs.readFileSync(path.join(installRoot,'active.txt'),'utf8').trim(); }
function userPath() {
  return execFileSync('powershell.exe', ['-NoProfile','-Command',"[Environment]::GetEnvironmentVariable('Path','User')"], { windowsHide:true, encoding:'utf8' }).trim();
}

const marketplace = path.resolve(process.env.HAPATLAS_ACCEPTANCE_MARKETPLACE);
execFileSync(process.execPath, [codexJs, 'plugin', 'marketplace', 'add', marketplace], { windowsHide:true, encoding:'utf8' });
check('Add staged Atlas Marketplace through the client CLI');
let app = await appServer();
let installed;
try {
  const marketplacePath = path.join(marketplace,'.agents','plugins','marketplace.json');
  await app.request('plugin/install', { marketplacePath, pluginName:'hapatlas' });
  installed = findInstalledPlugin();
  check('Install exactly one plugin through the marketplace service');
  const offlineFirst = runBootstrap(installed, '-InstallOnly', '-Offline');
  assert.notEqual(offlineFirst.status, 0);
  assert.equal(offlineFirst.stdout, '', `Bootstrap must keep stdout clear: ${offlineFirst.stdout}`);
  assert.match(offlineFirst.stderr, /BOOTSTRAP_OFFLINE/);
  assert.equal(fs.existsSync(installRoot), false);
  check('Fresh profile without network fails precisely and never activates a runtime');
  const resolvedMcp = spawnSync(process.execPath, [codexJs,'mcp','get','HAPAtlas','--json'], {encoding:'utf8',windowsHide:true});
  console.log('Client launch declaration:', resolvedMcp.stdout || resolvedMcp.stderr);
  await app.close();
  app = await appServer();
  const plugin = await app.request('plugin/read', { marketplacePath, pluginName:'hapatlas' });
  assert.ok(plugin.plugin.skills.some(skill => ['use-hapatlas','hapatlas:use-hapatlas'].includes(skill.name) && skill.enabled),
    `Enabled workflow skill expected; skills=${JSON.stringify(plugin.plugin.skills)}`);
  check('Restart discovers use-hapatlas skill');
  const started = await app.request('thread/start', { cwd:os.tmpdir(), ephemeral:true, experimentalRawEvents:false });
  // Thread creation schedules MCP startup asynchronously; an immediate empty
  // inventory is not a completed handshake, especially on the first download.
  const startupDeadline = Date.now() + 330000;
  let status;
  let hap;
  do {
    status = await app.request('mcpServerStatus/list', { limit:100 });
    hap = status.data.filter(server => Object.values(server.tools).some(tool => tool.name === 'hapatlas_project_scout'));
    if (hap.length > 0) break;
    assert.equal(app.startupErrors.length, 0, `MCP startup failed: ${JSON.stringify(app.startupErrors)}; ${app.stderr}`);
    await new Promise(resolve => setTimeout(resolve, 2000));
  } while (Date.now() < startupDeadline);
  assert.equal(hap.length, 1, `One loaded HAPAtlas MCP expected; status=${JSON.stringify(status)}; stderr=${app.stderr}`);
  const server = hap[0];
  const tools = Object.values(server.tools);
  assert.equal(tools.length, 21);
  assert.equal(tools.reduce((count, tool) => count + tool.inputSchema.properties.action.enum.length, 0), 100);
  assert.equal(active(), pin.package_implementation);
  check('First-use automatic download/install and client MCP discovery: 21 tools, 100 actions');
  const config = fs.readFileSync(path.join(os.homedir(),'.codex','config.toml'),'utf8');
  assert.doesNotMatch(config, /^\[mcp_servers(?:\.|\])/m);
  check('No standalone/global MCP entry');
  for (const document of ['index','action-gates','workflow-guidance','adapter-capabilities','space-workflow-v1','input-coverage']) {
    const result = body(await app.request('mcpServer/tool/call', {
      threadId:started.thread.id, server:server.name, tool:'hapatlas_contract_get',
      arguments:{ action:document === 'index' ? 'index' : 'read-static', document }
    }));
    assert.equal(result.ok, true, `${document}: ${JSON.stringify(result.error)}`);
    check(`Static contract without HAP/session: ${document}`);
  }
  const scout = body(await app.request('mcpServer/tool/call', {
    threadId:started.thread.id, server:server.name, tool:'hapatlas_project_scout', arguments:{ action:'summary', limit:10 }
  }));
  assert.equal(scout.error?.code, 'NO_HAP_SESSION');
  check('Project Scout returns NO_HAP_SESSION');
} finally { await app.close(); }

const firstPath = userPath();
let result = runBootstrap(installed, '-InstallOnly', '-Offline');
assert.equal(result.status, 0, result.stderr);
assert.equal(active(), pin.package_implementation);
assert.equal(userPath(), firstPath);
check('Offline warm-cache reuse is idempotent and preserves user PATH');
const raw = new Rpc('powershell.exe', ['-NoLogo','-NoProfile','-NonInteractive','-ExecutionPolicy','Bypass','-File',path.join(installed,'scripts','runtime-bootstrap.ps1'),'-Offline']);
try {
  const init = await raw.request('initialize', { protocolVersion:'2025-06-18', capabilities:{}, clientInfo:{name:'HAPAtlas — offline',version:'1.0'} });
  assert.equal(init.serverInfo.name, 'HAPAtlas');
  raw.notify('notifications/initialized');
  assert.equal((await raw.request('tools/list')).tools.length, 21);
  check('Byte-stream MCP relay and offline restart');
} finally { await raw.close(); }

const cache = path.resolve(cacheRoot, pin.zip_sha256);
const retained = path.resolve(cacheRoot, 'test-retained-' + pin.zip_sha256);
assert.equal(path.dirname(cache), path.resolve(cacheRoot));
assert.equal(path.dirname(retained), path.resolve(cacheRoot));
assert.equal(fs.lstatSync(cache).isSymbolicLink(), false);
assert.equal(fs.existsSync(retained), false);
fs.renameSync(cache, retained);
try {
  result = runBootstrap(installed, '-InstallOnly','-Offline');
  assert.notEqual(result.status, 0);
  assert.match(result.stderr, /BOOTSTRAP_OFFLINE/);
  assert.equal(active(), pin.package_implementation);
  check('Missing cache offline fails precisely without changing activation');
} finally { fs.renameSync(retained, cache); }
fs.appendFileSync(path.join(cache,'bundle','README.md'), '\nacceptance corruption fixture\n');
result = runBootstrap(installed, '-InstallOnly');
assert.equal(result.status, 0, result.stderr);
assert.equal(active(), pin.package_implementation);
assert.equal(userPath(), firstPath);
assert.ok(fs.readdirSync(cacheRoot).some(name => name.startsWith('quarantine-')));
check('Corrupt cached content is quarantined and recovered from the exact public release');

const evidence = { result:'PASS', plugin_version:metadata.plugin_version, runtime_source:pin.source_commit,
  zip_sha256:pin.zip_sha256, implementation:pin.package_implementation,
  candidate_commit:process.env.GITHUB_SHA, runner:'fresh GitHub-hosted Windows', checks,
  boundaries:['No HAP mutation tools','No model/API calls','No preinstalled HAPAtlas','No manual runtime ZIP install','No Carrier content in CI'] };
fs.mkdirSync(path.join(root,'artifacts'), { recursive:true });
fs.writeFileSync(path.join(root,'artifacts','clean-windows-acceptance.json'), JSON.stringify(evidence,null,2)+'\n');
console.log(JSON.stringify(evidence,null,2));
