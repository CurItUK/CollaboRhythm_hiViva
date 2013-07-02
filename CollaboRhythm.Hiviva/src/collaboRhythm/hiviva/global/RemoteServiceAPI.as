package collaboRhythm.hiviva.global
{
	public class RemoteServiceAPI
	{
		public static const RS_CREATE_USER:String = 					"WSHealthUser.svc/createuser?type=";
		public static const RS_GET_PATIENT:String = 					"WSHealthUser.svc/WSHealthUser.svc/GetPatient?AppId=";
		public static const RS_GET_HCP:String = 						"WSHealthUser.svc/GetHcp?AppId=";
		public static const RS_ADD_MEDICATION:String = 					"WSUserMedication.svc/AddUserMedication?";
		public static const RS_GET_PATIENT_MEDICATION:String = 			"WSUserMedication.svc/GetUserMedicaton?";

		//Connections
		public static const RS_CONNECTION_ESTABLISH:String = 			"WSConnection.svc/Establish?";
		public static const RS_CONNECTION_APPROVE:String = 				"WSConnection.svc/Approve?";
		public static const RS_CONNECTION_IGNORE:String = 				"WSConnection.svc/Ignore?";

	}
}
