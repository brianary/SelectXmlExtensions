# see https://docs.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest
# and https://docs.microsoft.com/powershell/module/microsoft.powershell.core/new-modulemanifest
@{
RootModule = 'SelectXmlExtensions.dll'
ModuleVersion = '1.1.3'
CompatiblePSEditions = @('Core')
GUID = 'b830f4ec-f7cf-4df4-97bb-aaa13fb125c9'
Author = 'Brian Lalonde'
CompanyName = 'Unknown'
Copyright = 'Copyright © 2019 Brian Lalonde'
Description = 'PowerShell cmdlets that Select-Xml can compose into pipelines'
PowerShellVersion = '7.0'
# RequiredModules = ,'Microsoft.PowerShell.Utility'
FunctionsToExport = @() # '*'
CmdletsToExport = 'Add-Xml', 'Get-XmlValue', 'Remove-Xml', 'Set-XmlValue'
VariablesToExport = @() # '*'
# AliasesToExport = 'axml', 'gxml', 'rxml', 'sxml'
FileList = 'SelectXmlExtensions.dll', 'SelectXmlExtensions.dll-Help.xml'
PrivateData = @{
    PSData = @{
        Tags = 'XML', 'SelectXmlInfo'
        LicenseUri = 'https://github.com/brianary/SelectXmlExtensions/blob/master/LICENSE'
        ProjectUri = 'https://github.com/brianary/SelectXmlExtensions/'
        IconUri = 'http://webcoder.info/images/SelectXmlExtensions.svg'
		# ReleaseNotes = ''
		# PS7: A list of external modules that this module is dependent upon.
		# ExternalModuleDependencies = ,'Microsoft.PowerShell.Utility'
    }
}
}
