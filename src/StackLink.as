package
{
	/**
	 * 类似栈的链表 
	 * @author lqh
	 */
	public class StackLink{
		private var _head:StackLinkStruct;
		private var _length:int;
		public function StackLink(){
			_length = 0;
		}
		public function get head():StackLinkStruct{
			return _head;
		}
		public function get length():int{
			return _length;
		}
		/** 入栈 */
		public function push(data:*):void{
			if(!_head){
				_head = new StackLinkStruct();
				_head.obj = data;
				_head.next = null;
			}else{
				var temphead:StackLinkStruct = new StackLinkStruct();
				_head.head = temphead;
				temphead.obj = data;
				temphead.next = _head;
				_head = temphead;
			}
			_length++;
		}
		/** 出栈 */
		public function shift():*{
			if(_head){
				var backdata:* = _head.obj;
				var returnhead:StackLinkStruct = _head;
				if(_head.next){
					_head = _head.next;
					_head.head = null;
				}else{
					_head = null;
				}
				returnhead.next = null;
				returnhead.obj = null;
				_length--;
				return backdata;
			}else{
				return null;
			}
		}
	}
}