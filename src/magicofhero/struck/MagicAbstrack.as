package magicofhero.struck
{
	public class MagicAbstrack{
		protected var _type:int;
		protected var _attack:Number;
		protected var _level:int;
		protected var _cost:int;
		public function MagicAbstrack(){
			
		}
		public function get type():int{
			return _type;
		}
		public function get attack():Number{
			return _attack;
		}
		public function get level():int{
			return _level;
		}
		public function get cost():int{
			return _cost;
		}
	}
}