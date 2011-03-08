package aw.projects.multibyte.data{
	/**
	 * 
	 * @author Galaburda a_[w] Oleg    http://www.actualwave.com
	 * 
	 */
	public class MultibyteFloatSimple extends MultibyteIntFlexible{
		protected var _multiplierLength:uint;
		protected var _fractionMultiplier:uint;
		public function MultibyteFloatSimple(target:Object, name:*, fractionMultiplierLength:uint=3, signed:Boolean=true):void{
			super(target, name, signed);
			_type = MultibyteValueType.FLOAT;
			multiplierLength = fractionMultiplierLength;
		}
		public function get multiplierLength():uint{
			return this._multiplierLength;
		}
		public function set multiplierLength(value:uint):void{
			this._multiplierLength = value;
			this._fractionMultiplier = getFractionMultiplier(value);
		}
		override protected function getValue():*{
			return int(super.getValue()*this._fractionMultiplier);
		}
		override protected function setValue(value:*):void{
			super.setValue(value/this._fractionMultiplier);
		}
		static public function getFractionMultiplier(value:uint):uint{
			var multiplier:uint = 1;
			while(value){
				multiplier *= 10;
				value--;
			}
			return multiplier;
		}
	}
}