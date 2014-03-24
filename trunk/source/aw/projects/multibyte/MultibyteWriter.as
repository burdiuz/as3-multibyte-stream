package aw.projects.multibyte{
	import __AS3__.vec.Vector;
	
	import aw.utils.BinUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * Writes data into ByteArray using bit as unit
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteWriter extends MultibyteAbstract{
		/**
		 * @private
		 */
		static public const FP_LENGTH:uint = 32;
		/**
		 * @private
		 */
		static public const FP_EXPONENT_LENGTH:uint = 8;
		/**
		 * @private
		 */
		static public const FP2_LENGTH:uint = 64;
		/**
		 * @private
		 */
		static public const FP2_EXPONENT_LENGTH:uint = 11;
		/**
		 * @private
		 */
		static public const VARIABLE_MAX_LENGTH:uint = 5;
		/**
		 * @private
		 */
		static public const BYTE_LENGTH:int = 8;
		/**
		 * @private
		 */
		static public const SIGNED:int = 0;
		/**
		 * @private
		 */
		static public const UNSIGNED:int = 1;
		/**
		 * @private
		 */
		static private const LITTLE_ENDIAN:String = Endian.LITTLE_ENDIAN;
		/**
		 * @private
		 */
		static private const BIG_ENDIAN:String = Endian.BIG_ENDIAN;
		/**
		 * @private
		 */
		static private const POWS:Vector.<int> = BinUtils.getPows();
		/**
		 * @private
		 */
		static private const LENGTHS:Array = MultibyteAbstract.getLengths();
		protected var _autoFill:Boolean;
		public function MultibyteWriter(source:ByteArray=null, remainder:int=0, remainderLength:uint=0, autoFill:Boolean=false):void{
			super(source, remainder, remainderLength);
			_autoFill = autoFill;
		}
		/**
		 * Generates methods
		 * 
		 */
		override protected function saveMethods():void{
			const byteArray:ByteArray = this._byteArray;
			const methods:Array = this._methods = [];
			methods[8] = byteArray.writeByte;
			methods[16] = byteArray.writeShort;
			methods[32] = byteArray.writeInt;
			methods[64] = byteArray.writeDouble;
		}
		public function write(value:int, length:uint=BYTE_LENGTH, signed:Boolean=true):void{
			const ba:ByteArray = this._byteArray;
			if(signed){
				if(value<0 && !this._useTwosComplement) value = -value | 1<<(length-1);
			}else if(value<0) value = -value;
			value = this._remainder << length | (value & POWS[length]);
			length += this._remainderLength;
			if(length in this._methods){
				this._methods[length](value);
				this._remainder = 0;
				this._remainderLength = 0;
			}else{
				while(length>=BYTE_LENGTH){
					length-=BYTE_LENGTH;
					ba.writeByte(value>>length);
					value = value & POWS[length];
				}
				this._remainder = value;
				this._remainderLength = length;
				if(this._autoFill) this.fill();
			}
		}
		public function writeFloat(value:Number):void{
			if(this._remainderLength){
				this.writeDataFloat(value, FP_LENGTH, FP_EXPONENT_LENGTH, true, true);
			}else{
				this._byteArray.writeFloat(value);
			}
		}
		public function writeDouble(value:Number):void{
			if(this._remainderLength){
				this.writeDataFloat(value, FP2_LENGTH, FP2_EXPONENT_LENGTH, true, true);
			}else{
				this._byteArray.writeDouble(value);
			}
		}
		public function writeDataFloat(value:Number, fullLength:uint=FP_LENGTH, expLength:uint=FP_EXPONENT_LENGTH, saveSign:Boolean=true, saveExpSign:Boolean=true):void{
			if(isNaN(value)){
				this.writeNaN(fullLength, expLength, saveSign);
				return;
			}else if(!isFinite(value)){
				this.writeInfinity(value, fullLength, expLength, saveSign);
				return;
			}
			const list:Vector.<int> = new Vector.<int>();
			var length:uint;
			var result:uint;
			// sign
			if(saveSign){
				length = 1;
				if(value<0) result = 1; 
			}
			if(value<0) value = -value;
			// exponent
			var expSign:int = int(value>1);
			if(saveExpSign){
				result = result << 1 | expSign;
				expLength--;
				length++;
			}
			var maxExp:uint = POWS[expLength];
			var realLength:uint = writeReal(list, value, maxExp);
			var fractionLength:uint = writeFraction(list, value, maxExp);
			if(value>1){
				list.shift();
				realLength-1;
				result = result << expLength | realLength-2;
			}else{
				var exp:int = 0;
				while(!list.shift()) exp++;
				result = (result << expLength) | (exp ^ POWS[expLength]);
			}
			length += expLength;
			while(length<fullLength){
				if(length>=FP_LENGTH){
					this.write(result, length);
					result = 0;
					length = 0;
					fullLength -= FP_LENGTH;
				}
				result <<= 1;
				if(list.length) result |= list.shift();
				length++;
			}
			this.write(result, length);
		}
		public function writeNaN(fullLength:uint=FP_LENGTH, expLength:uint=FP_EXPONENT_LENGTH, saveSign:Boolean=true):void{
			this.write(POWS[expLength], expLength+1, false);
			this.write(1, fullLength-expLength-1, false);
		}
		public function writeInfinity(value:Number, fullLength:uint=FP_LENGTH, expLength:uint=FP_EXPONENT_LENGTH, saveSign:Boolean=true):void{
			this.write(int(value<0)<<expLength | POWS[expLength], expLength+1, false);
			this.write(0, fullLength-expLength-1, false);
		}
		public function fill():void{
			if(this._remainderLength){
				this._byteArray.writeByte(this._remainder<<BYTE_LENGTH-this._remainderLength);
				this._remainder = 0;
				this._remainderLength = 0;
			}
		}
		[Inline]
		static private function writeReal(list:Vector.<int>, value:Number, length:uint=uint.MAX_VALUE):uint{
			value = int(value);
			if(value){
				var len:int = list.length-1;
				var i:uint = 0;
				while(value && len+i<length){
					list.unshift(value%2 ? 1 : 0);
					value = int(value/2);
					i++;
				}
			}else{
				list.unshift(0);
				i = 1;
			}
			return i;
		}
		[Inline]
		static private function writeFraction(list:Vector.<int>, value:Number, length:uint=uint.MAX_VALUE):uint{
			value -= int(value);
			var control:Number = 1;
			var len:uint = list.length-1;
			var i:uint = 0;
			while(value && len+i<length){
				control /= 2;
				if(value>=control){
					list.push(1);
					value -= control;
				}else list.push(0);
				i++;
			}
			return i;
		}
	}
}