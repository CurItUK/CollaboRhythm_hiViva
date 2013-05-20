package collaboRhythm.hiviva.global
{
	import flash.events.Event;

	public class LocalDataStoreEvent extends Event
	{
		public static const DATA_LOAD_COMPLETE:String						= "dataLoadComplete";
		public static const DATA_LOAD_UPDATE:String							= "dataLoadUpdate";

		public static const PROFILE_TYPE_UPDATE:String						= "profileTypeUpdate";
		public static const MEDICATIONS_LOAD_COMPLETE:String				= "medicationsLoadComplete";
		public static const MEDICATIONS_SAVE_COMPLETE:String				= "medicationsSaveComplete";
		public static const MEDICATIONS_DELETE_COMPLETE:String				= "medicationsDeleteComplete";
		public static const ADHERENCE_LOAD_COMPLETE:String					= "adherenceLoadComplete";
		public static const ADHERENCE_SAVE_COMPLETE:String					= "adherenceSaveComplete";
		public static const MEDICATIONS_SCHEDULE_LOAD_COMPLETE:String		= "medicationsScheduleLoadComplete";

		public var message:String;

		public var data:Object = new Object();

		public function LocalDataStoreEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
