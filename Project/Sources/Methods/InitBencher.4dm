//%attributes = {"preemptive":"capable"}
#DECLARE($buildModel : Boolean)->$bencher : cs:C1710.Bencher

Use (Storage:C1525)
	$bencher:=Storage:C1525.bencher
	If ($bencher=Null:C1517)
		$bencher:=OB Copy:C1225(cs:C1710.Bencher.new(Null:C1517); ck shared:K85:29)
		Storage:C1525.bencher:=$bencher
		
		If ($buildModel)
			$bencher.buildModel()
			// RESTART 4D
		Else 
			$bencher.analyseStructure(); 
		End if 
		
		var $metric : cs:C1710.Metric
		$metric:=$bencher.getMetric()
	End if 
	
	
End use 
