package
{
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
	public class Startup extends Sprite
	{
		private var _starling:Starling;
		
		public function Startup()
		{
			_starling = new Starling(Stranded,stage);
			_starling.start();
		}
	}
}