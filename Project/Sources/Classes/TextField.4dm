Class extends BaseAlphaField

Class constructor($table : cs:C1710.TableRef; $name : Text; $indexed : Boolean; $minChars : Integer; $maxChars : Integer)
	Super:C1705($table; $name; $indexed; $minChars; $maxChars)
	
	
Function generateSubXMLDef()->$def : Text
	$def:=Super:C1706.generateSubXMLDef()+"type=\"14\" "
	
	
Function generateValue($manager : cs:C1710.Bencher; $e : 4D:C1709.Entity)
	$e[This:C1470.name]:=$manager.generateSentence($manager.generateNumber(This:C1470.minChars; This:C1470.maxChars))
	
	
Function canQuery()->$result : Boolean
	$result:=False:C215
	
	
	