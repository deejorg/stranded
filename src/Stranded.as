package
{
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class Stranded extends Sprite
	{	
		public function Stranded()
		{
			var textField:TextField = new TextField(200,30,"Hello World","Verdana",12,0xFFFFFF);
			addChild(textField);
		}
	}
}