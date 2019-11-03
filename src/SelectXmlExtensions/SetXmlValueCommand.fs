namespace SelectXmlExtensions

open System
open System.Management.Automation
open System.Xml
open Microsoft.PowerShell.Commands

/// Sets the text value of a node found by Select-Xml.
[<Cmdlet("Set", "XmlValue")>]
[<OutputType(typeof<XmlDocument>)>]
type SetXmlAttributeCommand () =
    inherit PSCmdlet ()

    /// The attribute value to set.
    [<Parameter(Position=0, Mandatory=true)>]
    member val Value : string = null with get, set

    /// Output from the Select-Xml cmdlet.
    [<Parameter(Mandatory=true, ValueFromPipeline=true)>]
    member val SelectXmlInfo : SelectXmlInfo = null with get, set

    override x.ProcessRecord () =
        base.ProcessRecord ()
        match x.SelectXmlInfo.Node.NodeType with
        | XmlNodeType.Element -> x.SelectXmlInfo.Node.InnerText <- x.Value
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
