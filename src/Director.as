package
{
	import starling.display.Sprite;

	public class Director
	{	
		//singleton
		private static var _instance:Director
		
		public static function get instance():Director
		{
			if( !_instance ) _instance = new Director();
			
			return _instance;
		}
		//end singleton
		
		
		//scenes
		public var scenesContainer:Sprite;
		
		private var _actualScene:Sprite;
		
		public function changeToScene( scene:Sprite ):void
		{
			if(!scenesContainer) return;
			
			if(_actualScene) scenesContainer.removeChild(_actualScene);
			
			_actualScene = scene;
			
			scenesContainer.addChild(_actualScene);
		}
	}
}