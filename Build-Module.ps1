pushd $PSScriptRoot
dotnet build --version-suffix $(Get-Date -f yyyyMMddHHmmss)
dotnet publish
$framework = (Select-Xml '/Project/PropertyGroup/TargetFramework/text()' .\src\SelectXmlExtensions\SelectXmlExtensions.fsproj).Node.Value
New-ExternalHelp docs -OutputPath src\SelectXmlExtensions\bin\Debug\$framework\publish -Force
popd
