package collaboRhythm.hiviva.global
{
	import flash.events.Event;

	public class RemoteDataStoreEvent extends Event
	{

		//Users
		public static const CREATE_USER_COMPLETE:String							= "createUserComplete";

		//medications
		public static const ADD_MEDICATION_COMPLETE:String						= "addMedicationComplete";
		public static const DELETE_PATIENT_MEDICATION_COMPLETE:String			= "deletePatientMedicationComplete";
		public static const GET_PATIENT_MEDICATION_COMPLETE:String				= "getPatientMedicationComplete";

		//Messaging
		public static const GET_MESSAGES_COMPLETE:String						= "getMessagesComplete";
		public static const GET_HCP_SENT_MESSAGES_COMPLETE:String				= "getHCPSentMessagesComplete";
		public static const GET_USER_RECEIVED_MESSAGES_COMPLETE:String			= "getUserReceivedMessagesComplete";
		public static const SEND_USER_MESSAGE_COMPLETE:String					= "sendUserMessageComplete";
		public static const DELETE_USER_MESSAGE_COMPLETE:String					= "deleteUserMessageComplete";

		//Connections
		public static const GET_HCP_COMPLETE:String								= "getHCPComplete";
		public static const GET_PATIENT_COMPLETE:String							= "getPatientComplete";
		public static const ESTABLISH_CONNECTION_COMPLETE:String				= "establishConnectionComplete";
		public static const GET_APPROVED_CONNECTIONS_COMPLETE:String			= "getApprovedConnectionsComplete";
		public static const GET_PENDING_CONNECTIONS_COMPLETE:String				= "getPendingConnectionsComplete";
		public static const CONNECTION_APPROVE_COMPLETE:String					= "connectionApproveComplete";




		public var message:String;

		public var data:Object = new Object();



		public function RemoteDataStoreEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}


