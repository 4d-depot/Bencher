Class constructor()
	
	
	
Function initStorage($tables : Collection)
	Use (Storage:C1525)
		var $table : cs:C1710.TableRef
		For each ($table; $tables)
			var $field : cs:C1710.BaseField
			For each ($field; $table.fields)
				var $id : Text
				$id:=$field.getMetricID()
				$metricInfo:=New shared object:C1526("count"; 0; "time"; 0)
				Storage:C1525[$id]:=$metricInfo
			End for each 
		End for each 
		Storage:C1525.currentMeasure:=New shared object:C1526("count"; 0; "time"; 0; "lastChecked"; Milliseconds:C459)
		Storage:C1525.previousMeasure:=New shared object:C1526("count"; 0; "time"; 0)
	End use 
	
	
	
Function addMeasure($field : cs:C1710.BaseField; $starttime : Integer)
	var $id : Text
	$id:=$field.getMetricID()
	var $metricInfo : Object
	$metricInfo:=Storage:C1525[$id]
	Use ($metricInfo)
		$metricInfo.count:=$metricInfo.count+1
		$metricInfo.time:=$metricInfo.time+Abs:C99(Milliseconds:C459-$starttime)
	End use 
	
	$metricInfo:=Storage:C1525.currentMeasure
	Use ($metricInfo)
		$metricInfo.count:=$metricInfo.count+1
		$metricInfo.time:=$metricInfo.time+Abs:C99(Milliseconds:C459-$starttime)
	End use 
	
	
	
Function getAndResetCurrentMeasure()->$measure : Object
	$t:=Milliseconds:C459
	var $metricInfo; $previousMetricInfo : Object
	
	$measure:=New object:C1471
	$metricInfo:=Storage:C1525.currentMeasure
	$previousMetricInfo:=Storage:C1525.previousMeasure
	$elapsed:=Abs:C99($t-$metricInfo.lastChecked)
	If ($elapsed>1000)
		Use ($metricInfo)
			$measure.count:=$metricInfo.count
			$measure.time:=$metricInfo.time
			$measure.elapsed:=$elapsed
			var $path : Collection
			var $cache : Object
			$path:=New collection:C1472("DB.cacheMissCount"; "DB.cacheReadCount"; "DB.cacheMissBytes"; "DB.cacheReadBytes")
			$measure.dataAccesses:=Get database measures:C1314(New object:C1471("path"; $path)); 
			$cache:=Cache info:C1402()
			$measure.dataAccesses.cache:=New object:C1471("usedMem"; $cache.usedMem; "maxMem"; $cache.maxMem)
			$previousMetricInfo:=New object:C1471
			$previousMetricInfo.count:=$metricInfo.count
			$previousMetricInfo.time:=$metricInfo.time
			$previousMetricInfo.elapsed:=$elapsed
			$previousMetricInfo.dataAccesses:=$measure.dataAccesses
			Use (Storage:C1525)
				Storage:C1525.previousMeasure:=OB Copy:C1225($previousMetricInfo; ck shared:K85:29)
			End use 
			$metricInfo.time:=0
			$metricInfo.count:=0
			$metricInfo.lastChecked:=$t
		End use 
	Else 
		Use ($previousMetricInfo)
			$measure.count:=$previousMetricInfo.count
			$measure.time:=$previousMetricInfo.time
			$measure.elapsed:=$previousMetricInfo.elapsed
			$measure.dataAccesses:=$previousMetricInfo.dataAccesses
		End use 
	End if 
	
	