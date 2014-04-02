﻿package aw.projects.multibyte{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import aw.utils.BinUtils;
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteReader extends MultibyteAbstract{
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
		static protected const LITTLE_ENDIAN:String = Endian.LITTLE_ENDIAN;
		/**
		 * @private
		 */
		static protected const BIG_ENDIAN:String = Endian.BIG_ENDIAN;
		/**
		 * @private
		 */
		static protected const POWS:Vector.<int> = BinUtils.getPows();
		/**
		 * @private
		 */
		static protected const LENGTHS:Array = MultibyteAbstract.getLengths();
		/**
		 * @private
		 */
		protected var _autoClear:Boolean;

		/**
		 * Create MultibyteReader instance
		 * @param byteArray Data source
		 * @param remainder First data bits that may be read from previous source
		 * @param remainderLength First dfata bits length
		 * @param autoClear Auto clear reminder after each read method execution
		 * 
		 */
		public function MultibyteReader(byteArray:ByteArray=null, remainder:int=0, remainderLength:uint=0, autoClear:Boolean=false):void{
			super(byteArray, remainder, remainderLength);
			_autoClear = autoClear;
			clear();
		}
		/**
		 * Create list of ByteArray methods
		 * 
		 */
		override protected function saveMethods():void{
			var byteArray:ByteArray = this._byteArray;
			var methods:Array = this._methods = [];
			methods[8] = byteArray.readUnsignedByte;
			methods[16] = byteArray.readUnsignedShort;
			methods[32] = byteArray.readUnsignedInt;
			methods[64] = byteArray.readDouble;
		}
		/**
		 * Delete reminder
		 * 
		 */
		public function clear():void{
			this._lastLength = 0;
			this._remainder = 0;
			this._remainderLength = 0;
		}
		/**
		 * Read any number
		 * @param length Bits count to read
		 * @return 
		 * 
		 */
		protected function simpleRead(length:int):Number{
			var byteArray:ByteArray = this._byteArray;
			var value:Number = 0;
			length = LENGTHS[length];
			if(length in this._methods){
				value = value<<length | this._methods[length]();
			}else{
				var bytesCount:int = length/8;
				for(var i:int=0; i<bytesCount; i++) value = value<<8 | byteArray.readUnsignedByte();
			}
			return value;
		}
		/**
		 * Read number
		 * @param length Length in bits
		 * @param signed Is number signed
		 * @return 
		 * 
		 */
		public function readCustom(length:int, signed:Boolean=true):Number{
			this._lastLength = length;
			var ba:ByteArray = this._byteArray;
			var remainderLength:int = this._remainderLength;
			var newLength:int = length-remainderLength;
			var value:int = this._remainder;
			if(newLength>0){
				newLength = LENGTHS[newLength];
				if(newLength in this._methods){
					value = value<<newLength | this._methods[newLength]();
				}else{
					var bytesCount:int = newLength/8;
					for(var i:int=0; i<bytesCount; i++) value = value<<8 | ba.readUnsignedByte();
				}
				remainderLength = remainderLength+newLength;
			}
			newLength = remainderLength-length;
			this._remainder = value&POWS[newLength];
			this._remainderLength = newLength;
			if(this._autoClear) this.clear();
			value >>= newLength;
			var length_1:int = length-1;
			if(signed && (1<<length_1 & value)>>length_1){
				value = this._useTwosComplement ? -(--value^POWS[length]) : -(value&POWS[length_1]);
			}
			return value;
		}
		/**
		 * Read float number, that was written in IEEE-754 format
		 * <listing>
		 * 	var bytes:ByteArray = new ByteArray();
		 * 	var writer:MultibyteWriter = new MultibyteWriter(bytes);
		 * 	writer.writeNaN();
		 * 	writer.writeInfinity(+Infinity);
		 * 	writer.writeInfinity(-Infinity);
		 * 	writer.writeDataFloat(3.14);
		 * 	writer.writeDataFloat(1024);
		 * 	bytes.position = 0;
		 * 	trace(bytes.readFloat()); // NaN
		 * 	trace(bytes.readFloat()); // Infinity
		 * 	trace(bytes.readFloat()); // -Infinity
		 * 	trace(bytes.readFloat()); // 3.1399998664855957
		 * 	trace(bytes.readFloat()); // 1024
		 * 	bytes.position = 0;
		 * 	var reader:MultibyteReader = new MultibyteReader(bytes);
		 * 	trace(reader.readCustomFloat()); // NaN
		 * 	trace(reader.readCustomFloat()); // Infinity
		 * 	trace(reader.readCustomFloat()); // -Infinity
		 * 	trace(reader.readCustomFloat()); // 3.1399998664855957
		 * 	trace(reader.readCustomFloat()); // 1024
		 * </listing>
		 * @param fullLength Number length in bits
		 * @param exponentLength Number exponent length in bits
		 * @param signed Is number signed
		 * @param exponentSigned Is exponent signed
		 * @param allowNanInfinity Is NaN and +Infinity, -Infinity values are allowed
		 * @return 
		 * 
		 */
		public final function readCustomFloat(fullLength:uint=FP_LENGTH, exponentLength:uint=FP_EXPONENT_LENGTH, signed:Boolean=true, exponentSigned:Boolean=true, allowNanInfinity:Boolean=true):Number{
			this._lastLength = fullLength;
			var bufferLength:Number = this._remainderLength;
			var bufferValue:Number = this._remainder;
			var bitsCount:uint = (signed ? 1 : 0)+exponentLength;
			var mantissaLength:uint = fullLength-bitsCount;
			if(bufferLength<bitsCount){
				bitsCount = LENGTHS[bitsCount-bufferLength];
				bufferLength += bitsCount;
				bufferValue = bufferValue << bitsCount | simpleRead(bitsCount);
			}
			// -- sign
			var sign:int = 1;
			if(signed){
				bufferLength--;
				if(bufferValue >> bufferLength) sign = -1;
				bufferValue = bufferValue & POWS[bufferLength];
			}
			// -- exponent
			bufferLength -= exponentLength;
			var exponent:int = bufferValue >> bufferLength;
			var exponentLength_1:uint = exponentLength-1;
			var exponentValuePow:uint = POWS[exponentLength_1];
			var mantissaCurrentLength:uint = 0;
			var mantissaPartLength:uint = LENGTHS[1];
			var value:Number = 1;
			if(allowNanInfinity && exponent==POWS[exponentLength]){ // NaN, +/-Infinity
				value = Infinity;
				while(mantissaCurrentLength<mantissaLength){
					if(bufferLength<=0){
						bufferValue = simpleRead(mantissaPartLength);
						bufferLength = mantissaPartLength;
					}
					if(bufferValue>>--bufferLength&1){
						value = NaN;
						break;
					}
					mantissaCurrentLength++;
				}
			}else{ // Number value
				if(exponentSigned){
					if(exponent >> exponentLength_1) exponent = -(exponent & exponentValuePow ^ 0);
					else exponent = exponent ^ exponentValuePow;
				}else exponent = exponent ^ POWS[exponentLength];
				bufferValue = bufferValue & POWS[bufferLength];
				// -- mantissa
				var fractionValue:Number = 1;
				if(exponent<=0){
					// real
					while(mantissaCurrentLength<mantissaLength && exponent<=0){
						if(bufferLength<=0){
							bufferValue = simpleRead(mantissaPartLength);
							bufferLength = mantissaPartLength;
						}
						value = value*2+(bufferValue>>--bufferLength&1);
						mantissaCurrentLength++;
						exponent++;
					}
				}else{
					// fraction only
					while(exponent>0){
						value /= 2;
						exponent--;
					}
					fractionValue = value;
				}
				// fraction
				while(mantissaCurrentLength<mantissaLength){
					if(bufferLength<=0){
						bufferValue = simpleRead(mantissaPartLength);
						bufferLength = mantissaPartLength;
					}
					fractionValue /= 2;
					if(bufferValue>>--bufferLength&1) value += fractionValue;
					mantissaCurrentLength++;
				}
			}
			this._remainder = bufferValue & POWS[bufferLength];
			this._remainderLength = bufferLength;
			return sign*value;
		}
		public function read(l:uint=8):int{
			return int(readCustom(l, true));
		}
		public function readUnsigned(l:uint=8):uint{
			return uint(readCustom(l, false));
		}
		public function readBoolean():Boolean{
			return Boolean(readCustom(1, false));
		}
		public function readFloat():Number{
			if(this._lastLength){
				return this.readCustomFloat(FP_LENGTH, FP_EXPONENT_LENGTH, true, true, true);
			}else{
				return this._byteArray.readFloat();
			}
		}
		public function readDouble():Number{
			if(this._lastLength){
				return this.readCustomFloat(FP2_LENGTH, FP2_EXPONENT_LENGTH, true, true, true);
			}else{
				return this._byteArray.readDouble();
			}
		}
		override public function set position(i:uint):void{
			super.position = i;
			this.clear();
		}
		public function set autoClear(p:Boolean):void{
			this._autoClear = p;
			if(p) this.clear();
		}
		public function get autoClear():Boolean{
			return this._autoClear;
		}
	}
}