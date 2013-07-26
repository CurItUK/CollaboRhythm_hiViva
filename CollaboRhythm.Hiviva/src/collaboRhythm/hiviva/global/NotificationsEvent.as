package collaboRhythm.hiviva.global
{
	import flash.events.Event;

	public class NotificationsEvent extends Event
	{

		public static const HOMEPAGE_TICK_COMPLETE:String			= "homepageTickComplete";
		public static const GLOBAL_TICK:String						= "globalTick";



		public function NotificationsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
