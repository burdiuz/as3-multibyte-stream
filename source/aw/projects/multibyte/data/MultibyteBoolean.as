package aw.projects.multibyte.data{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	
	/**
	 * Utilize boolean values
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteBoolean extends MultibyteValue{
		public function MultibyteBoolean(target:Object, name:*):void{
			super(MultibyteValueType.BOOLEAN, target, name);
		}
		/**
		 * Boolean always has length in 1 bit
		 * @return 
		 * 
		 */
		override public function get length():uint{
			return 1;
		}
		/**
		 * Read boolean value from MultibyteReader
		 * @param reader
		 * 
		 */
		override internal function read(reader:MultibyteReader):void{
			this.setValue(Boolean(reader.read(1)));
		}
		/**
		 * Write boolean value into MultibyteWriter
		 * @param writer
		 * 
		 */
		override internal function write(writer:MultibyteWriter):void{
			writer.write(int(Boolean(this.getValue())), 1);
		}
	}
}