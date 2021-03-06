package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import feathers.display.TiledImage;

	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;

	public class HivivaHCPProfileScreen extends Screen
	{

		private var _header:HivivaHeader;
		private var _homeBtn:Button;
		private var _menuBtnGroup:ButtonGroup;
		private var _tilesInBtns:Vector.<TiledImage>;
		private var _appIdLabel:Label;
		private var _appId:Label;

		public function HivivaHCPProfileScreen()
		{
		}

		override protected function draw():void
		{
			super.draw();

			this._header.paddingLeft = Constants.HEADER_HOMEBTN_PADDING;
			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			drawMenuBtnGroup();
		}

		private function drawMenuBtnGroup():void
		{
			this._menuBtnGroup.validate();
			this._menuBtnGroup.width = this.actualWidth;
			this._menuBtnGroup.y = this._header.height;

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

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "HCP Profile";

			this._homeBtn = new Button();
			this._homeBtn.name = HivivaThemeConstants.HOME_BUTTON;
			this._homeBtn.addEventListener(Event.TRIGGERED , homeBtnHandler);

			this._header.leftItems =  new <DisplayObject>[this._homeBtn];

			initProfileMenuButtons();
			addChild(this._header);

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
					{name: "edit", label: "Edit profile"},
					{name: "display", label: "Display settings"},
					{name: "alerts", label: "Alerts"},
					{name: "connect", label: "Connect to a patient"},
					{name: "resetsettings", label: "Application settings"},
					{name: "passcode", label: "Passcode lock"}
				]
			);
			this._menuBtnGroup.buttonInitializer = function(button:Button, item:Object):void
			{
				var img:TiledImage = new TiledImage(Main.assets.getTexture("patient-profile-nav-button-pattern"));
				img.smoothing = TextureSmoothing.NONE;
				img.blendMode =  BlendMode.MULTIPLY;
				button.addChild(img);
				// add to Vector to assign width post draw
				_tilesInBtns.push(img);

				button.name = item.name;
				button.label =  item.label;
				button.addEventListener(Event.TRIGGERED, hcpProfileBtnHandler)
			};
			this._menuBtnGroup.direction = ButtonGroup.DIRECTION_VERTICAL;

			this.addChild(this._menuBtnGroup);
		}

		private function hcpProfileBtnHandler(e:Event):void
		{
			var btn:Button = e.target as Button;

			// when refactoring to own class we can use a local instance instead of storing the identifier in btn.name
			switch(btn.name)
			{
				case "edit" :
//					this.owner.showScreen(HivivaScreens.HCP_EDIT_PROFILE);
					this.owner.showScreen(HivivaScreens.HCP_MY_DETAILS_SCREEN);
					break;
				case "display" :
					this.owner.showScreen(HivivaScreens.HCP_DISPLAY_SETTINGS);
					break;
				case "alerts" :
					this.owner.showScreen(HivivaScreens.HCP_ALERT_SETTINGS);
					break;
				case "connect" :
					this.owner.showScreen(HivivaScreens.HCP_CONNECT_PATIENT);
					break;
				case "resetsettings" :
					this.owner.showScreen(HivivaScreens.HCP_RESET_SETTINGS);
				break;

				case "passcode" :
					this.owner.showScreen(HivivaScreens.PASSCODE_LOCK_SCREEN);
				break;
			}
		}

		private function homeBtnHandler(e:Event):void
		{
			this.dispatchEventWith("navGoHome");
		}
	}
}
