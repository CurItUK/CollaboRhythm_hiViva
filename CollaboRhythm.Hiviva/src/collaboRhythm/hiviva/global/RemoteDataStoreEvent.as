package collaboRhythm.hiviva.global
{
	import flash.events.Event;

	public class RemoteDataStoreEvent extends Event
	{

		public static const DATA_LOAD_COMPLETE:String							= "dataLoadComplete";


		public var message:String;

		public var data:Object = new Object();



		public function RemoteDataStoreEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
