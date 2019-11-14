#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0)][ValidateSet('Debug','Release')][string] $Configuration = 'Debug',
[switch] $Publish,
[switch] $Clean,
[switch] $Install
)

pushd $PSScriptRoot
$targetFramework = (Select-Xml '/Project/PropertyGroup/TargetFramework/text()' `
	.\src\SelectXmlExtensions\SelectXmlExtensions.fsproj).Node.Value
$pubdir = ".\src\SelectXmlExtensions\bin\$Configuration\$targetFramework"
if($Clean)
{
	dotnet clean
	Remove-Item .\src\SelectXmlExtensions\bin -Recurse -Force
}
if((Get-Command New-ExternalHelp -EA 0)) { New-ExternalHelp docs -OutputPath .\src\SelectXmlExtensions -Force }
else { Write-Warning 'Unable to update MAML help, is platyPS installed?' }
dotnet build -c $Configuration
if($Publish) {dotnet publish -c $Configuration; $pubdir += '\publish'}
dotnet pack -c $Configuration
(Get-Item $pubdir\SelectXmlExtensions.dll).VersionInfo
if($Install)
{
	Write-Warning "Not working yet"
	$modpath = Join-Path ($env:PSModulePath -split ';')[0] SelectXmlExtensions |
		Join-Path -ChildPath '1.0.0'
	mkdir $modpath -ErrorAction SilentlyContinue
	cp $pubdir $modpath -Recurse
}
popd
