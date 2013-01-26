package
{
	import com.greensock.TweenLite;
	
	import game.LevelDevelop;
	
	import starling.display.Sprite;
	
	public class Stranded extends Sprite
	{
		private var _scenesContainer:Sprite;
		private var _director:Director;
		
		public function Stranded()
		{
			_scenesContainer = new Sprite();
			addChild(_scenesContainer);
			
			_director = Director.instance;
			
			_director.scenesContainer = this;
			_director.changeToScene( new LevelDevelop() );
		}
	}
}