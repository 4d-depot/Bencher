Class extends BaseField

Class constructor($table : cs:C1710.TableRef; $name : Text; $indexed; $minBytes : Integer; $maxBytes : Integer)
	Super:C1705($table; $name; $indexed)
	This:C1470.minBytes:=$minBytes
	This:C1470.maxBytes:=$maxBytes
	
	
Function generateSubXMLDef()->$def : Text
	$def:=Super:C1706.generateSubXMLDef()+"type=\"18\" "
	
	
	
Function generateValue($manager : cs:C1710.Bencher; $e : 4D:C1709.Entity)
	var $blob : Blob
	var $text : Text
	$text:=$manager.generateSentence($manager.generateNumber(This:C1470.minBytes; This:C1470.maxBytes))
	TEXT TO BLOB:C554($text; $blob)
	$e[This:C1470.name]:=$blob
	
	
	
Function canQuery()->$result : Boolean
	$result:=False:C215
	
	
	
	
	