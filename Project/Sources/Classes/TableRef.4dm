Class constructor($name : Text)
	This:C1470.name:=$name
	// This.fields:=New collection
	This:C1470.fields:=Null:C1517
	This:C1470.indexedQueryFields:=Null:C1517
	This:C1470.seqQueryFields:=Null:C1517
	
	
	//--------------------------------------------------------
	
	
Function getUUID()->$uuid : Text
	Use (This:C1470)
		If (This:C1470.uuid=Null:C1517)
			This:C1470.uuid:=Generate UUID:C1066
		End if 
		$uuid:=This:C1470.uuid
	End use 
	
	
Function getDataClass()->$dataclass : 4D:C1709.DataClass
	$dataclass:=ds:C1482[This:C1470.name]
	
	
	
	//--------------------------------------------------------
	
	
Function AddField($field : cs:C1710.BaseField)
	Use (This:C1470)
		If (This:C1470.fields=Null:C1517)
			This:C1470.fields:=New shared collection:C1527()
		End if 
		This:C1470.fields.push($field)
		If (This:C1470.indexedQueryFields=Null:C1517)
			This:C1470.indexedQueryFields:=New shared collection:C1527()
		End if 
		If (This:C1470.seqQueryFields=Null:C1517)
			This:C1470.seqQueryFields:=New shared collection:C1527()
		End if 
		If ($field.canQuery())
			If ($field.isIndexed)
				This:C1470.indexedQueryFields.push($field)
			Else 
				This:C1470.seqQueryFields.push($field)
			End if 
		End if 
		$field.associateTable(This:C1470)
	End use 
	
	
	//--------------------------------------------------------
	
	
Function generateXMLDef()->$def : Text
	var $field : cs:C1710.BaseField
	$def:="<table name=\""+This:C1470.name+"\" uuid=\""+This:C1470.getUUID()+"\">"+Char:C90(13)+Char:C90(10)
	$def:=$def+"<field name=\"ID\" type=\"4\" unique=\"true\" autosequence=\"true\" not_null=\"true\" />"+Char:C90(13)+Char:C90(10)
	For each ($field; This:C1470.fields)
		$def:=$def+$field.generateXMLDef()+Char:C90(13)+Char:C90(10)
	End for each 
	$def:=$def+"<primary_key field_name=\"ID\"/>"+Char:C90(13)+Char:C90(10)
	$def:=$def+"</table>"+Char:C90(13)+Char:C90(10)+Char:C90(13)+Char:C90(10)
	
	For each ($field; This:C1470.fields)
		If ($field.isIndexed)
			$def:=$def+$field.generateIndexXMLDef()+Char:C90(13)+Char:C90(10)
		End if 
	End for each 
	
	
	//--------------------------------------------------------
	
	
Function generateData($manager : cs:C1710.Bencher; $howMany : Integer)
	var $i : Integer
	var $ok : Boolean
	var $dataclass : 4D:C1709.DataClass
	$dataclass:=ds:C1482[This:C1470.name]
	
	var $ptable : Pointer
	$ptable:=Table:C252($dataclass.getInfo().tableNumber)
	PAUSE INDEXES:C1293($ptable->)
	
	$ok:=True:C214
	var $progress : 4D:C1709.ProgessIndicator
	$progress:=:C1776
	
	If ($progress#Null:C1517)
		$progress.beginSession($howMany; "creating records in "+This:C1470.name+": {curValue} of {maxValue}"; True:C214)
	End if 
	
	var $i : Integer
	$i:=0
	While ($ok & ($i<$howMany))
		
		var $e : 4D:C1709.Entity
		
		If ($progress#Null:C1517)
			$ok:=$progress.progress($i)
		End if 
		
		If ($ok)
			
			$e:=$dataclass.new()
			$e.fillWithPseudoData()
/*
For each ($field; This.fields)
  $field.generateValue($manager; $e)
End for each 
*/
			$e.save()
		End if 
		$i:=$i+1
	End while 
	
	If ($progress#Null:C1517)
		$progress.endSession()
	End if 
	
	RESUME INDEXES:C1294($ptable->)
	
	
	
	//--------------------------------------------------------
	
	
	
Function getRandomEntity($bencher : cs:C1710.Bencher; $withQuery : Boolean)->$entity : 4D:C1709.Entity
	var $n : Integer
	
	$t:=Milliseconds:C459
	
	var $dataclass : 4D:C1709.DataClass
	$dataclass:=This:C1470.getDataClass()
	
	var $sel : 4D:C1709.EntitySelection
	$sel:=$dataclass.all()
	
	$n:=(Random:C100*Random:C100)%($sel.length)
	
	$entity:=$sel[$n]
	
	If ($withQuery)
		var $field : cs:C1710.BaseField
		$field:=This:C1470.getRandomField(True:C214; True:C214)
		$entity:=$field.queryWithEntity($entity)
		$bencher.getMetric().addMeasure($field; $t)
	End if 
	
	
	
	
	//--------------------------------------------------------
	
	
	
Function alterRandomEntity($bencher : cs:C1710.Bencher; $withQuery : Boolean)->$entity : 4D:C1709.Entity
	var $n : Integer
	
	$t:=Milliseconds:C459
	
	var $dataclass : 4D:C1709.DataClass
	$dataclass:=This:C1470.getDataClass()
	
	var $sel : 4D:C1709.EntitySelection
	$sel:=$dataclass.all()
	
	$n:=(Random:C100*Random:C100)%($sel.length)
	
	var $e : 4D:C1709.Entity
	$e:=$sel[$n]
	
	If ($withQuery)
		var $field : cs:C1710.BaseField
		$field:=This:C1470.getRandomField(True:C214; True:C214)
		$entity:=$field.queryWithEntity($e)
		If ($entity=Null:C1517)
			$debug:=1  // put a break here
		Else 
			var $nbfield : Integer
			$nbfield:=$bencher.generateNumber(3; 8)
			For ($i; 1; $nbfield)
				$field:=This:C1470.getRandomField(false, false)
				$field.generateValue($bencher; $entity)
			End for 
			$entity.save()
		End if 
		$bencher.getMetric().addMeasure($field; $t)
	End if 
	
	
	
	
	//--------------------------------------------------------
	
	
Function getRandomField($forQuery : Boolean; $indexed : Boolean)->$field : cs:C1710.BaseField
	var $fields : Collection
	
	If ($forQuery)
		If ($indexed)
			$fields:=This:C1470.indexedQueryFields
		Else 
			$fields:=This:C1470.seqQueryFields
		End if 
	Else 
		$fields:=This:C1470.fields
	End if 
	
	var $n : Integer
	$n:=Random:C100%($fields.length)
	$field:=$fields[$n]
	
	
	//--------------------------------------------------------
	
	
Function preFillCache()
	var $field : cs:C1710.BaseField
	For each ($field; This:C1470.indexedQueryFields)
		$field.preFillCache()
	End for each 
	
	
	
	//--------------------------------------------------------
	
	
	
	
	
	