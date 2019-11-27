# Data Document Object Model (DDOM)  

Basic map of data to DOM-style syntax for basic read/write operations. All data is stored as `Any` type, but can be flagged as a specific class and throw exceptions on cast. All endpoints can be 'observable'. All operations return a DDOM instance (this is similar to how JQuery works), field access is forwarded through the DDOM instance.  

DOM operations:  
static getById(id:String)  
static getByType(type:String)  
static create(type:String)  
append(node:DDOM)  
remove(node:DDOM)  
delete()  

most other operations become combinations of these basic calls

it looks like field access can be overridden: @:op(a.b) - https://haxe.org/manual/types-abstract-operator-overloading.html

11/26/2019:  
coming along well, things to build out:  
DDOM to typedef (or graphql), and have the typedefs provide code completion and type safety  
An async client side updater that can call to a server  
A server sync reader that can pull from a standard database  
Allow multiple filters per token?  
Quick way to generated unit tests for to/from string tokenization, iterate over all enums combinations and verify the go to/from string properly  