package collaboRhythm.hiviva.global
{
	public class RemoteServiceAPI
	{
		//Users
		public static const RS_CREATE_USER:String = 					"WSHealthUser.svc/createuser?type=";

		//medications
		public static const RS_ADD_MEDICATION:String = 					"WSUserMedication.svc/AddUserMedication?";
		public static const RS_DELETE_MEDICATION:String = 				"WSUserMedication.svc/DeleteUserMedication?";
		public static const RS_GET_PATIENT_MEDICATION:String = 			"WSUserMedication.svc/GetUserMedicaton?";
		public static const RS_TAKE_PATIENT_MEDICATION:String = 		"WSUserMedication.svc/TookMedication?";

		//messaging
		public static const RS_GET_MESSAGES:String = 					"WSMessage.svc/GetMessages";
		public static const RS_GET_HCP_SENT_MESSAGES:String = 			"WSMessage.svc/GetAllSentMessages?";
		public static const RS_GET_USER_RECEIVED_MESSAGES:String = 		"WSMessage.svc/GetAllReceivedMessages?";
		public static const RS_SEND_USER_MESSAGE:String = 				"WSMessage.svc/SendMessage?";
		public static const RS_DELETE_USER_MESSAGE:String = 			"WSMessage.svc/DeleteMessage?";

		//Connections
		public static const RS_GET_PATIENT:String = 					"WSHealthUser.svc/GetPatient?";
		public static const RS_GET_HCP:String = 						"WSHealthUser.svc/GetHcp?";
		public static const RS_CONNECTION_ESTABLISH:String = 			"WSConnection.svc/Establish?";
		public static const RS_GET_APPROVED_CONNECTIONS:String = 		"WSConnection.svc/GetApprovedConnections?";
		public static const RS_CONNECTION_APPROVE:String = 				"WSConnection.svc/Approve?";
		public static const RS_CONNECTION_IGNORE:String = 				"WSConnection.svc/Ignore?";
		public static const RS_GET_PENDING_CONNECTIONS:String = 		"WSConnection.svc/GetPendingConnections?";

	}
}
