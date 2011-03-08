package aw.projects.multibyte.data{
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public interface IMultibytePackage{
		function get items():Array;
		function add(type:int, name:*):IMultibyteValue;
		function addItem(item:IMultibyteValue, ...args:Array):void;
		function addItemList(list:Array):void;
		function changeTarget(fromTarget:Object, toTarget:Object):void;
	}
}