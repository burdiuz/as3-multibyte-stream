package aw.projects.multibyte.data.string{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	
	import flash.utils.ByteArray;

	/*
	Записать всё по стандарту. проще всего - тупо скинуть в ByteArray, а потом с него перенести куда надо. 
	*/
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteRawEncoder extends Object implements IMultibyteStringEncoder{
		static public const DEFAULT_CHARSET:String = 'utf-8';
		static private const byteArray:ByteArray = new ByteArray(); 
		protected var _charset:String;
		public function MultibyteRawEncoder(charset:String=DEFAULT_CHARSET):void{
			super();
			_charset = charset ? charset : DEFAULT_CHARSET;
		}
		public function get charset():String{
			return this._charset;
		}
		public function set charset(value:String):void{
			this._charset = value;    
		}
		public function getLength(value:String):uint{
			this.writeInternal(value, this._charset);
			var length:uint = byteArray.length*MultibyteWriter.BYTE_LENGTH;
			byteArray.clear();
			
			return length;
		}
		public function read(length:uint, reader:MultibyteReader):String{
			var source:ByteArray = reader.byteArray;
			byteArray.endian = source.endian;
			byteArray.objectEncoding = source.objectEncoding;
			length /= MultibyteWriter.BYTE_LENGTH;
			for(var i:int=0; i<length; i++){
				byteArray.writeByte(reader.readCustom(MultibyteWriter.BYTE_LENGTH, false));
			}
			var value:String;
			byteArray.position = 0;
			if(this._charset.toLowerCase()==DEFAULT_CHARSET){
				value = byteArray.readUTFBytes(length);
			}else{
				value = byteArray.readMultiByte(length, this._charset);
			}
			byteArray.clear();
			return value;
		}
		public function write(value:String, writer:MultibyteWriter):void{
			this.writeInternal(value, this._charset, writer.byteArray);
			var length:int = byteArray.length;
			byteArray.position = 0;
			for(var i:int=0; i<length; i++){
				writer.write(byteArray.readUnsignedByte(), MultibyteWriter.BYTE_LENGTH, false);
			}
			byteArray.clear();
		}
		public function writeInternal(value:String, charset:String, destination:ByteArray=null):void{
			if(destination){
				byteArray.endian = destination.endian;
				byteArray.objectEncoding = destination.objectEncoding;
			}
			if(charset.toLowerCase()==DEFAULT_CHARSET){
				byteArray.writeUTFBytes(value);
			}else{
				byteArray.writeMultiByte(value, charset);
			}
		}
	}
}