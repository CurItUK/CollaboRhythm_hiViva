package collaboRhythm.hiviva.view
{

	import collaboRhythm.feathers.controls.ScreenNavigatorWithHistory;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.galleryscreens.SportsGalleryScreen;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.core.TokenList;
	import feathers.data.ListCollection;
	import feathers.display.TiledImage;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.system.DeviceCapabilities;

	import source.themes.HivivaTheme;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Main extends Sprite
	{
		private var _screenHolder:Sprite;
		private var _screenBackground:Sprite;
		private var _feathersTheme:HivivaTheme;
		private var _patientNav:ScreenNavigatorWithHistory;
		private var _patientProfileNav:ScreenNavigatorWithHistory;
		private var _footerBtnGroup:ButtonGroup;
		private var _patientSettingsBtn:Button;
		private var _transitionManager:ScreenSlidingStackTransitionManager;
		private var _applicationController:HivivaApplicationController;
		private var _appReset:Boolean = false;
		private var _settingsOpen:Boolean = false;

		private const TRANSITION_DURATION:Number						= 0.4;
		private const SETTING_MENU_WIDTH:Number							= 250;

		public function Main()
		{
		}

		public function initMain():void
		{
			this._screenHolder = new Sprite();
			this.addChild(this._screenHolder);

			drawScreenBackground();
			initfeathersTheme();
			initAppNavigator();
		}

		protected function drawScreenBackground():void
		{
			this._screenBackground = new Sprite();

			var screenBase:TiledImage = new TiledImage(Assets.getTexture("BasePng"));
			screenBase.width = stage.stageWidth;
			screenBase.height = stage.stageHeight;
			screenBase.flatten();
			this._screenBackground.addChild(screenBase);

			var topGrad:TiledImage = new TiledImage(Assets.getTexture("BaseTopGradPng"));
			topGrad.touchable = false;
			// named because the alpha for this asset needs adjusting on the home screen (screenHolder may need own class with this as a local instance)
			topGrad.name = "topGrad";
			topGrad.width = stage.stageWidth;
			topGrad.flatten();
			this._screenBackground.addChild(topGrad);

			var bottomGrad:TiledImage = new TiledImage(Assets.getTexture("BaseBottomGradPng"));
			bottomGrad.touchable = false;
			bottomGrad.width = stage.stageWidth;
			bottomGrad.y = stage.stageHeight - bottomGrad.height;
			bottomGrad.flatten();
			this._screenBackground.addChild(bottomGrad);

			var settingEffect:TiledImage = new TiledImage(Assets.getTexture("SettingEffectPng"));
			settingEffect.touchable = false;
			settingEffect.name = "settingEffect";
			settingEffect.height = stage.stageHeight;
			settingEffect.x = 1 - settingEffect.width;
			settingEffect.blendMode = BlendMode.MULTIPLY;
			this._screenBackground.addChild(settingEffect);
		}

		private function initfeathersTheme():void
		{
			this._feathersTheme = new HivivaTheme(this.stage);
		}

		private function initAppNavigator():void
		{
			this._patientNav = new ScreenNavigatorWithHistory();
			this._patientNav.addChild(this._screenBackground);
			this._screenHolder.addChild(this._patientNav);
			this._patientNav.addScreen(HivivaScreens.SPLASH_SCREEN, new ScreenNavigatorItem(HivivaSplashScreen , {complete:splashComplete},{applicationController:applicationController}));

			this._transitionManager = new ScreenSlidingStackTransitionManager(_patientNav);
			this._transitionManager.ease = Transitions.EASE_OUT;
			this._transitionManager.duration = TRANSITION_DURATION;

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
				this._patientSettingsBtn.addEventListener(Event.TRIGGERED , patientSettingsBtnHandler);
				this._screenHolder.addChild(this._patientSettingsBtn);


				var patientSideNavScreen:HivivaPatientSideNavScreen = new HivivaPatientSideNavScreen();
				patientSideNavScreen.addEventListener(FeathersScreenEvent.NAVIGATE_AWAY , patientSlideNavHandler);
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
			patientSettingsBtnHandler();
			this._patientProfileNav = new ScreenNavigatorWithHistory();
			this._patientProfileNav.addChild(this._screenBackground);
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_PROFILE_SCREEN , new ScreenNavigatorItem(HivivaPatientProfileScreen , {navGoHome:navGoHomeFromProfileScreen}));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN, new ScreenNavigatorItem(HivivaPatientMyDetailsScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_HOMEPAGE_PHOTO_SCREEN, new ScreenNavigatorItem(HivivaPatientHomepagePhotoScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_GALLERY_SCREEN, new ScreenNavigatorItem(SportsGalleryScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_TEST_RESULTS_SCREEN, new ScreenNavigatorItem(HivivaPatientTestResultsScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_CONNECT_TO_HCP_SCREEN, new ScreenNavigatorItem(HivivaPatientConnectToHcpScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_USER_SIGNUP_SCREEN, new ScreenNavigatorItem(HivivaUserSignupScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_HELP_SCREEN, new ScreenNavigatorItem(HivivaPatientHelpScreen, {navGoHome:navGoHomeFromProfileScreen}));
			this.addChild(_patientProfileNav);

			this._patientProfileNav.showScreen(e.message);

		}


		//place holder for main app icons and navigation
		private function initPatientFooterMenu():void
		{
			// needs own class
			var footerBtnHeight:Number = Assets.getTexture("FooterIconBasePng").height * this._feathersTheme.scale;
			var footerBtnWidth:Number = Assets.getTexture("FooterIconBasePng").width * this._feathersTheme.scale;

			this._footerBtnGroup = new ButtonGroup();
			this._footerBtnGroup.customButtonName = "home-footer-buttons";
			this._footerBtnGroup.customFirstButtonName = "home-footer-buttons";
			this._footerBtnGroup.customLastButtonName = "home-footer-buttons";

			this._footerBtnGroup.dataProvider = new ListCollection(
				[
					{ width: footerBtnWidth, height: footerBtnHeight, name: "home", triggered: footerBtnHandler },
					{ width: footerBtnWidth, height: footerBtnHeight, name: "clock", triggered: footerBtnHandler },
					{ width: footerBtnWidth, height: footerBtnHeight, name: "takemeds", triggered: footerBtnHandler },
					{ width: footerBtnWidth, height: footerBtnHeight, name: "virus", triggered: footerBtnHandler },
					{ width: footerBtnWidth, height: footerBtnHeight, name: "report", triggered: footerBtnHandler }
				]
			);

			this._footerBtnGroup.buttonInitializer = function(button:Button, item:Object):void
			{
				var img:Image;

				button.name = item.name;
				button.addEventListener(Event.TRIGGERED, item.triggered);

				switch(item.name)
				{
					case "home" :
						img = new Image(Assets.getTexture("FooterIconHomePng"));
						button.isSelected = true;
						break;
					case "clock" :
						img = new Image(Assets.getTexture("FooterIconClockPng"));
						break;
					case "takemeds" :
						img = new Image(Assets.getTexture("FooterIconMedicPng"));
						break;
					case "virus" :
						img = new Image(Assets.getTexture("FooterIconVirusPng"));
						break;
					case "report" :
						img = new Image(Assets.getTexture("FooterIconReportPng"));
						break;
				}
				img.width = item.width;
				img.height = item.height;
				button.addChild(img);
			};

			this._footerBtnGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;

			this._screenHolder.addChild(this._footerBtnGroup);
			this._footerBtnGroup.y = this.stage.height - footerBtnHeight;
			this._footerBtnGroup.width = this.stage.width;
		}

		private function footerBtnHandler(e:Event):void
		{
			var loopLength:int;
			var btn:Button = e.target as Button;
			if(!btn.isSelected)
			{
				// when refactoring to own class we can use a local instance instead of storing the identifier in btn.name
				switch(btn.name.substring(0 ,btn.name.indexOf(" home-footer-buttons")))
				{
					case "home" :
						this._patientNav.showScreen(HivivaScreens.PATIENT_HOME_SCREEN);
						break;
					case "clock" :
						this._patientNav.showScreen(HivivaScreens.PATIENT_CLOCK_SCREEN);
						break;
					case "takemeds" :
						this._patientNav.showScreen(HivivaScreens.PATIENT_MEDICATION_SCREEN);
						break;
					case "virus" :
						this._patientNav.showScreen(HivivaScreens.PATIENT_VIRUS_MODEL_SCREEN);
						break;
					case "report" :
						this._patientNav.showScreen(HivivaScreens.PATIENT_REPORTS_SCREEN);
						break;
				}

				// deselect siblings
				loopLength = this._footerBtnGroup.dataProvider.length;
				for (var i:int = 0; i < loopLength; i++)
				{
					btn = this._footerBtnGroup.getChildAt(i) as Button;
					btn.isSelected = false;
				}
				btn = e.target as Button;
				btn.isSelected = true;
			}
		}

		private function patientSettingsBtnHandler(e:Event = null):void
		{
			var xLoc:Number = _settingsOpen ? 0 : SETTING_MENU_WIDTH;

			var settingsTween:Tween = new Tween(this._screenHolder , 0.2 , Transitions.EASE_OUT);
			settingsTween.animate("x" , xLoc);
			settingsTween.onComplete = function():void{_settingsOpen = !_settingsOpen;} ;
			Starling.juggler.add(settingsTween);
		}

		private function navGoHomeFromProfileScreen():void
		{
			this._patientProfileNav.clearScreen();
			this._patientNav.addChild(this._screenBackground);
		}
/*

		private function homeBtnHandler(e:Event):void
		{
			var btn:Button = e.target as Button;
			btn.isSelected = true;
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
*/

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
