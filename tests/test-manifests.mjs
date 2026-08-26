import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '..');
const read = file => JSON.parse(fs.readFileSync(path.join(root, file), 'utf8'));
const metadata = read('plugin.metadata.json');
const argsFor = replacement => metadata.runtime.args.map(arg => arg.replace('${CLAUDE_PLUGIN_ROOT}', replacement));
for (const file of ['.codex-plugin/plugin.json', '.claude-plugin/plugin.json', '.zcode-plugin/plugin.json', 'plugin.json', 'gemini-extension.json']) {
  const manifest = read(file);
  assert.equal(manifest.name, metadata.name, file);
  assert.equal(manifest.version, metadata.plugin_version, file);
  assert.equal(manifest.description, metadata.description, file);
}
assert.equal(read('.codex-plugin/plugin.json').mcpServers, './.mcp.json');
const codex = read('.mcp.json').mcpServers;
assert.deepEqual(Object.keys(codex), ['HAPAtlas']);
assert.deepEqual(codex.HAPAtlas.args, argsFor('.'));
assert.equal(codex.HAPAtlas.cwd, '.');
assert.deepEqual(codex.HAPAtlas.env_vars, metadata.runtime.platform_env_vars);
assert.deepEqual(metadata.runtime.platform_env_vars, ['OS', 'PROCESSOR_ARCHITECTURE', 'PROCESSOR_ARCHITEW6432', 'WINDIR']);
assert.equal(codex.HAPAtlas.command, metadata.runtime.command);
assert.equal(codex.HAPAtlas.startup_timeout_sec, metadata.runtime.startup_timeout_sec);
for (const file of ['.claude-plugin/plugin.json', '.zcode-plugin/plugin.json']) {
  const portable = read(read(file).mcpServers).mcpServers;
  assert.deepEqual(Object.keys(portable), ['HAPAtlas']);
  assert.deepEqual(portable.HAPAtlas.args, metadata.runtime.args);
  assert.equal(portable.HAPAtlas.command, metadata.runtime.command);
}
assert.deepEqual(read('mcp.json').mcpServers.hapatlas.args, argsFor('${PLUGIN_ROOT}'));
assert.deepEqual(read('gemini-extension.json').mcpServers.HAPAtlas.args, argsFor('${extensionPath}'));
const provenance = read('provenance.json');
for (const key of ['source_commit', 'zip_sha256', 'inventory_sha256', 'runtime_manifest_sha256', 'package_implementation']) {
  assert.equal(provenance.runtime[key], metadata.runtime.release[key], key);
}
assert.equal(provenance.capability_guidance.source_commit, metadata.runtime.release.source_commit);
assert.equal(provenance.universal_skill.handoff_source_commit, metadata.runtime.release.source_commit);
console.log('PASS canonical metadata, client launch declarations, single-server definitions, and runtime provenance');
