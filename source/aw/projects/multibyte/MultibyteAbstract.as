package aw.projects.multibyte{
	import flash.utils.ByteArray;
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
			var arr:Array = [0];
			for(var i:int=1; i<65; i++) arr[i] = Math.ceil(i/8)*8;
			return arr;
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
		 */
		protected var _methods:Array;
		public function MultibyteAbstract(ba:ByteArray=null, r:int=0, rl:uint=0):void{
			super();
			_byteArray = ba ? ba : new ByteArray();
			_remainder = r;
			_remainderLength = rl;
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
		 * @return 
		 * 
		 */
		public function get useTwosComplement():Boolean{
			return this._useTwosComplement;
		}
		public function set useTwosComplement(p:Boolean):void{
			this._useTwosComplement = p;
		}
		/**
		 * Source ByteArray object. Must be defined 
		 * @return 
		 * 
		 */
		public function get byteArray():ByteArray{
			return this._byteArray;
		}
		/**
		 * 
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
		 * @param i
		 * 
		 */
		public function set position(i:uint):void{
			this._byteArray.position = i;
		}
		public function get position():uint{
			return this._byteArray.position;
		}
		/**
		 * ByteArray length
		 * @param l
		 * 
		 */
		public function set length(l:uint):void{
			this._byteArray.length = l;
		}
		public function get length():uint{
			return this._byteArray.length;
		}
		/**
		 * @private
		 */
		static public function getLengths():Array{
			return LENGTHS;
		}
	}
}