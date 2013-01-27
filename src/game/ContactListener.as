package game
{
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	
	public class ContactListener extends b2ContactListener
	{
		override public function BeginContact(contact:b2Contact):void
		{	
			var userDataA:* = contact.GetFixtureA().GetBody().GetUserData();
			var userDataB:* = contact.GetFixtureB().GetBody().GetUserData();
			
			if( userDataA is Hero && userDataB is CoreBall ){
				
				if( !Hero(userDataA).moving ){
					Hero(userDataA).brake();
				}
			} else if( userDataB is Hero && userDataA is CoreBall ) {
				if( !Hero(userDataB).moving ){
					Hero(userDataB).brake();
				}
			}
			
		}
	}
}