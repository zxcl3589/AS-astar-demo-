package magicofhero.map
{
	/**
	 * 最小二叉堆 
	 * @author as
	 * 
	 */
	public class MinBHeep{
		/** 二叉堆节点数据数组 */
		private var heepNodes:Vector.<HeepNode>;
		/** 头节点 */
		private var head:HeepNode;
		/** 当前数据长度 */
		private var _len:int;
		/** 二叉堆节点缓存 */
		private var pool:HeepNodePool;
		/**
		 * 最小二叉堆 ，为满足最小二叉堆特性，数据数组从位置1开始
		 * @param size：地址池数据容量
		 */
		public function MinBHeep(size:uint){
			_len = 1;
			pool = new HeepNodePool(size);
			heepNodes = new Vector.<HeepNode>(size,true);
		}
		/**
		 * 向下修正节点 
		 */
		private function modifyFromRoot(heepnode:HeepNode):void{
			var curData:MapNode = heepnode.data;
			var f:uint = curData.thisToEndCost;
			var leftHeepnode:HeepNode;
			var rightHeepnode:HeepNode;
			while(true){
				leftHeepnode = heepnode.leftNode;
				rightHeepnode = heepnode.rightNode;
				//二叉堆的平衡性，必须有左边节点才会有右边节点，并且右边节点小于左边节点
				if(rightHeepnode && rightHeepnode.data.thisToEndCost < leftHeepnode.data.thisToEndCost){
					if(rightHeepnode.data.thisToEndCost < f){
						heepnode.data = rightHeepnode.data;
						heepnode.data._heepNode = heepnode;
						
						heepnode = rightHeepnode;
						continue;
					}
					break;
				}else if(leftHeepnode && leftHeepnode.data.thisToEndCost < f){
					heepnode.data = leftHeepnode.data;
					heepnode.data._heepNode = heepnode;
					
					heepnode = leftHeepnode;
				}else{
					break;
				}
			}
			heepnode.data = curData;
			curData._heepNode = heepnode;
		}
		/**
		 * 向上修正节点
		 */
		private function modifyFromLeaf(heepnode:HeepNode):void{
			var curData:MapNode = heepnode.data;
			var f:uint = curData.thisToEndCost;
			var parent:HeepNode = heepnode.parent;
			
			while(parent){
				//如果父节点数据的f值比当前值小，交换数据
				if(parent.data.thisToEndCost > f){
					heepnode.data = parent.data;
					heepnode.data._heepNode = heepnode;
					
					heepnode = parent;
					parent = heepnode.parent;
					continue;
				}
				break;
			}
			heepnode.data = curData;
			curData._heepNode = heepnode;
		}
		/** 从堆中取出最小值 */
		public function pop():MapNode{
			if(head){
				//首先把头数据取出
				var backdata:MapNode = head.data; 
				var lastNode:HeepNode = heepNodes[--_len];
				//如果二叉堆长度不为1，即头和尾不是同一个数据，把尾部数据放入头部二叉堆节点，向下修正节点
				if(_len != 1){
					var parent:HeepNode = lastNode.parent;
					parent.leftNode == lastNode ? parent.leftNode = null : parent.rightNode = null;
					head.data = lastNode.data;	
					head.data._heepNode = head;
					//向下修正节点
					modifyFromRoot(head);
				}else{
					head = null;
				}
				//把二叉堆节点存入缓存池
				pool.saveNode(heepNodes[_len]);
				//把尾部置空
				heepNodes[_len] = null;
				return backdata;
			}
			return null;
		}
		/** 放入堆 */
		public function push(mapnode:MapNode):void{
			if(head){
				//最小二叉堆特性
				var parent:HeepNode = heepNodes[_len>>1];
				
				var heepnode:HeepNode = pool.getNode();
				heepnode.parent = parent;
				//如果父节点左节点没数据，放入左节点否则放入右节点
				parent.leftNode ? parent.rightNode = heepnode : parent.leftNode = heepnode;
				
				//二叉堆节点和数据互相设置引用
				heepnode.data = mapnode;
				mapnode._heepNode = heepnode;
				
				//把节点放入数组
				heepNodes[_len++] = heepnode;
				//向上修正二叉堆
				modifyFromLeaf(heepnode);
			}else{
				head = pool.getNode();
				head.data = mapnode;
				mapnode._heepNode = head;
				heepNodes[1] = head;
				_len = 2;
			}
		}
		public function modify(node:HeepNode):void{
			if(node.parent && node.parent.data.thisToEndCost > node.data.thisToEndCost){
				modifyFromLeaf(node);
			}else{
				modifyFromRoot(node);
			}
		}
		/** 重置二叉堆 */
		public function reset():void{
			for(var i:int = 1;i<_len;i++){
				heepNodes[i].data._heepNode = null;
				pool.saveNode(heepNodes[i]);
				heepNodes[i] = null;
			}
			head = null;
		}
	}
}