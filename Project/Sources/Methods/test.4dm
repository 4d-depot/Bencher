//%attributes = {}

ds:C1482.setCacheSize(4000000000)
var $b : cs:C1710.Bencher
$b:=InitBencher(False:C215)
$b.preFillCache()

If (False:C215)
	var $e : 4D:C1709.Entity
	$e:=ds:C1482.table1.new()
	$e.fillWithPseudoData()
	
	For ($i; 1; 100)
		$e:=ds:C1482.randomAlterEntity()
	End for 
	
	
	var $b : cs:C1710.Bencher
	var $t : cs:C1710.TableRef
	var $f : cs:C1710.AlphaField
	$b:=InitBencher(False:C215)
	
	$t:=$b.tables[0]
	$f:=$t.fields[0]
	
	While (Not:C34(Shift down:C543))
		var $e : 4D:C1709.Entity
		$e:=ds:C1482.table1.new()
		$f.generateValue($b; $e)
		
		ALERT:C41($e.alpha_field1)
		
	End while 
	
	
End if 



//// ----------------------------------------------------



If (False:C215)
	
	
	var $e : 4D:C1709.Entity
	var $i : Integer
	var $col : Collection
	
	$col:=New collection:C1472
	For ($i; 1; 10)
		$e:=ds:C1482.randomGetEntity()
		$col.push($e)
	End for 
	
	
	var $b : cs:C1710.Bencher
	$b:=InitBencher(False:C215)
	
	var $mesure : Object
	$mesure:=$b.getMetric().getAndResetCurrentMeasure()
	
	
	
	
	
	
	
	
	
	var $table; $table2 : cs:C1710.TableRef
	$table2:=cs:C1710.TableRef.new("tabletest")
	$table:=OB Copy:C1225($table2; ck shared:K85:29)
	
	var $field2; $field : cs:C1710.BaseField
	$field2:=cs:C1710.AlphaField.new(Null:C1517; "testfield"; True:C214; 0; 20)
	$field:=OB Copy:C1225($field2; ck shared:K85:29)
	$table.AddField($field)
	//$field.associateTable($table)
	
	
	var $field3; $field4 : cs:C1710.BaseField
	$field3:=cs:C1710.AlphaField.new(Null:C1517; "testfield2"; True:C214; 0; 20)
	$field4:=OB Copy:C1225($field2; ck shared:K85:29)
	$table.AddField($field4)
	//$field4.associateTable($table)
	
	
	$o:=New object:C1471("toto"; 23; "sub"; New object:C1471("x"; 1))
	$o2:=OB Copy:C1225($o; ck shared:K85:29)
	
	$o3:=New object:C1471("a"; 1; "subx"; $o2)
	$o4:=OB Copy:C1225($o3; ck shared:K85:29)
	
	Use ($o2)
		$o2.toto:=24
		$o2.sub.x:=2
	End use 
	
	
	
	
	var $b : cs:C1710.Bencher
	$b:=OB Copy:C1225(cs:C1710.Bencher.new(Null:C1517); ck shared:K85:29)
	$x:=$b.generateNumber(0; 2000000000)
	
	If (True:C214)
		$b.analyseStructure(); 
		//$b.generateData(1000)
	Else 
		$b.buildModel()
		RESTART 4D:C1292
	End if 
	
	
	
	If (False:C215)
		
		$table:=cs:C1710.TableRef.new("table1")
		
		$col:=New collection:C1472
		$col.push(cs:C1710.AlphaField.new($table; "toto"; True:C214; 20; 40))
		$col.push(cs:C1710.UUIDField.new($table; "titi"; True:C214))
		$col.push(cs:C1710.TextField.new($table; "tata"; True:C214; 2000; 4000))
		
		$text:=""
		var $field : cs:C1710.BaseField
		
		For each ($field; $col)
			$text:=$text+$field.generateXMLDef()+Char:C90(13)+Char:C90(10)
		End for each 
		
		var $file : 4D:C1709.File
		$file:=File:C1566("/RESOURCES/out.xml")
		$file.setText($text)
		
	End if 
	
End if 


//ALERT($text)
