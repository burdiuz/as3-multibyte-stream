package aw.projects.multibyte.data{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	import aw.projects.multibyte.data.string.IMultibyteStringEncoder;
	import aw.projects.multibyte.data.string.MultibyteRawEncoder;
	import aw.utils.BinUtils;
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteString extends MultibyteValue{
		static public const HEADER_HALF:int = 14;
		static public const HEADER_HALF_COUNT:int = 13;
		static public const HEADER_HALF_COUNT_LENGTH:int = (2<<HEADER_HALF_COUNT)-1;
		static public const HEADER_FULL:int = 26;
		static public const HEADER_FULL_COUNT:int = 25;
		protected var _encoder:IMultibyteStringEncoder;
		protected var _length:uint;
		public function MultibyteString(target:Object, name:*, encoder:IMultibyteStringEncoder=null):void{
			super(MultibyteValueType.STRING, target, name);
			if(encoder) _encoder = encoder;
			else _encoder = new MultibyteRawEncoder();
		}
		override public function get length():uint{
			return this._encoder.getLength(this.getValue());
		}
		public function get encoder():IMultibyteStringEncoder{
			return this._encoder;
		}
		public function set encoder(value:IMultibyteStringEncoder):void{
			this._encoder = value;
		}
		override internal function read(reader:MultibyteReader):void{
			const POWS:Vector.<int> = BinUtils.getPows();
			var header:uint = reader.readCustom(HEADER_HALF, false);
			var lengthCount:int;
			var encoderCount:int;
			if(header>>HEADER_HALF_COUNT){
				var secondPartCount:int = HEADER_FULL-HEADER_HALF;
				header = header << secondPartCount | reader.readCustom(secondPartCount, false);
				lengthCount = HEADER_FULL_COUNT;
			}else{
				lengthCount = HEADER_HALF_COUNT;
			}
			var length:int = header & POWS[lengthCount];
			this.setValue(this._encoder.read(length, reader));
		}
		override internal function write(writer:MultibyteWriter):void{
			const POWS:Vector.<int> = BinUtils.getPows();
			var string:String = String(this.getValue());
			var length:int = this._encoder.getLength(string);
			var header:uint;
			if(length<=HEADER_HALF_COUNT_LENGTH){
				writer.write(length, HEADER_HALF, false);
			}else{
				header = 1 << HEADER_FULL_COUNT | (length&POWS[HEADER_FULL_COUNT]);
				writer.write(header, HEADER_FULL, false);
			}
			this._encoder.write(string, writer);
		}
	}
}