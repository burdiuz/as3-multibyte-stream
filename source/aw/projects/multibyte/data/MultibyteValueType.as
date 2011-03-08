package aw.projects.multibyte.data{
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteValueType extends Object{
		static public const BOOLEAN:int = 0;
		static public const INT:int = 1;
		static public const FLOAT:int = 2;
		static public const STRING:int = 3;
		static public const BINARY:int = 4;
		static public const PACKAGE:int = 10;
		static public function toString(type:int):String{
			var string:String = 'unknown';
			switch(type){
				case BOOLEAN:
					string = 'boolean';
				break;
				case INT:
					string = 'int';
				break;
				case FLOAT:
					string = 'float';
				break;
				case STRING:
					string = 'string';
				break;
				case BINARY:
					string = 'binary';
				break;
				case PACKAGE:
					string = 'package';
				break;
			}
			return string;
		}
		static public function getDefinition(type:int):Class{
			var definition:Class = null;
			switch(type){
				case BOOLEAN:
					definition = MultibyteBoolean;
				break;
				case INT:
					definition = MultibyteInt;
				break;
				case FLOAT:
					definition = MultibyteFloat;
				break;
				case STRING:
					definition = MultibyteString;
				break;
				case BINARY:
					definition = MultibyteBinary;
				break;
				case PACKAGE:
					definition = MultibytePackage;
				break;
			}
			return definition;
		}
	}
}