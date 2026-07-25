namespace SelectXmlExtensions

open System
open System.Collections
open System.Management.Automation
open System.Xml
open Microsoft.PowerShell.Commands

/// Indicates where new XML content will be added in relation to the selected node.
type AddXmlNodePosition = | AppendChild = 0 | InsertAfter = 1 | InsertBefore = 2 | PrependChild = 3

/// Insert XML into an XML document relative to a node found by Select-Xml.
[<Cmdlet(VerbsCommon.Add, "Xml")>]
[<OutputType(typeof<XmlDocument>)>]
type AddXmlCommand () =
    inherit PSCmdlet ()

    /// The XML node(s) to insert.
    [<Parameter(Position=0, Mandatory=true)>]
    [<ValidateNotNullOrEmpty>]
    [<Alias("Node", "Element")>]
    member val Xml : XmlDocument array = Array.empty with get, set

    /// Where to insert the new node(s), relative to the node found by Select-Xml.
    [<Parameter>]
    member val Position : AddXmlNodePosition = AddXmlNodePosition.AppendChild with get, set

    /// An XPath, rooted from the node found by Select-Xml, that will cancel the insert if it exists.
    /// Used to prevent inserting XML already in the document.
    [<Parameter>]
    [<Alias("IfMissing")>]
    member val UnlessXPath : string = null with get, set

    /// Specifies a hash table of the namespaces used in UnlessXPath.
    [<Parameter>]
    [<ValidateNotNull>]
    member val Namespace : Hashtable = Hashtable() with get, set

    /// Output from the Select-Xml cmdlet.
    [<Parameter(Mandatory=true, ValueFromPipeline=true)>]
    member val SelectXmlInfo : SelectXmlInfo = null with get, set
    member val ns : XmlNamespaceManager = XmlNamespaceManager (NameTable ()) with get
    member val shouldAdd : (XmlNode -> bool) = (fun _ -> true) with get, set
    member val add : (XmlNode -> unit) = ignore with get, set

    override x.BeginProcessing () =
        base.BeginProcessing ()
        for k in x.Namespace.Keys do x.ns.AddNamespace(k :?> string, x.Namespace.[k] :?> string)
        let subNodes (d : XmlDocument) = d.ChildNodes |> Seq.cast<XmlNode>
        let appendChild (at : XmlNode) x = at.AppendChild(at.OwnerDocument.ImportNode(x, true)) |> ignore
        let insertAfter (at : XmlNode) x = at.ParentNode.InsertAfter(at.OwnerDocument.ImportNode(x, true), at) |> ignore
        let insertBefore (at : XmlNode) x = at.ParentNode.InsertBefore(at.OwnerDocument.ImportNode(x, true), at) |> ignore
        let prependChild (at : XmlNode) x = at.AppendChild(at.OwnerDocument.ImportNode(x, true)) |> ignore
        let adding =
            match x.Position with
            | AddXmlNodePosition.InsertAfter | AddXmlNodePosition.PrependChild -> Seq.collect (subNodes >> Seq.rev) x.Xml
            | _ -> Seq.collect subNodes x.Xml
        x.shouldAdd <-
            match x.UnlessXPath with
            | null -> fun _ -> true
            | _ -> fun n -> (n.SelectNodes(x.UnlessXPath, x.ns).Count = 0)
        x.add <-
            match x.Position with
            | AddXmlNodePosition.AppendChild  -> fun at -> Seq.iter (appendChild at) adding
            | AddXmlNodePosition.InsertAfter  -> fun at -> Seq.iter (insertAfter at) adding
            | AddXmlNodePosition.InsertBefore -> fun at -> Seq.iter (insertBefore at) adding
            | AddXmlNodePosition.PrependChild -> fun at -> Seq.iter (prependChild at) adding
            | _ ->
                ErrorRecord(ArgumentException("Position"),"BadPosition",ErrorCategory.InvalidArgument,x.Position)
                    |> x.ThrowTerminatingError
                failwith "BadPosition"

    override x.ProcessRecord () =
        base.ProcessRecord ()
        if x.shouldAdd x.SelectXmlInfo.Node then x.add x.SelectXmlInfo.Node
        match x.SelectXmlInfo.Path with
        | "InputStream" | "" | null -> x.WriteObject x.SelectXmlInfo.Node.OwnerDocument
        | _ ->
            x.SelectXmlInfo.Node.OwnerDocument.PreserveWhitespace <- true
            use xw = new XmlTextWriter(x.SelectXmlInfo.Path, Text.Encoding.UTF8)
            x.SelectXmlInfo.Node.OwnerDocument.Save(xw)
