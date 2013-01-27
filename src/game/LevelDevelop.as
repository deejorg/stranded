package game
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
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
			
			heartBeat.push( new BeatSound( 2, 1 ) );
			heartBeat.push( new BeatSound( 1, 0 ) );
			heartBeat.push( new BeatSound( 1, .1 ) );
			heartBeat.push( new BeatSound( 1, .1 ) );
			
			heartBeat.push( new BeatSound( 1, 1 ) );
			heartBeat.push( new BeatSound( 1, 0 ) );
			heartBeat.push( new BeatSound( 1, .5 ) );
			heartBeat.push( new BeatSound( 1, 0 ) );
			
			heartBeat.push( new BeatSound( 2, 1 ) );
			heartBeat.push( new BeatSound( 1, 0 ) );
			heartBeat.push( new BeatSound( 1, .2 ) );
			heartBeat.push( new BeatSound( 1, .2 ) );
			
			super( heartBeat, 400 );
		}
		
		[Embed(source="assets/level1Fixtures.txt",mimeType="application/octet-stream")]
		public var SquareTest:Class;
		protected var _squareTest:Object;
		
		protected override function setupLevel():void
		{
			_squareTest = JSON.parse( new SquareTest().toString() );
			
			_levelCrustAngle = 0;
			_levelCrust = addLevelBody( _squareTest, new Point(400,300), _levelCrustAngle ); 
		}
		
		protected override function setupCoreBall():void
		{
			_coreBall = new CoreBall( new Point(400,300), 50, 100, _world );
			
			addChild(_coreBall);
		}
		
		protected override function setupHero():void
		{
			_hero = new Hero( new Point(400, 150), _world );
			
			addChild(_hero);
		}
	}
}