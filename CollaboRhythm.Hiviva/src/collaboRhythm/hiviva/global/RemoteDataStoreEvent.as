package collaboRhythm.hiviva.global
{
	import flash.events.Event;

	public class RemoteDataStoreEvent extends Event
	{

		//Users
		public static const CREATE_USER_COMPLETE:String									= "createUserComplete";
		public static const GET_SERVER_DATE_COMPLETE:String								= "getServerDateComplete";

		//medications
		public static const ADD_MEDICATION_COMPLETE:String								= "addMedicationComplete";
		public static const DELETE_PATIENT_MEDICATION_COMPLETE:String					= "deletePatientMedicationComplete";
		public static const GET_PATIENT_MEDICATION_COMPLETE:String						= "getPatientMedicationComplete";
		public static const TAKE_PATIENT_MEDICATION_COMPLETE:String						= "takePatientMedicationComplete";
		public static const GET_USER_MEDICATION_HISTORY_COMPLETE:String					= "getUserMedicationHistoryComplete";
		public static const GET_DAILY_MEDICATION_HISTORY_COMPLETE:String				= "getDailyMedicationHistoryComplete";
		public static const GET_WEEKLY_MEDICATION_HISTORY_COMPLETE:String				= "getWeeklyMedicationHistoryComplete";

		//Messaging
		public static const GET_MESSAGES_COMPLETE:String								= "getMessagesComplete";
		public static const GET_HCP_SENT_MESSAGES_COMPLETE:String						= "getHCPSentMessagesComplete";
		public static const GET_USER_RECEIVED_MESSAGES_COMPLETE:String					= "getUserReceivedMessagesComplete";
		public static const SEND_USER_MESSAGE_COMPLETE:String							= "sendUserMessageComplete";
		public static const DELETE_USER_MESSAGE_COMPLETE:String							= "deleteUserMessageComplete";
		public static const MARK_MESSAGE_AS_READ_COMPLETE:String						= "markMessageAsReadComplete";

		//Connections
		public static const GET_HCP_COMPLETE:String										= "getHCPComplete";
		public static const GET_PATIENT_COMPLETE:String									= "getPatientComplete";
		public static const ESTABLISH_CONNECTION_COMPLETE:String						= "establishConnectionComplete";
		public static const GET_APPROVED_CONNECTIONS_COMPLETE:String					= "getApprovedConnectionsComplete";
		public static const GET_APPROVED_CONNECTIONS_WITH_SUMMARY_COMPLETE:String		= "getApprovedConnectionsWithSummaryComplete";
		public static const GET_PENDING_CONNECTIONS_COMPLETE:String						= "getPendingConnectionsComplete";
		public static const CONNECTION_APPROVE_COMPLETE:String							= "connectionApproveComplete";
		public static const CONNECTION_DELETE_COMPLETE:String							= "connectionDeleteComplete";

		//Test results
		public static const ADD_TEST_RESULTS_COMPLETE:String							= "addTestResultsComplete";
		public static const GET_PATIENT_LATEST_RESULTS_COMPLETE:String					= "getPatientLatestResultsComplete";
		public static const GET_PATIENT_ALL_RESULTS_COMPLETE:String						= "getPatientAllResultsComplete";

		//display Settings
		public static const GET_DISPLAY_SETTINGS_COMPLETE:String						= "getDisplaySettingsComplete";
		public static const ADD_DISPLAY_SETTINGS_COMPLETE:String						= "addDisplaySettingsComplete";

		//alertSettings
		public static const GET_ALERT_SETTINGS_COMPLETE:String							= "getAlertSettingsComplete";
		public static const ADD_ALERT_SETTINGS_COMPLETE:String							= "addAlertSettingsComplete";



		public var message:String;
		public var data:Object = new Object();

		public function RemoteDataStoreEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}


