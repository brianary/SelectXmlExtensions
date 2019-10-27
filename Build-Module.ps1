pushd $PSScriptRoot
dotnet build
dotnet publish
New-ExternalHelp docs -OutputPath src\SelectXmlExtensions\bin\Debug\netcoreapp3.0\publish
popd
