pushd $PSScriptRoot
$framework = (Select-Xml '/Project/PropertyGroup/TargetFramework/text()' .\src\SelectXmlExtensions\SelectXmlExtensions.fsproj).Node.Value
Import-Module .\src\SelectXmlExtensions\bin\Debug\$framework\publish\SelectXmlExtensions.dll -vb
New-MarkdownHelp -Module SelectXmlExtensions -OutputFolder .\docs -ErrorAction SilentlyContinue
Update-MarkdownHelp docs
New-ExternalHelp docs -OutputPath src\SelectXmlExtensions\bin\Debug\$framework\publish -Force
popd
