[CmdletBinding()] Param()
pushd $PSScriptRoot
$module = Resolve-Path .\src\SelectXmlExtensions\bin\*\*\publish\SelectXmlExtensions.dll |
	sort LastWriteTime -Descending |
	select -First 1
$base = Split-Path $module
Import-Module $module -vb
New-MarkdownHelp -Module SelectXmlExtensions -OutputFolder .\docs -ErrorAction SilentlyContinue
Update-MarkdownHelp docs
New-ExternalHelp docs -OutputPath $base -Force
popd
