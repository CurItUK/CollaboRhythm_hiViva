package collaboRhythm.hiviva.view
{

	import collaboRhythm.feathers.controls.ScreenNavigatorWithHistory;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.galleryscreens.SportsGalleryScreen;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.data.ListCollection;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		private var _feathersTheme:MetalWorksMobileTheme;
		private var _patientNav:ScreenNavigatorWithHistory;
		private var _patientProfileNav:ScreenNavigatorWithHistory;

		private var _footerBtnGroup:ButtonGroup;
		private var _patientSettingsBtn:Button;
		private var _transitionManager:ScreenSlidingStackTransitionManager;
		private var _applicationController:HivivaApplicationController;
		private var _appReset:Boolean = false;
		private var _settingsOpen:Boolean = false;

		private const TRANSITION_DURRATION:Number						= 0.4;

		public function Main()
		{
		}

		public function initMain():void
		{
			initfeathersTheme();
			initAppNavigator();
		}

		private function initfeathersTheme():void
		{
			this._feathersTheme = new MetalWorksMobileTheme(this.stage);
		}

		private function initAppNavigator():void
		{
			this._patientNav = new ScreenNavigatorWithHistory();
			this.addChild(this._patientNav);
			this._patientNav.addScreen(HivivaScreens.SPLASH_SCREEN, new ScreenNavigatorItem(HivivaSplashScreen , {complete:splashComplete},{applicationController:applicationController}));

			this._transitionManager = new ScreenSlidingStackTransitionManager(_patientNav);
			this._transitionManager.ease = Transitions.EASE_OUT;
			this._transitionManager.duration = TRANSITION_DURRATION;

			this._patientNav.showScreen(HivivaScreens.SPLASH_SCREEN);
		}

		private function splashComplete(e:Event):void
		{
			switch(e.data.profileType)
			{
				case "HCP" :
					initHCPNavigator();
					break;

				case "Patient" :
					initPatientNavigator();
					break;
			}
		}

		private function initPatientNavigator():void
		{
			initPatientFooterMenu();

			if(!this._appReset)
			{
				this._patientSettingsBtn = new Button();
				this._patientSettingsBtn.label = "SNav";
				this._patientSettingsBtn.addEventListener(Event.TRIGGERED , pattientSettingsBtnHandler);
				this.addChild(this._patientSettingsBtn);


				var patientSideNavScreen:HivivaPatientSideNavScreen = new HivivaPatientSideNavScreen();
				patientSideNavScreen.addEventListener(FeathersScreenEvent.NAVIGATE_AWAY , patientSlideNavHandler)
				this.addChildAt(patientSideNavScreen , 0);


				this._patientNav.addScreen(HivivaScreens.PATIENT_HOME_SCREEN, new ScreenNavigatorItem(HivivaPatientHomeScreen));
				//this._patientNav.addScreen(HivivaScreens.PATIENT_SETTINGS_SCREEN, new ScreenNavigatorItem(HivivaPatientSettingsScreen , {navGoBack:navGoBack , resetAppSettings:resetAppSettings}));
				this._patientNav.addScreen(HivivaScreens.PATIENT_CLOCK_SCREEN, new ScreenNavigatorItem(HivivaPatientClockScreen));
				this._patientNav.addScreen(HivivaScreens.PATIENT_MEDICATION_SCREEN, new ScreenNavigatorItem(HivivaPatientTakeMedsScreen));
				this._patientNav.addScreen(HivivaScreens.PATIENT_VIRUS_MODEL_SCREEN, new ScreenNavigatorItem(HivivaPatientVirusModelScreen));
				this._patientNav.addScreen(HivivaScreens.PATIENT_REPORTS_SCREEN, new ScreenNavigatorItem(HivivaPatientReportsScreen));
			}

			this._patientNav.showScreen(HivivaScreens.PATIENT_HOME_SCREEN);
		}

		private function patientSlideNavHandler(e:FeathersScreenEvent):void
		{
			trace("patientSlideNavHandler " + e.message);
			this._patientProfileNav = new ScreenNavigatorWithHistory();
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_PROFILE_SCREEN , new ScreenNavigatorItem(HivivaPatientProfileScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN, new ScreenNavigatorItem(HivivaPatientMyDetailsScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_HOMEPAGE_PHOTO_SCREEN, new ScreenNavigatorItem(HivivaPatientHomepagePhotoScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_GALLERY_SCREEN, new ScreenNavigatorItem(SportsGalleryScreen));
			this.addChild(_patientProfileNav);
			this._patientProfileNav.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);

		}


		//place holder for main app icons and navigation
		private function initPatientFooterMenu():void
		{
			this._footerBtnGroup = new ButtonGroup();
			this._footerBtnGroup.dataProvider = new ListCollection(
					[
						{label: "H", triggered: homeBtnHandler },
						{label: "C", triggered: clockBtnHandler },
						{label: "T", triggered: takeMedsBtnHandler },
						{label: "V", triggered: virusModelBtnHandler },
						{label: "D", triggered: reportsBtnHandler }
					]
			);
			this._footerBtnGroup.y = this.stage.height - 100;
			this._footerBtnGroup.width = this.stage.width;
			this._footerBtnGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;

			this.addChild(this._footerBtnGroup);
		}

		// dummy test settings slide in out, needs tidy
		private function pattientSettingsBtnHandler():void
		{
			var xLoc:Number = _settingsOpen ? 0 : this.stage.width/3;

			var navTween:Tween = new Tween(this._patientNav , 0.2 , Transitions.EASE_OUT);
			var footerTween:Tween = new Tween(this._footerBtnGroup , 0.2 , Transitions.EASE_OUT);
			var settingsTween:Tween = new Tween(this._patientSettingsBtn , 0.2 , Transitions.EASE_OUT);


			navTween.animate("x" , xLoc);
			footerTween.animate("x" , xLoc);
			settingsTween.animate("x" , xLoc);
			settingsTween.onComplete = function():void{_settingsOpen = !_settingsOpen;} ;
			Starling.juggler.add(navTween);
			Starling.juggler.add(footerTween);
			Starling.juggler.add(settingsTween);
		}

		private function homeBtnHandler():void
		{
			this._patientNav.showScreen(HivivaScreens.PATIENT_HOME_SCREEN);
		}

		private function clockBtnHandler():void
		{
			this._patientNav.showScreen(HivivaScreens.PATIENT_CLOCK_SCREEN);
		}

		private function takeMedsBtnHandler():void
		{
			this._patientNav.showScreen(HivivaScreens.PATIENT_MEDICATION_SCREEN);
		}

		private function virusModelBtnHandler():void
		{
			this._patientNav.showScreen(HivivaScreens.PATIENT_VIRUS_MODEL_SCREEN);
		}

		private function reportsBtnHandler():void
		{
			this._patientNav.showScreen(HivivaScreens.PATIENT_REPORTS_SCREEN);
		}

		private function navGoBack():void
		{
			_patientNav.goBack();
		}

		private function resetAppSettings():void
		{
			applicationController.hivivaLocalStoreController.resetApplication();
			this._appReset = true;
			this._patientNav.clearHistory();
			this._patientNav.showScreen(HivivaScreens.SPLASH_SCREEN);
		}

		private function initHCPNavigator():void
		{
			if(!this._appReset)
			{

			}
		}

		public function get applicationController():HivivaApplicationController
		{
			return _applicationController;
		}

		public function set applicationController(value:HivivaApplicationController):void
		{
			_applicationController = value;
		}

	}
}
