package collaboRhythm.hiviva.global
{
	import flash.events.Event;

	public class RXNORMEvent extends Event
	{
		public static const DATA_LOAD_COMPLETE:String						= "dataLoadComplete";

		public var data:Object = new Object();

		public function RXNORMEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
