package aw.projects.multibyte.data.string{
	
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	import aw.utils.BinUtils;

	/*
	Определяется максимальное число бит в кодах, далее это значение записывается и каждый код значения записывается в указанное кол-во бит
	*/
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteFixedEncoder extends Object implements IMultibyteStringEncoder{
		static public const CHAR_BITS_COUNT:int = 5;
		protected var _value:String;
		protected var _valueCodes:Vector.<uint>;
		protected var _bitsPerChar:int;
		public function MultibyteFixedEncoder():void{
			super();
		}
		public function getLength(value:String):uint{
			var length:int = value.length;
			this._value = value;
			var codes:Vector.<uint> = this._valueCodes = new Vector.<uint>(length, true);
			var bitsPerChar:int = this._bitsPerChar = BinUtils.getBitCount(this.getCodes(value, codes));
			return bitsPerChar*length+CHAR_BITS_COUNT;
		}
		protected function getCodes(value:String, target:Vector.<uint>):uint{
			var length:int = value.length;
			var max:int;
			var code:int;
			for(var i:int=0; i<length; i++){
				code = value.charCodeAt(i);
				max = Math.max(max, code);
				target[i] = code;
			}
			return max;
		}
		public function read(length:uint, reader:MultibyteReader):String{
			length -= CHAR_BITS_COUNT;
			var bitsPerChar:int = reader.readData(CHAR_BITS_COUNT, false);
			length /= bitsPerChar;
			var value:String = '';
			while(length>0){
				value += String.fromCharCode(reader.readData(bitsPerChar, false));
				length--;
			}
			return value;
		}
		public function write(value:String, writer:MultibyteWriter):void{
			var codes:Vector.<uint>;
			var bitsPerChar:int;
			if(value==this._value){
				codes = this._valueCodes;
				bitsPerChar = this._bitsPerChar;
			}else{
				codes = new Vector.<uint>(length, true);
				bitsPerChar = BinUtils.getClosePow(this.getCodes(value, codes));
			}
			writer.write(bitsPerChar, CHAR_BITS_COUNT, false);
			for each(var code:uint in codes) writer.write(code, bitsPerChar, false);
			this._value = null;
			this._valueCodes = null;
		}
	}
}