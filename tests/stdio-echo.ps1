[Console]::InputEncoding = [Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
$line = [Console]::ReadLine()
[Console]::WriteLine($line)
[Console]::Error.WriteLine('stderr-only-marker')
exit 7
