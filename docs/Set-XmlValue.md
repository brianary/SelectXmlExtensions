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

### NodeValue (Default)
```
Set-XmlValue [-Value] <String> -SelectXmlInfo <SelectXmlInfo> [<CommonParameters>]
```

### AttributeValue
```
Set-XmlValue -AttributeName <String> -AttributeValue <String> [-AttributeNamespaceUri <String>]
 -SelectXmlInfo <SelectXmlInfo> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet sets the text value of a selected XML node.

## EXAMPLES

### Example 1
```powershell
PS C:\> ('<a href="https://old.example.com/">link</a>' |Select-Xml /a/@href |Set-XmlValue https://new.example.org/).OuterXml

<a href="https://new.example.org/">link</a>
```

### Example 2
```powershell
PS C:\> ('<a href="https://example.com/">link</a>' |Select-Xml /a |Set-XmlValue Example).OuterXml

<a href="https://example.com/">Example</a>
```

### Example 3
```powershell
PS C:\> ('<a href="https://old.example.com/">link</a>' |Select-Xml /a |Set-XmlValue -AttributeName href -AttributeValue https://new.example.org/).OuterXml

<a href="https://new.example.org/">Example</a>
```

### Example 4
```powershell
PS C:\> ('<a>link</a>' |Select-Xml /a |Set-XmlValue -AttributeName href -AttributeValue https://example.com/).OuterXml

<a href="https://example.com/">Example</a>
```

### Example 5
```powershell
PS C:\> ('<a href="https://example.com/">link</a>' |Select-Xml /a |Set-XmlValue -AttributeName title -AttributeValue 'Example site').OuterXml

<a href="https://example.com/" title="Example site">link</a>
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
Parameter Sets: NodeValue
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttributeName

The name of an attribute to set for selected elements (ignored for other node types).

```yaml
Type: String
Parameter Sets: AttributeValue
Aliases: AN, NameOfAttribute

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttributeNamespaceUri

The optional namespace URI for the attribute name.

```yaml
Type: String
Parameter Sets: AttributeValue
Aliases: NS, NamespaceUri

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttributeValue

The value of an attribute to set for selected elements (ignored for other node types).

```yaml
Type: String
Parameter Sets: AttributeValue
Aliases: AV, ValueOfAttribute

Required: True
Position: Named
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
