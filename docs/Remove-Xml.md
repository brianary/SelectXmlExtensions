---
external help file: SelectXmlExtensions.dll-Help.xml
Module Name: SelectXmlExtensions
online version:
schema: 2.0.0
---

# Remove-Xml

## SYNOPSIS
Removes a node found by Select-Xml from its XML document.

## SYNTAX

```
Remove-Xml [-SelectXmlInfo] <SelectXmlInfo> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet removes XML nodes found by Select-Xml from their document.

If selecting from a file, the file will be updated instead of returning the updated XML document.

## EXAMPLES

### Example 1
```powershell
PS C:\> ('<a><b /></a>' |Select-Xml /a/b |Remove-Xml).OuterXml

<a />
```

### Example 2
```
Select-Xml '/configuration/appSettings/add[@key="Version"]' app.config |Remove-Xml
```

Removes the specified node from the file.

## PARAMETERS

### -SelectXmlInfo
Output from the Select-Xml cmdlet.

```yaml
Type: SelectXmlInfo
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.PowerShell.Commands.SelectXmlInfo
Output from the Select-Xml cmdlet.

## OUTPUTS

### System.Xml.XmlDocument
Returned when Select-Xml queries an in-memory XML document or string, null when querying a file.

## NOTES

## RELATED LINKS

[Select-Xml]()

