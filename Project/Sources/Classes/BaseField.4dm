Class constructor($table : cs:C1710.TableRef; $name : Text; $indexed : Boolean)
	This:C1470.name:=$name
	This:C1470.isIndexed:=$indexed
	This:C1470.table:=$table
	
	
	
Function associateTable($table : cs:C1710.TableRef)
	Use (This:C1470)
		This:C1470.table:=$table
	End use 
	
	
	
Function generateSubXMLDef()->$def : Text
	$def:="name=\""+This:C1470.name+"\" "
	
	
	
Function generateXMLDef()->$def : Text
	$def:="<field uuid=\""+This:C1470.getUUID()+"\" "+This:C1470.generateSubXMLDef()+"/>"
	
	
	
Function generateIndexXMLDef()->$def : Text
	$def:="<index kind=\"regular\" uuid=\""+Generate UUID:C1066+"\" type=\"7\">"+Char:C90(13)+Char:C90(10)
	$def:=$def+"<field_ref uuid=\""+This:C1470.getUUID()+"\" name=\""+This:C1470.name+"\">"+Char:C90(13)+Char:C90(10)
	$def:=$def+"<table_ref uuid=\""+This:C1470.table.getUUID()+"\" name=\""+This:C1470.table.name+"\"/>"+Char:C90(13)+Char:C90(10)
	$def:=$def+"</field_ref>"+Char:C90(13)+Char:C90(10)
	$def:=$def+"</index>"+Char:C90(13)+Char:C90(10)
	
	
	// -------------------------------------------------------
	
	
Function getUUID()->$uuid : Text
	Use (This:C1470)
		If (This:C1470.uuid=Null:C1517)
			This:C1470.uuid:=Generate UUID:C1066
		End if 
		$uuid:=This:C1470.uuid
	End use 
	
	
	
Function getTable()->$table : cs:C1710.TableRef
	$table:=This:C1470.table
	
	
Function generateValue($manager : cs:C1710.Bencher; $e : 4D:C1709.Entity)
	// to be overridden
	
	
Function preFillCache()
	// to be overridden
	
	
Function canQuery()->$result : Boolean
	$result:=True:C214  // // to be overridden
	
	
Function getMetricID()->$id : Text
	$id:=This:C1470.table.name+"."+This:C1470.name
	
	
	// -----------------------------------------------------------------
	
	
Function queryWithEntity($e : 4D:C1709.Entity)->$entity : 4D:C1709.Entity
	
	var $value : Variant
	$value:=$e[This:C1470.name]
	var $dataclass : 4D:C1709.DataClass
	$dataclass:=This:C1470.table.getDataClass()
	var $sel : 4D:C1709.EntitySelection
	If ($value=Null:C1517)
		$sel:=$dataclass.query(":1 is null"; This:C1470.name)
	Else 
		$sel:=$dataclass.query(":1 == :2"; This:C1470.name; $value)
	End if 
	If ($sel.length=0)
		$entity:=Null:C1517
	Else 
		var $n : Integer
		$n:=Random:C100%$sel.length
		$entity:=$sel[$n]
	End if 
	
	
	
	
	
	
	
	
	
	