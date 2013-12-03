package collaboRhythm.hiviva.view.screens.patient.help
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

	public class HivivaPatient_help_Wcidwh_Screen  extends Screen
	{
		private var _header:HivivaHeader;
		private var _title:String;
		private var _scrollText:ScrollText;
		private var _backButton:Button;
		private var _scaledPadding:Number;
		private var _menuBtnGroup:ButtonGroup;
		private var _tilesInBtns:Vector.<TiledImage>;
		public function HivivaPatient_help_Wcidwh_Screen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._scaledPadding = (this.actualWidth * 0.04) * this.dpiScale;

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT * 1.5;
			this._header.initTrueTitle();

			drawMenuBtnGroup();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "What Can I Do \nwith INCHarge" //this._title;
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
						{name: "testResults", label: "Test Results"},
						{name: "takeMedicine", label: "Take Medicine"},
						{name: "seeAdherence", label: "See Adherence"},
						{name: "rewards", label: "Rewards"},
						{name: "messages", label: "Messages"},
						{name: "registerTolerability", label: "Register tolerability"},
						{name: "virusModel", label: "Virus Model"},
						{name: "pullReports", label: "Produce A Report"}
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
			this.owner.showScreen(HivivaScreens.PATIENT_HELP_SCREEN);
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


			if(scrManager.setStatus(_searchString) )return;

			switch(_searchString)
			{

				case "testResults" :
					scrManager.init( HivivaPatient_help_About_Screen)

					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_ABOUT_SCREEN)
					break;
				case "seeAdherence" :

					scrManager.init(  HivivaPatient_help_Privacy_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_PRIVACY_SCREEN)
					break;
				case "takeMedicine" :

					scrManager.init( HivivaPatient_help_GettingStarted_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_GETTINGSTARTED_SCREEN)
					break;
				case "rewards" :

					scrManager.init( HivivaPatient_help_Wcidwh_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_WCIDWH_SCREEN)
					break;

				case "messages" :

					scrManager.init( HivivaPatient_help_Wcidwh_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_WCIDWH_SCREEN)
					break;
				case "registerTolerability" :

					scrManager.init( HivivaPatient_help_Wcidwh_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_WCIDWH_SCREEN)
					break;

				case "testResults" :

					scrManager.init( HivivaPatient_help_Wcidwh_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_WCIDWH_SCREEN)
					break;

				case "virusModel" :

					scrManager.init( HivivaPatient_help_Wcidwh_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_WCIDWH_SCREEN)
					break;

				case "pullReports" :

					scrManager.init( HivivaPatient_help_Wcidwh_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_WCIDWH_SCREEN)
					break;

			}


		}
	}
}
