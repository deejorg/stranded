package game.sound
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Heart extends EventDispatcher
	{
		//singleton
		private static var _instance:Heart;
		
		public static function get instance():Heart
		{
			if( !_instance ) _instance = new Heart();
			
			return _instance;
		}
		
		//constructor
		public function Heart()
		{
			setupTimer();
		}
		
		//start/stop beat
		public function startBeat():void
		{
			_actualTime = 0;
			
			beat();
			
			_timer.start();
		}
		
		public function stopBeat():void
		{
			_timer.stop();
		}
		
		public function get beating():Boolean
		{
			return _timer.running;
		}
		
		//bpm
		private var _bpm:uint = 96;
		
		public function get BPM():uint
		{
			return _bpm;
		}
		
		public function set BPM( value:uint ):void
		{
			_bpm = value;
			
			_timer.delay = beatTime;
		}
		
		public function get beatTime():Number
		{
			return 60/_bpm*1000;
		}
		
		//heart beat
		private const _times:uint = 16;
		private var _actualTime:uint;
		private var _timer:Timer;
		
		private function setupTimer():void
		{
			_timer = new Timer(beatTime,0);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		private function onTimer(event:TimerEvent):void
		{
			_actualTime++;
			
			if( _actualTime >= _times ) _actualTime = 0;
			
			beat();
		}
		
		private function beat():void
		{
			dispatchEvent( new HeartEvent(HeartEvent.BEAT, _actualTime ) );
		}
	}
}