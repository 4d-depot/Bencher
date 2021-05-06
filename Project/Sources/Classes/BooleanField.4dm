Class extends BaseField

Class constructor($table : cs:C1710.TableRef; $name : Text; $indexed)
	Super:C1705($table; $name; $indexed)
	
Function generateSubXMLDef()->$def : Text
	$def:=Super:C1706.generateSubXMLDef()+"type=\"1\" "
	
	
Function generateValue($manager : cs:C1710.Bencher; $e : 4D:C1709.Entity)
	$e[This:C1470.name]:=((Random:C100%2)=1)
	
	
Function preFillCache()
	var $dataclass : 4D:C1709.DataClass
	$dataclass:=This:C1470.table.getDataClass()
	var $sel : 4D:C1709.EntitySelection
	$sel:=$dataclass.query(":1 == :2 or :1 == :3"; This:C1470.name; False:C215; True:C214)
	