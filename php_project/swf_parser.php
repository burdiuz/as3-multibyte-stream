<?php 
/*
 * UnitTesting: http://habrahabr.ru/post/56289/
 */
$args = null;
$predefinedCLAValues = array(
		'true' => true,
		'false' => false,
		'null' => null
);
function readCommandlineArguments(){
	global $args, $predefinedCLAValues;
	$args = array();
	$valuedArgs = array();
	$argName = 'phpSelf';
	for($index=1; $index<count($argv); $index++){
		if($argv[$index][0]=='-'){
			$argName = substr($argv[$index], 1);
			$args[$argName] = true;
		}else{
			$value = $argv[$index];
			if(isset($predefinedCLAValues[$value])) $value =  $predefinedCLAValues[$value];
			if(isset($valuedArgs[$argName])){
				if(is_array($args[$argName])) array_push($args[$argName], $value);
				else $args[$argName] = array($args[$argName], $value);
			}else{
				$args[$argName] = $value;
				$valuedArgs[$argName] = true;
			}
		}
	}
}
readCommandlineArguments();

$content = file_get_contents('eias3.swf');
switch($content[0]){
	case 'C': // unpack from zip
	
	break;
	case 'Z': // unpack from lzma
	
	break;
	case 'F': // skip
	break;
}
?>