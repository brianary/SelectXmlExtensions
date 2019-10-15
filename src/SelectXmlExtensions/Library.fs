namespace SelectXmlExtensions

open System
open System.Collections
open System.Management.Automation
open System.Xml
open Microsoft.PowerShell.Commands

/// Indicates where new XML content will be added in relation to the selected node.
type AddXmlNodePosition = | AppendChild = 0 | InsertAfter = 1 | InsertBefore = 2 | PrependChild = 3

/// <summary>
/// <para type="synopsis">Insert XML into an XML document relative to a node found by Select-Xml.</para>
/// </summary>
[<Cmdlet("Add", "Xml")>]
[<OutputType(typeof<SelectXmlInfo>)>]
type AddXmlCommand () =
    inherit PSCmdlet ()

    /// <summary>
    /// <para type="description">The XML node(s) to insert.</para>
    /// </summary>
    [<Parameter(Position=0,Mandatory=true)>]
    [<ValidateNotNullOrEmpty>]
    [<Alias("Node", "Element")>]
    member val Xml : XmlDocument array = Array.empty with get, set
    
    /// <summary>
    /// <para type="description">Where to insert the new node(s), relative to the node found by Select-Xml.</para>
    /// <para type="description"><list type="bullet">
    /// <item><description>AppendChild: At the end of the node's children. This is the default.</description></item>
    /// <item><description>InsertAfter: Following the node.</description></item>
    /// <item><description>InsertBefore: Preceding the node.</description></item>
    /// <item><description>PrependChild: At the beginning of the node's children.</description></item>
    /// </list></para>
    /// </summary>
    [<Parameter>]
    member val Position : AddXmlNodePosition = AddXmlNodePosition.AppendChild with get, set

    /// <summary>
    /// <para type="description">An XPath, rooted from the node found by Select-Xml, that will cancel the insert if it exists.
    /// Used to prevent inserting XML already in the document.</para>
    /// </summary>
    [<Parameter>]
    [<Alias("IfMissing")>]
    member val UnlessXPath : string = null with get, set

    /// <summary>
    /// <para type="description">Specifies a hash table of the namespaces used in UnlessXPath.</para>
    /// <para type="description">Use the format <c>@{prefix = 'uri'}</c>.</para>
    /// </summary>
    /// <example>
    /// <code>Select-Xml /configuration/appSettings app.config |Add-Xml.ps1 '&lt;add key="Version" value="2.0"/>' -UnlessXPath 'add[@key="Version"]'</code>
    /// <para>Adds element to document file if it is not already there.</para>
    /// </example>
    [<Parameter>]
    [<ValidateNotNull>]
    member val Namespace : Hashtable = Hashtable() with get, set

    /// <summary>
    /// <para type="description">Output from the Select-Xml cmdlet.</para>
    /// </summary>
    [<Parameter(Mandatory=true,ValueFromPipeline=true)>]

    member val SelectXmlInfo : SelectXmlInfo = null with get, set
    member val ns : XmlNamespaceManager = XmlNamespaceManager (NameTable ()) with get
    member val shouldAdd : (XmlNode -> bool) = (fun _ -> true) with get, set
    member val add : (XmlNode -> unit) = ignore with get, set

    override x.BeginProcessing () =
        base.BeginProcessing ()
        let subNodes (d : XmlDocument) = d.ChildNodes |> Seq.cast<XmlNode>
        let appendChild (at : XmlNode) x = at.AppendChild(at.OwnerDocument.ImportNode(x, true)) |> ignore
        let insertAfter (at : XmlNode) x = at.ParentNode.InsertAfter(at.OwnerDocument.ImportNode(x, true), at) |> ignore
        let insertBefore (at : XmlNode) x = at.ParentNode.InsertBefore(at.OwnerDocument.ImportNode(x, true), at) |> ignore
        let prependChild (at : XmlNode) x = at.AppendChild(at.OwnerDocument.ImportNode(x, true)) |> ignore
        let adding =
            match x.Position with
            | AddXmlNodePosition.InsertAfter | AddXmlNodePosition.PrependChild -> Seq.collect (subNodes >> Seq.rev) x.Xml
            | _ -> Seq.collect subNodes x.Xml
        for k in x.Namespace.Keys do x.ns.AddNamespace(k :?> string, x.Namespace.[k] :?> string)
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
        if x.shouldAdd x.SelectXmlInfo.Node then
            x.add x.SelectXmlInfo.Node
        x.WriteObject x.SelectXmlInfo
