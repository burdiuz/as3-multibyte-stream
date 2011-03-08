package aw.projects.multibyte.data{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	
	import flash.utils.ByteArray;
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteStream extends Object implements IMultibytePackage{
		protected var _reader:MultibyteReader;
		protected var _writer:MultibyteWriter;
		protected var _target:Object;
		protected var _autoFlush:Boolean;
		protected var _byteArray:ByteArray;
		protected var _items:Array = [];
		public function MultibyteStream(byteArray:ByteArray=null, target:Object=null, autoFlush:Boolean=true, ...args:Array):void{
			super();
			this.byteArray = byteArray ? byteArray : new ByteArray();
			_target = target;
			_autoFlush = autoFlush;
		}
		public function get reader():MultibyteReader{
			return this._reader;
		}
		public function get writer():MultibyteWriter{
			return this._writer;
		}
		public function get byteArray():ByteArray{
			return this._byteArray;
		}
		public function set byteArray(value:ByteArray):void{
			this._byteArray = value;
			this.resetControl();
		}
		protected function resetControl():void{
			this._reader = new MultibyteReader(this._byteArray);
			this._writer = new MultibyteWriter(this._byteArray);
		}
		public function get target():Object{
			return this._target;
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
		public function get autoFlush():Boolean{
			return this._autoFlush;
		}
		public function set autoFlush(value:Boolean):void{
			this._autoFlush = value;
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
		public function addItem(item:IMultibyteValue, ...args:Array):void{
			args.unshift(item);
			for each(item in args){
				if(item) this._items.push(item);
			}
		}
		public function addItemList(list:Array):void{
			this.addItem.apply(null, list);
		}
		public function refresh():void{
			this.byteArray = new ByteArray();
		}
		public function read(resetPosition:Boolean=true):void{
			if(resetPosition) this._byteArray.position = 0;
			for each(var item:MultibyteValue in this._items){
				item.read(this._reader);
			}
			if(this._autoFlush){
				this._reader.clear();
			}
		}
		public function write(resetPosition:Boolean=true):void{
			if(resetPosition) this._byteArray.position = 0;
			for each(var item:MultibyteValue in this._items){
				item.write(this._writer);
			}
			if(this._autoFlush){
				this._writer.fill();
			}
		}
	}
}