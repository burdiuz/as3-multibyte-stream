package aw.projects.multibyte.data.string{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	/*
		1 - тип значения, если 0, то простой пробел, если 1, то это значение
		1 - минимальный код
		16/32 - код
		1 - длинный или короткий добавочный код символа
		4/8 - длинна добавочного кода
		1 - длинное или короткое слово
		4/8 - длинна слова
		коды 
	
	*/
	/**
	* 
	* @author Galaburda a_[w] Oleg    http://www.actualwave.com
	* 
	*/
	public class MultibyteTextEncoder extends Object implements IMultibyteStringEncoder{
		public function MultibyteTextEncoder(){
			super();
		}
		public function getLength(value:String):uint{
			return 0;
		}
		public function read(length:uint, reader:MultibyteReader):String{
			return null;
		}
		public function write(value:String, writer:MultibyteWriter):void{
		}
	}
}