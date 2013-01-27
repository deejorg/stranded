package game
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.ui.Keyboard;
	
	import game.sound.BeatSound;
	import game.sound.Heart;
	import game.sound.HeartEvent;
	
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.utils.deg2rad;
	
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
			setupLevel();
			setupDebugDraw();
			setupHeartBeat();
			setupCoreBall();
			setupHero();
			setupControls();
			setupTheme();
			
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
			destroyLevel();
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
			updateLevel();
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
					sprite.rotation = bb.GetAngle();// * (180/Math.PI);
				}
				
				if (bb.GetUserData() is Shape){
					var shape:Shape = bb.GetUserData() as Shape;
					shape.x = bb.GetPosition().x * WORLD_SCALE;
					shape.y = bb.GetPosition().y * WORLD_SCALE;
					shape.rotation = bb.GetAngle();// * (180/Math.PI);
				}
			}
		}
		
		//level
		protected var _levelCrust:b2Body;
		protected var _levelCrustAngle:Number;
		
		protected function setupLevel():void
		{
			//
		}
		
		protected function updateLevel():void
		{
			
		}
		
		protected function destroyLevel():void
		{
			
		}
		
		protected function addLevelBody( bodyObject:Object, centerPosition:Point, angle:Number ):b2Body
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(centerPosition.x/WORLD_SCALE, centerPosition.y/WORLD_SCALE);
			bodyDef.type = b2Body.b2_kinematicBody;
			var body:b2Body = _world.CreateBody(bodyDef);
			body.SetAngle( angle );
			body.SetAngularVelocity(1);
			
			var shape:Shape = new Shape();
			
			shape.x = centerPosition.x;
			shape.y = centerPosition.y;
			
			body.SetUserData( shape );
			
			addChild(shape);
			
			for(var h:int = 0; h < bodyObject.rigidBodies.length; h++ )
			{
				for (var i:int = 0; i < bodyObject.rigidBodies[h].polygons.length; i++) 
				{	
					var vertices:Vector.<b2Vec2> = new Vector.<b2Vec2>();
					var vertice:b2Vec2;
					
					if( h == 1 ){
						shape.graphics.beginFill(0x032142);
					} else {
						shape.graphics.beginFill(0x032e5d);
					}
					
					for (var j:int = 0; j < bodyObject.rigidBodies[h].polygons[i].length; j++) 
					{
						vertice = new b2Vec2( (bodyObject.rigidBodies[h].polygons[i][j].x*800)/WORLD_SCALE, (bodyObject.rigidBodies[h].polygons[i][j].y*800)/WORLD_SCALE*1 );
						
						var newAngle:Number = Math.atan2(vertice.y, vertice.x) + angle;
						
						vertice.Set( Math.cos(newAngle)*vertice.Length(), Math.sin(newAngle)*vertice.Length() );
						
						if( j == 0 ){
							shape.graphics.moveTo(vertice.x*WORLD_SCALE, vertice.y*WORLD_SCALE);
						} else {
							shape.graphics.lineTo(vertice.x*WORLD_SCALE, vertice.y*WORLD_SCALE);
						}
						
						vertices.push( vertice );
					}
					
					shape.graphics.endFill();
					
					var polyShape:b2PolygonShape = new b2PolygonShape();
					polyShape.SetAsVector(vertices,vertices.length);
					var fixtureDef:b2FixtureDef = new b2FixtureDef();
					fixtureDef.shape = polyShape;
					fixtureDef.density = 1;
					fixtureDef.restitution = 0.1;
					fixtureDef.friction = 5;
					body.CreateFixture(fixtureDef);
					
				}
			}
			
			return body;
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
			//_world.DrawDebugData();
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
					//heroImpulseVector.Multiply( 9 + Math.abs(coreBallPulseDistanceLength - heroDistanceLength)*7 );
					heroImpulseVector.Multiply( 15 + Math.abs(coreBallPulseDistanceLength - heroDistanceLength)*10 );
					
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
		
		//sound
		[Embed(source="assets/theme.mp3")]
		public var Theme:Class;
		
		protected var theme:Sound;
		
		protected function setupTheme():void
		{
			theme = new Theme();
			
			var channel:SoundChannel = theme.play();
		}
	}
}