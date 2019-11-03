---
external help file: SelectXmlExtensions.dll-Help.xml
Module Name: SelectXmlExtensions
online version:
schema: 2.0.0
---

# Set-XmlValue

## SYNOPSIS
Sets the value of a node found by Select-Xml.

## SYNTAX

```
Set-XmlValue [-Value] <String> -SelectXmlInfo <SelectXmlInfo> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet sets the text value of a selected XML node.

## EXAMPLES

### Example 1
```powershell
PS C:\> (Select-Xml /a/@href -Xml ([xml]'<a href="https://example.com/">link</a>') |Set-XmlValue https://example.org/).OuterXml

<a href="https://example.org/">link</a>
```

### Example 1
```powershell
PS C:\> (Select-Xml /a -Xml ([xml]'<a href="https://example.com/">link</a>') |Set-XmlValue Example).OuterXml

<a href="https://example.com/">Example</a>
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

### -Value

The new text value of the node.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.PowerShell.Commands.SelectXmlInfo

The output from Select-Xml.

## OUTPUTS

### System.Xml.XmlDocument

The modified XML document (if not selected from a file).

## NOTES

## RELATED LINKS

[Select-Xml]()
