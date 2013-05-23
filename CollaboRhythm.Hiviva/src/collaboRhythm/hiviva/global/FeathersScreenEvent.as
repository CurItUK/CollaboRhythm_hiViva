package collaboRhythm.hiviva.global
{
	import starling.events.Event;


	public class FeathersScreenEvent extends Event
	{

		public static const NAVIGATE_AWAY:String						= "navigateAway";
		public static const HIDE_MAIN_NAV:String						= "hideMainNav";
		public static const SHOW_MAIN_NAV:String						= "showMainNav";

		public var message:String;


		public function FeathersScreenEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
