package collaboRhythm.hiviva.global
{
	import flash.events.Event;

	public class LocalDataStoreEvent extends Event
	{
		public static const APP_ID_SAVE_COMPLETE:String							= "appIdSaveComplete";
		public static const APP_ID_LOAD_COMPLETE:String							= "appIdLoadComplete";
		public static const GALLERY_TIMESTAMP_LOAD_COMPLETE:String				= "galleryTimeStampLoadComplete";
		public static const GALLERY_TIMESTAMP_SAVE_COMPLETE:String				= "galleryTimeStampSaveComplete";
		public static const GALLERY_IMAGES_LOAD_COMPLETE:String					= "galleryImagesLoadComplete";
		public static const GALLERY_IMAGES_SAVE_COMPLETE:String					= "galleryImagesSaveComplete";
		public static const MEDICATIONS_LOAD_COMPLETE:String					= "medicationsLoadComplete";
		public static const MEDICATIONS_SAVE_COMPLETE:String					= "medicationsSaveComplete";
		public static const MEDICATIONS_DELETE_COMPLETE:String					= "medicationsDeleteComplete";
		public static const ADHERENCE_LOAD_COMPLETE:String						= "adherenceLoadComplete";
		public static const ADHERENCE_SAVE_COMPLETE:String						= "adherenceSaveComplete";
		public static const TEST_RESULTS_LOAD_COMPLETE:String					= "testResultsLoadComplete";
		public static const TEST_RESULTS_SAVE_COMPLETE:String					= "testResultsSaveComplete";
		public static const MEDICATIONS_SCHEDULE_LOAD_COMPLETE:String			= "medicationsScheduleLoadComplete";
		public static const PATIENT_PROFILE_LOAD_COMPLETE:String				= "patientProfileLoadComplete";
		public static const PATIENT_PROFILE_SAVE_COMPLETE:String				= "patientProfileSaveComplete";

		public static const HCP_PROFILE_LOAD_COMPLETE:String					= "hcpProfileLoadComplete";
		public static const HCP_PROFILE_SAVE_COMPLETE:String					= "hcpProfileSaveComplete";
		public static const HCP_DISPLAY_SETTINGS_SAVE_COMPLETE:String			= "hcpDisplaySettingsSaveComplete";
		public static const HCP_DISPLAY_SETTINGS_LOAD_COMPLETE:String			= "hcpDisplaySettingsLoadComplete";
		public static const HCP_ALERT_SETTINGS_SAVE_COMPLETE:String				= "hcpAlertSettingsSaveComplete";
		public static const HCP_ALERT_SETTINGS_LOAD_COMPLETE:String				= "hcpAlertSettingsLoadComplete";
		public static const HCP_CONNECTIONS_LOAD_COMPLETE:String				= "hcpConnectionsLoadComplete";
		public static const HCP_CONNECTION_SAVE_COMPLETE:String					= "hcpConnectionsSaveComplete";
		public static const HCP_CONNECTION_DELETE_COMPLETE :String				= "hcpConnectionDeleteComplete";

		public static const PATIENT_CONNECTIONS_LOAD_COMPLETE:String			= "patientConnectionsLoadComplete";
		public static const PATIENT_CONNECTION_SAVE_COMPLETE:String				= "patientConnectionsSaveComplete";
		public static const PATIENT_CONNECTION_DELETE_COMPLETE :String			= "patientConnectionDeleteComplete";
		public static const PATIENT_MESSAGES_VIEWED_LOAD_COMPLETE :String		= "patientMessagesViewedLoadComplete";
		public static const PATIENT_MESSAGES_VIEWED_SAVE_COMPLETE :String		= "patientMessagesViewedSaveComplete";

		public static const PATIENT_LOAD_KUDOS_COMPLETE :String					= "patientLoadKudosComplete";
		public static const PATIENT_SAVE_KUDOS_COMPLETE :String					= "patientLoadSaveComplete";
		public static const PATIENT_LOAD_BADGES_COMPLETE :String				= "patientLoadBadgesComplete";



		public static const APPLICATION_RESET_COMPLETE :String					= "applicationResetComplete";
		public static const VIEWED_SETTINGS_ANIMATION_LOAD_COMPLETE :String		= "viewedSettingsAnimationLoadComplete";
		public static const VIEWED_SETTINGS_ANIMATION_SAVE_COMPLETE :String		= "viewedSettingsAnimationSaveComplete";
		public static const PASSCODE_TOGGLE_COMPLETE :String					= "passcodeToggleComplete";
		public static const PASSCODE_SAVE_DETAILS_COMPLETE :String				= "passcodeSaveDetailsComplete";


		public var message:String;

		public var data:Object = new Object();

		public function LocalDataStoreEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
