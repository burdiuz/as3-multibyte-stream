<?php
class BinUtils {
	/**
	 * @var integer
	 */
	static private $POWS_LENGTH;
	/**
	 * @var integer
	 */
	const MAX_POW_INDEX = 64;
	/**
	 * @var integer
	 */
	const MAX_VALID_POW_INDEX = 53;
	/**
	 * @var integer[]
	 */
	static private $POWS;
	static public function __initialize(){
		$arr = array(0);
		for($index=1; $index<65; $index++){
			$arr[$index] = pow(2, $index)-1;
		}
		self::$POWS_LENGTH = count($arr);
		self::$POWS = $arr;
	}
	/**
	* Возвращает объект Rectangle из данных, полученых из ByteArray. Использует спецификацию SWF, маркер RECT.
	* @param Объект ByteArray из которого вынимаются данные. Остаток от операции сбрасывается. Позиция ByteArray.position не восстанавливается.
	* @return Rectangle
	* /
	static public function readRect(Bytes $ba){
		var first:int = ba.readUnsignedByte();
		var len:int = first>>3;
		var arr:Array = readBitArray($ba, len, 4, first&7, 3);
		return new Rectangle(arr[0], arr[2], arr[1], arr[3]);
	}
	static public function readUnsignedRect(Bytes $ba):Rectangle{
		var first:int = 
ba . readUnsignedByte ();
		var len:int = first>>3;
		var arr:Array = readUnsignedBitArray($ba, len, 4, first&7, 3);
		return new Rectangle(arr[0], arr[2], arr[1], arr[3]);
	}
	/**
	* Возвращает массив значений произвольной длинны, полученых из ByteArray.
	* @param Объект ByteArray из которого вынимаются данные. Остаток от операции сбрасывается. Позиция ByteArray.position не восстанавливается.
	* @param Длина значения в битах.
	* @param Количество необходимых значений.
	* @param Начальное значение, к нему будут присоединятся новые значения из ByteArray и из него будут выниматься необходимые значения.
	* @param Длина начального значения, в битах.
	* @return Array
	* /
	static public function readBitArray(Bytes $ba, length:int, count:int=1, firstI:int=0, firstL:int=0):Array{
		var arr:Array = new Array();
		var i:int = 0;
		while(i<count){
			if(firstL<length){
				firstI = firstI<<8 | ba.readUnsignedByte();
				firstL += 8;
				continue;
			}
			var prop:int = firstI >> (firstL - length);
			if((1<<length-1 & prop)>>length-1) prop = -(prop&POWS[length-1]);
			arr.push(prop);
			firstI = firstI&POWS[firstL-=length];
			i++;
		}
		return arr;
	}
	static public function readUnsignedBitArray(ba:ByteArray, length:int, count:int=1, firstI:int=0, firstL:int=0):Array{
		var arr:Array = new Array();
		var i:int = 0;
		while(i<count){
			if(firstL<length){
				firstI = firstI<<8 | ba.readUnsignedByte();
				firstL += 8;
				continue;
			}
			arr.push(firstI >> (firstL - length));
			firstI = firstI&POWS[firstL-=length];
			i++;
		}
		return arr;
	}
	/**
	* Разбить значение побитово на неравномерные части.
	* @param значение
	* @param длинна значения в битах.
	* @param массив длин частей в битах.
	* /
	static public function getParted(value:Number, max:int, ...args:Array):Array{
		var len:int = args.length;
		var arr:Array = new Array();
		var num:int = 0;
		for(var i:int=0; i<len; i++){
			max-= args[i];
			arr.push(value>>max);
			value = value&POWS[max];
		}
		arr.push(value);
		return arr;
	}
	/**
	* Копирует содержимое объекта ByteArray.
	* @param Объект ByteArray, источник данных.
	* /
	static public function copy(ba:ByteArray, pos:uint=0, len:int=0):ByteArray{
		if(len==0){
			if(pos==0) return clone(ba);
			len = ba.length;
		}else if(len<0){
			len = ba.length-len;
		}
		var ret:ByteArray = new ByteArray();
		ret.endian = ba.endian;
		ret.objectEncoding = ba.objectEncoding;
		var i:int = 0;
		while(pos<len){
			ret[i] = ba[pos];
			pos++;
			i++;
		}
		return ret;
	}
	/**
	* Клонирует объект ByteArray.
	* @param Объект ByteArray, который нужно клонировать
	* /
	static public function clone(ba:ByteArray):ByteArray{
		var pos:int = ba.position;
		ba.position = 0;
		var con:ByteArray = new ByteArray();
		con.position = 0;
		con.writeBytes(ba);
		con.position = ba.position = pos;
		con.endian = ba.endian;
		con.objectEncoding = ba.objectEncoding;
		return con;
		
	}
	static public function getReader(ba:ByteArray=null):MultibyteReader{
		return new MultibyteReader(ba);
	}
	static public function getWriter(ba:ByteArray=null):MultibyteWriter{
		return new MultibyteWriter(ba);
	}
	static public function containsString(haystack:ByteArray, needle:String):Boolean{
		return searchString(haystack, needle) !== -1;
	}
	static public function contains(haystack:ByteArray, needle:ByteArray):Boolean{
		return search(haystack, needle) !== -1;
	}
	static public function searchString(haystack:ByteArray, needle:String, from:int=0, to:int=int.MAX_VALUE):int{
		const needleByteArray:ByteArray = new ByteArray();
		needleByteArray.writeUTFBytes(needle);
		return search(haystack, needleByteArray, from, to);
	}
	static public function search(haystack:ByteArray, needle:ByteArray, from:int=0, to:int=int.MAX_VALUE):int{
		const length:int = Math.min(haystack.length, to);
		const nLength:int = needle.length;
		search: for(var i:int=from; i<length; ++i){
			for(var j:int = 0; j<nLength; ++j){
				var pos:int = i+j;
				if (pos>=length || haystack[pos] !== needle[j]){
					continue search;
				}
			}
			return i;
		}
		return -1;
	}
	/**
	 * 
	 */
	static public function getCrop($value, $bitCount, $numLength){
		return $value >> ($numLength-$bitCount);
	}
	/**
	* Получить левую часть, в бинарном представлении, от числа.
	* @param значение
	* @param размер вырезаемой части в битах
	* @param размер числа в кол-ве бит.
	*/
	static public function getLCrop($value, $bitCount, $numLength){
		return $value >> ($numLength-$bitCount);
	}
	/**
	* Получить правую часть, в бинарном представлении, от значения.
	* @param значение
	* @param размер вырезаемой части в битах
	*/
	static public function getRCrop($value, $bitCount){
		return $value & self::$POWS[$bitCount];
	}
	/**
	* Получить маску для вырезания правой части.
	* @param размер вырезаемой части в битах
	*/
	static public function getRCropMask($numLength){
		return self::$POWS[$numLength];
	}
	/**
	* Получить значение бита
	* @param число
	* @param номер бита
	*/
	static public function getBit($value, $position){
		return ($value >> $position) & 1;
	}
	/**
	* Обратить значение бита
	* @param число
	* @param номер бита
	*/
	static public function resetBit($value, $position){
		if(1 & $value >> --$position) return  $value ^ 1 << $position;
		else return $value | 1 << $position;
	}
	/**
	* Определить значение бита
	* @param число
	* @param значение бита 0 или 1 / false или true.
	* @param номер бита
	*/
	static public function setBit($value, $bitValue, $position){
		if($bitValue) return  $value | 1 << $position-1;
		else return $value >> $position << $position | ($value & self::$POWS[$position-1]);
	}
	/**
	* Функция приводит к "правильному" виду отрицательные числа для записи в ByteArray. 
	* В ActionScript используется обратная запись отрицательных целых чисел - в бинарном 
	* виде все знаки инвертируются(1->0, 0->1) и к числу прибавляется единица. Поэтому 
	* записав, теоретически, byte -3, вы получите 11111101, вместо 10000011.
	<listing version="3.0">
import flash.utils.ByteArray;
import aw.utils.BinUtils;
var i:int = -3;
var ba:ByteArray = new ByteArray();
ba.writeByte(i);
ba.position = 0;
trace(ba.readUnsignedByte().toString(2));
trace(BinUtils.convertSignedInt(i, 8).toString(2));
	</listing>
	* @param $value integer значение
	* @param $length integer длинна значения в битах.
	*/
	static public function convertSignedInt($value, $length=32){
		if($value>=0) return $value;
		return -$value | 1<<($length-1);
	}
	static public function convertToNegative($value, $length=32){
		return -(--$value^self::$POWS[$length]);
	}
	static public function getPow($index){
		return self::$POWS[$index];
	}
	static public function getPows(){
		return self::$POWS;
	}
	static public function getClosePow($value){
		$pow = 1;
		$index = 0;
		while($index<self::$POWS_LENGTH && $pow < $value){
			$pow = self::$POWS[++$index];
		}
		return $pow;
	}
	static public function getBitCount($value, $countSign=false){
		$count = 0;
		if(!$value) return $count;
		if($countSign){
			if($value<0) return 2 << PHP_INT_SIZE;
		}else{
			if($value<0) $value = -$value;
		}
		while($value){
			$count++;
			$value >>= 1;
		}
		return $count;
	}
	// ------------------------------------- PHP Specific 
	/**
	 * Converts binary representation to Signed Integer
	 */
	static public function convertToSignedForm($value, $length=32, $useTwosComplement=true){
		$signBit = 1<<($length-1);
		if($value & $signBit){
			// Special case for PHP numbers here. We should skip conversion if length = 32 and $useTwosComplement = true because its natural form of PHP negative numbers, so its "already converted".
			if($useTwosComplement){
				$value = $length == 32 && $value<0 ? $value : -abs($value+1) ^ ((1<<$length)-1);
			}else{
				$value = -($value & ($signBit-1));
			}
		}
		return $value;
	}
	/**
	 * Convers signed integer to binary representation(unsigned integer with same per-bit value)
	 */
	static public function convertToUnsignedForm($value, $length=32, $useTwosComplement=true){
		$signBit = 1<<($length-1);
		if($value & $signBit){
			$value = $useTwosComplement ? ((-$value ^ ((1<<($length-1))-1)) | $signBit)+1 : (-$value & ((1<<$length)-1)) | $signBit;
		}
		return $value;
	}
	/**
	 * @param $stream string
	 * @param $bytesCount integer
	 * @param $position integer
	 * @param endian integer 
	 */
	static public function readUnsignedNumber($stream, $bytesCount=4, $position=0, $endian=1){
		$result = 0;
		for($index=0; $index<$bytesCount; $index++){
			$byte = ord($stream[$position+$index]);
			switch($endian){
				case Endian::LITTLE_ENDIAN:
					$result = $byte << ($index*8) | $result;
				break;
				case Endian::BIG_ENDIAN:
				default:
					$result = $result << 8 | $byte;
				break;
			}
		}
		return $result;
	}
	static public function readNumber($stream, $bytesCount=4, $position=0, $endian=1, $useTwosComplement=true){
		$result = self::readUnsignedNumber($stream, $bytesCount, $position, $endian);
		return self::convertToSignedForm($result, $bytesCount*8, $useTwosComplement);
	}
	/**
	 * 
	 * @param unknown $stream
	 * @param unknown $value
	 * @param unknown $position
	 * @param number $bytesCount
	 * @param number $endian
	 * @param string $useTwosComplement
	 */
	static public function writeNumber($stream, $value, $bytesCount=4, $position=0, $endian=1, $useTwosComplement=true){
		if($value<0){
			if($useTwosComplement) $stream = self::write2sComplementNegativeNumber($stream, $value, $bytesCount, $position, $endian);
			else $stream = self::writeNormalizedNegativeNumber($stream, $value, $bytesCount, $position, $endian);
		}else{
			$stream = self::writeUnsignedNumber($stream, $value, $bytesCount, $position, $endian);
		}
		return (string)$stream;
	}
	/**
	 * Writes number by its value, so if negative number passed it will change sign first.
	 * @param unknown $stream
	 * @param unknown $value
	 * @param unknown $position
	 * @param number $bytesCount
	 * @param number $endian
	 */
	static public function writeUnsignedNumber($stream, $value, $bytesCount=4, $position=0, $endian=1){
		if($value<0) $value = -$value;
		for($index=0; $index<$bytesCount; $index++){
			switch($endian){
				case Endian::LITTLE_ENDIAN:
					$byte = $value & 0xFF;
					$value = $value >> 8;
					break;
				case Endian::BIG_ENDIAN:
				default:
					$byte = ($value >> ($bytesCount-$index-1)*8) & 0xFF;
					break;
			}
			$stream[$position+$index] = chr($byte);
		}
		return (string)$stream;
	}
	/**
	 * Writes number exactly as its stored in memory, if negative -- 2's complement negative number. 
	 * @param unknown $stream
	 * @param unknown $value
	 * @param unknown $position
	 * @param number $bytesCount
	 * @param number $endian
	 */
	static protected function write2sComplementNegativeNumber($stream, $value, $bytesCount=4, $position=0, $endian=1){
		for($index=0; $index<$bytesCount; $index++){
			switch($endian){
				case Endian::LITTLE_ENDIAN:
					$byte = $value & 0xFF;
					$value >>= 8;
					break;
				case Endian::BIG_ENDIAN:
				default:
					$byte = ($value >> ($bytesCount-$index-1)*8) & 0xFF;
					break;
			}
			$stream[$position+$index] = chr($byte);
		}
		return (string)$stream;
	}
	static protected function writeNormalizedNegativeNumber($stream, $value, $bytesCount=4, $position=0, $endian=1){
		$bytes = "";
		$increase = true;
		$lastIndex = $bytesCount-1;
		for($index=0; $index<=$lastIndex; $index++){
			$byte = ($value & 0xFF) ^ 0xFF;
			$value >>= 8;
			if($index==$lastIndex) $byte |= 128;
			if($increase){
				$byte += 1;
				if($byte <= 0xFF) $increase = false;
				else $byte &= 0xFF; // in case if we have this situation even on last byte, that means total value is more than $bytesCount and should produce calculation error;
			}
			//echo str_pad(decbin($byte), 8, '0', STR_PAD_LEFT).'<br>';
			switch($endian){
				case Endian::LITTLE_ENDIAN:
					$bytes .= chr($byte);
					break;
				case Endian::BIG_ENDIAN:
				default:
					$bytes = chr($byte).$bytes;
					break;
			}
		}
		for($index=0; $index<$bytesCount; $index++){
			$stream[$position+$index] = $bytes[$index];
		}
		return (string)$stream;
	}
	static public function str2bin($stream, $spacer = ''){
		$string = '';
		$count = strlen($stream);
		if($count){
			$string = self::chr2bin($stream[0]);
			for($index=1; $index<$count; $index++){
				$string .= $spacer.self::chr2bin($stream[$index]);
			}
		}
		return (string)$string;
	}
	static public function chr2bin($char){
		$string = decbin(ord($char[0]));
		return str_pad($string, 8, '0', STR_PAD_LEFT);
	}
	static public function unsignedRightShift($value, $bias){
    	return ($value >= 0) ? ($value >> $bias) : (($value & 0x7fffffff) >> $bias) | (0x40000000 >> ($bias - 1));
	}
}
/* TESTS
?>
<span style="font-family:Lucida Console; ">
<?php 
require "Endian.php";
BinUtils::__initialize();

function testConversion($value, $length, $endian, $twosComplement){
	$stream = " ";
	echo '------ START -------------- '.$value.'<br>';
	$stream = BinUtils::writeNumber($stream, $value, $length, 0, $endian, $twosComplement);
	echo 'ORIG:'.str_pad(strlen(decbin($value)), 2, ' ', STR_PAD_LEFT).', '.strInt32(decbin($value)).'<br>';
	echo 'WRIT:'.str_pad(strlen(BinUtils::str2bin($stream)), 2, ' ', STR_PAD_LEFT).', '.strInt32(BinUtils::str2bin($stream)).'<br>';
	$value = BinUtils::readNumber($stream, $length, 0, $endian, $twosComplement);
	echo 'READ:'.str_pad(strlen(decbin($value)), 2, ' ', STR_PAD_LEFT).', '.strInt32(decbin($value)).'<br>';
	echo '------ END ---------------- '.$value.'<br>';
}
function strInt32($value){
	return str_replace(' ', '&nbsp;', str_pad($value, 32, ' ', STR_PAD_LEFT));
}
testConversion(-2346, 4, Endian::BIG_ENDIAN, true);
testConversion(-2346, 4, Endian::BIG_ENDIAN, false);
testConversion(-754, 2, Endian::BIG_ENDIAN, true);
testConversion(-754, 2, Endian::BIG_ENDIAN, false);
testConversion(-2346, 4, Endian::LITTLE_ENDIAN, true);
testConversion(-2346, 4, Endian::LITTLE_ENDIAN, false);
testConversion(-754, 2, Endian::LITTLE_ENDIAN, true);
testConversion(-754, 2, Endian::LITTLE_ENDIAN, false);

testConversion(3426, 4, Endian::BIG_ENDIAN, true);
testConversion(3426, 4, Endian::BIG_ENDIAN, false);
testConversion(457, 2, Endian::BIG_ENDIAN, true);
testConversion(457, 2, Endian::BIG_ENDIAN, false);
testConversion(4623, 4, Endian::LITTLE_ENDIAN, true);
testConversion(4623, 4, Endian::LITTLE_ENDIAN, false);
testConversion(574, 2, Endian::LITTLE_ENDIAN, true);
testConversion(574, 2, Endian::LITTLE_ENDIAN, false);
///echo decbin(BinUtils::convertToUnsignedForm(-127, 16, false));
//*/
?>