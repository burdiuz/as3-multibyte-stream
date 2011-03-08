package aw.projects.multibyte.data.string{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	
	/**
	 * String encoder class for MultibyteString
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 * @see aw.projects.multibyte.data.MultibyteString
	 */
	public interface IMultibyteStringEncoder{
		/**
		 * Get encoded value length in bits
		 * @param value
		 * @return 
		 * 
		 */
		function getLength(value:String):uint;
		/**
		 * Read data and decode from MultibyteReader
		 * @param length Encoded data length in bits
		 * @param reader MultibyteReader instance
		 * @return 
		 * 
		 */
		function read(length:uint, reader:MultibyteReader):String;
		/**
		 * Write encoded data to ByteArray using MultibyteWriter
		 * @param value Value to write
		 * @param writer Instance of MultibyteWriter that will be used to write encoded value 
		 * 
		 */
		function write(value:String, writer:MultibyteWriter):void;
	}
}