package aw.projects.multibyte.data.string{
	import __AS3__.vec.Vector;
	
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	import aw.utils.BinUtils;
	import aw.utils.MathUtils;

	/*
	один бит - 0, простое значение; 1, сложное значение
		простое значение - занимает 8 бит, значение 
		сложное значение - занимает до 20-ти бит
			 4 бита - длинна значения
			 4 бита - количество значений
			 от 1-го до 16-ти бит, значение
	*/
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteFloatEncoder extends Object implements IMultibyteStringEncoder{
		static public const TYPE_VALUE_BITS_COUNT:int = 1;
		static public const SIMPLE_VALUE_BITS_COUNT:int = 8;
		static public const SIMPLE_MAX_VALUE:int = (2<<SIMPLE_VALUE_BITS_COUNT)-1;
		static public const COMPLEX_LENGTH_BITS_COUNT:int = 4;
		static public const COMPLEX_MAX_LENGTH:int = (2<<COMPLEX_LENGTH_BITS_COUNT)-1;
		static public const COMPLEX_ITEMS_BITS_COUNT:int = 4;
		static public const COMPLEX_MAX_ITEMS:int = (2<<COMPLEX_ITEMS_BITS_COUNT)-1;
		protected var _value:String;
		protected var _valuesCache:Vector.<int>;
		protected var _lengthsCache:Vector.<int>;
		protected var _packageDistance:uint;
		public function MultibyteFloatEncoder(packageDistance:uint=128):void{
			super();
			_packageDistance = packageDistance;
		}
		public function get packageDistance():uint{
			return this._packageDistance;
		}
		public function set packageDistance(value:uint):void{
			this._packageDistance = value;
		}
		private var _started:Boolean;
		private var _complexCount:int;
		private var _length:int;
		private var _minValue:int;
		private var _maxValue:int;
		public function getLength(value:String):uint{
			this._value = value;
			this._valuesCache = new Vector.<int>();
			this._lengthsCache = new Vector.<int>();
			this._started = false;
			this._length = 0;
			var temp:Vector.<int>;
			for(var i:int=0; i<value.length; i++){
				var code:int = value.charCodeAt(i);
				if(this._started){
					var distance:int = MathUtils.abs(this._minValue-code);
					if(distance<this._packageDistance){
						temp.push(code);
						this._minValue = MathUtils.min(this._minValue, code);
						this._maxValue = MathUtils.max(this._maxValue, code);
						if(temp.length==COMPLEX_MAX_ITEMS){
							this.calculateComplex(temp);
							temp = null;
							this._started = false;
						}
						continue;
					}else{
						this.calculateComplex(temp);
						this.calculateSimple(code);
						temp = null;
						this._started = false;
						continue;
					}
				}
				if(code<=SIMPLE_MAX_VALUE){
					this.calculateSimple(code);
				}else{
					this._started = true;
					temp = new Vector.<int>();
					temp.push(code);
					this._minValue = code;
					this._maxValue = code;
				}
			}
			if(temp && temp.length){
					calculateComplex(temp);
			}
			return this._length;
		}
		private function calculateComplex(codes:Vector.<int>):void{
			const count:int = codes.length;
			const bitsCount:int = BinUtils.getBitCount(this._maxValue);
			this._length += COMPLEX_LENGTH_BITS_COUNT+COMPLEX_ITEMS_BITS_COUNT+TYPE_VALUE_BITS_COUNT;
			this._length += count*bitsCount;
			this.fillCacheValues(1, TYPE_VALUE_BITS_COUNT);
			this.fillCacheValues(bitsCount, COMPLEX_LENGTH_BITS_COUNT);
			this.fillCacheValues(count, COMPLEX_ITEMS_BITS_COUNT);
			for each(var item:int in codes) this.fillCacheValues(item, bitsCount);
		}
		private function calculateSimple(code:int):void{
			this.fillCacheValues(0, TYPE_VALUE_BITS_COUNT);
			this.fillCacheValues(code, SIMPLE_VALUE_BITS_COUNT);
			this._length += SIMPLE_VALUE_BITS_COUNT+TYPE_VALUE_BITS_COUNT;
		}
		private function fillCacheValues(value:int, length:int):void{
			this._valuesCache.push(value);
			this._lengthsCache.push(length);
		}
		public function read(length:uint, reader:MultibyteReader):String{
			var value:String = '';
			while(length){
				length -= TYPE_VALUE_BITS_COUNT;
				if(reader.readCustom(TYPE_VALUE_BITS_COUNT, false)){
					var bitsCount:int = reader.readCustom(COMPLEX_LENGTH_BITS_COUNT, false);
					var count:int = reader.readCustom(COMPLEX_ITEMS_BITS_COUNT, false);
					length -= COMPLEX_LENGTH_BITS_COUNT+COMPLEX_ITEMS_BITS_COUNT+count*bitsCount;
					while(count){
						value += String.fromCharCode(reader.readCustom(bitsCount,  false));
						count--;
					}
				}else{
					value += String.fromCharCode(reader.readCustom(SIMPLE_VALUE_BITS_COUNT,  false));
					length -= SIMPLE_VALUE_BITS_COUNT;
				}
			}
			return value;
		}
		public function write(value:String, writer:MultibyteWriter):void{
			if(!this._valuesCache || value){
				this.getLength(value);
			}
			var length:int = this._valuesCache.length;
			for(var i:int=0; i<length;  i++){
				writer.write(this._valuesCache[i], this._lengthsCache[i], false);
			}
			this._value = null;
			this._valuesCache = null;
			this._lengthsCache = null;
		}
	}
}