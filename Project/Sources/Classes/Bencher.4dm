Class constructor($settings : Object)
	If ($settings=Null:C1517)
		var $file : 4D:C1709.File
		$file:=File:C1566("/RESOURCES/bencher.json")
		$text:=$file.getText()
		$settings:=JSON Parse:C1218($text)
	End if 
	This:C1470.settings:=$settings
	This:C1470.tables:=New shared collection:C1527
	This:C1470.metric:=Null:C1517
	
	
	//--------------------------------------------------------
	
	
Function getMetric()->$metric : cs:C1710.Metric
	Use (This:C1470)
		If (This:C1470.metric=Null:C1517)
			This:C1470.metric:=OB Copy:C1225(cs:C1710.Metric.new(); ck shared:K85:29)
			$metric:=This:C1470.metric
			$metric.initStorage(This:C1470.tables)
		Else 
			$metric:=This:C1470.metric
		End if 
	End use 
	
	
	//--------------------------------------------------------
	
	
Function buildFieldFromAttribute($dataclass : 4D:C1709.DataClass; $table : cs:C1710.TableRef; $fieldname : Text; $att : Object)->$field : cs:C1710.BaseField
	var $type : Integer
	$type:=$att.fieldType
	
	var $keeptable : cs:C1710.TableRef
	$keeptable:=$table
	$table:=Null:C1517
	
	If (False:C215 & ($type=0))
		var $fieldType : Integer
		
		GET FIELD PROPERTIES:C258($dataclass.getInfo().tableNumber; $att.fieldNumber; $fieldType)
	End if 
	
	Case of 
			
		: ($type=0)
			$field:=cs:C1710.AlphaField.new($table; $fieldname; $att.indexed; 5; 50)
			
		: ($type=2)
			$field:=cs:C1710.TextField.new($table; $fieldname; $att.indexed; 100; 5000)
			
		: ($type=-1)
			$field:=cs:C1710.UUIDField.new($table; $fieldname; $att.indexed)
			
		: ($type=1)
			$field:=cs:C1710.RealField.new($table; $fieldname; $att.indexed; 0; 5000000000)
			
		: ($type=8)
			$field:=cs:C1710.IntegerField.new($table; $fieldname; $att.indexed; 0; 32000)
			
		: ($type=9)
			$field:=cs:C1710.IntegerField.new($table; $fieldname; $att.indexed; 0; 2000000000)
			
		: ($type=6)
			$field:=cs:C1710.BooleanField.new($table; $fieldname; $att.indexed)
			
		: ($type=30)
			$field:=cs:C1710.BlobField.new($table; $fieldname; $att.indexed; 100; 4000)
			
		: ($type=38)
			$field:=cs:C1710.ObjectField.new($table; $fieldname; $att.indexed)
			
		: ($type=4)
			$field:=cs:C1710.DateField.new($table; $fieldname; $att.indexed)
			
	End case 
	
	$field:=OB Copy:C1225($field; ck shared:K85:29)
	$keeptable.AddField($field)
	// $field.associateTable($keeptable)
	
	
	
	//--------------------------------------------------------
	
	
Function buildField($table : cs:C1710.TableRef; $fieldname : Text; $indexed : Boolean; $type : Text)->$field : cs:C1710.BaseField
	$fieldname:=$type+"_"+$fieldname
	
	var $keeptable : cs:C1710.TableRef
	$keeptable:=$table
	$table:=Null:C1517
	
	Case of 
			
		: ($type="alpha")
			$field:=cs:C1710.AlphaField.new($table; $fieldname; $indexed; 5; 50)
			
		: ($type="text")
			$field:=cs:C1710.TextField.new($table; $fieldname; $indexed; 100; 5000)
			
		: ($type="uuid")
			$field:=cs:C1710.UUIDField.new($table; $fieldname; $indexed)
			
		: ($type="real")
			$field:=cs:C1710.RealField.new($table; $fieldname; $indexed; 0; 5000000000)
			
		: ($type="integer")
			$field:=cs:C1710.IntegerField.new($table; $fieldname; $indexed; 0; 32000)
			
		: ($type="longint")
			$field:=cs:C1710.IntegerField.new($table; $fieldname; $indexed; 0; 2000000000)
			
		: ($type="bool")
			$field:=cs:C1710.BooleanField.new($table; $fieldname; $indexed)
			
		: ($type="blob")
			$field:=cs:C1710.BlobField.new($table; $fieldname; $indexed; 100; 4000)
			
		: ($type="object")
			$field:=cs:C1710.ObjectField.new($table; $fieldname; $indexed)
			
		: ($type="date")
			$field:=cs:C1710.DateField.new($table; $fieldname; $indexed)
			
	End case 
	
	$field:=OB Copy:C1225($field; ck shared:K85:29)
	$keeptable.AddField($field)
	// $field.associateTable($keeptable)
	
	
	
	
	//--------------------------------------------------------
	
