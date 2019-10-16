dotnet clean
dotnet build
dotnet publish
Import-Module "$((ls src -dir -r -fi publish).FullName)\SelectXmlExtensions.dll"
