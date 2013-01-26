package game.sound
{
	import flash.events.Event;
	
	public class HeartEvent extends Event
	{
		public static const BEAT:String = "BeatHeartEvent";
		
		public var time:uint;
		
		public function HeartEvent(type:String, time:uint, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.time = time;
		}
		override public function clone():Event
		{
			return new HeartEvent(type, time, bubbles, cancelable);
		}
		override public function toString():String
		{
			return formatToString("HeartEvent", "type", "time", "bubbles", "cancelable",
				"eventPhase");
		}
	}
}