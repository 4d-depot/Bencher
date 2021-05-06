Class extends NumberField

Class constructor($table : cs:C1710.TableRef; $name : Text; $indexed : Boolean; $minRange : Real; $maxRange : Real)
	Super:C1705($table; $name; $indexed; $minRange; $maxRange)
	
Function generateSubXMLDef()->$def : Text
	$def:=Super:C1706.generateSubXMLDef()+"type=\"4\" "
	