# Pester tests, see https://github.com/Pester/Pester/wiki
$envPath = $env:Path # avoid testing the wrong cmdlets
$module = Import-Module (Resolve-Path ./src/*/bin/Debug/*/*.psd1) -PassThru -vb
Import-LocalizedData -BindingVariable manifest -BaseDirectory ./src/* -FileName (Split-Path $PWD -Leaf)
Describe $module.Name {
    Context "$($module.Name) module" -Tag Module {
        It "Given the module, the version should match the manifest version" {
            $module.Version |Should -BeExactly $manifest.ModuleVersion
        }
		It "Given the module, the DLL file version should match the manifest version" {
            (Get-Item "$($module.ModuleBase)\$($module.Name).dll").VersionInfo.FileVersionRaw |
                Should -BeLike "$($manifest.ModuleVersion)*"
		}
		It "Given the module, the DLL product version should match the manifest version" {
            (Get-Item "$($module.ModuleBase)\$($module.Name).dll").VersionInfo.ProductVersionRaw |
                Should -BeLike "$($manifest.ModuleVersion)*"
		} -Pending
		It "Given the module, the DLL should have a valid semantic product version" {
			$v = (Get-Item "$($module.ModuleBase)\$($module.Name).dll").VersionInfo.ProductVersion
			[semver]::TryParse($v, [ref]$null) |Should -BeTrue
		} -Pending
    }
	Context Add-Xml {
		It ("Given source document '<XmlDocument>' searched for '<XPath>', " +
			"adding -Xml '<Xml>' at the default position eventually returns '<Expected>'") -TestCases @(
			@{ XmlDocument = '<a />'; XPath = '/a'; Xml = '<b />'; Expected = '<a><b /></a>' }
			@{ XmlDocument = '<a><b /></a>'; XPath = '/a'; Xml = '<c />'; Expected = '<a><b /><c /></a>' }
			@{ XmlDocument = '<a><b /><b /><b /></a>'; XPath = '/a/b'; Xml = '<c />'
				Expected = '<a><b><c /></b><b><c /></b><b><c /></b></a>' }
		) {
			Param($XmlDocument,$XPath,$Xml,$Expected)
			[xml]$result = Select-Xml $XPath -Xml ([xml]$XmlDocument) |Add-Xml $Xml |select -Last 1
			$result.OuterXml |Should -BeExactly $Expected
		}
		It ("Given source document file containing '<XmlDocument>' searched for '<XPath>', " +
			"adding -Xml '<Xml>' at the default position updates the file to '<Expected>'") -TestCases @(
			@{ XmlDocument = '<a />'; XPath = '/a'; Xml = '<b />'; Expected = '<a><b /></a>' }
			@{ XmlDocument = '<a><b /></a>'; XPath = '/a'; Xml = '<c />'; Expected = '<a><b /><c /></a>' }
			@{ XmlDocument = '<a><b /><b /><b /></a>'; XPath = '/a/b'; Xml = '<c />'
				Expected = '<a><b><c /></b><b><c /></b><b><c /></b></a>' }
		) {
			Param($XmlDocument,$XPath,$Xml,$Expected)
			Set-Content TestDrive:\test.xml $XmlDocument
			Select-Xml $XPath -Path TestDrive:\test.xml |Add-Xml $Xml
			# read the file, strip the XML PI by comparing only the root document element
			Get-Content TestDrive:\test.xml -Raw |
				foreach {([xml]$_).DocumentElement.OuterXml} |
				Should -BeExactly $Expected
		}
		It ("Given source document '<XmlDocument>' searched for '<XPath>', " +
			"adding -Xml '<Xml>' is prevented by -UnlessXPath <UnlessXPath> and is not modified") -TestCases @(
			@{ XmlDocument = '<a><b /></a>'; XPath = '/a'; Xml = '<b />'; UnlessXPath = 'b' }
			@{ XmlDocument = '<a><b /><c /></a>'; XPath = '/a'; Xml = '<c />'; UnlessXPath = 'c' }
			@{ XmlDocument = '<a><b><c /></b><b><c /></b><b><c /></b></a>'; XPath = '/a/b'; Xml = '<c />'; UnlessXPath = 'c' }
		) {
			Param($XmlDocument,$XPath,$Xml,$UnlessXPath)
			[xml]$result = Select-Xml $XPath -Xml ([xml]$XmlDocument) |Add-Xml $Xml -UnlessXPath $UnlessXPath |select -Last 1
			$result.OuterXml |Should -BeExactly $XmlDocument
		}
	}
	Context Remove-Xml {
		It ("Given source document '<XmlDocument>' searched for '<XPath>', " +
			"removing eventually returns '<Expected>'") -TestCases @(
			@{ XmlDocument = '<a><b /></a>'; XPath = '/a/b'; Expected = '<a />' }
			@{ XmlDocument = '<a><b /><c /></a>'; XPath = '/a/c'; Expected = '<a><b /></a>' }
			@{ XmlDocument = '<a><b><c /></b><b><c /></b><b><c /></b></a>'; XPath = '/a/b/c'
				Expected = '<a><b /><b /><b /></a>' }
		) {
			Param($XmlDocument,$XPath,$Expected)
			[xml]$result = Select-Xml $XPath -Xml ([xml]$XmlDocument) |Remove-Xml |select -Last 1
			$result.OuterXml |Should -BeExactly $Expected
		}
		It ("Given source document file containing '<XmlDocument>' searched for '<XPath>', " +
			"removing updates the file to '<Expected>'") -TestCases @(
			@{ XmlDocument = '<a><b /></a>'; XPath = '/a/b'; Expected = '<a />' }
			@{ XmlDocument = '<a><b /><c /></a>'; XPath = '/a/c'; Expected = '<a><b /></a>' }
			@{ XmlDocument = '<a><b><c /></b><b><c /></b><b><c /></b></a>'; XPath = '/a/b/c'
				Expected = '<a><b /><b /><b /></a>' }
		) {
			Param($XmlDocument,$XPath,$Expected)
			Set-Content TestDrive:\test.xml $XmlDocument
			Select-Xml $XPath -Path TestDrive:\test.xml |Remove-Xml
			# read the file, strip the XML PI by comparing only the root document element
			Get-Content TestDrive:\test.xml -Raw |
				foreach {([xml]$_).DocumentElement.OuterXml} |
				Should -BeExactly $Expected
		}
	}
	Context Get-XmlValue {
		It "Given source document '<XmlDocument>' searched for '<XPath>', returns value '<Expected>'" -TestCases @(
			@{ XmlDocument = '<a>5</a>'; XPath = '/a'; Expected = '5' }
			@{ XmlDocument = '<a><!--thing--></a>'; XPath = '/a/comment()'; Expected = 'thing' }
			@{ XmlDocument = '<a href="https://example.org/">link</a>'; XPath = '/a/@href'; Expected = 'https://example.org/' }
		) {
			Param($XmlDocument,$XPath,$Expected)
			Select-Xml $XPath -Xml ([xml]$XmlDocument) |Get-XmlValue |Should -BeExactly $Expected
		}
	}
	Context Set-XmlValue {
		It ("Given source document '<XmlDocument>' searched for '<XPath>', " +
			"setting value '<Value>' returns '<Expected>'") -TestCases @(
			@{ XmlDocument = '<a />'; XPath = '/a'; Value = 'test'; Expected = '<a>test</a>' }
			@{ XmlDocument = '<a b="1" />'; XPath = '/a/@b'; Value = '2'; Expected = '<a b="2" />' }
			@{ XmlDocument = '<a><b /><b /><b /></a>'; XPath = '/a/b'; Value = 'c'
				Expected = '<a><b>c</b><b>c</b><b>c</b></a>' }
		) {
			Param($XmlDocument,$XPath,$Value,$Expected)
			[xml]$result = Select-Xml $XPath -Xml ([xml]$XmlDocument) |Set-XmlValue $Value |select -Last 1
			$result.OuterXml |Should -BeExactly $Expected
		}
		It ("Given source document '<XmlDocument>' searched for '<XPath>', " +
			"setting attribute name '<AttributeName>' to value '<AttributeValue>' returns '<Expected>'") -TestCases @(
			@{ XmlDocument = '<a />'; XPath = '/a'; AttributeName = 'b'; AttributeValue = 'test'; Expected = '<a b="test" />' }
			@{ XmlDocument = '<a b="c" />'; XPath = '/a'; AttributeName = 'b'; AttributeValue = 'test'; Expected = '<a b="test" />' }
		) {
			Param($XmlDocument,$XPath,$AttributeName,$AttributeValue,$Expected)
			[xml]$result = Select-Xml $XPath -Xml ([xml]$XmlDocument) |
				Set-XmlValue -AttributeName $AttributeName -AttributeValue $AttributeValue |
				select -Last 1
			$result.OuterXml |Should -BeExactly $Expected
		}
		It ("Given source document file containing '<XmlDocument>' searched for '<XPath>', " +
			"setting value '<Value>' updates the file to '<Expected>'") -TestCases @(
			@{ XmlDocument = '<a />'; XPath = '/a'; Value = 'test'; Expected = '<a>test</a>' }
			@{ XmlDocument = '<a b="1" />'; XPath = '/a/@b'; Value = '2'; Expected = '<a b="2" />' }
			@{ XmlDocument = '<a><b /><b /><b /></a>'; XPath = '/a/b'; Value = 'c'
				Expected = '<a><b>c</b><b>c</b><b>c</b></a>' }
		) {
			Param($XmlDocument,$XPath,$Value,$Expected)
			Set-Content TestDrive:\test.xml $XmlDocument
			Select-Xml $XPath -Path TestDrive:\test.xml |Set-XmlValue $Value
			# read the file, strip the XML PI by comparing only the root document element
			Get-Content TestDrive:\test.xml -Raw |
				foreach {([xml]$_).DocumentElement.OuterXml} |
				Should -BeExactly $Expected
		}
		It ("Given source document file containing '<XmlDocument>' searched for '<XPath>', " +
			"setting attribute name '<AttributeName>' to value '<AttributeValue>' updates the file to '<Expected>'") -TestCases @(
			@{ XmlDocument = '<a />'; XPath = '/a'; AttributeName = 'b'; AttributeValue = 'test'; Expected = '<a b="test" />' }
			@{ XmlDocument = '<a b="c" />'; XPath = '/a'; AttributeName = 'b'; AttributeValue = 'test'; Expected = '<a b="test" />' }
		) {
			Param($XmlDocument,$XPath,$AttributeName,$AttributeValue,$Expected)
			Set-Content TestDrive:\test.xml $XmlDocument
			Select-Xml $XPath -Path TestDrive:\test.xml |
				Set-XmlValue -AttributeName $AttributeName -AttributeValue $AttributeValue
			# read the file, strip the XML PI by comparing only the root document element
			Get-Content TestDrive:\test.xml -Raw |
				foreach {([xml]$_).DocumentElement.OuterXml} |
				Should -BeExactly $Expected
		}
	}
}
$env:Path = $envPath
