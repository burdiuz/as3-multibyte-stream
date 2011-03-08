package aw.utils{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	
	import flash.geom.*;
	import flash.utils.*;
	/**
	 * Utils class to work with bytes and bits.
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class BinUtils extends Object{
		static private var POWS_LENGTH:uint;
		static public const MAX_POW_INDEX:int = 64;
		static public const MAX_VALID_POW_INDEX:int = 53;
		static private const POWS:Vector.<int> = function():Vector.<int>{
			var arr:Vector.<int> = new Vector.<int>(65, true);
			arr[0] = 0;
			for(var i:int=1; i<65; i++){
				arr[i] = (2<<i-1)-1;
			}
			POWS_LENGTH = arr.length;
			return arr;
		}();
		/**
		* Возвращает объект Rectangle из данных, полученых из ByteArray. Использует спецификацию SWF, маркер RECT.
		* @param Объект ByteArray из которого вынимаются данные. Остаток от операции сбрасывается. Позиция ByteArray.position не восстанавливается.
		* @return Rectangle
		*/
		static public function readRect(ba:ByteArray):Rectangle{
			var first:int = ba.readUnsignedByte();
			var len:int = first>>3;
			var arr:Array = readBitArray(ba, len, 4, first&7, 3);
			return new Rectangle(arr[0], arr[2], arr[1], arr[3]);
		}
		static public function readUnsignedRect(ba:ByteArray):Rectangle{
			var first:int = ba.readUnsignedByte();
			var len:int = first>>3;
			var arr:Array = readUnsignedBitArray(ba, len, 4, first&7, 3);
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
		*/
		static public function readBitArray(ba:ByteArray, length:int, count:int=1, firstI:int=0, firstL:int=0):Array{
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
		static public function getCrop(value:Number, count:int, length:int):Number{
			return value >> (length-count);
		}
		/**
		* Получить левую часть, в бинарном представлении, от числа.
		* @param значение
		* @param размер вырезаемой части в битах
		* @param размер числа в кол-ве бит.
		*/
		static public function getLCrop(value:Number, count:int, length:int):Number{
			return value >> (length-count);
		}
		/**
		* Получить правую часть, в бинарном представлении, от значения.
		* @param значение
		* @param размер вырезаемой части в битах
		*/
		static public function getRCrop(value:Number, count:int):Number{
			return value&POWS[count];
		}
		/**
		* Получить маску для вырезания правой части.
		* @param размер вырезаемой части в битах
		*/
		static public function getRCropMask(length:int):int{
			return POWS[length];
		}
		/**
		* Получить значение бита
		* @param число
		* @param номер бита
		*/
		static public function getBit(value:int, position:int):int{
			return (1<<--position & value)>>position;
		}
		/**
		* Обратить значение бита
		* @param число
		* @param номер бита
		*/
		static public function resetBit(value:int, position:int):int{
			if(1 & value >> --position) return  value ^ 1 << position;
			else return value | 1 << position;
		}
		/**
		* Определить значение бита
		* @param число
		* @param значение бита 0 или 1 / false или true.
		* @param номер бита
		*/
		static public function setBit(value:int, c:*, pos:int):int{
			if(c) return  value | 1 << pos-1;
			else return value>>pos<<pos | (value & POWS[pos-1]);
		}
		/**
		* Разбить значение побитово на неравномерные части.
		* @param значение
		* @param длинна значения в битах.
		* @param массив длин частей в битах.
		*/
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
		*/
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
		*/
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
		* @param значение
		* @param длинна значения в битах.
		*/
		static public function convertSignedInt(i:int, len:uint=32):uint{
			if(i>=0) return i;
			return -i | 1<<(len-1);
		}
		static public function convertToNegative(i:uint, len:uint=32):int{
			return -(--i^POWS[len]);
		}
		static public function getPow(index:int):Number{
			return POWS[index];
		}
		static public function getPows():Vector.<int>{
			return POWS;
		}
		static public function getClosePow(value:uint):Number{
			var pow:uint = 1;
			var i:int = 0;
			while(i<POWS_LENGTH && (pow = POWS[i])<value){
				i++;
			}
			return pow;
		}
		static public function getBitCount(value:Number, countSign:Boolean=false):int{
			var count:int = 0;
			if(!value) return count;
			if(countSign){
				if(value<0) return (value is int) ? 32 : 64;
			}else{
				if(value<0) value = -value;
			}
			while(value){
				count++;
				value >>= 1;
			}
			return count;
		}
		static public function getReader(ba:ByteArray=null):MultibyteReader{
			return new MultibyteReader(ba);
		}
		static public function getWriter(ba:ByteArray=null):MultibyteWriter{
			return new MultibyteWriter(ba);
		}
	}
}