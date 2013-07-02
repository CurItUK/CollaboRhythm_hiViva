package collaboRhythm.hiviva.global
{
	import flash.events.Event;

	public class RemoteDataStoreEvent extends Event
	{


		public static const CREATE_USER_COMPLETE:String							= "createUserComplete";
		public static const GET_HCP_COMPLETE:String								= "getHCPComplete";
		public static const ADD_MEDICATION_COMPLETE:String						= "addMedicationComplete";
		public static const GET_PATIENT_MEDICATION_COMPLETE:String				= "getPatientMedicationComplete";



		public var message:String;

		public var data:Object = new Object();



		public function RemoteDataStoreEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}


