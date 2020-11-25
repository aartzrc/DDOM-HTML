package ddom.html;

import htmlparser.HtmlNodeElement;
using Lambda;
using LambdaExt;
using StringTools;

import ddom.DDOM;
import ddom.Selector;
import ddom.Processor;

import htmlparser.HtmlDocument;
import htmlparser.HtmlNode;

@:access(ddom.DDOMInst, ddom.DataNode)
class HtmlProcessor extends Processor implements IProcessor {
    
    var htmlDoc:HtmlDocument;

	public function new(html:String, tolerant:Bool = true) {
        htmlDoc = new HtmlDocument(html, tolerant);
        super(htmlDoc.children.map((hn) -> htmlNodeToDataNode(hn)));
    }

    public function select(selector:Selector = null):DDOM {
        return new DDOMInst(this, selector);
    }

    var nodeMap:Map<HtmlNode, DataNode> = [];
    function htmlNodeToDataNode(hn:HtmlNode):DataNode {
        if(!nodeMap.exists(hn)) {
            var dn:DataNode;
            if(Type.getClass(hn) == HtmlNodeElement) {
                var hne:HtmlNodeElement = cast hn;
                dn = new DataNode(hne.name, [ for(a in hne.attributes) a.name => a.value ]);
                for(c in hne.nodes)
                    dn.addChild(htmlNodeToDataNode(c));
            } else {
                var text = hn.toText();
                dn = new DataNode("text", !LambdaExt.isNullOrWhitespace(text) ? ["text" => hn.toText()] : []);
            }
            nodeMap.set(hn, dn);
        }
        return nodeMap[hn];
    }
}
