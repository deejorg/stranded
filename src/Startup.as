package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import game.LevelBase;
	
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
			
			//debug
			debugSprite = new Sprite();
			addChild(debugSprite);
			
			//starling
			_starling = new Starling(Stranded,stage);
			_starling.start();
		}
	}
}