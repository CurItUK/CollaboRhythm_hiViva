package collaboRhythm.hiviva.global
{
	import flash.events.Event;

	public class LocalDataStoreEvent extends Event
	{
		public static const DATA_LOAD_COMPLETE:String						= "dataLoadComplete";
		public static const DATA_LOAD_UPDATE:String							= "dataLoadUpdate";

		public static const PROFILE_TYPE_UPDATE:String						= "profileTypeUpdate";

		public var message:String;

		public var data:String;

		public function LocalDataStoreEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
