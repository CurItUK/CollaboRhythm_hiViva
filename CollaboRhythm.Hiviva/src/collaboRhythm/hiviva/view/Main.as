package collaboRhythm.hiviva.view
{

	import collaboRhythm.feathers.controls.ScreenNavigatorWithHistory;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.model.HivivaLocalStoreService;
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
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPSideNavigationScreen;
	import collaboRhythm.hiviva.view.screens.hcp.messages.HivivaHCPMessageCompose;
	import collaboRhythm.hiviva.view.screens.hcp.messages.HivivaHCPMessages;
	import collaboRhythm.hiviva.view.screens.patient.HivivaHCPHelpScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientBagesScreen;
	import collaboRhythm.hiviva.view.galleryscreens.SportsGalleryScreen;
	import collaboRhythm.hiviva.view.media.Assets;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientAddMedsScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientConnectToHcpScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientEditMedsScreen;
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


	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.data.ListCollection;
	import feathers.display.TiledImage;
	import feathers.motion.transitions.ScreenFadeTransitionManager;

	import flash.filesystem.File;

	import source.themes.HivivaTheme;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import starling.utils.AssetManager;

	public class Main extends Sprite
	{
		private var _screenHolder:Sprite;
		private var _screenBackground:Sprite;
		private var _feathersTheme:HivivaTheme;
		private var _mainScreenNav:ScreenNavigatorWithHistory;
		private var _settingsNav:ScreenNavigatorWithHistory;
		private var _footerBtnGroup:ButtonGroup;
		private var _settingsBtn:Button;
		private var _transitionManager:ScreenFadeTransitionManager;
		private var _applicationController:HivivaApplicationController;
		private var _appReset:Boolean = false;
		private var _settingsOpen:Boolean = false;
		private var _currFooterBtn:Button;
		private var _currMainScreenId:String;
		private var _scaleFactor:Number;
		private var _profile:String;
		private var _selectedHCPPatientProfile:Object = {};
		private var _main:Main;

		private const TRANSITION_DURATION:Number						= 0.4;
		private const SETTING_MENU_WIDTH:Number							= 177;

		private var _stageHeight:Number;
		private var _stageWidth:Number;

		private var _mainStageHeight:Number;
		private var _mainStageWidth:Number;

		private var _starlingMain:Main;

		private static var _assets:AssetManager;


		public function Main()
		{
		}

		public function initMain(assetManager:AssetManager):void
		{

			_assets = assetManager;

			this._main = this;
			this._starlingMain = this;

			trace(" rendermode " +  Starling.context.driverInfo);

			this._stageHeight = Starling.current.viewPort.height;
			this._stageWidth = Starling.current.viewPort.width;

			this._mainStageHeight = Starling.current.viewPort.height;
			this._mainStageWidth = Starling.current.viewPort.width;

			initAssetManagement();
		}

		private function initAssetManagement():void
		{
			var appDir:File = File.applicationDirectory;
			_assets.enqueue(appDir.resolvePath("assets/images/atlas/hivivaBaseImages.png"),appDir.resolvePath("assets/images/atlas/hivivaBaseImages.xml"));
			_assets.loadQueue(function onProgress(ratio:Number):void
			{
				trace("Loading Assets " + ratio);

				if (ratio == 1)
					Starling.juggler.delayCall(function ():void
					{
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
//			var isDesktop:Boolean = true;
			var isDesktop:Boolean = false;
			this._feathersTheme = new HivivaTheme(this.stage, !isDesktop);
			this._scaleFactor = isDesktop ? 1 : this._feathersTheme.scale;
		}

		private function initAppNavigator():void
		{
			this._screenHolder = new Sprite();
			this.addChild(this._screenHolder);

			this._mainScreenNav = new ScreenNavigatorWithHistory();

			this._screenHolder.addChild(this._mainScreenNav);
			this._mainScreenNav.addScreen(HivivaScreens.SPLASH_SCREEN, new ScreenNavigatorItem(HivivaSplashScreen , {complete:splashComplete},{starlingMain:starlingMain}));

			//TODO add transition manager for more powerfull devices
			//this._transitionManager = new ScreenFadeTransitionManager(_mainScreenNav);
			//this._transitionManager.ease = Transitions.EASE_OUT;
			//this._transitionManager.duration = TRANSITION_DURATION;

			this._mainScreenNav.showScreen(HivivaScreens.SPLASH_SCREEN);
		}

		private function splashComplete(e:Event):void
		{
			drawScreenBackground();
			//this._mainScreenNav.clearScreen();

			this._profile = e.data.profileType;

			this._settingsBtn = new Button();
			this._settingsBtn.name = HivivaTheme.NONE_THEMED;
			this._settingsBtn.defaultIcon = new Image(_assets.getTexture("top_nav_icon_01"));
			this._settingsBtn.addEventListener(Event.TRIGGERED , settingsBtnHandler);
			this._screenHolder.addChild(this._settingsBtn);
			this._settingsBtn.width = (this._stageWidth * 0.2);
			this._settingsBtn.scaleY = this._settingsBtn.scaleX;

			this._settingsNav = new ScreenNavigatorWithHistory();
			this.addChild(this._settingsNav);

			switch(this._profile)
			{
				case HivivaLocalStoreService.USER_APP_TYPE_HCP :
					initHCPSettingsNavigator();
					initHCPNavigator();
					break;

				case HivivaLocalStoreService.USER_APP_TYPE_PATIENT :
					initPatientSettingsNavigator();
					initPatientNavigator();
					break;
			}
		}

		protected function drawScreenBackground():void
		{
			this._screenBackground = new Sprite();

			//var screenBase:TiledImage = new TiledImage(Assets.getTexture(HivivaAssets.SCREEN_BASE));
			var screenBase:TiledImage = new TiledImage(_assets.getTexture("screen_base"));//new TiledImage(hivivaAtlas.getTexture("screen_base"));

			screenBase.width = mainStageWidth;
			screenBase.height = mainStageHeight;
			screenBase.smoothing = TextureSmoothing.NONE;
			//screenBase.flatten();
			this._screenBackground.addChild(screenBase);

			//var topGrad:TiledImage = new TiledImage(Assets.getTexture(HivivaAssets.SCREEN_BASE_TOP_GRADIENT));
			var topGrad:TiledImage = new TiledImage(_assets.getTexture("top_gradient"));
			//topGrad.touchable = false;
			topGrad.width = mainStageWidth;
			topGrad.smoothing = TextureSmoothing.NONE;
			topGrad.blendMode = BlendMode.MULTIPLY;
			//topGrad.flatten();
			this._screenBackground.addChild(topGrad);

			//var bottomGrad:TiledImage = new TiledImage(Assets.getTexture(HivivaAssets.SCREEN_BASE_BOTTOM_GRADIENT));
			var bottomGrad:TiledImage = new TiledImage(_assets.getTexture("bottom_gradient"));
			//bottomGrad.touchable = false;
			bottomGrad.width = mainStageWidth;
			bottomGrad.y = mainStageHeight - bottomGrad.height;
			bottomGrad.smoothing = TextureSmoothing.NONE;
			bottomGrad.blendMode = BlendMode.MULTIPLY;
			//bottomGrad.flatten();
			this._screenBackground.addChild(bottomGrad);

			//var settingEffect:TiledImage = new TiledImage(Assets.getTexture(HivivaAssets.SETTING_EFFECT));
			var settingEffect:TiledImage = new TiledImage(_assets.getTexture("settings_above_effect"));
			//settingEffect.touchable = false;
			settingEffect.name = "settingEffect";
			settingEffect.height = mainStageHeight;
			settingEffect.x = 1 - settingEffect.width;
			settingEffect.smoothing = TextureSmoothing.NONE;
			settingEffect.blendMode = BlendMode.MULTIPLY;
			this._screenBackground.addChild(settingEffect);
			this._screenBackground.flatten();
			this._screenBackground.touchable = false;

			this._mainScreenNav.addChildAt(this._screenBackground , 0);

		}


		private function settingsBtnHandler(e:Event = null):void
		{
			var xLoc:Number = _settingsOpen ? 0 : SETTING_MENU_WIDTH;

			var settingsTween:Tween = new Tween(this._screenHolder , 0.2 , Transitions.EASE_OUT);
			settingsTween.animate("x" , xLoc);
			settingsTween.onComplete = function():void{_settingsOpen = !_settingsOpen;} ;
			Starling.juggler.add(settingsTween);
		}

		private function initPatientNavigator():void
		{
			initPatientFooterMenu();

			if(!this._appReset)
			{
				var patientSideNavScreen:HivivaPatientSideNavScreen = new HivivaPatientSideNavScreen(SETTING_MENU_WIDTH, this._scaleFactor);
				patientSideNavScreen.addEventListener(FeathersScreenEvent.NAVIGATE_AWAY , settingsNavHandler);
				this.addChildAt(patientSideNavScreen , 0);

				this._mainScreenNav.addScreen(HivivaScreens.PATIENT_HOME_SCREEN, new ScreenNavigatorItem(HivivaPatientHomeScreen, {navGoSettings:navGoSettings}, {applicationController:_applicationController , footerHeight:this._footerBtnGroup.height}));
				this._mainScreenNav.addScreen(HivivaScreens.PATIENT_VIEW_MEDICATION_SCREEN, new ScreenNavigatorItem(HivivaPatientViewMedicationScreen , null , {applicationController:_applicationController , footerHeight:this._footerBtnGroup.height}));
				this._mainScreenNav.addScreen(HivivaScreens.PATIENT_MEDICATION_SCREEN, new ScreenNavigatorItem(HivivaPatientTakeMedsScreen , null , {applicationController:_applicationController,footerHeight:this._footerBtnGroup.height}));
				this._mainScreenNav.addScreen(HivivaScreens.PATIENT_VIRUS_MODEL_SCREEN, new ScreenNavigatorItem(HivivaPatientVirusModelScreen, null, {applicationController:_applicationController , footerHeight:this._footerBtnGroup.height}));
				this._mainScreenNav.addScreen(HivivaScreens.PATIENT_REPORTS_SCREEN, new ScreenNavigatorItem(HivivaPatientReportsScreen, null, {applicationController:_applicationController , footerHeight:this._footerBtnGroup.height}));

			}
		}

		private function initHCPNavigator():void
		{
			initHcpFooterMenu();

			if(!this._appReset)
			{
				var hcpSideNavScreen:HivivaHCPSideNavigationScreen = new HivivaHCPSideNavigationScreen(SETTING_MENU_WIDTH, this._scaleFactor);
				hcpSideNavScreen.addEventListener(FeathersScreenEvent.NAVIGATE_AWAY , settingsNavHandler);
				this.addChildAt(hcpSideNavScreen , 0);

				this._mainScreenNav.addScreen(HivivaScreens.HCP_HOME_SCREEN, new ScreenNavigatorItem(HivivaHCPHomesScreen, {mainToSubNav:navigateToDirectProfileMenu}, {applicationController:_applicationController , footerHeight:this._footerBtnGroup.height}));
				this._mainScreenNav.addScreen(HivivaScreens.HCP_ADHERENCE_SCREEN, new ScreenNavigatorItem(HivivaHCPAllPatientsAdherenceScreen));
				this._mainScreenNav.addScreen(HivivaScreens.HCP_REPORTS_SCREEN, new ScreenNavigatorItem(HivivaHCPReportsScreen, null, {applicationController:_applicationController , footerHeight:this._footerBtnGroup.height}));
				this._mainScreenNav.addScreen(HivivaScreens.HCP_MESSAGE_SCREEN, new ScreenNavigatorItem(HivivaHCPMessages ,  {mainToSubNav:navigateToDirectProfileMenu} , {applicationController:_applicationController , footerHeight:this._footerBtnGroup.height}));

				// add listeners for homepage user signup check, to hide / show the footer and settings button
				addEventListener(FeathersScreenEvent.HIDE_MAIN_NAV, hideMainNav);
				addEventListener(FeathersScreenEvent.SHOW_MAIN_NAV, showMainNav);
			}
		}

		private function initHCPSettingsNavigator():void
		{
			this._settingsNav.addScreen(HivivaScreens.HCP_PROFILE_SCREEN, new ScreenNavigatorItem(HivivaHCPProfileScreen, {navGoHome:goBackToMainScreen}, {applicationController:_applicationController}));
			this._settingsNav.addScreen(HivivaScreens.HCP_HELP_SCREEN, new ScreenNavigatorItem(HivivaHCPHelpScreen, {navGoHome:goBackToMainScreen}));
			this._settingsNav.addScreen(HivivaScreens.HCP_EDIT_PROFILE, new ScreenNavigatorItem(HivivaHCPEditProfile, null, {applicationController:_applicationController}));
			this._settingsNav.addScreen(HivivaScreens.HCP_DISPLAY_SETTINGS, new ScreenNavigatorItem(HivivaHCPDisplaySettings, null, {applicationController:_applicationController}));
			this._settingsNav.addScreen(HivivaScreens.HCP_ALERT_SETTINGS, new ScreenNavigatorItem(HivivaHCPAlertSettings, null, {applicationController:_applicationController}));
			this._settingsNav.addScreen(HivivaScreens.HCP_CONNECT_PATIENT, new ScreenNavigatorItem(HivivaHCPConnectToPatientScreen, null, {applicationController:_applicationController}));
			this._settingsNav.addScreen(HivivaScreens.HCP_ADD_PATIENT, new ScreenNavigatorItem(HivivaHCPAddPatientScreen));
			this._settingsNav.addScreen(HivivaScreens.HCP_PATIENT_PROFILE, new ScreenNavigatorItem(HivivaHCPPatientProfileScreen, {navGoHome:goBackToMainScreen},{applicationController:_applicationController , main:main}));
			this._settingsNav.addScreen(HivivaScreens.HCP_MESSAGE_COMPOSE_SCREEN, new ScreenNavigatorItem(HivivaHCPMessageCompose, {navGoHome:goBackToMainScreen},{applicationController:_applicationController}));
//			this._settingsNav.addScreen(HivivaScreens.HCP_MESSAGES_SENT_SCREEN, new ScreenNavigatorItem(HivivaHCPMessagesSent, {navGoHome:goBackToMainScreen},{applicationController:_applicationController}));


		}

		private function initPatientSettingsNavigator():void
		{
			this._settingsNav.addScreen(HivivaScreens.PATIENT_PROFILE_SCREEN , new ScreenNavigatorItem(HivivaPatientProfileScreen, {navGoHome:goBackToMainScreen}, {applicationController:_applicationController}));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN, new ScreenNavigatorItem(HivivaPatientMyDetailsScreen, null, {applicationController:_applicationController}));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_HOMEPAGE_PHOTO_SCREEN, new ScreenNavigatorItem(HivivaPatientHomepagePhotoScreen, null, {applicationController:_applicationController}));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_GALLERY_SCREEN, new ScreenNavigatorItem(SportsGalleryScreen));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_TEST_RESULTS_SCREEN, new ScreenNavigatorItem(HivivaPatientTestResultsScreen));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_CONNECT_TO_HCP_SCREEN, new ScreenNavigatorItem(HivivaPatientConnectToHcpScreen));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_EDIT_MEDICATION_SCREEN, new ScreenNavigatorItem(HivivaPatientEditMedsScreen, null, {applicationController:_applicationController}));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_ADD_MEDICATION_SCREEN, new ScreenNavigatorItem(HivivaPatientAddMedsScreen, null, {applicationController:_applicationController}));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_USER_SIGNUP_SCREEN, new ScreenNavigatorItem(HivivaPatientUserSignupScreen, null, {applicationController:_applicationController}));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_HELP_SCREEN, new ScreenNavigatorItem(HivivaPatientHelpScreen, {navGoHome:goBackToMainScreen}));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_MESSAGES_SCREEN, new ScreenNavigatorItem(HivivaPatientMessagesScreen, {navGoHome:goBackToMainScreen}, {applicationController:_applicationController}));
			this._settingsNav.addScreen(HivivaScreens.PATIENT_BADGES_SCREEN, new ScreenNavigatorItem(HivivaPatientBagesScreen, {navGoHome:goBackToMainScreen}, {applicationController:_applicationController}));
		}

		private function navigateToDirectProfileMenu(e:Event):void
		{
			if(e.data.patientName != null)
			{
				selectedHCPPatientProfile.name = e.data.patientName;
				selectedHCPPatientProfile.appID = e.data.appID;
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

		private function settingsNavHandler(e:FeathersScreenEvent, mainToSubmenuDirect:Boolean = false):void
		{
			trace("settingsNavHandler " + e.message);

			// TODO : what is the purpose of this boolean?
			/*if(!mainToSubmenuDirect)
			{
				settingsBtnHandler();
			}*/
			if(_settingsOpen) settingsBtnHandler();

			if(!this._settingsNav.contains(this._screenBackground)) this._settingsNav.addChild(this._screenBackground);
			this._settingsNav.showScreen(e.message);
			//this._currMainScreenId = this._mainScreenNav.activeScreenID;
			this._currMainScreenId = this._profile == HivivaLocalStoreService.USER_APP_TYPE_HCP ? HivivaScreens.HCP_HOME_SCREEN : HivivaScreens.PATIENT_HOME_SCREEN;
			this._mainScreenNav.clearScreen();
		}

		//place holder for main app icons and navigation
		private function initPatientFooterMenu():void
		{
			// needs own class
			var footerBtnHeight:Number = _assets.getTexture("footer_icon_base").height * this._scaleFactor;
			var footerBtnWidth:Number = _assets.getTexture("footer_icon_base").width * this._scaleFactor;

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
				button.addEventListener(Event.TRIGGERED, patientFooterBtnHandler);

				switch(item.name)
				{
					case "home" :
						img = new Image(_assets.getTexture("footer_icon_1"));
						button.isSelected = true;
						_currFooterBtn = button;
						_mainScreenNav.showScreen(HivivaScreens.PATIENT_HOME_SCREEN);
						break;
					case "clock" :
						img = new Image(_assets.getTexture("footer_icon_2"));
						break;
					case "takemeds" :
						img = new Image(_assets.getTexture("footer_icon_3"));
						break;
					case "virus" :
						img = new Image(_assets.getTexture("footer_icon_4"));
						break;
					case "report" :
						img = new Image(_assets.getTexture("footer_icon_5"));
						break;
				}

				button.defaultIcon = img;
			};

			this._footerBtnGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;

			this._screenHolder.addChild(this._footerBtnGroup);
			this._footerBtnGroup.y = this._stageHeight - footerBtnHeight;
			this._footerBtnGroup.height = footerBtnHeight;
			this._footerBtnGroup.width = this._stageWidth;
		}

		private function patientFooterBtnHandler(e:Event):void
		{
			var btn:Button = e.target as Button;
			if(!btn.isSelected)
			{
				// when refactoring to own class we can use a local property instead of storing the identifier in btn.name
				switch(btn.name.substring(0 ,btn.name.indexOf(" home-footer-buttons")))
				{
					case "home" :
						this._mainScreenNav.showScreen(HivivaScreens.PATIENT_HOME_SCREEN);
						break;
					case "clock" :
						this._mainScreenNav.showScreen(HivivaScreens.PATIENT_VIEW_MEDICATION_SCREEN);
						break;
					case "takemeds" :
						this._mainScreenNav.showScreen(HivivaScreens.PATIENT_MEDICATION_SCREEN);
						break;
					case "virus" :
						this._mainScreenNav.showScreen(HivivaScreens.PATIENT_VIRUS_MODEL_SCREEN);
						break;
					case "report" :
						this._mainScreenNav.showScreen(HivivaScreens.PATIENT_REPORTS_SCREEN);
						break;
				}
				this._currFooterBtn.isSelected = false;
				this._currFooterBtn = e.target as Button;
				this._currFooterBtn.isSelected = true;
			}
		}

		//place holder for main app icons and navigation
		private function initHcpFooterMenu():void
		{
			// needs own class
			var footerBtnHeight:Number = assets.getTexture("footer_icon_base").height * this._scaleFactor;
			var footerBtnWidth:Number = assets.getTexture("footer_icon_base").width * this._scaleFactor;

			this._footerBtnGroup = new ButtonGroup();
			this._footerBtnGroup.customButtonName = "home-footer-buttons";
			this._footerBtnGroup.customFirstButtonName = "home-footer-buttons";
			this._footerBtnGroup.customLastButtonName = "home-footer-buttons";

			this._footerBtnGroup.dataProvider = new ListCollection(
				[
					{ width: footerBtnWidth, height: footerBtnHeight, name: "home"},
					{ width: footerBtnWidth, height: footerBtnHeight, name: "adherence"},
					{ width: footerBtnWidth, height: footerBtnHeight, name: "reports"},
					{ width: footerBtnWidth, height: footerBtnHeight, name: "messages"}
				]
			);

			this._footerBtnGroup.buttonInitializer = function(button:Button, item:Object):void
			{
				var img:Image;

				button.name = item.name;
				button.addEventListener(Event.TRIGGERED, hcpFooterBtnHandler);

				switch(item.name)
				{
					case "home" :
						img = new Image(assets.getTexture("footer_icon_1"));
						button.isSelected = true;
						_currFooterBtn = button;
						_mainScreenNav.showScreen(HivivaScreens.HCP_HOME_SCREEN);
						break;
					case "adherence" :
						img = new Image(assets.getTexture("footer_icon_6"));
						break;
					case "reports" :
						img = new Image(assets.getTexture("footer_icon_3"));
						break;
					case "messages" :
						img = new Image(assets.getTexture("footer_icon_7"));
						break;
				}

				button.defaultIcon = img;
			};

			this._footerBtnGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;

			this._screenHolder.addChild(this._footerBtnGroup);
			this._footerBtnGroup.y = this._stageHeight - footerBtnHeight;
			this._footerBtnGroup.height = footerBtnHeight;
			this._footerBtnGroup.width = this._stageWidth;
		}

		private function hcpFooterBtnHandler(e:Event):void
		{
			var btn:Button = e.target as Button;
			if(!btn.isSelected)
			{
				// when refactoring to own class we can use a local property instead of storing the identifier in btn.name
				switch(btn.name.substring(0 ,btn.name.indexOf(" home-footer-buttons")))
				{
					case "home" :
						this._mainScreenNav.showScreen(HivivaScreens.HCP_HOME_SCREEN);
						break;
					case "adherence" :
						this._mainScreenNav.showScreen(HivivaScreens.HCP_ADHERENCE_SCREEN);
						break;
					case "reports" :
						this._mainScreenNav.showScreen(HivivaScreens.HCP_REPORTS_SCREEN);
						break;
					case "messages" :
						this._mainScreenNav.showScreen(HivivaScreens.HCP_MESSAGE_SCREEN);
						break;
				}
				this._currFooterBtn.isSelected = false;
				this._currFooterBtn = e.target as Button;
				this._currFooterBtn.isSelected = true;
			}
		}

		private function goBackToMainScreen():void
		{
			this._settingsNav.clearScreen();
			this._mainScreenNav.addChild(this._screenBackground);

			this._mainScreenNav.showScreen(this._currMainScreenId);
			// currently goes back to home screen so select first button on footer menu
			this._currFooterBtn.isSelected = false;
			this._currFooterBtn = this._footerBtnGroup.getChildAt(0) as Button;
			this._currFooterBtn.isSelected = true;
		}

		private function hideMainNav(e:FeathersScreenEvent):void
		{
			this._settingsBtn.touchable = false;
			this._settingsBtn.visible = false;

			this._footerBtnGroup.touchable = false;
			this._footerBtnGroup.visible = false;
		}

		private function showMainNav(e:FeathersScreenEvent):void
		{
			this._settingsBtn.touchable = true;
			this._settingsBtn.visible = true;

			this._footerBtnGroup.touchable = true;
			this._footerBtnGroup.visible = true;
		}

		private function navGoBack():void
		{
			_mainScreenNav.goBack();
		}

		private function resetAppSettings():void
		{
			applicationController.hivivaLocalStoreController.resetApplication();
			this._appReset = true;
			this._mainScreenNav.clearHistory();
			this._mainScreenNav.showScreen(HivivaScreens.SPLASH_SCREEN);
		}

		public function get starlingMain():Main
		{
			return this._starlingMain;
		}

		public function get mainStageHeight():Number
		{
			return this._mainStageHeight;
		}

		public function get mainStageWidth():Number
		{
			return this._mainStageWidth;
		}

		public function get applicationController():HivivaApplicationController
		{
			return _applicationController;
		}

		public function set applicationController(value:HivivaApplicationController):void
		{
			_applicationController = value;
		}

		public function set selectedHCPPatientProfile(patient:Object):void
		{
			this._selectedHCPPatientProfile = patient;
		}

		public function get selectedHCPPatientProfile():Object
		{
			return this._selectedHCPPatientProfile;
		}

		public function get main():Main
		{
			return this._main;
		}

		public static function get assets():AssetManager
		{
			return _assets;
		}
	}
}
