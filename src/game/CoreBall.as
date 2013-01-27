package game
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	
	import flash.geom.Point;
	
	import game.sound.BeatSound;
	import game.sound.Heart;
	
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class CoreBall extends Sprite
	{	
		public function CoreBall( position:Point, standRadius:Number, pulseRadius:Number, world:b2World )
		{
			_position = position;
			_standRadius = _actualRadius =standRadius;
			_pulseRadius = pulseRadius;
			_world = world;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		//added to and removed from stage
		private function onAddedToStage():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			setupBody();
			setupSprite();
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			destroyBody();
			destroySprite();
			
			removeEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		//body
		private var _world:b2World;
		private var _body:b2Body;
		private var _position:Point;
		
		public function get body():b2Body
		{
			return _body;
		}
		
		private function setupBody():void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(_position.x/LevelBase.WORLD_SCALE, _position.y/LevelBase.WORLD_SCALE);
			bodyDef.type = b2Body.b2_kinematicBody;
			bodyDef.userData = this;
			var bodyShape:b2CircleShape = new b2CircleShape(_standRadius/LevelBase.WORLD_SCALE);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = bodyShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.3;
			fixtureDef.friction = 5;
			_body = _world.CreateBody(bodyDef);
			_body.CreateFixture(fixtureDef);
		}
		
		private function updateBody():void
		{
			_body.GetFixtureList().GetShape().Set( new b2CircleShape( _actualRadius/LevelBase.WORLD_SCALE ) );
		}
		
		private function destroyBody():void
		{
			_world.DestroyBody(_body);
		}
		
		//sprite
		private var _sprite:Sprite;
		private var _shape:Shape;
		
		private function setupSprite():void
		{
			_sprite = new Sprite();
			addChild(_sprite);
			
			_shape = new Shape();
			_shape.graphics.beginFill( 0xFF0000 );
			_shape.graphics.drawCircle(0,0,_standRadius);
			_shape.graphics.endFill();
			
			_sprite.addChild(_shape);
		}
		
		private function updateSprite():void
		{
			_shape.graphics.clear();
			_shape.graphics.beginFill( 0xFF0000, 1 );
			_shape.graphics.drawCircle(0,0,_actualRadius);
			_shape.graphics.endFill();
		}
		
		private function destroySprite():void
		{
			_sprite.removeChild(_shape);
			_shape = null;
			
			removeChild(_sprite);
			_sprite = null;
		}
		
		//
		private var _standRadius:Number;
		private var _pulseRadius:Number;
		public var _actualRadius:Number;
		
		public function beat( beatSound:BeatSound ):void
		{
			if( beatSound.intensity > 0 ){
				_actualRadius = _standRadius + (_pulseRadius - _standRadius)*beatSound.intensity;
				
				TweenLite.to(this, Heart.instance.beatTime/1000*beatSound.duration, { _actualRadius:_standRadius, ease:Sine.easeOut } );
			}
		}
		
		public function get standRadius():Number
		{
			return _standRadius;
		}
		
		public function get pulseRadius():Number
		{
			return _pulseRadius;
		}
		
		//update
		private function onUpdate(e:Event):void
		{
			updateBody();
			updateSprite();
		}
	}
}