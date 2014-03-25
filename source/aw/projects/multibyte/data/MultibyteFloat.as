package aw.projects.multibyte.data{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteFloat extends MultibyteValue{
		protected var _signed:Boolean;
		protected var _exponentLength:int;
		protected var _mantissaLength:int;
		protected var _length:uint;
		protected var _exponentSigned:Boolean;
		public function MultibyteFloat(target:Object, name:*, exponentLength:int=8, mantissaLength:int=23, signed:Boolean=true, exponentSigned:Boolean=true):void{
			super(MultibyteValueType.FLOAT, target, name);
			_signed = signed;
			_exponentLength = exponentLength;
			_mantissaLength = mantissaLength;
			_exponentSigned = exponentSigned;
			calculateLength();
		}
		override public function get length():uint{
			return this._length;
		}
		protected function calculateLength():void{
			this._length = this._exponentLength+this._mantissaLength+(this._signed ? 1 : 0);
		}
		public function get signed():Boolean{
			return this._signed;
		}
		public function set signed(value:Boolean):void{
			this._signed = value;
			this.calculateLength();
		}
		public function get exponentLength():int{
			return this._exponentLength;
		}
		public function set exponentLength(value:int):void{
			this._exponentLength = value;
			this.calculateLength();
		}
		public function get mantissaLength():int{
			return this._mantissaLength;
		}
		public function set mantissaLength(value:int):void{
			this._mantissaLength = value;
			this.calculateLength();
		}
		public function get exponentSigned():Boolean{
			return this._exponentSigned;
		}
		public function set exponentSigned(value:Boolean):void{
			this._exponentSigned = value;
		}
		override internal function read(reader:MultibyteReader):void{
			var value:Number = reader.readCustomFloat(this._length, this._exponentLength, this._signed, this._exponentSigned);
			this.setValue(value);
		}
		override internal function write(writer:MultibyteWriter):void{
			writer.writeCustomFloat(this.getValue(), this._length, this._exponentLength, this._signed, this._exponentSigned);
		}
	}
}