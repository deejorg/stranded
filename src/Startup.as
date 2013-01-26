package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
	public class Startup extends Sprite
	{
		public static var debugSprite:Sprite;
		
		private var _starling:Starling;
		
		public function Startup()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_starling = new Starling(Stranded,stage);
			_starling.start();
			
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		}
		
		private function onContextCreated(e:Event):void{
			//debug mode
			debugSprite=new Sprite();
			addChild(debugSprite);
		}
	}
}