package collaboRhythm.hiviva.view
{

	import collaboRhythm.feathers.controls.ScreenNavigatorWithHistory;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.model.HivivaLocalStoreService;
	import collaboRhythm.hiviva.view.HivivaPatientBagesScreen;
	import collaboRhythm.hiviva.view.galleryscreens.SportsGalleryScreen;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.data.ListCollection;
	import feathers.display.TiledImage;
	import feathers.motion.transitions.ScreenFadeTransitionManager;

	import flash.desktop.NativeApplication;
	import flash.system.Capabilities;


	import source.themes.HivivaTheme;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;

	public class Main extends Sprite
	{
		private var _screenHolder:Sprite;
		private var _screenBackground:Sprite;
		private var _feathersTheme:HivivaTheme;
		private var _patientNav:ScreenNavigatorWithHistory;
		private var _patientProfileNav:ScreenNavigatorWithHistory;
		private var _footerBtnGroup:ButtonGroup;
		private var _patientSettingsBtn:Button;
		private var _transitionManager:ScreenFadeTransitionManager;
		private var _applicationController:HivivaApplicationController;
		private var _appReset:Boolean = false;
		private var _settingsOpen:Boolean = false;
		private var _currFooterBtn:Button;
		private var _scaleFactor:Number;

		private const TRANSITION_DURATION:Number						= 0.4;
		private const SETTING_MENU_WIDTH:Number							= 177;

		private var _stageHeight:Number;
		private var _stageWidth:Number;

		public function Main()
		{
		}

		public function initMain():void
		{
			this._stageHeight = Starling.current.viewPort.height;
			this._stageWidth = Starling.current.viewPort.width;

			this._screenHolder = new Sprite();
			this.addChild(this._screenHolder);



			drawScreenBackground();
			initfeathersTheme();
			initAppNavigator();
		}

		protected function drawScreenBackground():void
		{
			this._screenBackground = new Sprite();

			var screenBase:TiledImage = new TiledImage(HivivaAssets.SCREEN_BASE);
			screenBase.width = this._stageWidth;
			screenBase.height = this._stageHeight;
			screenBase.smoothing = TextureSmoothing.NONE;
			screenBase.flatten();
			this._screenBackground.addChild(screenBase);

			var topGrad:TiledImage = new TiledImage(HivivaAssets.SCREEN_BASE_TOP_GRADIENT);
			topGrad.touchable = false;
			// named because the alpha for this asset needs adjusting on the home screen (screenHolder may need own class with this as a local instance)
			topGrad.name = "topGrad";
			topGrad.width = this._stageWidth;
			topGrad.smoothing = TextureSmoothing.NONE;
			topGrad.blendMode = BlendMode.MULTIPLY;
			topGrad.flatten();
			this._screenBackground.addChild(topGrad);

			var bottomGrad:TiledImage = new TiledImage(HivivaAssets.SCREEN_BASE_BOTTOM_GRADIENT);
			bottomGrad.touchable = false;
			bottomGrad.width = this._stageWidth;
			bottomGrad.y = this._stageHeight - bottomGrad.height;
			bottomGrad.smoothing = TextureSmoothing.NONE;
			bottomGrad.blendMode = BlendMode.MULTIPLY;
			bottomGrad.flatten();
			this._screenBackground.addChild(bottomGrad);

			var settingEffect:TiledImage = new TiledImage(HivivaAssets.SETTING_EFFECT);
			settingEffect.touchable = false;
			settingEffect.name = "settingEffect";
			settingEffect.height = this._stageHeight;
			settingEffect.x = 1 - settingEffect.width;
			settingEffect.smoothing = TextureSmoothing.NONE;
			settingEffect.blendMode = BlendMode.MULTIPLY;
			this._screenBackground.addChild(settingEffect);
		}

		private function initfeathersTheme():void
		{
			//var isDesktop:Boolean = true;
			var isDesktop:Boolean = false;
			this._feathersTheme = new HivivaTheme(this.stage, !isDesktop);
			this._scaleFactor = isDesktop ? 1 : this._feathersTheme.scale;
		}

		private function initAppNavigator():void
		{
			this._patientNav = new ScreenNavigatorWithHistory();
			this._patientNav.addChild(this._screenBackground);
			this._screenHolder.addChild(this._patientNav);
			this._patientNav.addScreen(HivivaScreens.SPLASH_SCREEN, new ScreenNavigatorItem(HivivaSplashScreen , {complete:splashComplete},{applicationController:applicationController}));

			this._transitionManager = new ScreenFadeTransitionManager(_patientNav);
			this._transitionManager.ease = Transitions.EASE_OUT;
			this._transitionManager.duration = TRANSITION_DURATION;

			this._patientNav.showScreen(HivivaScreens.SPLASH_SCREEN);
		}

		private function splashComplete(e:Event):void
		{
			// TODO: move controller logic out of this view class and into a controller class
			switch(e.data.profileType)
			{
				case HivivaLocalStoreService.USER_APP_TYPE_HCP :
					initHCPNavigator();
					break;

				case HivivaLocalStoreService.USER_APP_TYPE_PATIENT :
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
				this._patientSettingsBtn.name = HivivaTheme.NONE_THEMED;
				this._patientSettingsBtn.defaultIcon = new Image(HivivaAssets.SETTINGS_ICON);
				this._patientSettingsBtn.addEventListener(Event.TRIGGERED , patientSettingsBtnHandler);
				this._screenHolder.addChild(this._patientSettingsBtn);
				this._patientSettingsBtn.width = 130 * this._scaleFactor;
				this._patientSettingsBtn.height = 110 * this._scaleFactor;

				var patientSideNavScreen:HivivaPatientSideNavScreen = new HivivaPatientSideNavScreen(SETTING_MENU_WIDTH, this._scaleFactor);
				patientSideNavScreen.addEventListener(FeathersScreenEvent.NAVIGATE_AWAY , patientSlideNavHandler);
				this.addChildAt(patientSideNavScreen , 0);

				this._patientNav.addScreen(HivivaScreens.PATIENT_HOME_SCREEN, new ScreenNavigatorItem(HivivaPatientHomeScreen, null, {footerHeight:this._footerBtnGroup.height}));
				this._patientNav.addScreen(HivivaScreens.PATIENT_VIEW_MEDICATION_SCREEN, new ScreenNavigatorItem(HivivaPatientViewMedicationScreen));
				this._patientNav.addScreen(HivivaScreens.PATIENT_MEDICATION_SCREEN, new ScreenNavigatorItem(HivivaPatientTakeMedsScreen , null , {applicationController:_applicationController,footerHeight:this._footerBtnGroup.height}));
				this._patientNav.addScreen(HivivaScreens.PATIENT_VIRUS_MODEL_SCREEN, new ScreenNavigatorItem(HivivaPatientVirusModelScreen));
				this._patientNav.addScreen(HivivaScreens.PATIENT_REPORTS_SCREEN, new ScreenNavigatorItem(HivivaPatientReportsScreen));

			}

			//this._patientNav.showScreen(HivivaScreens.PATIENT_HOME_SCREEN);

		}

		private function patientSlideNavHandler(e:FeathersScreenEvent):void
		{
			trace("patientSlideNavHandler " + e.message);
			patientSettingsBtnHandler();
			this._patientProfileNav = new ScreenNavigatorWithHistory();
			this._patientProfileNav.addChild(this._screenBackground);
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_PROFILE_SCREEN , new ScreenNavigatorItem(HivivaPatientProfileScreen, {navGoHome:navGoHomeFromProfileScreen}));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN, new ScreenNavigatorItem(HivivaPatientMyDetailsScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_HOMEPAGE_PHOTO_SCREEN, new ScreenNavigatorItem(HivivaPatientHomepagePhotoScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_GALLERY_SCREEN, new ScreenNavigatorItem(SportsGalleryScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_TEST_RESULTS_SCREEN, new ScreenNavigatorItem(HivivaPatientTestResultsScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_CONNECT_TO_HCP_SCREEN, new ScreenNavigatorItem(HivivaPatientConnectToHcpScreen));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_EDIT_MEDICATION_SCREEN, new ScreenNavigatorItem(HivivaPatientEditMedsScreen, null, {applicationController:_applicationController}));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_ADD_MEDICATION_SCREEN, new ScreenNavigatorItem(HivivaPatientAddMedsScreen, null, {applicationController:_applicationController}));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_USER_SIGNUP_SCREEN, new ScreenNavigatorItem(HivivaUserSignupScreen, null, {applicationController:_applicationController}));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_HELP_SCREEN, new ScreenNavigatorItem(HivivaPatientHelpScreen, {navGoHome:navGoHomeFromProfileScreen}));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_MESSAGES_SCREEN, new ScreenNavigatorItem(HivivaPatientMessagesScreen, {navGoHome:navGoHomeFromProfileScreen}));
			this._patientProfileNav.addScreen(HivivaScreens.PATIENT_BADGES_SCREEN, new ScreenNavigatorItem(HivivaPatientBagesScreen, {navGoHome:navGoHomeFromProfileScreen}));
			this.addChild(_patientProfileNav);

			this._patientProfileNav.showScreen(e.message);

			if(this._patientNav.activeScreenID == HivivaScreens.PATIENT_HOME_SCREEN) this._patientNav.clearScreen();
		}


		//place holder for main app icons and navigation
		private function initPatientFooterMenu():void
		{
			// needs own class
			var footerBtnHeight:Number = HivivaAssets.FOOTER_ICON_BASE.height * this._scaleFactor;
			var footerBtnWidth:Number = HivivaAssets.FOOTER_ICON_BASE.width * this._scaleFactor;

			this._footerBtnGroup = new ButtonGroup();
			this._footerBtnGroup.customButtonName = "home-footer-buttons";
			this._footerBtnGroup.customFirstButtonName = "home-footer-buttons";
			this._footerBtnGroup.customLastButtonName = "home-footer-buttons";

			this._footerBtnGroup.dataProvider = new ListCollection(
				[
					{ width: footerBtnWidth, height: footerBtnHeight, name: "home"},
					{ width: footerBtnWidth, height: footerBtnHeight, name: "clock"},
					{ width: footerBtnWidth, height: footerBtnHeight, name: "takemeds"},
					{ width: footerBtnWidth, height: footerBtnHeight, name: "virus"},
					{ width: footerBtnWidth, height: footerBtnHeight, name: "report"}
				]
			);

			this._footerBtnGroup.buttonInitializer = function(button:Button, item:Object):void
			{
				var img:Image;

				button.name = item.name;
				button.addEventListener(Event.TRIGGERED, footerBtnHandler);

				switch(item.name)
				{
					case "home" :
						img = new Image(HivivaAssets.FOOTER_ICON_HOME);
						button.isSelected = true;
						_currFooterBtn = button;
						_patientNav.showScreen(HivivaScreens.PATIENT_HOME_SCREEN);
						break;
					case "clock" :
						img = new Image(HivivaAssets.FOOTER_ICON_CLOCK);
						break;
					case "takemeds" :
						img = new Image(HivivaAssets.FOOTER_ICON_MEDIC);
						break;
					case "virus" :
						img = new Image(HivivaAssets.FOOTER_ICON_VIRUS);
						break;
					case "report" :
						img = new Image(HivivaAssets.FOOTER_ICON_REPORT);
						break;
				}
				img.width = item.width;
				img.height = item.height;
				button.addChild(img);
			};

			this._footerBtnGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;

			this._screenHolder.addChild(this._footerBtnGroup);
			this._footerBtnGroup.y = this._stageHeight - footerBtnHeight;
			this._footerBtnGroup.height = footerBtnHeight;
			this._footerBtnGroup.width = this._stageWidth;
		}

		private function footerBtnHandler(e:Event):void
		{
			var btn:Button = e.target as Button;
			if(!btn.isSelected)
			{
				// when refactoring to own class we can use a local property instead of storing the identifier in btn.name
				switch(btn.name.substring(0 ,btn.name.indexOf(" home-footer-buttons")))
				{
					case "home" :
						this._patientNav.showScreen(HivivaScreens.PATIENT_HOME_SCREEN);
						break;
					case "clock" :
						this._patientNav.showScreen(HivivaScreens.PATIENT_VIEW_MEDICATION_SCREEN);
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
				this._currFooterBtn.isSelected = false;
				this._currFooterBtn = e.target as Button;
				this._currFooterBtn.isSelected = true;
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

			this._patientNav.showScreen(HivivaScreens.PATIENT_HOME_SCREEN);
			this._currFooterBtn.isSelected = false;
			this._currFooterBtn = this._footerBtnGroup.getChildAt(0) as Button;
			this._currFooterBtn.isSelected = true;
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
