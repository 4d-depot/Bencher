Class extends BaseField

Class constructor($table : cs:C1710.TableRef; $name : Text; $indexed)
	Super:C1705($table; $name; $indexed)
	
Function generateSubXMLDef()->$def : Text
	$def:=Super:C1706.generateSubXMLDef()+"type=\"21\" "
	
	
Function canQuery()->$result : Boolean
	$result:=False:C215
	
	
	