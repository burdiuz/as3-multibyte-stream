package aw.projects.multibyte.data{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	import aw.utils.BinUtils;
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteRange extends MultibyteValue{
		protected var _minimum:int;
		protected var _maximum:int;
		protected var _length:int;
		public function MultibyteRange(target:Object, name:*, minimum:int, maximum:int):void{
			super(MultibyteValueType.INT, target, name);
			resetBorders(minimum, maximum);
		}
		protected function resetBorders(value1:int, value2:int):void{
			this._minimum = Math.min(value1, value2);
			this._maximum = Math.max(value1, value2);
			this.countLength();
		}
		protected function countLength():void{
			var diff:uint = Math.abs(this._maximum-this._minimum);
			this._length = BinUtils.getBitCount(diff);
		}
		override public function get length():uint{
			return this._length;
		}
		public function get minimum():int{
			return this._minimum;
		}
		public function set minimum(value:int):void{
			if(value==this._minimum){
				this.resetBorders(value, this._maximum);
			}
		}
		public function get maximum():int{
			return this._maximum;
		}
		public function set maximum(value:int):void{
			if(value==this._maximum){
				this.resetBorders(this._minimum, value);
			}
		}
		override internal function read(reader:MultibyteReader):void{
			this.setValue(this._minimum+reader.readData(this._length, this._minimum<0));
		}
		override internal function write(writer:MultibyteWriter):void{
			writer.write(this.getValue()-this._minimum, this._length, this._minimum<0);
		}
	}
}