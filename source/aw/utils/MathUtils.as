package aw.utils{
	public class MathUtils extends Object{
		[Inline]
		static public function ceil(value:Number):Number{
			return value == int(value) ? value : value >= 0 ? int(value+1) : int(value);
		}
		[Inline]
		static public function abs(value:Number):Number{
			return value>0 ? value : -value;
		}
		[Inline]
		static public function min(value1:Number, value2:Number):Number{
			return value1<value2 ? value1 : value2;
		}
		[Inline]
		static public function max(value1:Number, value2:Number):Number{
			return value1>value2 ? value1 : value2;
		}
	}
}