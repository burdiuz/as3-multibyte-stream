package aw.projects.multibyte.data{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteInt extends MultibyteValue{
		protected var _signed:Boolean;
		protected var _length:uint;
		public function MultibyteInt(target:Object, name:*, length:uint=32, signed:Boolean=true):void{
			super(MultibyteValueType.INT, target, name);
			_signed = signed;
			_length = length;
		}
		public function get signed():Boolean{
			return this._signed;
		}
		public function set signed(value:Boolean):void{
			this._signed = value;
		}
		override public function get length():uint{
			return this._length;
		}
		public function set length(value:uint):void{
			this._length = value;
		}
		override internal function read(reader:MultibyteReader):void{
			this.setValue(reader.readCustom(this._length, this._signed));
		}
		override internal function write(writer:MultibyteWriter):void{
			writer.write(this.getValue(), this._length, this._signed);
		}
	}
}