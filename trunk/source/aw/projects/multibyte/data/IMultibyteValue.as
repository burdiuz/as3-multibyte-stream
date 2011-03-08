package aw.projects.multibyte.data{
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public interface IMultibyteValue{
		function get target():Object;
		function set target(value:Object):void;
		function get name():QName;
		function set name(value:QName):void;
		function get length():uint;
	}
}