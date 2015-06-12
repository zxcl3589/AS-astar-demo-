package magicofhero.map
{
	/**
	 * 最小二叉堆节点 
	 * @author as
	 * 
	 */
	public class HeepNode{
		/** 父节点 */
		internal var parent:HeepNode;
		/** 左节点 */
		internal var leftNode:HeepNode;
		/** 右节点 */
		internal var rightNode:HeepNode;
		/** 数据对象 */
		internal var data:MapNode;
		public function HeepNode(){
			
		}
	}
}