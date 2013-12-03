package collaboRhythm.hiviva.view.screens.hcp.help
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.screens.shared.HelpScreenManager;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;
	import feathers.data.ListCollection;
	import feathers.display.TiledImage;

	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;

	public class HivivaHCP_help_GettingStarted_Screen extends Screen
	{
		private var _header:HivivaHeader;
		private var _title:String;
		private var _scrollText:ScrollText;
		private var _backButton:Button;
		private var _scaledPadding:Number;
		private var _menuBtnGroup:ButtonGroup;
		private var _tilesInBtns:Vector.<TiledImage>;
		public function HivivaHCP_help_GettingStarted_Screen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._scaledPadding = (this.actualWidth * 0.04) * this.dpiScale;

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			drawMenuBtnGroup();

		}
		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Getting Started" //this._title;
			addChild(this._header);
			this._tilesInBtns = new <TiledImage>[];
			this._menuBtnGroup = new ButtonGroup();
			this._menuBtnGroup.customButtonName = "patient-profile-nav-buttons";
			this._menuBtnGroup.customFirstButtonName = "patient-profile-nav-buttons";
			this._menuBtnGroup.customLastButtonName = "patient-profile-nav-buttons";
			addChild(this._menuBtnGroup);

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);
			this.initProfileMenuButtons();
			this._header.leftItems = new <DisplayObject>[_backButton];
		}


		private function initProfileMenuButtons():void
		{
			var lc:ListCollection = new ListCollection(
					[
						{name: "hcphelpdisplaySettings", label: "Display settings"},
						{name: "hcphelpAlertsScreen", label: "Alerts"},
						{name: "hcphelpConnectToPatientScreen", label: "Connect to patient"}
					]
			);

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
			trace("BUTTON ADDED  ::::::: ")

			button.name = item.name;
			button.label =  item.label;
			button.addEventListener(Event.TRIGGERED, patientProfileBtnHandler)
		}

		private function backBtnHandler():void
		{
			this.owner.showScreen(HivivaScreens.HCP_HELP_SCREEN);
		}

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}

		private function patientProfileBtnHandler(e:Event):void
		{
			var __arr : Array =  new Array();
			var btn:Button = e.target as Button;

			var _searchString : String = btn.name;
			var scrManager : HelpScreenManager =  new HelpScreenManager(e);
			scrManager._sNav = this.owner;

			if(scrManager.setStatus(_searchString))return;

			switch(_searchString)
			{

				case "hcphelpdisplaySettings" :
					scrManager.init( HivivaHCP_help_Display_Settings_Screen);
					scrManager.__addScreen(HivivaScreens.HCP_HELP_DISPLAY_SETTINGS)
					break;

				case "hcphelpAlertsScreen" :
					scrManager.init(  HivivaHCP_help_Alerts_Screen)
					scrManager.__addScreen(HivivaScreens.HCP_HELP_ALERTS_SCREEN)
					break;

				case "hcphelpConnectToPatientScreen" :
					scrManager.init( HivivaHCP_help_Connect_To_Patient_Screen)
					scrManager.__addScreen(HivivaScreens.HCP_HELP_CONNECT_TO_PATIENT_SCREEN)
					break;
			}

		}
	}
}
