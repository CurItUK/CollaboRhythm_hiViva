package collaboRhythm.hiviva.view
{


	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.model.HivivaLocalStoreService;
	import collaboRhythm.hiviva.view.components.HCPFooterBtnGroup;
	import collaboRhythm.hiviva.view.components.IFooterBtnGroup;
	import collaboRhythm.hiviva.view.components.PatientFooterBtnGroup;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPAddPatientScreen;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPAlertSettings;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPAllPatientsAdherenceScreen;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPConnectToPatientScreen;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPDisplaySettings;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPEditProfile;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPHomesScreen;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPPatientProfileScreen;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPProfileScreen;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPReportsScreen;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPResetSettingsScreen;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPSideNavigationScreen;
	import collaboRhythm.hiviva.view.screens.hcp.messages.HivivaHCPMessageCompose;
	import collaboRhythm.hiviva.view.screens.hcp.messages.HivivaHCPMessages;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPHelpScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientBagesScreen;
	import collaboRhythm.hiviva.view.galleryscreens.SportsGalleryScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientAddMedsScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientConnectToHcpScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientEditMedsScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientEditSettingsScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientHelpScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientHomeScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientHomepagePhotoScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientMessagesScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientMyDetailsScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientProfileScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientReportsScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientSideNavScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientTakeMedsScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientTestResultsScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientViewMedicationScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientVirusModelScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientUserSignupScreen;
	import collaboRhythm.hiviva.view.screens.shared.HivivaSplashScreen;
	import collaboRhythm.hiviva.view.screens.shared.MainBackground;

	import feathers.controls.Button;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;

	import flash.filesystem.File;
	import source.themes.HivivaTheme;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import feathers.core.PopUpManager;
	import collaboRhythm.hiviva.view.components.Calendar;
	import starling.display.Quad;
	import flash.desktop.NativeApplication;
	import collaboRhythm.hiviva.view.PasswordPopUp;
	public class Main extends Sprite
	{
		private var _screenHolder:Sprite;
		private var _screenBackground:MainBackground;
		private var _mainScreenNav:ScreenNavigator;
		private var _settingsNav:ScreenNavigator;
		private var _footerBtnGroup:IFooterBtnGroup;
		private var _settingsBtn:Button;
		private var _settingsOpen:Boolean = false;
		private var _currMainScreenId:String;
		private var _scaleFactor:Number;
		//private var _profile:String;
		private var _calendar:Calendar;
		private static var _selectedHCPPatientProfile:Object = {};
		private static var _assets:AssetManager;
		private static var _footerBtnGroupHeight:Number;
		private var _popupContainer:PasswordPopUp;

		   // Startup image for SD screens
//        [Embed(source="/assets/images/temp/Landing-page.png")]
        private static var Preloader_Background:Class;


		public function Main()
		{
		}

		public function initMain(assetManager:AssetManager):void
		{
			_assets = assetManager;

			initAssetManagement();
		}

		private function initAssetManagement():void
		{
			var appDir:File = File.applicationDirectory;
			_assets.enqueue(appDir.resolvePath("assets/images/atlas/homePagePhoto.atf"),appDir.resolvePath("assets/images/atlas/homePagePhoto.xml"));
			_assets.enqueue(appDir.resolvePath("assets/images/atlas/hivivaBaseImages.png"),appDir.resolvePath("assets/images/atlas/hivivaBaseImages.xml"));
			// fonts
			_assets.enqueue(appDir.resolvePath("assets/fonts/normal-white-regular.png"),appDir.resolvePath("assets/fonts/normal-white-regular.fnt"));
			_assets.enqueue(appDir.resolvePath("assets/fonts/normal-white-bold.png"),appDir.resolvePath("assets/fonts/normal-white-bold.fnt"));
			_assets.enqueue(appDir.resolvePath("assets/fonts/engraved-dark-bold.png"),appDir.resolvePath("assets/fonts/engraved-dark-bold.fnt"));
			_assets.enqueue(appDir.resolvePath("assets/fonts/engraved-medium-bold.png"),appDir.resolvePath("assets/fonts/engraved-medium-bold.fnt"));
			_assets.enqueue(appDir.resolvePath("assets/fonts/engraved-light-bold.png"),appDir.resolvePath("assets/fonts/engraved-light-bold.fnt"));
			_assets.enqueue(appDir.resolvePath("assets/fonts/engraved-lighter-bold.png"),appDir.resolvePath("assets/fonts/engraved-lighter-bold.fnt"));
			_assets.enqueue(appDir.resolvePath("assets/fonts/engraved-lightest-bold.png"),appDir.resolvePath("assets/fonts/engraved-lightest-bold.fnt"));
			_assets.enqueue(appDir.resolvePath("assets/fonts/engraved-lighter-regular.png"),appDir.resolvePath("assets/fonts/engraved-lighter-regular.fnt"));
			_assets.enqueue(appDir.resolvePath("assets/fonts/raised-lighter-bold.png"),appDir.resolvePath("assets/fonts/raised-lighter-bold.fnt"));
            var __home =  this
			_assets.loadQueue(function onProgress(ratio:Number):void
			{
				trace("Loading Assets " + ratio);
				const quad:Quad = new Quad(100, 5, 0xff00ff);
				 quad.x =  0 // ( Constants.STAGE_WIDTH - quad.width) / 2;
				 quad.y = ( Constants.STAGE_HEIGHT - quad.height) / 2;
				 __home.addChild(quad);
				quad.width = ratio * Constants.STAGE_WIDTH;

				if (ratio == 1)

					Starling.juggler.delayCall(function ():void
					{
						__home.removeChild(quad)
						quad.dispose()

						startup();
					}, 0.15);
			});
		}

		private function startup():void
		{
			trace(_assets.getTextureNames());
			initfeathersTheme();
			initAppNavigator();
		}

		private function initfeathersTheme():void
		{
			//var isDesktop:Boolean = true;
			var isDesktop:Boolean = false;
			var _hivivaTheme:HivivaTheme = new HivivaTheme(this.stage, !isDesktop);
			this._scaleFactor = isDesktop ? 1 : _hivivaTheme.scale;
			_footerBtnGroupHeight = Constants.FOOTER_BTNGROUP_HEIGHT * this._scaleFactor;
		}

		private function initAppNavigator():void
		{
			this._screenHolder = new Sprite();
			this._mainScreenNav = new ScreenNavigator();
			this.addChild(this._screenHolder);
			this._screenHolder.addChild(this._mainScreenNav);

			this._mainScreenNav.addScreen(HivivaScreens.SPLASH_SCREEN, new ScreenNavigatorItem(HivivaSplashScreen , {complete:splashComplete}));
			this._mainScreenNav.showScreen(HivivaScreens.SPLASH_SCREEN);

			this._popupContainer = new PasswordPopUp();
						//	this._popupContainer.scale = this.dpiScale;
					//	 this._popupContainer.width = this.actualWidth;
						//	this._popupContainer.height = this.actualHeight;
						//	this._popupContainer.addEventListener(starling.events.Event.CLOSE, closePopup);
					//		this._popupContainer.message = _main.selectedHCPPatientProfile.name;
						//	this._popupContainer.confirmLabel = 'Message Sent';
						//	this._popupContainer.validate();

						 PopUpManager.addPopUp(this._popupContainer, true, true);
						 this._popupContainer.validate();




		}





		private function splashComplete(e:Event):void
		{
			//this._profile = e.data.profileType;

			this._mainScreenNav.clearScreen();
			this._mainScreenNav.removeScreen(HivivaScreens.SPLASH_SCREEN);

			drawScreenBackground();
			drawSettingsBtn();

			this._settingsNav = new ScreenNavigator();
			this.addChild(this._settingsNav);

			switch(HivivaStartup.userVO.type)
			{
				case Constants.APP_TYPE_HCP :
					initHCPSettingsNavigator();
					initFooterMenu(HCPFooterBtnGroup);
					initHCPNavigator();
					break;

				case Constants.APP_TYPE_PATIENT :
					initPatientSettingsNavigator();
					initFooterMenu(PatientFooterBtnGroup);
					initPatientNavigator();
					break;
			}
		}

		protected function drawScreenBackground():void
		{
			this._screenBackground = new MainBackground();
			this._screenBackground.draw(Constants.STAGE_WIDTH , Constants.STAGE_HEIGHT);
//			this._screenBackground.touchable = false;
			this._mainScreenNav.addChildAt(this._screenBackground , 0);
		}

		private function drawSettingsBtn():void
		{
			this._settingsBtn = new Button();
			this._settingsBtn.name = HivivaTheme.NONE_THEMED;
			this._settingsBtn.defaultIcon = new Image(_assets.getTexture("top_nav_icon_01"));
			this._settingsBtn.addEventListener(Event.TRIGGERED , settingsBtnHandler);
			this._screenHolder.addChild(this._settingsBtn);
			this._settingsBtn.width = (Constants.STAGE_WIDTH * 0.2);
			this._settingsBtn.scaleY = this._settingsBtn.scaleX;
		}

		private function settingsBtnHandler(e:Event = null):void
		{
			var xLoc:Number = _settingsOpen ? 0 : Constants.SETTING_MENU_WIDTH;

			var settingsTween:Tween = new Tween(this._screenHolder , 0.2 , Transitions.EASE_OUT);
			settingsTween.animate("x" , xLoc);
			settingsTween.onComplete = function():void{_settingsOpen = !_settingsOpen; Starling.juggler.remove(settingsTween);};
			Starling.juggler.add(settingsTween);
		}

		private function initPatientNavigator():void
		{
			var patientSideNavScreen:HivivaPatientSideNavScreen = new HivivaPatientSideNavScreen(Constants.SETTING_MENU_WIDTH, this._scaleFactor);
			patientSideNavScreen.addEventListener(FeathersScreenEvent.NAVIGATE_AWAY , settingsNavHandler);
			this.addChildAt(patientSideNavScreen , 0);

			this._mainScreenNav.addScreen(HivivaScreens.PATIENT_HOME_SCREEN, new ScreenNavigatorItem(HivivaPatientHomeScreen, {navGoSettings:navGoSettings}));
			this._mainScreenNav.addScreen(HivivaScreens.PATIENT_VIEW_MEDICATION_SCREEN, new ScreenNavigatorItem(HivivaPatientViewMedicationScreen));
			this._mainScreenNav.addScreen(HivivaScreens.PATIENT_MEDICATION_SCREEN, new ScreenNavigatorItem(HivivaPatientTakeMedsScreen ));
			this._mainScreenNav.addScreen(HivivaScreens.PATIENT_VIRUS_MODEL_SCREEN, new ScreenNavigatorItem(HivivaPatientVirusModelScreen));
			this._mainScreenNav.addScreen(HivivaScreens.PATIENT_REPORTS_SCREEN, new ScreenNavigatorItem(HivivaPatientReportsScreen));

		}

		private function initHCPNavigator():void
		{
			var hcpSideNavScreen:HivivaHCPSideNavigationScreen = new HivivaHCPSideNavigationScreen(Constants.SETTING_MENU_WIDTH, this._scaleFactor);
			hcpSideNavScreen.addEventListener(FeathersScreenEvent.NAVIGATE_AWAY , settingsNavHandler);
			this.addChildAt(hcpSideNavScreen , 0);

			this._mainScreenNav.addScreen(HivivaScreens.HCP_HOME_SCREEN, new ScreenNavigatorItem(HivivaHCPHomesScreen, {mainToSubNav:navigateToDirectProfileMenu}));
			this._mainScreenNav.addScreen(HivivaScreens.HCP_ADHERENCE_SCREEN, new ScreenNavigatorItem(HivivaHCPAllPatientsAdherenceScreen));
			this._mainScreenNav.addScreen(HivivaScreens.HCP_REPORTS_SCREEN, new ScreenNavigatorItem(HivivaHCPReportsScreen));
			this._mainScreenNav.addScreen(HivivaScreens.HCP_MESSAGE_SCREEN, new ScreenNavigatorItem(HivivaHCPMessages ,  {mainToSubNav:navigateToDirectProfileMenu}));

			// add listeners for homepage user signup check, to hide / show the footer and settings button
			addEventListener(FeathersScreenEvent.HIDE_MAIN_NAV, hideMainNav);
			addEventListener(FeathersScreenEvent.SHOW_MAIN_NAV, showMainNav);
		}

		private function initHCPSettingsNavigator():void
		{
			this._settingsNav.addScreen(HivivaScreens.HCP_PROFILE_SCREEN, new ScreenNavigatorItem(HivivaHCPProfileScreen, {navGoHome:goBackToMainScreen}));
			this._settingsNav.addScreen(HivivaScreens.HCP_HELP_SCREEN, new ScreenNavigatorItem(HivivaHCPHelpScreen, {navGoHome:goBackToMainScreen}));
			this._settingsNav.addScreen(HivivaScreens.HCP_EDIT_PROFILE, new ScreenNavigatorItem(HivivaHCPEditProfile));
			this._settingsNav.addScreen(HivivaScreens.HCP_DISPLAY_SETTINGS, new ScreenNavigatorItem(HivivaHCPDisplaySettings));
			this._settingsNav.addScreen(HivivaScreens.HCP_ALERT_SETTINGS, new ScreenNavigatorItem(HivivaHCPAlertSettings));
			this._settingsNav.addScreen(HivivaScreens.HCP_CONNECT_PATIENT, new ScreenNavigatorItem(HivivaHCPConnectToPatientScreen));
			this._settingsNav.addScreen(HivivaScreens.HCP_ADD_PATIENT, new ScreenNavigatorItem(HivivaHCPAddPatientScreen));
			this._settingsNav.addScreen(HivivaScreens.HCP_PATIENT_PROFILE, new ScreenNavigatorItem(HivivaHCPPatientProfileScreen, {navGoHome:goBackToMainScreen}));
			this._settingsNav.addScreen(HivivaScreens.HCP_MESSAGE_COMPOSE_SCREEN, new ScreenNavigatorItem(HivivaHCPMessageCompose, {navGoHome:goBackToMainScreen}));
			this._settingsNav.addScreen(HivivaScreens.HCP_RESET_SETTINGS, new ScreenNavigatorItem(HivivaHCPResetSettingsScreen, {navGoHome:goBackToMainScreen, navFromReset:resetApplication}));

		}

		private function initPatientSettingsNavigator():void
		{
			this._settingsNav.addScreen(HivivaScreens.PATIENT_PROFILE_SCREEN , new ScreenNavigatorItem(HivivaPatientProfileScreen, {navGoHome:goBackToMainScreen}));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN, new ScreenNavigatorItem(HivivaPatientMyDetailsScreen));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_HOMEPAGE_PHOTO_SCREEN, new ScreenNavigatorItem(HivivaPatientHomepagePhotoScreen));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_GALLERY_SCREEN, new ScreenNavigatorItem(SportsGalleryScreen));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_TEST_RESULTS_SCREEN, new ScreenNavigatorItem(HivivaPatientTestResultsScreen));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_CONNECT_TO_HCP_SCREEN, new ScreenNavigatorItem(HivivaPatientConnectToHcpScreen));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_EDIT_MEDICATION_SCREEN, new ScreenNavigatorItem(HivivaPatientEditMedsScreen));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_ADD_MEDICATION_SCREEN, new ScreenNavigatorItem(HivivaPatientAddMedsScreen));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_USER_SIGNUP_SCREEN, new ScreenNavigatorItem(HivivaPatientUserSignupScreen));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_HELP_SCREEN, new ScreenNavigatorItem(HivivaPatientHelpScreen, {navGoHome:goBackToMainScreen}));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_MESSAGES_SCREEN, new ScreenNavigatorItem(HivivaPatientMessagesScreen, {navGoHome:goBackToMainScreen}));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_BADGES_SCREEN, new ScreenNavigatorItem(HivivaPatientBagesScreen, {navGoHome:goBackToMainScreen}));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_ALERTS_SCREEN, new ScreenNavigatorItem(HivivaPatientBagesScreen, {navGoHome:goBackToMainScreen}));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_EDIT_SETTINGS_SCREEN, new ScreenNavigatorItem(HivivaPatientEditSettingsScreen, {navGoHome:goBackToMainScreen}));

		}

		private function navigateToDirectProfileMenu(e:Event):void
		{
			if(e.data.patientName != null)
			{
				_selectedHCPPatientProfile.name = e.data.patientName;
				_selectedHCPPatientProfile.appID = e.data.appID;
			}
			var navAwayEvent:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.NAVIGATE_AWAY);
			navAwayEvent.message = e.data.profileMenu;

			settingsNavHandler(navAwayEvent);
		}

		private function navGoSettings(e:Event):void
		{
			var feathEvent:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.NAVIGATE_AWAY);
			feathEvent.message = e.data.screen;
			settingsNavHandler(feathEvent);
		}

		private function settingsNavHandler(e:FeathersScreenEvent):void
		{
			if(_settingsOpen) settingsBtnHandler();

			if(!this._settingsNav.contains(this._screenBackground)) this._settingsNav.addChild(this._screenBackground);
			this._settingsNav.showScreen(e.message);
			this._currMainScreenId = HivivaStartup.userVO.type == Constants.APP_TYPE_HCP ? HivivaScreens.HCP_HOME_SCREEN : HivivaScreens.PATIENT_HOME_SCREEN;
			this._mainScreenNav.clearScreen();
		}

		private function initFooterMenu(type:Class):void
		{
			this._footerBtnGroup = new type(this._mainScreenNav , this._scaleFactor);
			this._footerBtnGroup.asButtonGroup().y = Constants.STAGE_HEIGHT - _footerBtnGroupHeight;
			this._footerBtnGroup.asButtonGroup().width = Constants.STAGE_WIDTH;
			this._screenHolder.addChild(this._footerBtnGroup.asButtonGroup());
		}

		private function goBackToMainScreen():void
		{
			this._settingsNav.clearScreen();
			this._mainScreenNav.addChild(this._screenBackground);
			this._mainScreenNav.showScreen(this._currMainScreenId);
			this._footerBtnGroup.resetToHomeState();
		}

		private function resetApplication():void
		{
			trace("Reset from profile...");

			///this._settingsNav.clearScreen();
			//this._mainScreenNav.addScreen(HivivaScreens.SPLASH_SCREEN, new ScreenNavigatorItem(HivivaSplashScreen , {complete:splashResetComplete}));
			//this._mainScreenNav.showScreen(HivivaScreens.SPLASH_SCREEN);
		}

		private function splashResetComplete(e:Event):void
		{
			trace("Reset splashResetCompletee...");
		}

		private function hideMainNav(e:FeathersScreenEvent):void
		{
			this._settingsBtn.touchable = false;
			this._settingsBtn.visible = false;

			this._footerBtnGroup.asButtonGroup().touchable = false;
			this._footerBtnGroup.asButtonGroup().visible = false;
		}

		private function showMainNav(e:FeathersScreenEvent):void
		{
			this._settingsBtn.touchable = true;
			this._settingsBtn.visible = true;

			this._footerBtnGroup.asButtonGroup().touchable = true;
			this._footerBtnGroup.asButtonGroup().visible = true;
		}



		public static function get selectedHCPPatientProfile():Object
		{
			return _selectedHCPPatientProfile;
		}

		public static function get assets():AssetManager
		{
			return _assets;
		}

		public static function get footerBtnGroupHeight():Number
		{
			return _footerBtnGroupHeight;
		}
	}
}
