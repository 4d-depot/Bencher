Class extends BaseField

Class constructor($table : cs:C1710.TableRef; $name : Text; $indexed : Boolean; $minRange : Real; $maxRange : Real)
	Super:C1705($table; $name; $indexed)
	This:C1470.minRange:=$minRange
	This:C1470.maxRange:=$maxRange
	
	
	
	
Function generateValue($manager : cs:C1710.Bencher; $e : 4D:C1709.Entity)
	$e[This:C1470.name]:=$manager.generateNumber(This:C1470.minRange; This:C1470.maxRange)
	
	
	
Function preFillCache()
	var $dataclass : 4D:C1709.DataClass
	$dataclass:=This:C1470.table.getDataClass()
	var $sel : 4D:C1709.EntitySelection
	$sel:=$dataclass.query(":1 >= :2"; This:C1470.name; 0)
	