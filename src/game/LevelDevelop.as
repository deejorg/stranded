package game
{
	import flash.geom.Point;
	
	import game.sound.BeatSound;

	public class LevelDevelop extends LevelBase
	{
		public function LevelDevelop()
		{
			var heartBeat:Vector.<BeatSound> = new Vector.<BeatSound>();
			
			heartBeat.push( new BeatSound( 1, 1 ) );
			heartBeat.push( new BeatSound( 1, 0 ) );
			heartBeat.push( new BeatSound( 1, .5 ) );
			heartBeat.push( new BeatSound( 1, 0 ) );
			
			heartBeat.push( new BeatSound( 1, 1 ) );
			heartBeat.push( new BeatSound( 1, 0 ) );
			heartBeat.push( new BeatSound( 1, .5 ) );
			heartBeat.push( new BeatSound( 1, 0 ) );
			
			heartBeat.push( new BeatSound( 1, 1 ) );
			heartBeat.push( new BeatSound( 1, 0 ) );
			heartBeat.push( new BeatSound( 1, .5 ) );
			heartBeat.push( new BeatSound( 1, 0 ) );
			
			heartBeat.push( new BeatSound( 1, 1 ) );
			heartBeat.push( new BeatSound( 1, 0 ) );
			heartBeat.push( new BeatSound( 1, .5 ) );
			heartBeat.push( new BeatSound( 1, 0 ) );
			
			super( heartBeat, 400 );
		}
		
		protected override function setupCoreBall():void
		{
			_coreBall = new CoreBall( new Point(400,300), 100, 200, _world );
			
			addChild(_coreBall);
		}
		
		protected override function setupHero():void
		{
			_hero = new Hero( new Point(400, 100), _world );
			
			addChild(_hero);
		}
	}
}