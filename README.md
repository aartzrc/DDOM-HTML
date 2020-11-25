# DDOM HTML Processor   

`HtmlProcessor` makes an HTML string DDOM accessible.  

Example:

```haxe
var hProcessor = new HtmlProcessor(Http.requestUrl("https://haxe.org/"));
trace(hProcessor.select("html > body a[href=download/]")); // Get the 'html' tag, direct child 'body, then search for an 'anchor' decendant with href of 'download/'
```