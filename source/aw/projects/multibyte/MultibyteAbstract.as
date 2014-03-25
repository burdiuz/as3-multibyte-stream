package aw.projects.multibyte{
	import flash.utils.ByteArray;
	
	import aw.utils.MathUtils;

	[ExcludeClass]
	/**
	 * Abstract class that contains shared methods and properties for MultibyteReader and MultibyteWriter
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 * @see aw.projects.multibyte.MultibyteReader
	 * @see aw.projects.multibyte.MultibyteWriter
	 */
	public /* abstract */ class MultibyteAbstract extends Object{
		/**
		 * @private
		 */
		static public const NO_BYTEARRAY_ERROR:String = 'Multibyte Error: ByteArray object is NULL(as constructor parameter).';
		static protected const LENGTHS:Array = function():Array{
			var list:Array = [0];
			for(var index:int=1; index<65; index++){
				list[index] = MathUtils.ceil(index/8)<<3;
			}
			return list;
		}();
		/**
		 *Use two’s complement number format 
		 */
		protected var _useTwosComplement:Boolean = true;
		/**
		 * Raw data
		 */
		protected var _byteArray:ByteArray;
		/**
		 * 
		 */
		protected var _lastLength:uint;
		/**
		 * Not saved bits
		 */
		protected var _remainder:int;
		/**
		 * Not saved bits length
		 */
		protected var _remainderLength:uint;
		/**
		 * ByteArray methods sorted by max bits count
		 * @param ByteArray Data source, if not exists, will be created for writing.
		 * @param int Base value to start with
		 * @param int Length of base value in bits
		 */
		protected var _methods:Array;
		public function MultibyteAbstract(source:ByteArray=null, remainder:int=0, remainderLength:uint=0):void{
			super();
			_byteArray = source ? source : new ByteArray();
			_remainder = remainder;
			_remainderLength = remainderLength;
			if(!_byteArray) throw new Error(NO_BYTEARRAY_ERROR);
			else saveMethods();
		}
		/**
		 * Create methods array
		 * 
		 */
		protected function saveMethods():void{
		}
		/**
		 * Use two’s complement number format
		 * @return Boolean
		 * 
		 */
		public function get useTwosComplement():Boolean{
			return this._useTwosComplement;
		}
		public function set useTwosComplement(value:Boolean):void{
			this._useTwosComplement = value;
		}
		/**
		 * Source ByteArray object. Must be defined through constructor or will be creted empty. 
		 * @return ByteArray
		 * 
		 */
		public function get byteArray():ByteArray{
			return this._byteArray;
		}
		/**
		 * Length of last value that was readen from the source. 
		 * @return 
		 * 
		 */
		public function get lastLength():uint{
			return this._lastLength;
		}
		/**
		 * Not saved bits, that waiting for anotyher portion of data to be written.
		 * @return 
		 * 
		 */
		public function get remainder():int{
			return this._remainder;
		}
		/**
		 * Not saved bits length
		 * @return 
		 * 
		 */
		public function get remainderLength():uint{
			return this._remainderLength;
		}
		/**
		 * Controls Endian used in ByteArray
		 * @param s
		 * 
		 */
		public function set endian(s:String):void{
			this._byteArray.endian = s;
		}
		public function get endian():String{
			return this._byteArray.endian;
		}
		/**
		 * ByteArray current position
		 * @param uint
		 * 
		 */
		public function set position(value:uint):void{
			this._byteArray.position = value;
		}
		public function get position():uint{
			return this._byteArray.position;
		}
		/**
		 * ByteArray length
		 * @param l
		 * 
		 */
		public function set length(value:uint):void{
			this._byteArray.length = value;
		}
		public function get length():uint{
			return this._byteArray.length;
		}
		/**
		 * @private
		 */
		[Inline]
		static public function getLengths():Array{
			return LENGTHS;
		}
	}
}