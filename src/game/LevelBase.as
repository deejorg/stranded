package game
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.sound.BeatSound;
	import game.sound.Heart;
	import game.sound.HeartEvent;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class LevelBase extends Sprite
	{
		public function LevelBase( heartBeat:Vector.<BeatSound>, gravityRadius:Number )
		{
			_heartBeat = heartBeat;
			_gravityRadius = gravityRadius;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		//added to and removed from stage
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			setupWorld();
			setupDebugDraw();
			setupHeartBeat();
			setupCoreBall();
			setupHero();
			setupControls();
			
			start();
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			destroyControls();
			destroyHero();
			destroyCoreBall();
			destroyHeartBeat();
			destroyDebugDraw();
			destroyWorld();
			
			removeEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		//start
		protected function start():void {
			if( !Heart.instance.beating ) Heart.instance.startBeat();
		}
		
		//update
		private function onUpdate(e:Event):void
		{
			updateWorld();
			updateGravity();
			updateHero();
			updateDebugDraw();
		}
		
		//world
		public static const WORLD_SCALE:uint = 30;
		
		protected var _world:b2World;
		
		private function setupWorld():void
		{
			_world = new b2World( new b2Vec2(0,0), false );
			_world.SetContactListener( new ContactListener() );
		}
		
		private function destroyWorld():void
		{
			_world = null;
		}
		
		private function updateWorld():void
		{
			_world.Step(1/60,10,10);
			_world.ClearForces();
			
			//update bodies
			for (var bb:b2Body = _world.GetBodyList(); bb; bb = bb.GetNext()){
				if (bb.GetUserData() is Sprite){
					var sprite:Sprite = bb.GetUserData() as Sprite;
					sprite.x = bb.GetPosition().x * WORLD_SCALE;
					sprite.y = bb.GetPosition().y * WORLD_SCALE;
					sprite.rotation = bb.GetAngle() * (180/Math.PI);
				}
			}
		}
		
		//debug draw
		private function setupDebugDraw():void
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(Startup.debugSprite);
			debugDraw.SetDrawScale(WORLD_SCALE);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit |b2DebugDraw.e_jointBit);
			debugDraw.SetFillAlpha(.5);
			_world.SetDebugDraw(debugDraw);
		}
		
		private function destroyDebugDraw():void
		{
			_world.SetDebugDraw(null);
		}
		
		private function updateDebugDraw():void
		{
			_world.DrawDebugData();
		}
		
		//heart beat
		private var _heartBeat:Vector.<BeatSound>;
		
		private function setupHeartBeat():void
		{
			Heart.instance.addEventListener( HeartEvent.BEAT, onHeartBeat );
		}
		
		private function destroyHeartBeat():void
		{
			Heart.instance.removeEventListener( HeartEvent.BEAT, onHeartBeat );
		}
		
		private function onHeartBeat(event:HeartEvent):void
		{
			var currentBeatSound:BeatSound = _heartBeat[ event.time ] as BeatSound;
			
			if( currentBeatSound.intensity > 0 ){
				
				var heroDistanceVector:b2Vec2 = _hero.body.GetPosition();
				heroDistanceVector.Subtract(_coreBall.body.GetPosition());
				
				var heroDistanceLength:Number = heroDistanceVector.Length();
				
				var coreBallPulseDistanceLength:Number = _coreBall.standRadius/WORLD_SCALE + (_coreBall.pulseRadius/WORLD_SCALE-_coreBall.standRadius/WORLD_SCALE)*currentBeatSound.intensity
				
				_coreBall.beat( currentBeatSound );
				
				if( coreBallPulseDistanceLength - heroDistanceLength > 0 ){
				
					var heroImpulseVector:b2Vec2 = heroDistanceVector.Copy();
					heroImpulseVector.Normalize();
					heroImpulseVector.Multiply( 9 + Math.abs(coreBallPulseDistanceLength - heroDistanceLength)*7 );
					
					_hero.impulseJump( heroImpulseVector );
				}
				
			}
		}
		
		//core ball
		protected var _coreBall:CoreBall;
		
		//to override
		protected function setupCoreBall():void {}
		
		protected function destroyCoreBall():void {
			removeChild(_coreBall);
			
			_coreBall = null;
		}
		
		//hero
		protected var _hero:Hero;
		
		//to override
		protected function setupHero():void {}
		
		protected function updateHero():void
		{
			if( _leftIsDown ){
				_hero.left( new Point( _coreBall.body.GetPosition().x, _coreBall.body.GetPosition().y ) );
			}
			
			if( _rightIsDown ){
				_hero.right( new Point( _coreBall.body.GetPosition().x, _coreBall.body.GetPosition().y ) );
			}
			
			if( !_leftIsDown && !_rightIsDown ){
				_hero.moving = false;
			} else {
				_hero.moving = true;
			}
		}
		
		protected function destroyHero():void {
			removeChild(_hero);
			
			_hero = null;
		}
		
		//circular gravity
		protected var _gravityRadius:Number;
		
		protected function updateGravity():void
		{
			var distance:b2Vec2 = new b2Vec2(0,0);
			distance.Add(_hero.body.GetPosition());
			distance.Subtract(_coreBall.body.GetPosition());
			
			if( distance.Length() <= _gravityRadius/WORLD_SCALE ){
				
				var tempDistance:b2Vec2 = distance.Copy();
				tempDistance.NegativeSelf();
				tempDistance.Multiply( (_gravityRadius/WORLD_SCALE - tempDistance.Length()) * 1.5 );
				
				_hero.body.ApplyForce( tempDistance, _hero.body.GetWorldCenter() );
			}
		}
		
		//controls
		protected var _leftIsDown:Boolean;
		protected var _rightIsDown:Boolean;
		
		protected function setupControls():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyDown( e:KeyboardEvent ):void
		{
			switch(e.keyCode)
			{
				case Keyboard.LEFT:
				{
					_leftIsDown = true;
					_hero.impulseLeft( new Point( _coreBall.body.GetPosition().x, _coreBall.body.GetPosition().y ) );
					
					break;
				}
				
				case Keyboard.RIGHT:
				{
					_rightIsDown = true;
					_hero.impulseRight( new Point( _coreBall.body.GetPosition().x, _coreBall.body.GetPosition().y ) );
					
					break;
				}
			}
		}
		
		private function onKeyUp( e:KeyboardEvent ):void
		{
			switch(e.keyCode)
			{
				case Keyboard.LEFT:
				{
					_leftIsDown = false;
					
					break;
				}
					
				case Keyboard.RIGHT:
				{
					_rightIsDown = false;
					
					break;
				}
			}
		}
		
		protected function destroyControls():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
	}
}