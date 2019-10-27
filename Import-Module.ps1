pushd $PSScriptRoot
dotnet publish
Import-Module "$((ls src -dir -r -fi publish).FullName)\SelectXmlExtensions.dll"
popd
