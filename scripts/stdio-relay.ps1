# Windows PowerShell 5.1 does not reliably inherit redirected native stdio.
# Compile a small .NET Framework relay using the OS compiler, not a .NET SDK.
if (-not ('HapAtlasBootstrap.StdioRelay' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Diagnostics;
using System.Threading.Tasks;

namespace HapAtlasBootstrap
{
    public static class StdioRelay
    {
        public static int Run(string executable, string arguments, string directory)
        {
            var start = new ProcessStartInfo(executable, arguments);
            start.UseShellExecute = false;
            start.CreateNoWindow = true;
            start.WindowStyle = ProcessWindowStyle.Hidden;
            start.WorkingDirectory = directory;
            start.RedirectStandardInput = true;
            start.RedirectStandardOutput = true;
            start.RedirectStandardError = true;
            using (var child = Process.Start(start))
            {
                if (child == null) throw new InvalidOperationException("Unable to start the verified HAPAtlas launcher.");
                try
                {
                    var input = Console.OpenStandardInput().CopyToAsync(child.StandardInput.BaseStream);
                    input.ContinueWith(delegate(Task completed) {
                        try { child.StandardInput.Close(); } catch (InvalidOperationException) { }
                    }, TaskScheduler.Default);
                    var output = child.StandardOutput.BaseStream.CopyToAsync(Console.OpenStandardOutput());
                    var error = child.StandardError.BaseStream.CopyToAsync(Console.OpenStandardError());
                    child.WaitForExit();
                    Task.WaitAll(output, error);
                    return child.ExitCode;
                }
                finally
                {
                    if (!child.HasExited) child.Kill();
                }
            }
        }
    }
}
'@
}
