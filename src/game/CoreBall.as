package game
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class CoreBall extends Sprite
	{
		private var _body:b2Body;
		
		public function CoreBall()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		//added to and removed from stage
		private function onAddedToStage():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			setupBody();
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			destroyBody();
			
			removeEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		private function setupBody():void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(pX/WORLD_SCALE, pY/WORLD_SCALE);
			bodyDef.type = b2Body.b2_kinematicBody;
			bodyDef.userData = "circleCore";
			var ballShape:b2CircleShape = new b2CircleShape(coreRadius/WORLD_SCALE);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = ballShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.3;
			fixtureDef.friction = 5;
			var theBall:b2Body = world.CreateBody(bodyDef);
			theBall.CreateFixture(fixtureDef);
			
			core = theBall;
		}
		
		private function destroyBody():void
		{
			
		}
		
		//update
		private function onUpdate(e:Event):void
		{
			
		}
	}
}