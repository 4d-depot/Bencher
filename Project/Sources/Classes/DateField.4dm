Class extends BaseField

Class constructor($table : cs:C1710.TableRef; $name : Text; $indexed)
	Super:C1705($table; $name; $indexed)
	
Function generateSubXMLDef()->$def : Text
	$def:=Super:C1706.generateSubXMLDef()+"type=\"8\" "
	
	
Function preFillCache()
	var $dataclass : 4D:C1709.DataClass
	$dataclass:=This:C1470.table.getDataClass()
	var $sel : 4D:C1709.EntitySelection
	$sel:=$dataclass.query(":1 >= :2"; This:C1470.name; !1850-01-01!)
	
	