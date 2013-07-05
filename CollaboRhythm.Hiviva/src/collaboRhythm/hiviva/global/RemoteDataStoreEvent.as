package collaboRhythm.hiviva.global
{
	import flash.events.Event;

	public class RemoteDataStoreEvent extends Event
	{


		public static const CREATE_USER_COMPLETE:String							= "createUserComplete";
		public static const GET_HCP_COMPLETE:String								= "getHCPComplete";
		public static const GET_PATIENT_COMPLETE:String							= "getPatientComplete";
		public static const ADD_MEDICATION_COMPLETE:String						= "addMedicationComplete";
		public static const GET_PATIENT_MEDICATION_COMPLETE:String				= "getPatientMedicationComplete";
		public static const GET_MESSAGES_COMPLETE:String						= "getMessagesComplete";
		public static const GET_HCP_SENT_MESSAGES_COMPLETE:String				= "getHCPSentMessagesComplete";
		public static const GET_USER_RECEIVED_MESSAGES_COMPLETE:String			= "getUserReceivedMessagesComplete";
		public static const SEND_USER_MESSAGE_COMPLETE:String					= "sendUserMessageComplete";
		public static const DELETE_USER_MESSAGE_COMPLETE:String					= "deleteUserMessageComplete";
		public static const ESTABLISH_CONNECTION_COMPLETE:String				= "establishConnectionComplete";

		public static const GET_APPROVED_CONNECTIONS_COMPLETE:String			= "getApprovedConnectionsComplete";
		public static const GET_PENDING_CONNECTIONS_COMPLETE:String				= "getPendingConnectionsComplete";




		public var message:String;

		public var data:Object = new Object();



		public function RemoteDataStoreEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}


