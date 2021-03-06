package collaboRhythm.hiviva.global
{
	import starling.events.Event;


	public class FeathersScreenEvent extends Event
	{

		public static const NAVIGATE_AWAY:String						= "navigateAway";
		public static const HIDE_MAIN_NAV:String						= "hideMainNav";
		public static const SHOW_MAIN_NAV:String						= "showMainNav";
		public static const PATIENT_PROFILE_SELECTED:String				= "patientProfileSelected";
		//public static const PATIENT_EDIT_MEDICINE_CELL:String			= "patientEditMedicineCell";
		public static const CALENDAR_BUTTON_TRIGGERED:String			= "calendarButtonTriggered";
		public static const SETTING_SCREEN_FROM_HOME:String				= "settingScreenFromHome";
		public static const MEDICATION_RADIO_TRIGGERED:String			= "medicationRadioTriggered";
		public static const MEDICATION_DELETE_TRIGGERED:String			= "medicationDeleteTriggered";
		public static const PRELOADER_ONPOGRESS:String					= "onProgress";
		public static const PRELOADER_ON_COMPLETE:String	            = "onComplete";
		public static const SHOW_SETTINGS_ANIMATION:String				= "showSettingsAnimation";

		public static const MESSAGE_READ:String							= "messageRead";
		public static const MESSAGE_SELECT:String						= "messageSelect";


		public var message:String;
		public var evtData:Object =  {};


		public function FeathersScreenEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
