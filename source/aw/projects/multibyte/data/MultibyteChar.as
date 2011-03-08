package aw.projects.multibyte.data{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	import aw.utils.BinUtils;
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	/*
	2bit - 8/16/24/32 bits for value
	*/
	public class MultibyteChar extends MultibyteValue{
		static private const HEADER_COUNT:int = 2;
		static private const BYTE_LENGTH:int = 8;
		static private const COUNT_1BYTE:int = 10;
		static private const COUNT_2BYTES:int = 18;
		static private const COUNT_3BYTES:int = 26;
		static private const COUNT_4BYTES:int = 34;
		public function MultibyteChar(target:Object, name:*):void{
			super(MultibyteValueType.STRING, target, name);
		}
		override public function get length():uint{
			var char:String = String(this.getValue());
			if(char){
				return Math.ceil(BinUtils.getBitCount(char.charCodeAt(0))/BYTE_LENGTH)+HEADER_COUNT;
			}
			return COUNT_1BYTE;
		}
		override internal function read(reader:MultibyteReader):void{
			var count:int = reader.readData(HEADER_COUNT, false);
			this.setValue(String.fromCharCode(reader.readData(BYTE_LENGTH*count, false)));
		}
		//FIXME добавить исключение - если хеадер указывает на 16 бит и код = 0, значит пустая строка.
		override internal function write(writer:MultibyteWriter):void{
			var code:int = 0;
			var char:String = String(this.getValue());
			if(char){
				code = char.charCodeAt(0);
			}
			var count:int = Math.ceil(BinUtils.getBitCount(code)/BYTE_LENGTH);
			writer.write(count, HEADER_COUNT, false);
			writer.write(code, count*BYTE_LENGTH, false);
		}
	}
}