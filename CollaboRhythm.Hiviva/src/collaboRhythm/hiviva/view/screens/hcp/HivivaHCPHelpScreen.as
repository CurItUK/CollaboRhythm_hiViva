package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.global.Constants;

	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.*;

	import collaboRhythm.hiviva.view.screens.shared.HelpScreenManager;
	import collaboRhythm.hiviva.view.screens.hcp.help.HivivaHCP_help_About_Screen;
	import collaboRhythm.hiviva.view.screens.hcp.help.HivivaHCP_help_GettingStarted_Screen;
	import collaboRhythm.hiviva.view.screens.hcp.help.HivivaHCP_help_Privacy_Screen;
	import collaboRhythm.hiviva.view.screens.hcp.help.HivivaHCP_help_Wcidwh_Screen;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;

	import feathers.controls.Screen;

	import feathers.data.ListCollection;
	import feathers.display.TiledImage;


	import collaboRhythm.hiviva.view.HivivaHeader;


	import starling.display.BlendMode;

	import starling.display.DisplayObject;

	import starling.events.Event;
	import starling.textures.TextureSmoothing;


	public class HivivaHCPHelpScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _tilesInBtns:Vector.<TiledImage>;
		private var _menuBtnGroup:ButtonGroup;
		private var _scaledPadding:Number;

		public function HivivaHCPHelpScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._scaledPadding = (this.actualWidth * 0.04) * this.dpiScale;

			this._header.paddingLeft = Constants.HEADER_HOMEBTN_PADDING;
			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			drawMenuBtnGroup();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Help";
			addChild(this._header);

			this._tilesInBtns = new <TiledImage>[];
			this._menuBtnGroup = new ButtonGroup();
			this._menuBtnGroup.customButtonName = "patient-profile-nav-buttons";
			this._menuBtnGroup.customFirstButtonName = "patient-profile-nav-buttons";
			this._menuBtnGroup.customLastButtonName = "patient-profile-nav-buttons";
			addChild(this._menuBtnGroup);
			initProfileMenuButtons();

			var homeBtn:Button = new Button();
			homeBtn.name = HivivaThemeConstants.HOME_BUTTON;
			homeBtn.addEventListener(Event.TRIGGERED , homeBtnHandler);
			this._header.leftItems =  new <DisplayObject>[homeBtn];
		}

		private function homeBtnHandler():void
		{
			this.dispatchEventWith("navGoHome");
		}

		private function initProfileMenuButtons():void
		{
			var lc:ListCollection = new ListCollection(
					[
						{name: "hcpabout", label: "About"},
						{name: "hcpprivacy", label: "Privacy"},
						{name: "hcpgettingstarted", label: "Getting Started"},
						{name: "hcpwhatcanIdowithhiviva", label: "What can I do with INCHarge?"}
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

			button.name = item.name;
			button.label =  item.label;
			button.addEventListener(Event.TRIGGERED, patientProfileBtnHandler)
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

				case "hcpabout" :
					scrManager.init( HivivaHCP_help_About_Screen)
					scrManager.__addScreen(HivivaScreens.HCP_HELP_ABOUT_SCREEN)
					break;

				case "hcpprivacy" :
					scrManager.init(  HivivaHCP_help_Privacy_Screen)
					scrManager.__addScreen(HivivaScreens.HCP_HELP_PRIVACY_SCREEN)
					break;

				case "hcpgettingstarted" :
					scrManager.init( HivivaHCP_help_GettingStarted_Screen)
					scrManager.__addScreen(HivivaScreens.HCP_HELP_GETTINGSTARTED_SCREEN)
					break;

				case "hcpwhatcanIdowithhiviva" :
					scrManager.init( HivivaHCP_help_Wcidwh_Screen)
					scrManager.__addScreen(HivivaScreens.HCP_HELP_WCIDWH_SCREEN)
					break;
			}
		}

	}
}
