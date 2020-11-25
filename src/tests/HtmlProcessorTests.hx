package tests;

import haxe.Http;
import ddom.Selector;
import haxe.iterators.StringIterator;
import ddom.DDOM;
import ddom.html.HtmlProcessor;
import sys.io.File;
using StringTools;

class HtmlProcessorTests {
	static function main() {
        var className = "DOMFuncs";
        var lines:Array<String> = [];

        lines.push('import js.html.*;');
        lines.push('import js.Browser.document;');
        lines.push('');
        lines.push('class $className {');

        lines.push('static function header() {');

        lines = lines.concat(toDOMFuncs(new HtmlProcessor(File.getContent("./src/tests/blog-page.htm")), "html div[class~=card]:pos(0)").lines);

        lines.push('}');
        lines.push('}');

        var output = formatLines(lines).join("\n");
        trace(output);

        File.saveContent('$className.hx', output);
    }

    static function toDOMFuncs(processor:HtmlProcessor, selector:Selector) {
        var castTypes = [
            "div" => "DivElement"
        ];

        var ddom = processor.select(selector);
        var lines:Array<String> = [];
        var eNames:Map<String, Int> = [];
        var vars:Map<String, String> = [];

        function toF(ddom:DDOM, pName:String = null) {
            if(ddom.size() == 0) return;
            var type = ddom.types()[0];
            var fields = ddom.fields();
            if(fields.indexOf("ddom-skip") != -1 && ddom.fieldRead("ddom-skip") == "true") return;

            if(type == "text") {
                if(fields.indexOf("text") != -1)
                    lines.push('$pName.innerText = "${ddom.text.trim()}";');
            } else {
                if(!eNames.exists(type)) eNames.set(type, 0);
                eNames[type]++;
                var name = '${type}_${eNames[type]}';
                var castType = castTypes[type];
                lines.push('var $name${castType == null ? " =" : ':$castType = cast'} document.createElement("${type}");');
                if(pName != null)
                    lines.push('$pName.appendChild($name);');

                for(f in [ "class", "title", "name", "placeholder", "style" ].filter((f) -> fields.indexOf(f) != -1)) {
                    lines.push('$name.setAttribute("$f", "${ddom.fieldRead(f)}");'); 
                }

                if(fields.indexOf("ddom-var") != -1) {
                    vars.set(ddom.fieldRead("ddom-var"), name);
                }

                if(fields.indexOf("ddom-skipchildren") != -1 && ddom.fieldRead("ddom-skipchildren") == "true") return;
                for(c in ddom.children()) toF(c, name);
            }
        }

        for(n in ddom) toF(n);

        return {lines:lines, vars:vars};
    }

    static function formatLines(lines:Array<String>) {
        var tabs = 0;
        for(i in 0 ... lines.length) {
            var l = lines[i];
            for(c in new StringIterator(l)) if(c == '}'.code) tabs--;
            l = [for(i in 0 ... tabs) "\t"].join("") + l.trim();
            for(c in new StringIterator(l)) if(c == '{'.code) tabs++;
            lines[i] = l;
        }
        return lines;
    }
}
