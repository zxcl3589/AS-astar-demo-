package magicofhero.map
{
	/**
	 * 地图数据节点，因为游戏特性，所有节点passCost值都是一致 
	 * @author as
	 * 
	 */
	public class MapNode{
		internal var _x:int;
		internal var _y:int;
		/** 此节点的穿越代价 */
		internal var passCost:uint = 1;
		/** 从起点到该节点的代价 */
		internal var startToThisCost:uint;
		/** 此节点到目标节点代价 */
		internal var thisToEndCost:uint;
		/** 检查编号 */
		internal var checkMark:int;
		/** 是否能穿越 */
		internal var _walkable:Boolean;
		/** 父地图节点 */
		internal var _parent:MapNode;
		/** 所在二叉堆节点 */
		internal var _heepNode:HeepNode;
		/** 相邻节点 */
		internal var _neighborNodes:Vector.<MapNode>;
		/** 地图实体显示精灵 */
		internal var _mapSprite:SexangleSprite;
		public function MapNode(x:int,y:int,walkable:Boolean = true){
			_x = x;
			_y = y;
			_walkable = walkable;
			_neighborNodes = new Vector.<MapNode>();
		}
		public function get x():int{
			return _x;
		}
		public function get y():int{
			return _y;
		}
		/**
		 * 互相添加相邻节点 
		 * @param neigborNode：地图节点
		 */
		public function addNeigborEachOther(neigborNode:MapNode):void{
			_neighborNodes.push(neigborNode);
			neigborNode._neighborNodes.push(this);
		}
	}
}