Function buildModel()
	var $xml : Text
	var $table : cs:C1710.TableRef
	
	$xml:=File:C1566("/RESOURCES/template.xml").getText()
	
	var $i; $j; $n; $nbsub : Integer
	var $part : Text
	
	// first generate in mem definition
	For ($i; 1; This:C1470.settings.nbTables)
		$table:=OB Copy:C1225(cs:C1710.TableRef.new("table"+String:C10($i)))
		Use (This:C1470)
			This:C1470.tables.push($table)
		End use 
		
		$n:=0
		For each ($part; This:C1470.settings.fields)
			var $field : cs:C1710.BaseField
			$nbsub:=This:C1470.settings.fields[$part]
			For ($j; 1; $nbsub)
				$n:=$n+1
				$fieldname:="field"+String:C10($n)
				$field:=This:C1470.buildField($table; $fieldname; False:C215; $part)
				$table.AddField($field)
			End for 
			
		End for each 
		
		For each ($part; This:C1470.settings.indexedFields)
			var $field : cs:C1710.BaseField
			$nbsub:=This:C1470.settings.indexedFields[$part]
			For ($j; 1; $nbsub)
				$n:=$n+1
				$fieldname:="field"+String:C10($n)
				$field:=This:C1470.buildField($table; $fieldname; True:C214; $part)
				$table.AddField($field)
			End for 
			
		End for each 
		
	End for 
	
	// now generate xml file content
	
	For each ($table; This:C1470.tables)
		$xml:=$xml+$table.generateXMLDef()+Char:C90(13)+Char:C90(10)
	End for each 
	
	$xml:=$xml+"</base>"+Char:C90(13)+Char:C90(10)
	
	var $file : 4D:C1709.File
	// $file:=File("/RESOURCES/out.xml")
	$file:=File:C1566("/PROJECT/Sources/catalog.4DCatalog")
	$file.setText($xml)
	
	
	
	//--------------------------------------------------------
	
	
	
Function analyseStructure()
	var $dataclass : 4D:C1709.DataClass
	var $table : cs:C1710.TableRef
	var $att : Object
	var $dataclassName; $attname : Text
	var $field : cs:C1710.BaseField
	
	For each ($dataclassName; ds:C1482)
		$table:=OB Copy:C1225(cs:C1710.TableRef.new($dataclassName); ck shared:K85:29)
		This:C1470.tables.push($table)
		$dataclass:=ds:C1482[$dataclassName]
		For each ($attname; $dataclass)
			$att:=$dataclass[$attname]
			If (($att.kind="storage") & ($att.unique=False:C215))
				$field:=This:C1470.buildFieldFromAttribute($dataclass; $table; $attname; $att)
				$table.AddField($field)
			End if 
		End for each 
		
	End for each 
	
	
	
	//--------------------------------------------------------
	
Function generateNumber($min : Real; $max : Real)->$result : Real
	var $range; $result; $div; $mod : Real
	$range:=$max-$min
	var $r1; $r2; $r3 : Real
	$r1:=Random:C100
	$r2:=Random:C100
	$r3:=Random:C100
	$result:=$r1*$r2*$r3
	$div:=Trunc:C95($result/$range; 0)
	$mod:=$result-($div*$range)
	$result:=$mod+$min
	
	//$result:=($r1*$r2*$r3)%$range+$min
	
	
Function generateWord($len : Integer)->$word : Text
	var $i : Integer
	$word:=""
	For ($i; 1; $len)
		$char:=Char:C90(Random:C100%26+97)
		$word:=$word+$char
	End for 
	
Function generateSentence($len : Integer)->$sentence : Text
	$sentence:=""
	While (Length:C16($sentence)<$len)
		$sentence:=$sentence+This:C1470.generateWord(Random:C100%20+2)+" "
	End while 
	
	
	
	//--------------------------------------------------------
	
	
Function generateData($howMany : Integer)
	var $table : cs:C1710.TableRef
	
	For each ($table; This:C1470.tables)
		$table.generateData(This:C1470; $howMany); 
	End for each 
	
	
	//--------------------------------------------------------
	
	
Function getRandomTable()->$table : cs:C1710.TableRef
	var $n : Integer
	$n:=Random:C100%(This:C1470.tables.length)
	$table:=This:C1470.tables[$n]
	
	
	//--------------------------------------------------------
	
	
Function getAllTables()->$tables : Collection
	$tables:=This:C1470.tables
	
	
	//--------------------------------------------------------
	
	
Function preFillCache()
	var $table : cs:C1710.TableRef
	For each ($table; This:C1470.tables)
		$table.preFillCache()
	End for each 
	
	
	
	
	
	