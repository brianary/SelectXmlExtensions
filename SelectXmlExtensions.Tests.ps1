# Pester test, see https://github.com/Pester/Pester/wiki
# Invoke-Pester .\SelectXmlExtensions.Tests.ps1

& "$PSScriptRoot\Build-Module.ps1"
& "$PSScriptRoot\Import-Module.ps1"

Describe 'SelectXmlExtensions' {
	Context Add {
		It "Given source document '<XmlDocument>' searched for '<XPath>' and -Xml '<Xml>' and default position, return '<Expected>'" -TestCases @(
			@{ XmlDocument = '<a/>'; XPath = '/a'; Xml = '<b/>'; Expected = '<a><b /></a>' }
		) {
			Param($XmlDocument,$XPath,$Xml,$Expected)
			[xml]$result = Select-Xml $XPath -Xml ([xml]$XmlDocument) |Add-Xml $Xml
			$result.OuterXml |Should -BeExactly $Expected
		}
	}
}
