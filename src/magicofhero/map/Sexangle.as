package magicofhero.map
{
	import flash.display.GraphicsPathCommand;
	import flash.display.Sprite;
	
	/**
	 * 6边形绘制 
	 * @author as
	 */
	public class Sexangle extends Sprite{
		public function Sexangle(){
			super();
			graphics.beginFill((Math.random() * 0x000fff));
			graphics.drawPath(
				Vector.<int>([GraphicsPathCommand.MOVE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,
					GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO]),
				Vector.<Number>([0,3,0,7,3,10,6,7,6,3,3,0,0,3])
			);
			graphics.endFill();
		}
		public function isBarrier():void{
			graphics.clear();
			graphics.beginFill((/*Math.random() * */0xffffff));
			graphics.drawPath(
				Vector.<int>([GraphicsPathCommand.MOVE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,
					GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO]),
				Vector.<Number>([0,3,0,7,3,10,6,7,6,3,3,0,0,3])
			);
			graphics.endFill();
		}
	}
}