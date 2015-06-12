package magicofhero.map
{
	import flash.display.Sprite;
	
	/**
	 * 6边形精灵 ，地图的实体显示对象
	 * @author as
	 */
	public class SexangleSprite extends Sprite{
		public static const BASEX:int = 10;
		public static const BASEY:int = 10;
		internal var _mapNode:MapNode;
		private var sexangle:Sexangle;
		public function SexangleSprite(){
			super();
			sexangle = new Sexangle();
			sexangle.x = -3;
			sexangle.y = -5;
			addChild(sexangle);
		}
		/**
		 * 更新地图节点数据 
		 * @param mapnode：节点数据
		 */
		public function updataMapNode(mapnode:MapNode):void{
			_mapNode = mapnode;
			mapnode._mapSprite = this;
			if(!_mapNode._walkable){
				sexangle.isBarrier();
			}
			this.y = mapnode.y * 7 + BASEY;
			if(!(y%2)){
				this.x = mapnode.x * 6 + BASEX;
			}else{
				this.x = mapnode.x * 6 + 3 + BASEX;
			}
		}
	}
}