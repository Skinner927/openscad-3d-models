$openscad = 'C:\Program Files\OpenSCAD\openscad.exe'

# File = @("value of model", "value of model")
$models = @{
  'gears' = @('usb', 'planet', 'sun');
  'shafts' = @('sun_stepper2arm');
}


$ErrorActionPreference = 'Stop'

# CD to where this script lives
Set-Location $PSScriptRoot
$out_dir = '.\out'

# RM out dir if it exist
if (Test-Path -LiteralPath $out_dir) {
  Remove-Item -LiteralPath $out_dir -Recurse -Force | Out-Null
}
New-Item -Path $out_dir -ItemType Directory -Force | Out-Null

foreach ($file_name in $models.Keys) {
  foreach ($name in $models[$file_name]) {
    $out_name = "$($file_name)_$($name)"
    if ($file_name -eq $name) {
      $out_name = $name;
    }
    # Once again, Powershell is a PoS. Need to escape quotes with backslash even
    # though the escape character in PS is backtick. I suspect this is likley a
    # downstream Win32 issue, but it doesn't matter whose fault, it's stupid.
    $argz = @('-D', "model=\`"$($name)\`"", '-o', "$out_dir\$($out_name).stl", '--hardwarnings', "$($file_name).scad")
    Write-Host "Rendering $($name): $argz"

    $proc = Start-Process -FilePath $openscad -ArgumentList $argz -WorkingDirectory $PSScriptRoot -PassThru -Wait
    if ((-not $?) -or ($proc.ExitCode -ne 0)) {
      # Using $? and $LASTEXITCODE didn't work, so Start-Process it is.
      Write-Error "Failed on $name  ExitCode=$($proc.ExitCode)"
      Exit 1
    }
  }

}

Write-Host ''
Write-Host 'Success  ~:D'
