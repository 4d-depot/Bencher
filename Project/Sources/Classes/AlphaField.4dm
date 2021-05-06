Class extends BaseAlphaField

Class constructor($table : cs:C1710.TableRef; $name : Text; $indexed : Boolean; $minChars : Integer; $maxChars : Integer)
	Super:C1705($table; $name; $indexed; $minChars; $maxChars)
	
	
Function generateSubXMLDef()->$def : Text
	$def:=Super:C1706.generateSubXMLDef()+"type=\"10\" limiting_length=\"255\" "
	
	
Function generateValue($manager : cs:C1710.Bencher; $e : 4D:C1709.Entity)
	var $tx : Text
	var $l : Integer
	$l:=$manager.generateNumber(This:C1470.minChars; This:C1470.maxChars)
	$tx:=$manager.generateWord($l)
	$e[This:C1470.name]:=$tx
	
	