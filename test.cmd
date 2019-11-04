.paket\paket.exe install
pwsh -Command "cd %0\..; Import-Module .\packages\Pester\tools\Pester.psm1; Invoke-Pester .\SelectXmlExtensions.Tests.ps1"
