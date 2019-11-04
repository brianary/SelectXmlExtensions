---
external help file: SelectXmlExtensions.dll-Help.xml
Module Name: SelectXmlExtensions
online version:
schema: 2.0.0
---

# Add-Xml

## SYNOPSIS
Insert XML into an XML document relative to a node found by Select-Xml.

## SYNTAX

```
Add-Xml [-Xml] <XmlDocument[]> [-Position <AddXmlNodePosition>] [-UnlessXPath <String>]
 [-Namespace <Hashtable>] -SelectXmlInfo <SelectXmlInfo> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet puts new XML nodes into a document, inside or next to a node found by the Select-Xml cmdlet.
If you provide a value for -UnlessXPath, it will only add the new XML if the XPath provided does not find a node,
usually this is used to stop the same node from being re-added.

This allows you to write idempotent scripts, which you can run multiple times to get the same result,
instead of unexpectedly adding the same XML multiple times because you don't know if the script has already been run.

If selecting from a file, the file will be updated instead of returning the updated XML document.

## EXAMPLES

### Example 1
```powershell
PS C:\> Select-Xml /configuration/appSettings app.config |Add-Xml.ps1 '<add key="Version" value="2.0"/>' -UnlessXPath 'add[@key="Version"]'
```

The appSettings node is located in app.config, and the Version setting is added if it isn't already present.

## PARAMETERS

### -Xml
The XML node(s) to insert.

```yaml
Type: XmlDocument[]
Parameter Sets: (All)
Aliases: Node, Element

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Position
Where to insert the new node(s), relative to the node found by Select-Xml.

- AppendChild: At the end of the node's children.
- InsertAfter: Following the node.
- InsertBefore: Preceding the node.
- PrependChild: At the beginning of the node's children.

```yaml
Type: AddXmlNodePosition
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UnlessXPath
An XPath, relative to the node found by Select-Xml, that will cancel the insert if it exists.
Used to prevent inserting XML already in the document.

```yaml
Type: String
Parameter Sets: (All)
Aliases: IfMissing

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Namespace
Specifies a hash table of the namespaces used in UnlessXPath. Use the format `@{prefix = 'uri'}`

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

The output from Select-Xml.

## OUTPUTS

### Microsoft.PowerShell.Commands.SelectXmlInfo

Returned when Select-Xml queries an in-memory XML document or string (null when querying a file).

## NOTES

## RELATED LINKS

[Select-Xml](Select-Xml)
