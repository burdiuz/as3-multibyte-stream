package aw.utils{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
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
			var list:Vector.<int> = new Vector.<int>(65, true);
			list[0] = 0;
			for(var index:int=1; index<65; index++){
				list[index] = (2<<index-1)-1;
			}
			POWS_LENGTH = list.length;
			return list;
		}();
		/**
		 * Get a Rectangle filled with x/y/with/height values from RECT marker  based on SWF specification.
		 * @param Объект ByteArray Data source. Data left after reading Rect values will be forotten.
		 * @return Rectangle
		*/
		[Inline]
		static public function readRect(byteArray:ByteArray):Rectangle{
			var first:int = byteArray.readUnsignedByte();
			var length:int = first>>3;
			var list:Array = readBitArray(byteArray, length, 4, first&7, 3);
			return new Rectangle(list[0], list[2], list[1], list[3]);
		}
		/**
		 * Reads Rectangle values as unsigned integers.
		 * @see aw.utils.BinUtils:readRect
		 */
		[Inline]
		static public function readUnsignedRect(byteArray:ByteArray):Rectangle{
			var first:int = byteArray.readUnsignedByte();
			var length:int = first>>3;
			var arr:Array = readUnsignedBitArray(byteArray, length, 4, first&7, 3);
			return new Rectangle(arr[0], arr[2], arr[1], arr[3]);
		}
		/**
		* Get an Array of values with cutom length.
		* @param Объект ByteArray Data source. Data left after reading Rect values will be forotten. ByteArray.position value will not be returned to value before this operation, so you can track where Array ends.
		* @param Bits of value length.
		* @param Array length, values count to read.
		* @param Base value for first byte, to use with first ByteArray value.
		* @param Длина начального значения, в битах.
		* @return Array
		*/
		[Inline]
		static public function readBitArray(byteArray:ByteArray, length:int, count:int=1, baseValue:int=0, baseLength:int=0):Array{
			var list:Array = [];
			var index:int = 0;
			while(index<count){
				if(baseLength<length){
					baseValue = baseValue<<8 | byteArray.readUnsignedByte();
					baseLength += 8;
					continue;
				}
				var prop:int = baseValue >> (baseLength - length);
				if((1<<length-1 & prop)>>length-1) prop = -(prop&POWS[length-1]);
				list[index] = prop;
				baseValue = baseValue&POWS[baseLength-=length];
				index++;
			}
			return list;
		}
		[Inline]
		static public function readUnsignedBitArray(byteArray:ByteArray, length:int, count:int=1, baseValue:int=0, baseLength:int=0):Array{
			var list:Array = new Array();
			var index:int = 0;
			while(index<count){
				if(baseLength<length){
					baseValue = baseValue<<8 | byteArray.readUnsignedByte();
					baseLength += 8;
					continue;
				}
				list[index] = baseValue >> (baseLength - length);
				baseValue = baseValue&POWS[baseLength-=length];
				index++;
			}
			return list;
		}
		[Inline]
		static public function getCrop(value:Number, count:int, length:int):Number{
			return value >> (length-count);
		}
		/**
		* Return left binary part of a source number
		* @param Source value
		* @param Length of a cut in bits
		* @param Length of source number in bits
		*/
		[Inline]
		static public function getLCrop(value:Number, count:int, length:int):Number{
			return value >> (length-count);
		}
		/**
		* Right crop of the value
		* @param Source value
		* @param Bit count to cut from right
		*/
		[Inline]
		static public function getRCrop(value:Number, count:int):Number{
			return value&POWS[count];
		}
		/**
		* Bit mask
		* @param Bit count to fill with "1"
		*/
		[Inline]
		static public function getMask(length:int):int{
			return POWS[length];
		}
		/**
		* Get bit value from source integer
		* @param Source Integer
		* @param Bit index
		*/
		[Inline]
		static public function getBit(value:int, position:int):int{
			return (value>>position) & 1;
		}
		/**
		* Revert bit value
		* @param Source Integer
		* @param Bit index
		*/
		[Inline]
		static public function resetBit(value:int, position:int):int{
			if(1 & value >> --position) return  value ^ 1 << position;
			else return value | 1 << position;
		}
		/**
		* Get a bit value from source integer.
		* @param Source integer
		* @param Bit value 0 or 1 / false or true.
		* @param Bit index
		*/
		[Inline]
		static public function setBit(value:int, c:*, pos:int):int{
			if(c) return  value | 1 << pos-1;
			else return value>>pos<<pos | (value & POWS[pos-1]);
		}
		/**
		* Break integer value to parts.
		* @param Source value
		* @param Length of the value in bits
		* @param List of parts length that should be read
		*/
		[Inline]
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
		* Copy source ByteArray data from position to position+length. It will copy endian and objectEncoding properties also.
		* @param Source ByteArray.
		*/
		[Inline]
		static public function copy(source:ByteArray, position:uint=0, length:int=0):ByteArray{
			if(length==0){
				if(position==0) return clone(source);
				length = source.length;
			}else if(length<0){
				length = source.length-length;
			}
			var result:ByteArray = new ByteArray();
			result.endian = source.endian;
			result.objectEncoding = source.objectEncoding;
			var i:int = 0;
			while(position<length){
				result[i] = source[position];
				position++;
				i++;
			}
			return result;
		}
		/**
		* Clone ByteArray.
		* @param Source ByteArray
		*/
		[Inline]
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
		 * Normalize signed integer, converts from two's complement number to normal notaition.
		 *  AS3 uses two's complement nuumbers to represent negative integers - in a binary representation, 
		 * all bits will be inverted(1->0, 0->1) and to whole number will added 1. For example, if you will 
		 * store byte -3, you will get binary value of 11111101, except 10000011.
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
		* @param Value
		* @param Value length in bits
		*/
		[Inline]
		static public function convertSignedInt(i:int, len:uint=32):uint{
			if(i>=0) return i;
			return -i | 1<<(len-1);
		}
		/**
		 * Converts normal integer value to negative adding last bit set to 1.
		 * @param uint Source value
		 * @param uint Max length of the value that is for byte 8, short - 16 and integer - 32(by default).
		 */
		[Inline]
		static public function convertToNegative(value:uint, length:uint=32):int{
			return -(--value^POWS[length]);
		}
		/**
		 * Returns value's mask  -- same count of bits but filled with "1".
		 */
		[Inline]
		static public function getPow(value:int):Number{
			return POWS[value];
		}
		/**
		 * Value masks collection where index is bits count and value is a mask.
		 */
		[Inline]
		static public function getPows():Vector.<int>{
			return POWS;
		}
		/**
		 * Gets bit count of the vlue and returns its mask.
		 */
		[Inline]
		static public function getValuesPow(value:uint):Number{
			var pow:uint = 1;
			var i:int = 0;
			while(i<POWS_LENGTH && (pow = POWS[i])<value){
				i++;
			}
			return pow;
		}
		/**
		 * Get bit count for value.
		 * @param Value to be calculated.
		 * @param Include a sign bit into calculation
		 */
		[Inline]
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
		[Inline]
		static public function getReader(source:ByteArray=null):MultibyteReader{
			return new MultibyteReader(source);
		}
		[Inline]
		static public function getWriter(source:ByteArray=null):MultibyteWriter{
			return new MultibyteWriter(source);
		}
		/**
		 * Look if string included into haystack ByteArray.
		 */
		[Inline]
		static public function containsString(haystack:ByteArray, needle:String):Boolean{
			var result:Boolean = searchString(haystack, needle, 0, int.MAX_VALUE) !== -1;
			return result;
		}
		/**
		 * Look if haystack ByteArray contains a needle ByteArray.
		 */
		[Inline]
		static public function contains(haystack:ByteArray, needle:ByteArray):Boolean{
			return search(haystack, needle, 0, int.MAX_VALUE) !== -1;
		}
		/**
		 * Get an index where needle string starts in haystack ByteArray.
		 */
		[Inline]
		static public function searchString(haystack:ByteArray, needle:String, from:int=0, to:int=int.MAX_VALUE):int{
			const needleByteArray:ByteArray = new ByteArray();
			needleByteArray.writeUTFBytes(needle);
			return search(haystack, needleByteArray, from, to);
		}
		/**
		 * Get an index where needle ByteArray starts in haystack ByteArray.
		 */
		[Inline]
		static public function search(haystack:ByteArray, needle:ByteArray, from:int=0, to:int=int.MAX_VALUE):int{
			var length:int = haystack.length;
			if(length>to) length = to;
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
	}
}