package magicofhero.struck
{
	import flash.geom.Point;

	public class ArmAbstrack{
		public static const ATTACK_STATE:int = 1;
		public static const DEFENSE_STATE:int = 2;
		protected var _speed:int;
		protected var _num:int;
		protected var _baseAttack:Number;
		protected var _baseDefense:Number;
		protected var _attack:Number;
		protected var _defense:Number;
		protected var _baseLive:Number;
		protected var _live:Number;
		protected var _damage:Point;
		protected var _type:int;
		/** 1：等待状态，2：防御状态 */
		protected var _state:int;
		protected var _position:Point;
		protected var _description:String;
		/** 反击次数，如果该值为负数，表示无限反击 */
		protected var _attackBack:int;
		protected var _magics:Vector.<MagicAbstrack>;
		public function ArmAbstrack(){
			_magics = new Vector.<MagicAbstrack>();
		}
		public function get speed():int{
			return _speed;
		}
		public function get num():int{
			return _num;
		}
		public function get baseAttack():Number{
			return _baseAttack;
		}
		public function get baseDefense():Number{
			return _baseDefense;
		}
		public function get attack():Number{
			return _attack;
		}
		public function get defense():Number{
			return _defense;
		}
		public function get baseLive():Number{
			return _baseLive;
		}
		public function get live():Number{
			return _live;
		}
		public function set live(value:Number):void{
			_live = value;
		}
		public function get type():Number{
			return _type;
		}
		public function get state():int{
			return _state;
		}
		public function get description():String{
			return _description;
		}
		public function get position():Point{
			return _position;
		}
		public function set position(value:Point):void{
			_position = value;
		}
		public function get damage():Point{
			return _damage;
		}
		public function get magics():Vector.<MagicAbstrack>{
			return _magics;
		}
		public function get attackBack():int{
			return _attackBack;
		}
		public function set attackBack(value:int){
			_attackBack = value;
		}
	}
}