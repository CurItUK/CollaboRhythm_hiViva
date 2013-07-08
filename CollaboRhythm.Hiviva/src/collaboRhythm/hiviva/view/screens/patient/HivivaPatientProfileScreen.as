package collaboRhythm.hiviva.view.screens.patient
{

	import collaboRhythm.hiviva.global.HivivaThemeConstants;
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

		private var _scaledPadding:Number;

		public function HivivaPatientProfileScreen()
		{
		}

		override protected function draw():void
		{
			super.draw();

			this._scaledPadding = (this.actualWidth * 0.04) * this.dpiScale;

			this._header.width = this.actualWidth;
			this._header.paddingLeft = this._scaledPadding;
			this._header.initTrueTitle();
			drawMenuBtnGroup();

			this._appIdLabel.validate();
			this._appIdLabel.x = this._scaledPadding;
			this._appIdLabel.y = this._menuBtnGroup.y + this._menuBtnGroup.height + this._scaledPadding;

			this._appId.validate();
			this._appId.x = this.actualWidth - this._scaledPadding - this._appId.width;
			this._appId.y = this._appIdLabel.y;

			/*
			this._userSignupPopupContent.width = this.actualWidth * 0.75;
			this._userSignupPopupContent.validate();
			*/


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
			this._appIdLabel.name = HivivaThemeConstants.APPID_LABEL;
			this._appIdLabel.text = "Your app ID";
			addChild(this._appIdLabel);

			this._appId = new Label();
			this._appId.name = HivivaThemeConstants.APPID_LABEL;
			this._appId.text = HivivaStartup.userVO.appId;
			addChild(this._appId);

			initProfileMenuButtons();

			/*
			this._userSignupPopupContent = new HivivaPopUp();
			this._userSignupPopupContent.scale = this.dpiScale;
			this._userSignupPopupContent.message = "You will need to create an account in order to connect to a care provider";
			this._userSignupPopupContent.confirmLabel = "Sign up";
			this._userSignupPopupContent.addEventListener(Event.COMPLETE, userSignupScreen);
			this._userSignupPopupContent.addEventListener(Event.CLOSE, closePopup);

			userSignupCheck();
			*/
		}

		/*
		private function userSignupCheck():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.PATIENT_PROFILE_LOAD_COMPLETE, getPatientProfileHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.getPatientProfile();
		}

		private function getPatientProfileHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.PATIENT_PROFILE_LOAD_COMPLETE, getPatientProfileHandler);

			var patientProfile:Array = e.data.patientProfile;

			try
			{
				this._userIsSignedUp = patientProfile != null;
			}
			catch(e:Error)
			{
				this._userIsSignedUp = false;
			}
			trace("this._userIsSignedUp = " + this._userIsSignedUp);
		}
		*/

			private function initProfileMenuButtons():void
		{
			var lc:ListCollection = new ListCollection(
				[
					{name: "photo", label: "Home page photo"},
					{name: "medicines", label: "Daily medicines"},
					{name: "results", label: "Test results"},
					{name: "connect", label: "Connect to care provider"},
					{name: "settings", label: "Application settings"}

				]
			);

			if (this._userIsSignedUp) lc.addItemAt({name: "details", label: "My details"}, 0);

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
			switch(btn.name.substring(0 ,btn.name.indexOf(" patient-profile-nav-buttons")))
			{
				case "details" :
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
				case "connect" :
					this.owner.showScreen(HivivaScreens.PATIENT_CONNECT_TO_HCP_SCREEN);
					/*
					if (this._userIsSignedUp)
					{
						this.owner.showScreen(HivivaScreens.PATIENT_CONNECT_TO_HCP_SCREEN);
					}
					else
					{
						showSignupPopup();
					}
					*/
					break;
			}
		}

		private function homeBtnHandler(e:Event):void
		{
			this.dispatchEventWith("navGoHome");
		}


		/*
		private function showSignupPopup():void
		{
			PopUpManager.addPopUp(this._userSignupPopupContent,true,true);
			this._userSignupPopupContent.validate();
			PopUpManager.centerPopUp(this._userSignupPopupContent);
			// draw close button post center so the centering works correctly
			this._userSignupPopupContent.drawCloseButton();
		}

		private function userSignupScreen(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN);
			PopUpManager.removePopUp(this._userSignupPopupContent);
			trace("open PATIENT_USER_SIGNUP_SCREEN");
		}

		private function closePopup(e:Event):void
		{
			PopUpManager.removePopUp(this._userSignupPopupContent);
		}
		*/

		override public function dispose():void
		{
			super.dispose();
			this.removeChild(this._menuBtnGroup);
			this._menuBtnGroup.dispose();
			this._menuBtnGroup = null;
			trace("HivivaPatientProfileScreen dispose");
		}
	}
}
