package collaboRhythm.hiviva.global
{
	public class RemoteServiceAPI
	{
		//Users
		public static const RS_CREATE_USER:String = 								"WSHealthUser.svc/createuser?type=";
		public static const RS_GET_SERVER_DATE:String = 							"WSHealthUser.svc/CurrentDateTime";

		//Medications
		public static const RS_ADD_MEDICATION:String = 								"WSUserMedication.svc/AddUserMedication?";
		public static const RS_DELETE_MEDICATION:String = 							"WSUserMedication.svc/DeleteUserMedication?";
		public static const RS_GET_PATIENT_MEDICATION:String = 						"WSUserMedication.svc/GetUserMedication?";
		public static const RS_TAKE_PATIENT_MEDICATION:String = 					"WSUserMedication.svc/TookMedication?";
		public static const RS_GET_NUMBER_DAYS_ADHERENCE:String = 					"WSUserMedication.svc/GetNumberDaysAdherence?";
		public static const RS_GET_USER_MEDICATION_HISTORY:String = 				"WSUserMedication.svc/GetHistoryUserMedicationTaken?";
		public static const RS_GET_DAILY_MEDICATION_HISTORY:String = 				"WSUserMedication.svc/GetDailyHistoryOfMedicationTaken?";
		public static const RS_GET_DAILY_MEDICATION_HISTORY_RANGE:String = 			"WSUserMedication.svc/GetDailyMedicationTakenBetweenDates?";
		public static const RS_GET_WEEKLY_MEDICATION_HISTORY:String = 				"WSUserMedication.svc/GetWeeklyHistoryOfMedicationTaken?";
		public static const RS_GET_ALL_WEEKLY_MEDICATION_HISTORY:String = 			"WSUserMedication.svc/GetAllUsersWeeklyMedication?";

		//Messaging
		public static const RS_GET_MESSAGES:String = 								"WSMessage.svc/GetMessages";
		public static const RS_GET_HCP_SENT_MESSAGES:String = 						"WSMessage.svc/GetAllSentMessages?";
		public static const RS_GET_USER_RECEIVED_MESSAGES:String =	 				"WSMessage.svc/GetAllReceivedMessages?";
		public static const RS_SEND_USER_MESSAGE:String = 							"WSMessage.svc/SendMessage?";
		public static const RS_DELETE_USER_MESSAGE:String = 						"WSMessage.svc/DeleteMessage?";
		public static const RS_MARK_MESSAGE_AS_READ:String = 						"WSMessage.svc/MarkMessageAsRead?";
		public static const RS_GET_PATIENT_BADGE_ALERTS:String = 					"WSMessage.svc/GetUserAlertMessages?";
		public static const RS_MARK_ALERT_MESSAGE_AS_READ:String = 					"WSMessage.svc/MarkAlertMessageAsRead?";
		public static const RS_GET_HCP_ALERTS:String = 								"WSMessage.svc/GetAllAlertMessages?";

		//Connections
		public static const RS_GET_PATIENT:String = 								"WSHealthUser.svc/GetPatient?";
		public static const RS_GET_HCP:String = 									"WSHealthUser.svc/GetHcp?";
		public static const RS_CONNECTION_ESTABLISH:String = 						"WSConnection.svc/Establish?";
		public static const RS_GET_APPROVED_CONNECTIONS:String = 					"WSConnection.svc/GetApprovedConnections?";
		public static const RS_GET_APPROVED_CONNECTIONS_WITH_SUMMARY:String = 		"WSConnection.svc/GetApprovedConnectionsWithSummary?";
		public static const RS_CONNECTION_APPROVE:String = 							"WSConnection.svc/Approve?";
		public static const RS_CONNECTION_DELETE:String = 							"WSConnection.svc/Delete?";
		public static const RS_CONNECTION_IGNORE:String = 							"WSConnection.svc/Ignore?";
		public static const RS_GET_PENDING_CONNECTIONS:String = 					"WSConnection.svc/GetPendingConnections?";

		//Test results
		public static const RS_ADD_TEST_RESULTS:String = 							"WSTestResults.svc/AddTestResults?";
		public static const RS_GET_PATIENT_LATEST_RESULTS:String = 					"WSTestResults.svc/GetLatestUserTestResults?";
		public static const RS_GET_PATIENT_ALL_RESULTS:String = 					"WSTestResults.svc/GetAllUserResults?";
		public static const RS_GET_PATIENT_RESULTS_RANGE:String = 					"WSTestResults.svc/GetUserTestResultsBetweenDates?";

		//HCP Display Settings
		public static const RS_GET_DISPLAY_SETTINGS:String = 						"WSHealthUser.svc/GetUserSettings?";
		public static const RS_ADD_DISPLAY_SETTINGS:String = 						"WSHealthUser.svc/AddUserSettings?";

		//HCP Alert Settings
		public static const RS_GET_ALERT_SETTINGS:String = 							"WSHealthUser.svc/GetUserAlerts?";
		public static const RS_ADD_ALERT_SETTINGS:String = 							"WSHealthUser.svc/AddUserAlerts?";


	}
}
