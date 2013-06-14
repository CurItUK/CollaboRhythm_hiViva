package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.media.Assets;

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
		private var _applicationController:HivivaApplicationController;
		private var _header:HivivaHeader;
		private var _homeBtn:Button;
		private var _menuBtnGroup:ButtonGroup;
		private var _tilesInBtns:Vector.<TiledImage>;
		private var _appIdLabel:Label;
		private var _appId:Label;

		private var _scaledPadding:Number;

		public function HivivaHCPProfileScreen()
		{
		}

		override protected function draw():void
		{
			super.draw();

			this._scaledPadding = 44 * this.dpiScale;

			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			drawMenuBtnGroup();

			this._appIdLabel.validate();
			this._appIdLabel.x = this._scaledPadding;
			this._appIdLabel.y = this._menuBtnGroup.y + this._menuBtnGroup.height + (20 * this.dpiScale);

			this._appId.validate();
			this._appId.x = this.actualWidth - this._scaledPadding - this._appId.width;
			this._appId.y = this._appIdLabel.y;
		}

		private function drawMenuBtnGroup():void
		{
			this._menuBtnGroup.validate();
			this._menuBtnGroup.width = this.actualWidth;
			this._menuBtnGroup.y = this._header.height + (30 * this.dpiScale);

			var patternHeight:Number = Button(this._menuBtnGroup.getChildAt(0)).height;
			for (var i:int = 0; i < _tilesInBtns.length; i++)
			{
				var img:TiledImage = _tilesInBtns[i];
				img.width = this.actualWidth;
				img.height = patternHeight;
			}
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "HCP Profile";

			this._homeBtn = new Button();
			this._homeBtn.name = "home-button";
			this._homeBtn.addEventListener(Event.TRIGGERED , homeBtnHandler);

			this._header.leftItems =  new <DisplayObject>[this._homeBtn];

			initProfileMenuButtons();
			addChild(this._header);

			this._appIdLabel = new Label();
			this._appIdLabel.name = "patient-profile-appid";
			this._appIdLabel.text = "Your app ID";
			addChild(this._appIdLabel);

			this._appId = new Label();
			this._appId.name = "patient-profile-appid";
			addChild(this._appId);
			localStoreController.addEventListener(LocalDataStoreEvent.APP_ID_LOAD_COMPLETE,getAppId);
			localStoreController.getAppId();
		}

		private function getAppId(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.APP_ID_LOAD_COMPLETE,getAppId);

			var appIdData:String = e.data.app_id;
			this._appId.text = appIdData;

			this._appId.validate();
			this._appId.x = this.actualWidth - this._scaledPadding - this._appId.width;
			this._appId.y = this._appIdLabel.y;
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
					{name: "connect", label: "Connect to a patient"}
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
			switch(btn.name.substring(0 ,btn.name.indexOf(" patient-profile-nav-buttons")))
			{
				case "edit" :
					this.owner.showScreen(HivivaScreens.HCP_EDIT_PROFILE);
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
			}
		}

		private function homeBtnHandler(e:Event):void
		{
			this.dispatchEventWith("navGoHome");
		}

		public function get localStoreController():HivivaLocalStoreController
		{
			return applicationController.hivivaLocalStoreController;
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
