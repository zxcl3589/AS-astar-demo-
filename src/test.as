package
{
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	import magicofhero.map.MapOfHero;
	import magicofhero.map.Sexangle;
	[SWF(width=1000, height=900,backgroundColor="0x09e6b5")]
	public class test extends Sprite
	{
		private var accept:NetConnection;
		private var myResponder:Responder;
		private var serverIP:String = "rtmp://www.new9channel.com/live";
		public var gsp:Sprite;
		public function test()
		{
			gsp = new Sprite();
			var map:MapOfHero = new MapOfHero();
			map.initializerMapSprite(this);
			addChild(gsp);
		}
	}
}