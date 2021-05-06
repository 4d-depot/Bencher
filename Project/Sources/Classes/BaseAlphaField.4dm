Class extends BaseField

Class constructor($table : cs:C1710.TableRef; $name : Text; $indexed : Boolean; $minChars : Integer; $maxChars : Integer)
	Super:C1705($table; $name; $indexed)
	This:C1470.minChars:=$minChars
	This:C1470.maxChars:=$maxChars
	
	
	
Function preFillCache()
	var $dataclass : 4D:C1709.DataClass
	$dataclass:=This:C1470.table.getDataClass()
	var $sel : 4D:C1709.EntitySelection
	$sel:=$dataclass.query(":1 >= :2"; This:C1470.name; "")
	
	