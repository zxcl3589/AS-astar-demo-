package magicofhero.map
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * 六边形地图类 <br/>
	 * 六边形地图的特性是隔排的格子会有一个格子差<br/>
	 * 在此定义第一排的格子为单排最大格子（即如果单排最大16个，那第一排就16个，弟二排15个依次类推）<br/>
	 * 定义每个地图节点穿越代价都为1，且相等。
	 * @author as
	 * 
	 */
	public class MapOfHero{
		public static const WIDTH:int = 256;
		public static const HEIGHT:int = 96;
		/** 地图节点数据 */
		private var mapDataNodes:Vector.<Vector.<MapNode>>;
		/** 地图上每个实体精灵格子 */
		private var mapSpriteNodes:Vector.<Vector.<SexangleSprite>>;
		private var minBHeep:MinBHeep;
		private var checkNum:int;
		public function MapOfHero(){
			mapDataNodes = new Vector.<Vector.<MapNode>>(HEIGHT);
			var len:int = WIDTH - 1;
			for(var i:int = 0;i<HEIGHT;i++){
				var hvec:Vector.<MapNode>;
				var k:int = 0;
				if(i%2 == 0){
					hvec = new Vector.<MapNode>(WIDTH);
					for(;k < WIDTH;k++){
						hvec[k] = new MapNode(k,i);
					}
				}else{
					hvec = new Vector.<MapNode>(len);
					for(;k < len;k++){
						hvec[k] = new MapNode(k,i);
					}
				}
				mapDataNodes[i] = hvec;
			}
			refreshAllNeigbor();
			minBHeep = new MinBHeep((WIDTH * HEIGHT)>>1);
		}
		/**
		 * 刷新所有地图节点的邻节点
		 */
		private function refreshAllNeigbor():void{
			var mapNode:MapNode;
			for(var m:int = 0;m < HEIGHT;m++){
				var len:int = mapDataNodes[m].length;
				for(var n:int = 0; n < len;n++){
					mapNode = mapDataNodes[m][n];
					if(!(m % 2)){
						if(m < HEIGHT - 1){
							if(n < len - 1){
								mapNode.addNeigborEachOther(mapDataNodes[m][n + 1]);
								mapNode.addNeigborEachOther(mapDataNodes[m + 1][n]);
							}
							if(n > 0){
								mapNode.addNeigborEachOther(mapDataNodes[m + 1][n - 1]);
							}
						}else{
							if(n < len - 1){
								mapNode.addNeigborEachOther(mapDataNodes[m][n + 1]);
							}
						}
					}else{
						if(m < HEIGHT - 1){
							mapNode.addNeigborEachOther(mapDataNodes[m + 1][n]);
							mapNode.addNeigborEachOther(mapDataNodes[m + 1][n + 1]);
							if(n < len - 1){
								mapNode.addNeigborEachOther(mapDataNodes[m][n + 1]);
							}
						}else{
							if(n < len - 1){
								mapNode.addNeigborEachOther(mapDataNodes[m][n + 1]);
							}
						}
					}
				}
			}
		}
		/**
		 * 初始化地图显示 
		 * @param s：需要一个显示对象承载地图精灵
		 */
		public function initializerMapSprite(s:Sprite):void{
			drawPathSprite = (s as media_test).gsp;
			testDefineMap();
			var hvec:Vector.<MapNode>;
			var node:MapNode;
			var len:int;
			var sexangleSprite:SexangleSprite;
			mapSpriteNodes = new Vector.<Vector.<SexangleSprite>>(HEIGHT);
			var hmapsprites:Vector.<SexangleSprite>;
			for(var m:int = 0;m < HEIGHT;m++){
				len = mapDataNodes[m].length;
				hmapsprites = new Vector.<SexangleSprite>(len);
				for(var n:int = 0 ; n < len; n++){
					sexangleSprite = new SexangleSprite();
					sexangleSprite.updataMapNode(mapDataNodes[m][n]);
					s.addChild(sexangleSprite);
					hmapsprites[n] = sexangleSprite;
					sexangleSprite.addEventListener(MouseEvent.CLICK,clickNode);
				}
				mapSpriteNodes[m] = hmapsprites;
			}
		}
		/**
		 * 启发函数<br/>
		 * 计算从指定节点到目标节点代价
		 * @param curNode：指定节点
		 * @param endNode：目标节点
		 */
		public function toEndCost(curNode:MapNode,endNode:MapNode):uint{
			//当前排是基数排或者偶数排
			var value:uint = endNode.y % 2;
			//当前节点和目标节点相差的排数
			var d:uint = Math.abs(curNode.y - endNode.y);
			//用于计算当前排最近点的一个修正值
			var vd:uint;
			//当前排最左边离目标点最近的点
			var cl:int;
			//当前排最右边离目标点最近的点
			var cr:int;
			
			if(value == curNode.y%2){//目标点和运算点都属于相同类型排
				vd = d>>1;
				//如果该节点正好在最近圈上，则代值为圈数（即d）
				cl = endNode.x - vd;
				cr = endNode.x + vd;
			}else if(value && !(curNode.y%2)){//目标点为基数排，运算点为偶数排
				vd = (d + 1)>>1;
				cl = endNode.x - vd + 1;
				cr = endNode.x + vd;
			}else{//目标点为偶数排，运算点为基数排
				vd = (d + 1)>>1;
				cl = endNode.x - vd;
				cr = endNode.x + vd - 1;
			}
			cl < 0 ? cl = 0 : 0;
			//如果刚还在圈上，则代价为圈d
			if(curNode.x >= cl && curNode.x <= cr){
				return d;
			}else{//水平到达该行最近圈上的点，然后加上圈的值
				//当前点到当前排左边最近点的值
				var ld:uint = Math.abs(curNode.x - cl);
				//当前点到当前排右边最近点值
				var rd:uint = Math.abs(curNode.x - cr);
				if(ld < rd){
					return ld + d;
				}else{
					return rd + d;
				}
			}
		}
		
		/**
		 * 模拟设置障碍 
		 */
		private function testDefineMap():void{
			var value:int = HEIGHT * WIDTH - (HEIGHT>>1);
			var temp:int;
			temp = value/2*(Math.random());
			var m:int;
			var v:Vector.<MapNode>;
			for(var i:int = 0; i < temp;i++){
				m = Math.random() * value;
				
				v = mapDataNodes[int(m/WIDTH)];
				if(m%WIDTH < v.length){
					v[m%WIDTH]._walkable = false;
				}
			}
		}
		/**
		 * 自定义地图，某些点不可穿越 
		 * @param notearr：不可穿越节点位置
		 */
		public function defineMap(notearr:Vector.<Point>):void{
			var len:int = notearr.length;
			for(var i:int = len - 1 ; i>=0 ;i--){
				mapDataNodes[notearr[i].x][notearr[i].y]._walkable = false;
			}
		}
		/**
		 * A*寻路 
		 * @param start：开始地图节点
		 * @param end：结束地图节点
		 * @param checkMark：检查编号
		 * @return：是否找到路
		 */
		private function searchPath(startNode:MapNode,endNode:MapNode,checkMark:int):Boolean{
			/**已进入关闭列表(从openList中移除即进入关闭列表)*/
			const STATUS_CLOSED:uint=checkMark+1;
			//重置二叉堆
			minBHeep.reset();
			//开放链表
			var openList:MinBHeep = minBHeep;
			
			startNode.startToThisCost = 0;
			startNode.thisToEndCost = startNode.startToThisCost+toEndCost(startNode,endNode);
			startNode.checkMark = STATUS_CLOSED;
			
			var curNode:MapNode = startNode;
			var tempNode:MapNode;
			var g:int;
			var neighbors:Vector.<MapNode>;
			
			while(curNode != endNode){
				neighbors = curNode._neighborNodes;
				for(var i:int = neighbors.length - 1 ;i >= 0 ;i--){
					tempNode = neighbors[i];
					//是否可通过
					if(tempNode._walkable){
						//计算从node节点到该节点的代价
						g = curNode.startToThisCost + tempNode.passCost;
						if(tempNode.checkMark >= checkMark){/*已被检查过*/
							if(tempNode.startToThisCost > g){
								
								tempNode.startToThisCost = g;
								tempNode.thisToEndCost = g + toEndCost(tempNode,endNode);
								
								tempNode._parent = curNode;
								
								if(tempNode.checkMark == checkMark){
									openList.modify(tempNode._heepNode);
								}
							}
						}else{
							tempNode.thisToEndCost = g + toEndCost(tempNode,endNode);
							tempNode.startToThisCost = g;
							tempNode._parent = curNode;
							
							openList.push(tempNode);
							tempNode.checkMark = checkMark;
						}
					}
				}
				curNode = openList.pop();
				if(curNode){
					curNode.checkMark = STATUS_CLOSED;
				}else{
					return false;
				}
			}
			return true;
		}
		private function find(startNode:SexangleSprite,endNode:SexangleSprite):Vector.<MapNode>{
			checkNum += 2;
			
			if(searchPath(startNode._mapNode,endNode._mapNode,checkNum)){
				var curNode:MapNode=endNode._mapNode;
				drawPathSprite.graphics.clear();
				var path:Vector.<MapNode>= Vector.<MapNode>([curNode]);
				drawPathSprite.graphics.moveTo(path[0]._mapSprite.x,path[0]._mapSprite.y);
				drawPathSprite.graphics.lineStyle(1,0xff0000);
				var n:uint;
				while(curNode != startNode._mapNode){
					curNode=curNode._parent;
					path[n++]=curNode;
					drawPathSprite.graphics.lineTo(curNode._mapSprite.x,curNode._mapSprite.y);
					drawPathSprite.graphics.moveTo(curNode._mapSprite.x,curNode._mapSprite.y);
				}
				drawPathSprite.graphics.endFill();
				return path;
			}
			return null;
		}
		private var startSprite:SexangleSprite;
		private var endSprite:SexangleSprite;
		private var drawPathSprite:Sprite;
		private function clickNode(e:MouseEvent):void{
			if((e.currentTarget as SexangleSprite)._mapNode._walkable){
				if(!startSprite){
					startSprite = e.currentTarget as SexangleSprite;
				}else if(!endSprite){
					endSprite = e.currentTarget as SexangleSprite;
					var t:uint = getTimer();
					find(startSprite,endSprite);
					trace("the search cost time: " + (getTimer() - t));
					startSprite = null;
					endSprite = null;
				}
			}
		}
	}
}