package game
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class LevelBase extends Sprite
	{
		private static const WORLD_SCALE:uint = 30;
		
		private var _world:b2World;
		
		public function LevelBase()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		//added to and removed from stage
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			setupWorld();
			setupDebugDraw();
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			destroyDebugDraw();
			destroyWorld();
			
			removeEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		//setup
		private function setupWorld():void
		{
			_world = new b2World( new b2Vec2(0,0), false );
		}
		
		private function destroyWorld():void
		{
			
		}
		
		private function setupDebugDraw():void
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(Startup.debugSprite);
			debugDraw.SetDrawScale(WORLD_SCALE);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit |b2DebugDraw.e_jointBit);
			debugDraw.SetFillAlpha(0.5);
			_world.SetDebugDraw(debugDraw);
		}
		
		private function destroyDebugDraw():void
		{
			
		}
		
		//update
		private function onUpdate(e:Event):void
		{
			updateWorld();
		}
		
		private function updateWorld():void
		{
			_world.Step(1/60,10,10);
			
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
	}
}