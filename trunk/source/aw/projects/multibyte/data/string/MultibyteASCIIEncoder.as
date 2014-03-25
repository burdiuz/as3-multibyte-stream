package aw.projects.multibyte.data.string{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	
	/*
	без упаковки, на каждый код отводится по 8 бит
	*/
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteASCIIEncoder extends Object implements IMultibyteStringEncoder{
		public function MultibyteASCIIEncoder():void{
			super();
		}
		public function getLength(value:String):uint{
			return value.length*MultibyteWriter.BYTE_LENGTH;
		}
		public function read(length:uint, reader:MultibyteReader):String{
			var count:uint = length/MultibyteWriter.BYTE_LENGTH;
			var value:String = '';
			while(count>0){
				value += String.fromCharCode(reader.readCustom(MultibyteWriter.BYTE_LENGTH, false));
				count--;
			}
			return value;
		}
		public function write(value:String, writer:MultibyteWriter):void{
			var length:int = value.length;
			for(var i:int=0; i<length; i++){
				writer.write(value.charCodeAt(i), MultibyteWriter.BYTE_LENGTH, false);
			}
		}
	}
}