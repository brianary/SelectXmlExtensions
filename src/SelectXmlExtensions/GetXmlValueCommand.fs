namespace SelectXmlExtensions

open System.Management.Automation
open System.Xml
open Microsoft.PowerShell.Commands

/// Returns the text value of a node found by Select-Xml.
[<Cmdlet(VerbsCommon.Get, "XmlValue")>]
[<OutputType(typeof<string>)>]
type GetXmlValueCommand () =
    inherit PSCmdlet ()

    /// Output from the Select-Xml cmdlet.
    [<Parameter(Mandatory=true, ValueFromPipeline=true)>]
    member val SelectXmlInfo : SelectXmlInfo = null with get, set

    override x.ProcessRecord () =
        base.ProcessRecord ()
        match x.SelectXmlInfo.Node.NodeType with
        | XmlNodeType.Element -> x.WriteObject(x.SelectXmlInfo.Node.InnerText)
        | XmlNodeType.Document | XmlNodeType.DocumentFragment | XmlNodeType.DocumentType
        | XmlNodeType.Entity | XmlNodeType.EntityReference | XmlNodeType.Notation ->
            sprintf "Cannot get a value for a %A node." x.SelectXmlInfo.Node.NodeType |> x.WriteWarning
        | _ -> x.WriteObject(x.SelectXmlInfo.Node.Value)
