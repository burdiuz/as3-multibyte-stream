package aw.projects.multibyte.data{
	import aw.projects.multibyte.MultibyteReader;
	import aw.projects.multibyte.MultibyteWriter;
	
	/**
	 * Abstract class for all implementations of IMultibyteValue
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteValue extends Object implements IMultibyteValue{
		protected var _type:int;
		protected var _target:Object;
		protected var _name:QName;
		/**
		 * 
		 * @param type Data type
		 * @param target Object, source data target
		 * @param name Property name, that contains data
		 * @see aw.projects.multibyte.MultibyteValueType
		 */
		public function MultibyteValue(type:int, target:Object, name:*):void{
			super();
			if(Object(this).constructor==MultibyteValue){
				throw new Error('Abstract class instantiated');
			}
			_type = type;
			_target = target;
			if(name) _name = name is QName ? name : new QName('', name);
		}
		public function get length():uint{
			return 0;
		}
		public function get target():Object{
			return this._target;
		}
		public function set target(value:Object):void{
			this._target = value;
		}
		public function get name():QName{
			return this._name;
		}
		public function set name(value:QName):void{
			this._name = value;
		}
		protected function setValue(value:*):void{
			this._target[this._name] = value;
		}
		protected function getValue():*{
			return this._target[this._name];
		}
		internal function read(reader:MultibyteReader):void{
			throw new Error('Feature not implemented.');
		}
		internal function write(writer:MultibyteWriter):void{
			throw new Error('Feature not implemented.');
		}
	}
}