package game
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Hero extends Sprite
	{
		public const HERO_RADIUS:Number = 13;
		
		public function Hero( position:Point, world:b2World )
		{
			_position = position;
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
		
		//update
		private function onUpdate(e:Event):void
		{
			updateBody();
			updateSprite();
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
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.userData = this;
			bodyDef.bullet = true;
			var bodyShape:b2CircleShape = new b2CircleShape(HERO_RADIUS/LevelBase.WORLD_SCALE);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = bodyShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.3;
			fixtureDef.friction = 1;
			_body = _world.CreateBody(bodyDef);
			_body.CreateFixture(fixtureDef);
		}
		
		private function updateBody():void
		{
			_body.GetFixtureList().GetShape().Set( new b2CircleShape( HERO_RADIUS/LevelBase.WORLD_SCALE ) );
		}
		
		private function destroyBody():void
		{
			_world.DestroyBody(_body);
		}
		
		//sprite
		private var _sprite:Sprite;
		private var _shape:Shape;
		
		[Embed(source="assets/char.png")]
		public var CharactedBitmap:Class;
		
		private function setupSprite():void
		{
			_sprite = new Sprite();
			addChild(_sprite);
			
			var image:Image = new Image( Texture.fromBitmap( new CharactedBitmap() ) );
			image.width = HERO_RADIUS*2;
			image.height = HERO_RADIUS*2;
			image.x = - image.width/2;
			image.y = - image.height/2;
			_sprite.addChild( image );
			
			/*
			_shape = new Shape();
			_shape.graphics.beginFill( 0x0000ff );
			_shape.graphics.drawCircle(0,0,HERO_RADIUS);
			_shape.graphics.endFill();
			
			_sprite.addChild(_shape);
			*/
		}
		
		private function updateSprite():void
		{
			/*
			_shape.graphics.clear();
			_shape.graphics.beginFill( 0xFF0000, 1 );
			_shape.graphics.drawCircle(0,0,HERO_RADIUS);
			_shape.graphics.endFill();
			*/
		}
		
		private function destroySprite():void
		{
			/*
			_sprite.removeChild(_shape);
			_shape = null;
			*/
			
			removeChild(_sprite);
			_sprite = null;
		}
		
		//control
		public var moving:Boolean;
		
		public function left( center:Point ):void
		{
			var distance:b2Vec2 = _body.GetPosition().Copy();
			distance.Subtract(new b2Vec2( center.x, center.y ) );
			
			var perpendicular:b2Vec2 = new b2Vec2( -distance.y, distance.x );
			perpendicular.Multiply(.5);
			perpendicular.NegativeSelf();
			
			_body.ApplyForce( perpendicular, _body.GetWorldCenter() );
			
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			var velocityLength:Number = velocity.Length();
			
			if( velocityLength > 13 ){
				velocity.Multiply(13/velocityLength);
				_body.SetLinearVelocity( velocity );
			}
		}
		
		public function right( center:Point ):void
		{
			var distance:b2Vec2 = _body.GetPosition().Copy();
			distance.Subtract(new b2Vec2( center.x, center.y ) );
			
			var perpendicular:b2Vec2 = new b2Vec2( -distance.y, distance.x );
			perpendicular.Multiply(.5);
			
			_body.ApplyForce( perpendicular, _body.GetWorldCenter() );
			
			var velocity:b2Vec2 = _body.GetLinearVelocity();
			var velocityLength:Number = velocity.Length();
			
			if( velocityLength > 13 ){
				velocity.Multiply(13/velocityLength);
				_body.SetLinearVelocity( velocity );
			}
		}
		
		public function impulseLeft( center:Point ):void
		{
			var distance:b2Vec2 = _body.GetPosition().Copy();
			distance.Subtract(new b2Vec2( center.x, center.y ) );
			
			var perpendicular:b2Vec2 = new b2Vec2( -distance.y, distance.x );
			perpendicular.Multiply(.5);
			perpendicular.NegativeSelf();
			
			_body.ApplyImpulse( perpendicular, _body.GetWorldCenter() );
		}
		
		public function impulseRight( center:Point ):void
		{
			var distance:b2Vec2 = _body.GetPosition().Copy();
			distance.Subtract(new b2Vec2( center.x, center.y ) );
			
			var perpendicular:b2Vec2 = new b2Vec2( -distance.y, distance.x );
			perpendicular.Multiply(.5);
			
			_body.ApplyImpulse( perpendicular, _body.GetWorldCenter() );
		}
		
		public function impulseJump( velocity:b2Vec2 ):void
		{
			_body.ApplyImpulse( velocity, _body.GetWorldCenter() );
		}
		
		public function brake():void
		{
			_body.SetLinearVelocity( new b2Vec2( _body.GetLinearVelocity().x*.8, _body.GetLinearVelocity().y*.7 ) );
		}
	}
}