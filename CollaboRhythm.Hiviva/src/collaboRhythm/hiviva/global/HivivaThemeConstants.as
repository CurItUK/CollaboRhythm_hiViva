package collaboRhythm.hiviva.global
{
	public class HivivaThemeConstants
	{
		// ttf fonts

		[Embed(source="/assets/fonts/exo-regular.ttf", fontName="ExoRegular", mimeType="application/x-font", embedAsCFF="false")]
		public static const ExoRegularFont:Class;

		[Embed(source="/assets/fonts/exo-bold.ttf", fontName="ExoBold", mimeType="application/x-font", embedAsCFF="false")]
		public static const ExoBoldFont:Class;

		[Embed(source="/assets/fonts/exo-light.ttf", fontName="ExoLight", mimeType="application/x-font", embedAsCFF="false")]
		public static const ExoLightFont:Class;

		// colours (not to be used with bitmap fonts with effects applied!)

		public static const DARK_FONT_COLOUR:uint					= 0x293d54;
		public static const MEDIUM_FONT_COLOUR:uint					= 0x495c72;
		public static const LIGHT_FONT_COLOUR:uint					= 0x607895;
		public static const LIGHTER_FONT_COLOUR:uint				= 0xb9c4cd;
		public static const LIGHTEST_FONT_COLOUR:uint				= 0xdee4e9;

		// labels style names

		public static const BODY_CENTERED_LABEL:String				= "body-centered-label";
		public static const BODY_BOLD_LABEL:String					= "body-bold-label";
		public static const BODY_BOLD_CENTERED_LABEL:String			= "body-bold-centered-label";
		public static const SUBHEADER_LABEL:String					= "subheader-label";
		public static const INPUT_LABEL_LEFT:String					= "input-label-left";
		public static const INPUT_LABEL_RIGHT:String				= "input-label-right";
		public static const HOME_LENS_LABEL:String					= "home-lens-label";
		public static const VALIDATION_LABEL:String					= "validation-label";
		public static const MEDICINE_BRANDNAME_LABEL:String			= "medicine-brandname-label";
		public static const SPLASH_FOOTER_LABEL:String				= "splash-footer-label";
		public static const CALENDAR_MONTH_LABEL:String				= "calender-month-label";
		public static const CALENDAR_DAYS_LABEL:String				= "calendar-days-label";
		public static const FEELING_SLIDER_LABEL:String				= "feeling-slider-label";
		public static const APPID_LABEL:String						= "appid-label";
		public static const INSTRUCTIONS_LABEL:String				= "instructions-label";
		public static const SUPERSCRIPT_LABEL:String				= "superscript-label";
		public static const CELL_SMALL_LABEL:String					= "cell-small-label";
		public static const CELL_SMALL_BOLD_LABEL:String			= "cell-small-bold-label";
		public static const PATIENT_DATA_LIGHTER_LABEL:String		= "patient-data-lighter-label";

		// UI Objects style names

		public static const BORDER_BUTTON:String					= "border-button";
		public static const HOME_BUTTON:String						= "home-button";
		public static const SPLASH_HCP_BUTTON:String				= "splash-hcp-button";
		public static const SPLASH_PATIENT_BUTTON:String			= "splash-patient-button";
		public static const SPLASH_FOOTER_BUTTON:String				= "splash-footer-button";
		public static const BACK_BUTTON:String						= "back-button";
		public static const CLOSE_BUTTON:String						= "close-button";
		public static const DELETE_CELL_BUTTON:String				= "delete-cell-button";
		public static const EDIT_CELL_BUTTON:String					= "edit-cell-button";
		public static const CALENDAR_BUTTON:String					= "calendar-button";
		public static const CALENDAR_DAY_CELL:String				= "calendar-day-cell";
		public static const CALENDAR_ARROWS:String					= "calendar-arrows";
	}
}
