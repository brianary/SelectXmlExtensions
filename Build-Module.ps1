#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0)][ValidateSet('Debug','Release')][string] $Configuration = 'Debug',
[switch] $Clean
)

pushd $PSScriptRoot
if($Clean)
{
	Remove-Item .\src\SelectXmlExtensions\bin\Debug\$framework\publish -Recurse -Force -ErrorAction SilentlyContinue
	Remove-Item .\src\SelectXmlExtensions\bin\Release\$framework\publish -Recurse -Force -ErrorAction SilentlyContinue
	dotnet clean
}
dotnet build --configuration $Configuration
dotnet publish --configuration $Configuration
$framework = (Select-Xml '/Project/PropertyGroup/TargetFramework/text()' .\src\SelectXmlExtensions\SelectXmlExtensions.fsproj).Node.Value
if(!(Get-Command New-ExternalHelp -ErrorAction SilentlyContinue)) { Write-Warning 'Unable to update MAML help, is platyPS installed?' }
else { New-ExternalHelp docs -OutputPath src\SelectXmlExtensions\bin\$Configuration\$framework\publish -Force }
(Get-Item .\src\SelectXmlExtensions\bin\$Configuration\$framework\publish\SelectXmlExtensions.dll).VersionInfo
popd
