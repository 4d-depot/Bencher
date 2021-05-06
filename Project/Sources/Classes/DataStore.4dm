Class extends DataStoreImplementation



exposed Function buildModel()
	var $b : cs:C1710.Bencher
	$b:=InitBencher(True:C214)
	RESTART 4D:C1292
	
	
	
exposed Function generateData($howmanyRecords : Integer)->$status : Object
	var $b : cs:C1710.Bencher
	$b:=InitBencher(False:C215)
/*
If (Count parameters=0)
$howmanyRecords:=100000
End if 
*/
	$b.generateData($howmanyRecords)
	$status:=New object:C1471("nbrec"; $howmanyRecords)
	
	
	
	
exposed Function randomGetEntity()->$entity : 4D:C1709.Entity
	var $b : cs:C1710.Bencher
	$b:=InitBencher(False:C215)
	var $table : cs:C1710.TableRef
	$table:=$b.getRandomTable()
	$entity:=$table.getRandomEntity($b; True:C214)
	
	
	
exposed Function getMeasures()->$mesure : Object
	var $b : cs:C1710.Bencher
	$b:=InitBencher(False:C215)
	$mesure:=$b.getMetric().getAndResetCurrentMeasure()
	
	
exposed Function randomAlterEntity()->$entity : 4D:C1709.Entity
	var $b : cs:C1710.Bencher
	$b:=InitBencher(False:C215)
	var $table : cs:C1710.TableRef
	$table:=$b.getRandomTable()
	$entity:=$table.alterRandomEntity($b; True:C214)
	
	
exposed Function setCacheSize($cachesize : Real)->$ok : Boolean
	SET CACHE SIZE:C1399($cachesize; $cachesize/20)
	$ok:=True:C214
	
	
exposed Function getCacheInfo()->$cacheinfo : Object
	var $cache : Object
	$cache:=Cache info:C1402()
	$cacheinfo:=New object:C1471("usedMem"; $cache.usedMem; "maxMem"; $cache.maxMem)
	
	
exposed Function preFillCache()->$ok : Boolean
	var $b : cs:C1710.Bencher
	$b:=InitBencher(False:C215)
	$b.preFillCache()
	
	$ok:=True:C214
	
	
	
	