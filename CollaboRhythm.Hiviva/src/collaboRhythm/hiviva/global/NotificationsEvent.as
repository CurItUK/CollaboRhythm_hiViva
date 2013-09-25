package collaboRhythm.hiviva.global
{
	import flash.events.Event;

	public class NotificationsEvent extends Event
	{

		public static const HOMEPAGE_TICK_COMPLETE:String			= "homepageTickComplete";
		public static const GLOBAL_TICK:String						= "globalTick";
		public static const UPDATE_DAILY_VO_DATA:String				= "updateDailyVOData";
		public static const APPLICATION_ACTIVATE:String				= "applicationActivate";
		public static const APPLICATION_DEACTIVATE:String			= "applicationDeactivate";
		public static const ACTIAVTE_PASSCODE:String				= "applicationDeactivate";



		public function NotificationsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
