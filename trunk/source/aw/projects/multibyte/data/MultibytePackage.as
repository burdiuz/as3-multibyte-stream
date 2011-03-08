package aw.projects.multibyte.data{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	import aw.projects.multibyte.data.string.IMultibyteStringEncoder;
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibytePackage extends MultibyteValue implements IMultibytePackage{
		protected var _items:Array = [];
		public function MultibytePackage(target:Object, ...args:Array):void{
			super(MultibyteValueType.PACKAGE, target, null);
			this.addItemList(args);
		}
		override public function get length():uint{
			var value:uint = 0;
			for each(var item:IMultibyteValue in this._items){
				value += item.length;
			}
			return value;
		}
		public function get items():Array{
			return this._items.concat();
		}
		public function add(type:int, name:*):IMultibyteValue{
			var definition:Class = MultibyteValueType.getDefinition(type);
			var item:IMultibyteValue = new definition(this._target, name);
			this._items.push(item);
			return item;
		}
		public function addString(name:*, encoder:IMultibyteStringEncoder):MultibyteString{
			var item:MultibyteString = new MultibyteString(this._target, name, encoder);
			this._items.push(item);
			return item;
		}
		public function addItem(item:IMultibyteValue, ...args:Array):void{
			args.unshift(item);
			for each(item in args){
				if(item) this._items.push(item);
			}
		}
		public function addItemList(list:Array):void{
			this.addItem.apply(null, list);
		}
		public function changeTarget(fromTarget:Object, toTarget:Object):void{
			if(this._target===fromTarget) this._target = toTarget;
			for each(var item:Object in this._items){
				if(item is IMultibytePackage){
					(item as IMultibytePackage).changeTarget(fromTarget, toTarget);
				}else{
					if((item as IMultibyteValue).target===fromTarget){
						(item as IMultibyteValue).target = toTarget;
					}
				}
			}
		}
		override internal function read(reader:MultibyteReader):void{
			for each(var item:MultibyteValue in this._items){
				item.read(reader);
			}
		}
		override internal function write(writer:MultibyteWriter):void{
			for each(var item:MultibyteValue in this._items){
				item.write(writer);
			}
		}
	}
}