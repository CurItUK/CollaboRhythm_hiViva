package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.display.TiledImage;
	import feathers.layout.VerticalLayout;
	import feathers.layout.ViewPortBounds;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.filesystem.File;

	import starling.display.BlendMode;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;

	import starling.events.Event;
	import starling.textures.TextureSmoothing;


	public class HivivaPatientProfileScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _menuBtnGroup:ButtonGroup;
		private var _userSignupPopup:VerticalCenteredPopUpContentManager;
		private var _userSignupPopupContent:FeathersControl;
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
			drawPopupContent();
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

			var homeBtn:Button = new Button();
			homeBtn.nameList.add("home-button");
			homeBtn.addEventListener(Event.TRIGGERED , homeBtnHandler);

			this._header.leftItems =  new <DisplayObject>[homeBtn];

			initProfileMenuButtons();
			addChild(this._header);

			initPopupContent();

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
				var img:TiledImage = new TiledImage(Assets.getTexture("PatientProfileNavButtonPatternPng"));
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
/*

		private function myDetailsBtnHandler():void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN);
		}

		private function homepagePhotoBtnHandler():void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_HOMEPAGE_PHOTO_SCREEN);
		}

		private function testResultsBtnHandler():void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_TEST_RESULTS_SCREEN);
		}

		private function connectToHcpBtnHandler():void
		{
			// if user signed up then go to connect to hcp else go to patient signup
			userSignupCheck();
		}
*/

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
		}

		private function showSignupPopup():void
		{
			this._userSignupPopup = new VerticalCenteredPopUpContentManager();

			var dummy:Sprite = new Sprite();

			_userSignupPopup.open(this._userSignupPopupContent, dummy);
			this.draw();
		}

		private function initPopupContent():void
		{
			this._userSignupPopupContent = new FeathersControl();

			var bg:Quad = new Quad(400 * this.dpiScale, 200 * this.dpiScale, 0x000000);
			bg.name = "bg";
			this._userSignupPopupContent.addChild(bg);

			var label:ScrollText = new ScrollText();
			label.isHTML = true;
			label.name = "label";
			label.text = "You will need to create an account in order to connect to a care provider";
			this._userSignupPopupContent.addChild(label);

			var closeButton:Button = new Button();
			closeButton.name = "closeBtn";
			closeButton.label = "Close";
			closeButton.addEventListener(Event.TRIGGERED, closePopup);
			this._userSignupPopupContent.addChild(closeButton);

			var signupButton:Button = new Button();
			signupButton.name = "signupBtn";
			signupButton.label = "Sign up";
			signupButton.addEventListener(Event.TRIGGERED, userSignupScreen);
			this._userSignupPopupContent.addChild(signupButton);
		}

		private function drawPopupContent():void
		{
			var bg:Quad = this._userSignupPopupContent.getChildByName("bg") as Quad;
			var label:ScrollText = this._userSignupPopupContent.getChildByName("label") as ScrollText;
			label.invalidate();
			label.width = 380 * this.dpiScale;

			var closeButton:Button = this._userSignupPopupContent.getChildByName("closeBtn") as Button;
			closeButton.invalidate();

			var signupButton:Button = this._userSignupPopupContent.getChildByName("signupBtn") as Button;
			signupButton.invalidate();
			signupButton.y = closeButton.y;
			signupButton.x = closeButton.x + (10 * this.dpiScale);

			this._userSignupPopupContent.width = bg.width;
			this._userSignupPopupContent.height = bg.height;
			this._userSignupPopupContent.invalidate();

			var items:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			items.push(label);
			items.push(closeButton);

			autoLayout(items, 50 * this.dpiScale);

			label.x = 10 * this.dpiScale;

			closeButton.x = 10 * this.dpiScale;

			signupButton.y = closeButton.y;
			signupButton.x = closeButton.x + closeButton.width + (10 * this.dpiScale);
		}

		private function userSignupScreen(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_USER_SIGNUP_SCREEN);
			this._userSignupPopup.close();
			trace("open PATIENT_USER_SIGNUP_SCREEN");
		}

		private function closePopup(e:Event):void
		{
			this._userSignupPopup.close();
		}

		private function autoLayout(items:Vector.<DisplayObject>, gap:Number):void
		{
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.x = 0;
			bounds.y = this._header.height;
			bounds.maxHeight = this.actualHeight - this._header.height;
			bounds.maxWidth = this.actualWidth;

			var contentLayout:VerticalLayout = new VerticalLayout();
			contentLayout.gap = gap;
			contentLayout.layout(items,bounds);
		}
	}
}
