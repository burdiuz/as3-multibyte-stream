package aw.projects.multibyte.data{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	import aw.utils.BinUtils;
	import aw.utils.MathUtils;

	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteIntFlexible extends MultibyteValue{
		static private const HEADER_COUNT:int = 2;
		static private const BYTE_LENGTH:int = 8;
		static private const COUNT_1BYTE:int = 10;
		static private const COUNT_2BYTES:int = 18;
		static private const COUNT_3BYTES:int = 26;
		static private const COUNT_4BYTES:int = 34;
		protected var _signed:Boolean;
		public function MultibyteIntFlexible(target:Object, name:*, signed:Boolean=true):void{
			super(MultibyteValueType.INT, target, name);
			_signed = signed;
		}
		public function get signed():Boolean{
			return this._signed;
		}
		public function set signed(value:Boolean):void{
			this._signed = value;
		}
		override public function get length():uint{
			return MathUtils.ceil(BinUtils.getBitCount(this.getValue())/BYTE_LENGTH)+HEADER_COUNT;
		}
		override internal function read(reader:MultibyteReader):void{
			var count:int = reader.readCustom(HEADER_COUNT, false);
			this.setValue(reader.readCustom(BYTE_LENGTH*count, false));
		}
		override internal function write(writer:MultibyteWriter):void{
			var value:int = this.getValue();
			var count:int = MathUtils.ceil(BinUtils.getBitCount(value)/BYTE_LENGTH);
			writer.write(count, HEADER_COUNT, false);
			writer.write(value, count*BYTE_LENGTH, this._signed);
		}
	}
}