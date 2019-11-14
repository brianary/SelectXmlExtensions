---
external help file: SelectXmlExtensions.dll-Help.xml
Module Name: SelectXmlExtensions
online version:
schema: 2.0.0
---

# Get-XmlValue

## SYNOPSIS
Returns the value of an XML node found by Select-Xml.

## SYNTAX

```
Get-XmlValue -SelectXmlInfo <SelectXmlInfo> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet returns the text value of a node found by Select-Xml.

If selecting from a file, the file will be updated instead of returning the updated XML document.

## EXAMPLES

### Example 1
```powershell
PS C:\> '<a>B</a>' |Select-Xml /a |Get-XmlValue

B
```

### Example 2
```powershell
PS C:\> '<a href="https://example.org/">link</a>' |Select-Xml /a/@href |Get-XmlValue

https://example.org/
```

## PARAMETERS

### -SelectXmlInfo

The output from Select-Xml.

```yaml
Type: SelectXmlInfo
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.PowerShell.Commands.SelectXmlInfo

The output of Select-Xml.

## OUTPUTS

### System.String

The text value of the selected node.

## NOTES

## RELATED LINKS

[Select-Xml]()
