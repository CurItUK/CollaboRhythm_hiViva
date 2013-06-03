package collaboRhythm.hiviva.view.media
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	import starling.textures.Texture;

	public class Assets
	{

		// the following assets are individual image files but need to compiled into atlases

		// BACKGROUND ASSETS

		[Embed(source="/assets/images/temp/splash_bg.jpg")]
		public static const SplashScreenBgJpg:Class;

		[Embed(source="/assets/images/temp/logo.png")]
		public static const LogoPng:Class;

		[Embed(source="/assets/images/temp/splash_button_01.png")]
		public static const SplashButtonPatientPng:Class;

		[Embed(source="/assets/images/temp/splash_button_02.png")]
		public static const SplashButtonHcpPng:Class;

		[Embed(source="/assets/images/temp/fixed_base.png")]
		public static const FixedBasePng:Class;

		[Embed(source="/assets/images/temp/settings_above_effect.png")]
		public static const SettingEffectPng:Class;


		[Embed(source="/assets/images/temp/screen_base.png")]
		public static const BasePng:Class;

		[Embed(source="/assets/images/temp/bottom_gradient.png")]
		public static const BaseBottomGradPng:Class;

		[Embed(source="/assets/images/temp/top_gradient.png")]
		public static const BaseTopGradPng:Class;

		// ICONS AND BUTTONS

		[Embed(source="/assets/images/temp/footer_icon_base.png")]
		public static const FooterIconBasePng:Class;

		[Embed(source="/assets/images/temp/footer_icon_active.png")]
		public static const FooterIconActivePng:Class;

		[Embed(source="/assets/images/temp/footer_icon_1.png")]
		public static const FooterIconHomePng:Class;

		[Embed(source="/assets/images/temp/footer_icon_2.png")]
		public static const FooterIconClockPng:Class;

		[Embed(source="/assets/images/temp/footer_icon_3.png")]
		public static const FooterIconMedicPng:Class;

		[Embed(source="/assets/images/temp/footer_icon_4.png")]
		public static const FooterIconVirusPng:Class;

		[Embed(source="/assets/images/temp/footer_icon_5.png")]
		public static const FooterIconReportPng:Class;

		[Embed(source="/assets/images/temp/side_nav_base.png")]
		public static const SideNavBasePng:Class;

		[Embed(source="/assets/images/temp/side_nav_icon_01.png")]
		public static const SideNavIconProfilePng:Class;

		[Embed(source="/assets/images/temp/side_nav_icon_02.png")]
		public static const SideNavIconHelpPng:Class;

		[Embed(source="/assets/images/temp/side_nav_icon_03.png")]
		public static const SideNavIconMessagesPng:Class;

		[Embed(source="/assets/images/temp/side_nav_icon_04.png")]
		public static const SideNavIconBadgesPng:Class;

		[Embed(source="/assets/images/temp/top_nav_icon_01.png")]
		public static const SettingIconPng:Class;

		[Embed(source="/assets/images/temp/icon_art.png")]
		public static const ArtIconPng:Class;

		[Embed(source="/assets/images/temp/icon_cinema.png")]
		public static const CinemaIconPng:Class;

		[Embed(source="/assets/images/temp/icon_history.png")]
		public static const HistoryIconPng:Class;

		[Embed(source="/assets/images/temp/icon_music.png")]
		public static const MusicIconPng:Class;

		[Embed(source="/assets/images/temp/icon_sports.png")]
		public static const SportsIconPng:Class;

		[Embed(source="/assets/images/temp/icon_travel.png")]
		public static const TravelIconPng:Class;

		[Embed(source="/assets/images/temp/icon_upload.png")]
		public static const UploadIconPng:Class;

		[Embed(source="/assets/images/temp/delete_icon.png")]
		public static const DeleteCellIconPng:Class;

		[Embed(source="/assets/images/temp/edit_icon.png")]
		public static const EditCellIconPng:Class;
/*
		[Embed(source="/assets/images/temp/top_nav_icon_02.png")]
		public static const TopNavIconMessagesPng:Class;

		[Embed(source="/assets/images/temp/top_nav_icon_03.png")]
		public static const TopNavIconBadgesPng:Class;
*/

		[Embed(source="/assets/images/temp/patient-profile-nav-button.png")]
		public static const PatientProfileNavButtonPng:Class;

		[Embed(source="/assets/images/temp/patient-profile-nav-button-pattern.png")]
		public static const PatientProfileNavButtonPatternPng:Class;

		[Embed(source="/assets/images/temp/back-button.png")]
		public static const BackButtonPng:Class;

		[Embed(source="/assets/images/temp/toggle_switch.png")]
		public static const ToggleSwitchPng:Class;

		[Embed(source="/assets/images/temp/toggle_track.png")]
		public static const ToggleTrackPng:Class;

		[Embed(source="/assets/images/temp/pillbox_icon.png")]
		public static const PillboxIconPng:Class;

		[Embed(source="/assets/images/temp/clock_icon.png")]
		public static const ClockIconPng:Class;

		[Embed(source="/assets/images/temp/clockface_hand.png")]
		public static const ClockFaceHandPng:Class;

		[Embed(source="/assets/images/temp/clockSegment.png")]
		public static const ClockFaceSegmentPng:Class;

		[Embed(source="/assets/images/temp/tablet1.png")]
		public static const Tablet1Png:Class;

		[Embed(source="/assets/images/temp/tablet2.png")]
		public static const Tablet2Png:Class;

		[Embed(source="/assets/images/temp/tablet3.png")]
		public static const Tablet3Png:Class;

		[Embed(source="/assets/images/temp/tablet4.png")]
		public static const Tablet4Png:Class;

		[Embed(source="/assets/images/temp/feeling_slider_track.png")]
		public static const FeelingSliderTrack:Class;

		[Embed(source="/assets/images/temp/feeling_slider_switch.png")]
		public static const FeelingSliderSwitch:Class;

		[Embed(source="/assets/images/temp/feeling_slider_cloud.png")]
		public static const FeelingSliderCloud:Class;

		[Embed(source="/assets/images/temp/feeling_slider_sun.png")]
		public static const FeelingSliderSun:Class;

		// forms

		[Embed(source="/assets/images/temp/button.png")]
		public static const ButtonPng:Class;

		[Embed(source="/assets/images/temp/button_borderless.png")]
		public static const BorderlessButtonPng:Class;

		[Embed(source="/assets/images/temp/input_field.png")]
		public static const InputFieldPng:Class;

		[Embed(source="/assets/images/temp/tick_box.png")]
		public static const TickBoxPng:Class;

		[Embed(source="/assets/images/temp/tick_box_active.png")]
		public static const TickBoxActivePng:Class;

		[Embed(source="/assets/images/temp/popup_panel.png")]
		public static const PopupPanelPng:Class;

		[Embed(source="/assets/images/temp/close_button.png")]
		public static const CloseButtonPng:Class;

		[Embed(source="/assets/images/temp/validation_bg.png")]
		public static const ValidationBgPng:Class;

		[Embed(source="/assets/images/temp/header_line.png")]
		public static const HeaderLinePng:Class;

		//front facing screen Items

		[Embed(source="/assets/images/temp/home_lens_rim.png")]
		public static const HomeLensRimPng:Class;

		[Embed(source="/assets/images/temp/home_lens_bg.png")]
		public static const HomeLensBgPng:Class;

		[Embed(source="/assets/images/temp/home_lens_shine.png")]
		public static const HomeLensShinePng:Class;

		[Embed(source="/assets/images/temp/clockFace.png")]
		public static const ClockFacePng:Class;

		[Embed(source="/assets/images/temp/pillbox.png")]
		public static const PillboxPng:Class;

		[Embed(source="/assets/images/temp/snakey_thing.png")]
		public static const SnakeyThingPng:Class;


		// TTF FONTS

		[Embed(source="/assets/fonts/exo-regular.ttf", fontName="ExoRegular", mimeType="application/x-font", embedAsCFF="false")]
		public static const ExoRegularFont:Class;

		[Embed(source="/assets/fonts/exo-bold.ttf", fontName="ExoBold", mimeType="application/x-font", embedAsCFF="false")]
		public static const ExoBoldFont:Class;

		[Embed(source="/assets/fonts/exo-light.ttf", fontName="ExoLight", mimeType="application/x-font", embedAsCFF="false")]
		public static const ExoLightFont:Class;

		private static var applicationTextures:Dictionary = new Dictionary();

		public static function getTexture(name:String):Texture
		{
			if (applicationTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				applicationTextures[name] = Texture.fromBitmap(bitmap);
			}
			return applicationTextures[name];
		}
	}
}
