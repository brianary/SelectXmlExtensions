pushd $PSScriptRoot
$framework = (Select-Xml '/Project/PropertyGroup/TargetFramework/text()' .\src\SelectXmlExtensions\SelectXmlExtensions.fsproj).Node.Value
Import-Module .\src\SelectXmlExtensions\bin\Debug\$framework\publish\SelectXmlExtensions.dll -vb
popd
