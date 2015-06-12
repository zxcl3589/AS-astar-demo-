package magicofhero.map
{
	/**
	 * 二叉堆节点数据缓存池，用于高速存取 
	 * @author as
	 * 
	 */
	public class HeepNodePool{
		/** 当前缓存池最大缓存数量 */
		private var MAXLEN:uint;
		/** 当前缓存池数据量 */
		private var len:uint;
		/** 缓存池数据 */
		private var datas:Vector.<HeepNode>;
		public function HeepNodePool(maxsiz:uint){
			datas = new Vector.<HeepNode>(maxsiz,true);
			len = maxsiz - 1;
			for(var i:int=0;i<maxsiz;i++){
				datas[i] = new HeepNode();
			}
		}
		/**
		 * 从缓存池获取一个二叉堆节点，如果缓存池已空，会new新的二叉堆节点 
		 * @return：返回一个二叉堆节点
		 * 
		 */
		internal function getNode():HeepNode{
			if(len > 0){
				var backNode:HeepNode = datas[len];
				datas[len] = null;
				len --;
				return backNode;
			}
			return new HeepNode();
		}
		/**
		 * 存入一个二叉堆节点到缓存池，如果缓存池溢出，则直接抛弃该节点，且该方法会格式化二叉堆节点的数据
		 * @param node：二叉堆节点
		 */
		internal function saveNode(node:HeepNode):void{
			if(node){
				node.parent = null;
				node.leftNode = null;
				node.rightNode = null;
				node.data = null;
				if(len < MAXLEN - 1){
					datas[++len] = node;
				}
			}
		}
		public function destory():void{
			datas.length = 0;
			datas = null;
		}
	}
}