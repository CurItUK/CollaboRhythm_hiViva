package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Screen;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.display.TiledImage;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.filesystem.File;

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

		public function HivivaPatientProfileScreen()
		{
		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			drawMenuBtnGroup();

			this._userSignupPopupContent.width = 500 * dpiScale;
			this._userSignupPopupContent.validate();
		}

		private function drawMenuBtnGroup():void
		{
			this._menuBtnGroup.validate();
			this._menuBtnGroup.width = this.actualWidth;
			this._menuBtnGroup.y = this._header.height + (30 * this.dpiScale);

			for (var i:int = 0; i < _tilesInBtns.length; i++)
			{
				var img:TiledImage = _tilesInBtns[i];
				img.width = this.actualWidth;
			}
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Patient Profile";

			this._homeBtn = new Button();
			this._homeBtn.nameList.add("home-button");
			this._homeBtn.addEventListener(Event.TRIGGERED , homeBtnHandler);

			this._header.leftItems =  new <DisplayObject>[this._homeBtn];

			initProfileMenuButtons();
			addChild(this._header);

			this._userSignupPopupContent = new HivivaPopUp();
			this._userSignupPopupContent.scale = this.dpiScale;
			this._userSignupPopupContent.message = "You will need to create an account in order to connect to a care provider";
			this._userSignupPopupContent.confirmLabel = "Sign up";
			this._userSignupPopupContent.addEventListener(Event.COMPLETE, userSignupScreen);
			this._userSignupPopupContent.addEventListener(Event.CLOSE, closePopup);
		}

		private function initProfileMenuButtons():void
		{
			this._tilesInBtns = new <TiledImage>[];
			this._menuBtnGroup = new ButtonGroup();
			this._menuBtnGroup.customButtonName = "patient-profile-nav-buttons";
			this._menuBtnGroup.customFirstButtonName = "patient-profile-nav-buttons";
			this._menuBtnGroup.customLastButtonName = "patient-profile-nav-buttons";
			this._menuBtnGroup.dataProvider = new ListCollection(
				[
					{name: "details", label: "My details"},
					{name: "photo", label: "Home page photo"},
					{name: "medicines", label: "Daily medicines"},
					{name: "results", label: "Test results"},
					{name: "connect", label: "Connect to care provider"}
				]
			);
			this._menuBtnGroup.buttonInitializer = function(button:Button, item:Object):void
			{
				var img:TiledImage = new TiledImage(HivivaAssets.PATIENTPROFILENAV_BUTTON_PATTERN);
				img.smoothing = TextureSmoothing.NONE;
				img.blendMode =  BlendMode.MULTIPLY;
				button.addChild(img);
				// add to Vector to assign width post draw
				_tilesInBtns.push(img);

				button.name = item.name;
				button.label =  item.label;
				button.addEventListener(Event.TRIGGERED, patientProfileBtnHandler)
			};
			this._menuBtnGroup.direction = ButtonGroup.DIRECTION_VERTICAL;

			this.addChild(this._menuBtnGroup);
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
				case "results" :
					this.owner.showScreen(HivivaScreens.PATIENT_TEST_RESULTS_SCREEN);
					break;
				case "connect" :
					userSignupCheck();
					break;
			}
		}

		private function homeBtnHandler(e:Event):void
		{
			this.dispatchEventWith("navGoHome");
		}

		private function userSignupCheck():void
		{
			var isUserSignedUp:Boolean = false;
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			var _sqConn:SQLConnection = new SQLConnection();
			_sqConn.open(dbFile);

			var _sqStatement:SQLStatement = new SQLStatement();
			_sqStatement.text = "SELECT * FROM connect_user_details";
			_sqStatement.sqlConnection = _sqConn;
			_sqStatement.execute();

			var sqlRes:SQLResult = _sqStatement.getResult();
			//trace(sqlRes.data[0].user_name);
			//trace(sqlRes.data[0].user_email);
			//trace(sqlRes.data[0].user_updates);
			//trace(sqlRes.data[0].user_research);

			try
			{
				isUserSignedUp = String(sqlRes.data[0].user_name).length > 0;
			}
			catch(e:Error)
			{
				isUserSignedUp = false;
			}

			if(isUserSignedUp)
			{
				trace("user is signed up");
				this.owner.showScreen(HivivaScreens.PATIENT_CONNECT_TO_HCP_SCREEN);
			}
			else
			{
				trace("user is not signed up");
				showSignupPopup();
			}
			//showSignupPopup();
		}

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
			this.owner.showScreen(HivivaScreens.PATIENT_USER_SIGNUP_SCREEN);
			PopUpManager.removePopUp(this._userSignupPopupContent);
			trace("open PATIENT_USER_SIGNUP_SCREEN");
		}

		private function closePopup(e:Event):void
		{
			PopUpManager.removePopUp(this._userSignupPopupContent);
		}
	}
}
