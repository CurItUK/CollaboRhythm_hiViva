package collaboRhythm.hiviva.view.screens.patient
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.display.TiledImage;


	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;


	public class HivivaPatientProfileScreen extends Screen
	{

		private var _header:HivivaHeader;
		private var _homeBtn:Button;
		private var _menuBtnGroup:ButtonGroup;
		private var _userSignupPopupContent:HivivaPopUp;
		private var _tilesInBtns:Vector.<TiledImage>;
		private var _appIdLabel:Label;
		private var _appId:Label;
		private var _userIsSignedUp:Boolean;
		private var _remoteCallMade:Boolean;

		public function HivivaPatientProfileScreen()
		{
		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = Constants.STAGE_WIDTH;
			this._header.paddingLeft = Constants.HEADER_HOMEBTN_PADDING;
			this._header.initTrueTitle();

			this._userSignupPopupContent.width = this.actualWidth * 0.75;
			this._userSignupPopupContent.validate();

			if(!this._remoteCallMade)
			{
				userSignupCheck();
			}
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Patient Profile";
			addChild(this._header);

			this._homeBtn = new Button();
			this._homeBtn.name = HivivaThemeConstants.HOME_BUTTON;
			this._homeBtn.addEventListener(Event.TRIGGERED , homeBtnHandler);

			this._header.leftItems =  new <DisplayObject>[this._homeBtn];

			this._tilesInBtns = new <TiledImage>[];
			this._menuBtnGroup = new ButtonGroup();
			this._menuBtnGroup.customButtonName = "patient-profile-nav-buttons";
			this._menuBtnGroup.customFirstButtonName = "patient-profile-nav-buttons";
			this._menuBtnGroup.customLastButtonName = "patient-profile-nav-buttons";
			addChild(this._menuBtnGroup);

			this._appIdLabel = new Label();
			this._appIdLabel.visible = false;
			this._appIdLabel.name = HivivaThemeConstants.APPID_LABEL;
			this._appIdLabel.text = "Your app ID";
			addChild(this._appIdLabel);

			this._appId = new Label();
			this._appId.visible = false;
			this._appId.name = HivivaThemeConstants.APPID_LABEL;
			this._appId.text = HivivaStartup.userVO.appId;
			addChild(this._appId);

			this._userSignupPopupContent = new HivivaPopUp();
			this._userSignupPopupContent.scale = this.dpiScale;
			this._userSignupPopupContent.message = "You will need to create an account in order to connect to a care provider";
			this._userSignupPopupContent.buttons = ["Sign up"];
			this._userSignupPopupContent.addEventListener(Event.TRIGGERED, userSignupPopupHandler);
		}

		private function userSignupCheck():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_COMPLETE , getPatientCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatient(HivivaStartup.userVO.appId);
			this._remoteCallMade = true;
		}

		private function getPatientCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_COMPLETE , getPatientCompleteHandler);

			var firstName:String = e.data.xmlResponse.FirstName;
			var lastName:String = e.data.xmlResponse.LastName;

			this._userIsSignedUp = (firstName.length > 0 && lastName.length > 0);

			trace("this._userIsSignedUp = " + this._userIsSignedUp);
			initProfileMenuButtons();
		}

			private function initProfileMenuButtons():void
		{
			var lc:ListCollection = new ListCollection(
				[
//					{name: "details", label: "Edit profile"},
					{name: "photo", label: "Homepage photo"},
					{name: "medicines", label: "Daily medicines"},
					{name: "results", label: "Test results"},
					{name: "connect", label: "Connect to care provider"},
					{name: "settings", label: "Application settings"},
					{name: "passcode", label: "Passcode lock"}

				]
			);

			if (this._userIsSignedUp) lc.addItemAt({name: "details", label: "Edit profile"}, 0);

			this._menuBtnGroup.dataProvider = lc;
			this._menuBtnGroup.buttonInitializer = patientProfileBtnInitializer;
			this._menuBtnGroup.direction = ButtonGroup.DIRECTION_VERTICAL;

			drawMenuBtnGroup();
		}

		private function drawMenuBtnGroup():void
		{
			this._menuBtnGroup.width = this.actualWidth;
			this._menuBtnGroup.y = this._header.height;
			this._menuBtnGroup.validate();

			var patternHeight:Number = Button(this._menuBtnGroup.getChildAt(0)).height;
			for (var i:int = 0; i < _tilesInBtns.length; i++)
			{
				var img:TiledImage = _tilesInBtns[i];
				img.width = this.actualWidth;
				img.height = patternHeight;
			}
			drawAppid();
		}

		private function drawAppid():void
		{
			var menuBtn:Button = this._menuBtnGroup.getChildAt(0) as Button;

			this._appIdLabel.validate();
//			this._appIdLabel.x = Constants.PADDING_LEFT;
			this._appIdLabel.x = menuBtn.paddingLeft;
			this._appIdLabel.y = this._menuBtnGroup.y + this._menuBtnGroup.height + Constants.PADDING_TOP;
			this._appIdLabel.visible = true;

			this._appId.validate();
			this._appId.x = this.actualWidth - menuBtn.paddingLeft - this._appId.width;
			this._appId.y = this._appIdLabel.y;
			this._appId.visible = true;
		}

		private function patientProfileBtnInitializer(button:Button, item:Object):void
		{
			var img:TiledImage = new TiledImage(Main.assets.getTexture("patient-profile-nav-button-pattern"));
			img.smoothing = TextureSmoothing.NONE;
			img.blendMode =  BlendMode.MULTIPLY;
			button.addChild(img);
			// add to Vector to assign width post draw
			_tilesInBtns.push(img);

			button.name = item.name;
			button.label =  item.label;
			button.addEventListener(Event.TRIGGERED, patientProfileBtnHandler)
		}

		private function patientProfileBtnHandler(e:Event):void
		{
			var btn:Button = e.target as Button;

			// when refactoring to own class we can use a local instance instead of storing the identifier in btn.name
			switch(btn.name)
			{
				case "details" :
					Main.parentOfPatientMyDetailsScreen = owner.activeScreenID;
					this.owner.showScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN);
					break;
				case "photo" :
					this.owner.showScreen(HivivaScreens.PATIENT_HOMEPAGE_PHOTO_SCREEN);
					break;
				case "medicines" :
					this.owner.showScreen(HivivaScreens.PATIENT_EDIT_MEDICATION_SCREEN);
					break;
				case "settings" :
					this.owner.showScreen(HivivaScreens.PATIENT_EDIT_SETTINGS_SCREEN);
					break;
				case "results" :
					this.owner.showScreen(HivivaScreens.PATIENT_TEST_RESULTS_SCREEN);
					break;
				case "passcode" :
					this.owner.showScreen(HivivaScreens.PASSCODE_LOCK_SCREEN);
					break;
				case "connect" :
//					this.owner.showScreen(HivivaScreens.PATIENT_CONNECT_TO_HCP_SCREEN);
					if (this._userIsSignedUp)
					{
						this.owner.showScreen(HivivaScreens.PATIENT_CONNECT_TO_HCP_SCREEN);
					}
					else
					{
						showSignupPopup();
					}
					break;
			}
		}

		private function homeBtnHandler(e:Event):void
		{
			this.dispatchEventWith("navGoHome");
		}

		private function showSignupPopup():void
		{
			PopUpManager.addPopUp(this._userSignupPopupContent,true,true);
			this._userSignupPopupContent.validate();
			PopUpManager.centerPopUp(this._userSignupPopupContent);
			// draw close button post center so the centering works correctly
			this._userSignupPopupContent.drawCloseButton();
		}

		private function userSignupPopupHandler(e:Event):void
		{
			var btn:String = e.data.button as String;
			switch(btn)
			{
				case "Sign up" :
					Main.parentOfPatientMyDetailsScreen = owner.activeScreenID;
					this.owner.showScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN);
				case "Close" :
					PopUpManager.removePopUp(this._userSignupPopupContent);
					break;
			}
		}

		override public function dispose():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_COMPLETE , getPatientCompleteHandler);
			super.dispose();
			this.removeChild(this._menuBtnGroup);
			this._menuBtnGroup.dispose();
			this._menuBtnGroup = null;
			trace("HivivaPatientProfileScreen dispose");
		}
	}
}
