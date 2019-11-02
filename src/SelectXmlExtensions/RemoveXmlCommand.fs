namespace SelectXmlExtensions

open System
open System.Management.Automation
open System.Xml
open Microsoft.PowerShell.Commands

/// Removes a node found by Select-Xml from its XML document.
[<Cmdlet("Remove", "Xml")>]
[<OutputType(typeof<XmlDocument>)>]
type RemoveXmlCommand () =
    inherit PSCmdlet ()

    /// Output from the Select-Xml cmdlet.
    [<Parameter(Mandatory=true,ValueFromPipeline=true)>]
    member val SelectXmlInfo : SelectXmlInfo = null with get, set

    override x.ProcessRecord () =
        base.ProcessRecord ()
        if isNull x.SelectXmlInfo.Node.ParentNode then
            ErrorRecord(ArgumentException("Cannot remove the root element.","SelectXmlInfo"),
                "RootRequired",ErrorCategory.InvalidArgument,x.SelectXmlInfo)
                |> x.ThrowTerminatingError
            failwith "RootRequired"
        x.SelectXmlInfo.Node.ParentNode.RemoveChild(x.SelectXmlInfo.Node) |> ignore
        match x.SelectXmlInfo.Path with
        | "InputStream" | "" | null -> x.WriteObject x.SelectXmlInfo.Node.OwnerDocument
        | _ ->
            use xw = new XmlTextWriter(x.SelectXmlInfo.Path,Text.Encoding.UTF8)
            x.SelectXmlInfo.Node.OwnerDocument.Save(xw)
