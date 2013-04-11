package collaboRhythm.hiviva.global
{
	import starling.events.Event;


	public class FeathersScreenEvent extends Event
	{

		public static const NAVIGATE_AWAY:String						= "navigateAway";

		public var message:String;


		public function FeathersScreenEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
