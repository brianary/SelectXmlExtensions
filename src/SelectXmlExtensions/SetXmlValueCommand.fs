namespace SelectXmlExtensions

open System
open System.Management.Automation
open System.Xml
open Microsoft.PowerShell.Commands

/// Sets the text value of a node found by Select-Xml.
[<Cmdlet("Set", "XmlValue", DefaultParameterSetName = "NodeValue")>]
[<OutputType(typeof<XmlDocument>)>]
type SetXmlAttributeCommand () =
    inherit PSCmdlet ()

    /// The node value to set.
    [<Parameter(ParameterSetName="NodeValue", Position=0, Mandatory=true)>]
    member val Value : string = null with get, set

    /// The name of an attribute to set for selected elements (ignored for other node types).
    [<Parameter(ParameterSetName="AttributeValue", Mandatory=true)>]
    [<ValidateNotNullOrEmpty()>]
    [<Alias("NameOfAttribute")>]
    member val AttributeName : string = null with get, set

    /// The value of an attribute to set for selected elements (ignored for other node types).
    [<Parameter(ParameterSetName="AttributeValue", Mandatory=true)>]
    [<Alias("ValueOfAttribute")>]
    member val AttributeValue : string = null with get, set

    /// The optional namespace URI for the attribute name.
    [<Parameter(ParameterSetName="AttributeValue")>]
    [<ValidateNotNullOrEmpty()>]
    [<Alias("NS","NamespaceUri")>]
    member val AttributeNamespaceUri : string = null with get, set

    /// Output from the Select-Xml cmdlet.
    [<Parameter(Mandatory=true, ValueFromPipeline=true)>]
    member val SelectXmlInfo : SelectXmlInfo = null with get, set

    override x.ProcessRecord () =
        base.ProcessRecord ()
        match x.SelectXmlInfo.Node.NodeType with
        | XmlNodeType.Element ->
            let e = x.SelectXmlInfo.Node :?> XmlElement
            if (not << String.IsNullOrWhiteSpace) x.AttributeNamespaceUri then
                e.SetAttribute(x.AttributeName, x.AttributeNamespaceUri, x.AttributeValue) |> ignore
            elif (not << String.IsNullOrWhiteSpace) x.AttributeName then
                e.SetAttribute(x.AttributeName, x.AttributeValue)
            else
                x.SelectXmlInfo.Node.InnerText <- x.Value
        | XmlNodeType.Document | XmlNodeType.DocumentFragment | XmlNodeType.DocumentType
        | XmlNodeType.Entity | XmlNodeType.EntityReference | XmlNodeType.Notation ->
            sprintf "Cannot set a value for a %A node." x.SelectXmlInfo.Node.NodeType |> x.WriteWarning
        | _ -> x.SelectXmlInfo.Node.Value <- x.Value
        match x.SelectXmlInfo.Path with
        | "InputStream" | "" | null -> x.WriteObject x.SelectXmlInfo.Node.OwnerDocument
        | _ ->
            x.SelectXmlInfo.Node.OwnerDocument.PreserveWhitespace <- true
            use xw = new XmlTextWriter(x.SelectXmlInfo.Path, Text.Encoding.UTF8)
            x.SelectXmlInfo.Node.OwnerDocument.Save(xw)
