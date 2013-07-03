package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientHelpDetailScreen;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollText;
	import collaboRhythm.hiviva.view.HivivaHeader;

	import feathers.data.ListCollection;

	import feathers.display.TiledImage;

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

			this._header.width = this.actualWidth;
			this._header.paddingLeft = this._scaledPadding;
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
			homeBtn.addEventListener(starling.events.Event.TRIGGERED, homeBtnHandler);
			this._header.leftItems = new <DisplayObject>[homeBtn];

		}

		private function homeBtnHandler():void
		{
			this.dispatchEventWith("navGoHome");
		}

		private function initProfileMenuButtons():void
		{
			var lc:ListCollection = new ListCollection(
					[
						{name: "help1", label: "labore et dolore"},
						{name: "help2", label: "Fusce pellentesque"},
						{name: "help3", label: "Praesent elementum"},
						{name: "help4", label: "Duis ullamcorper"},
						{name: "help5", label: "Privacy policy"},
						{name: "help6", label: "Terms of use"}
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
			img.blendMode = BlendMode.MULTIPLY;
			button.addChild(img);
			// add to Vector to assign width post draw
			_tilesInBtns.push(img);

			button.name = item.name;
			button.label = item.label;
			button.addEventListener(starling.events.Event.TRIGGERED, profileBtnHandler)
		}

		private function profileBtnHandler(e:starling.events.Event):void
		{
			var btn:Button = e.target as Button;
			trace(btn.name.substring(0, btn.name.indexOf(" patient-profile-nav-buttons")));
			var screenNavItem:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaHCPHelpDetailScreen, null, {title: btn.label});
	/*		if (this.owner.hasScreen(HivivaScreens.HCP_HELP_DETAIL_SCREEN))
			{
				this.owner.removeScreen(HivivaScreens.HCP_HELP_DETAIL_SCREEN);
			}
			this.owner.addScreen(HivivaScreens.HCP_HELP_DETAIL_SCREEN, screenNavItem);
			this.owner.showScreen(HivivaScreens.HCP_HELP_DETAIL_SCREEN);
		}*/
			var _searchString : String = btn.name.substring(0 ,btn.name.indexOf(" patient-profile-nav-buttons"))
			            var scrManager : HCPScreenManager =  new HCPScreenManager(e);
			            scrManager._sNav = this.owner;
						var __exists : Boolean  = scrManager.setStatus(_searchString) ;

						if(__exists)return;

						switch(_searchString)
						{

							case "help1" :
								scrManager.init( HivivaHCP_help_help1_Screen)
								scrManager.__addScreen(HivivaScreens.HCP_HELP_HELP1_SCREEN)
								break;
							case "help2" :
									/*
								temp = String(HivivaScreens.PATIENT_HELP_HELP2_SCREEN);
								var screenNavItem2:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatient_help_help2_Screen);
								//temp = String(HivivaScreens.PATIENT_HELP_HELP2_SCREEN);
								//temp = String(HivivaScreens.PATIENT_HELP_HELP2_SCREEN);
								this.owner.addScreen(HivivaScreens.PATIENT_HELP_HELP2_SCREEN, screenNavItem2);
								this.owner.showScreen(HivivaScreens.PATIENT_HELP_HELP2_SCREEN);
								new HelpScreen2(this.owner , HivivaPatient_help_help2_Screen).__addScreen();
								// __arr.push(temp);
								*/
								scrManager.init(  HivivaHCP_help_help2_Screen)
								scrManager.__addScreen(HivivaScreens.HCP_HELP_HELP2_SCREEN)
								break;
							case "help3" :
									/*
								var screenNavItem3:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatient_help_help3_Screen);
								// temp = String(HivivaScreens.PATIENT_HELP_HELP3_SCREEN);
								this.owner.addScreen(HivivaScreens.PATIENT_HELP_HELP3_SCREEN, screenNavItem3);
								this.owner.showScreen(HivivaScreens.PATIENT_HELP_HELP3_SCREEN);
								// __arr.push(temp);
								*/
								scrManager.init( HivivaHCP_help_help3_Screen)
								scrManager.__addScreen(HivivaScreens.HCP_HELP_HELP3_SCREEN)
								break;
							case "help4" :
							/*	var screenNavItem4:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatient_help_help4_Screen);
								// temp = String(HivivaScreens.PATIENT_HELP_HELP4_SCREEN);
								this.owner.addScreen(HivivaScreens.PATIENT_HELP_HELP4_SCREEN, screenNavItem4);
								this.owner.showScreen(HivivaScreens.PATIENT_HELP_HELP4_SCREEN);
								// __arr.push(temp);*/
								scrManager.init( HivivaHCP_help_help4_Screen)
								scrManager.__addScreen(HivivaScreens.HCP_HELP_HELP4_SCREEN)
									break;
							case "help5" :
									/*
								var screenNavItem5:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatient_help_help5_Screen);
							// 	temp = String(HivivaScreens.PATIENT_HELP_HELP5_SCREEN);
								this.owner.addScreen(HivivaScreens.PATIENT_HELP_HELP5_SCREEN, screenNavItem5);
								this.owner.showScreen(HivivaScreens.PATIENT_HELP_HELP5_SCREEN);
							// 	__arr.push(temp);
									*/
								scrManager.init(  HivivaHCP_help_help5_Screen)
								scrManager.__addScreen(HivivaScreens.HCP_HELP_HELP5_SCREEN)
								break;
							case "help6" :
									/*
								 var screenNavItem6:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatient_help_help6_Screen);
								//   temp = String(HivivaScreens.PATIENT_HELP_HELP6_SCREEN);
								  this.owner.addScreen(HivivaScreens.PATIENT_HELP_HELP6_SCREEN, screenNavItem6);
								  this.owner.showScreen(HivivaScreens.PATIENT_HELP_HELP6_SCREEN);
								// __arr.push(temp);
								*/
								scrManager.init(  HivivaHCP_help_help6_Screen)
								scrManager.__addScreen(HivivaScreens.HCP_HELP_HELP6_SCREEN)
								    break;
						}

	}
}
}
