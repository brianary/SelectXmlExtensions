[CmdletBinding()] Param()
pushd $PSScriptRoot
$module = Resolve-Path .\src\SelectXmlExtensions\bin\*\*\SelectXmlExtensions.psd1,
	.\src\SelectXmlExtensions\bin\*\*\publish\SelectXmlExtensions.psd1 |
	sort LastWriteTime -Descending |
	select -First 1
$base = Split-Path $module
try {Import-Module $module -vb -ErrorAction Stop}
catch {Write-Error 'Unable to import module'; throw}
$envPath,$env:Path = $env:Path,'' # prevent pulling duplicate cmdlets into documentation
New-MarkdownHelp -Module SelectXmlExtensions -OutputFolder .\docs -ErrorAction SilentlyContinue
$env:Path = $envPath
Update-MarkdownHelp docs
New-ExternalHelp docs -OutputPath $base -Force
popd
