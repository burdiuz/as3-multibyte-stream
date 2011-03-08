package aw.projects.multibyte.data{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	
	import flash.net.ObjectEncoding;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/*
	 * первые два бита указывают длинну хеадера
	 * следующие 6, 14, 22, 30 бит указывают длинну контента в БАЙТАХ
	 * далее идёт 8 бит с настройками байтаррея, побитово:
	   - создан ли байтаррей, если этот параметр 0, то надо вернуть NULL
	   - endian 
	   - object encoding
	   - 
	   - 
	   - 
	   - 
	   - сохранена ли позиция, если 1, то следующие столько же бит, сколько было выделено на длинну контента, указывают позицию
	 * далее сдедует контент
	 */
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteBinary extends MultibyteValue{
		protected var SMALL_SIZE_BITS_COUNT:int = 6;
		protected var SMALL_SIZE_ID:int = 0;
		protected var SMALL_SIZE:int = Math.pow(2, SMALL_SIZE_BITS_COUNT)-1;
		protected var MEDIUM_SIZE_BITS_COUNT:int = 14;
		protected var MEDIUM_SIZE_ID:int = 1;
		protected var MEDIUM_SIZE:int = Math.pow(2, MEDIUM_SIZE_BITS_COUNT)-1;
		protected var BIG_SIZE_BITS_COUNT:int = 22;
		protected var BIG_SIZE_ID:int = 2;
		protected var BIG_SIZE:int = Math.pow(2, BIG_SIZE_BITS_COUNT)-1;
		protected var MAXIMUM_SIZE_BITS_COUNT:int = 30;
		protected var MAXIMUM_SIZE_ID:int = 3;
		protected var MAXIMUM_SIZE:int = Math.pow(2, MAXIMUM_SIZE_BITS_COUNT)-1;
		protected var _savePosition:Boolean;
		public function MultibyteBinary(target:Object, name:*, savePosition:Boolean=true):void{
			super(MultibyteValueType.BINARY, target, name);
			_savePosition = savePosition;
		}
		public function get savePosition():Boolean{
			return this._savePosition;
		}
		public function set savePosition(value:Boolean):void{
			this._savePosition = value;
		}
		override public function get length():uint{
			
			return 0;
		}
		protected function getHeaderId():uint{
			var id:int = MAXIMUM_SIZE_ID;
			var byteArray:ByteArray = this.getValue() as ByteArray;
			if(byteArray){
				var length:int = byteArray.length;
				if(length<=SMALL_SIZE) id = SMALL_SIZE_ID;
				else if(length<=MEDIUM_SIZE) id = MEDIUM_SIZE_ID;
				else if(length<=BIG_SIZE) id = BIG_SIZE_ID;
			}
			return id;
		}
		protected function getHeaderBitsCount():uint{
			var count:int = MAXIMUM_SIZE_BITS_COUNT;
			var byteArray:ByteArray = this.getValue() as ByteArray;
			if(byteArray){
				var length:int = byteArray.length;
				if(length<=SMALL_SIZE) count = SMALL_SIZE_BITS_COUNT;
				else if(length<=MEDIUM_SIZE) count = MEDIUM_SIZE_BITS_COUNT;
				else if(length<=BIG_SIZE) count = BIG_SIZE_BITS_COUNT;
			}
			return count;
		}
		protected function getHeaderBitsCountById(id:uint):uint{
			var count:int = MAXIMUM_SIZE_BITS_COUNT;
			switch(id){
				case SMALL_SIZE_ID:
					count = SMALL_SIZE_BITS_COUNT;
				break;
				case MEDIUM_SIZE_ID:
					count = MEDIUM_SIZE_BITS_COUNT;
				break;
				case BIG_SIZE_ID:
					count = BIG_SIZE_BITS_COUNT;
				break;
				case MAXIMUM_SIZE_ID:
				default:
					count = MAXIMUM_SIZE_BITS_COUNT;
				break;
			}
			return count;
		}
		override internal function read(reader:MultibyteReader):void{
			var value:ByteArray = null;
			var id:uint = reader.readData(2, false);
			var count:uint = getHeaderBitsCountById(id);
			var length:uint = reader.readData(count, false);
			if(reader.readData(1, false)){
				value = new ByteArray();
				value.endian = reader.readData(1, false) ? Endian.BIG_ENDIAN : Endian.LITTLE_ENDIAN;
				value.objectEncoding = reader.readData(1, false) ? ObjectEncoding.AMF3 : ObjectEncoding.AMF0;
				reader.readData(4, false)
				var position:int = 0;
				if(reader.readData(1, false)){
					position = reader.readData(count, false);
				}
				for(var i:int=0; i<length; i++){
					value.writeByte(reader.readData(8, false));
				}
				value.position = position;
			}
			this.setValue(value);
		}
		override internal function write(writer:MultibyteWriter):void{
			var id:uint = this.getHeaderId();
			var value:ByteArray = this.getValue() as ByteArray;
			writer.write(id, 2, false);
			var length:uint = getHeaderBitsCountById(id);
			writer.write(value ? value.length : 0, length, false);
			writer.write(int(Boolean(value)), 1, false);
			if(value){
				writer.write(value.endian==Endian.BIG_ENDIAN ? 1 : 0, 1, false);
				writer.write(value.objectEncoding==ObjectEncoding.AMF3 ? 1 : 0, 1, false);
				writer.write(0, 4, false); // reserved
				writer.write(int(this._savePosition), 1, false);
				var position:uint = value.position;
				if(this._savePosition){
					writer.write(position, length, false);
				}
				length = value.length;
				for(var i:int=0; i<length; i++){
					writer.write(value[i], 8, false);
				}
			} 
		}
	}
}