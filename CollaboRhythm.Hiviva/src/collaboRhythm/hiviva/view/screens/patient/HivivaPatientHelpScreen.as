package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.media.Assets;
    import collaboRhythm.hiviva.view.screens.patient.HelpScreens.ScreenManager;
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollText;
	import feathers.data.ListCollection;
	import feathers.display.TiledImage;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;

	import collaboRhythm.hiviva.view.HivivaHeader;

	import mx.core.IFactory;

	import spark.components.supportClasses.ViewReturnObject;

	import starling.display.BlendMode;

	import starling.display.DisplayObject;

	import starling.events.Event;
	import starling.textures.TextureSmoothing;
    import collaboRhythm.hiviva.view.screens.patient.HelpScreens.*;

	public class HivivaPatientHelpScreen extends Screen
	{
		private var _header:HivivaHeader;
//		private var _scrollText:ScrollText;
		private var _tilesInBtns:Vector.<TiledImage>;
		private var _menuBtnGroup:ButtonGroup;

		private var _scaledPadding:Number;

		public function HivivaPatientHelpScreen()
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

			/*
			this._scrollText.y = this._header.y + this._header.height;
			this._scrollText.x = scaledPadding;
			this._scrollText.width = this.actualWidth - (scaledPadding * 2);
			this._scrollText.height = this.actualHeight - this._scrollText.y - scaledPadding;
			this._scrollText.validate();*/
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
/*

			this._scrollText = new ScrollText();
			this._scrollText.text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.\n\nNeque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?\n\nAt vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.";
			this.addChild(this._scrollText);
*/

			var homeBtn:Button = new Button();
			homeBtn.name = "home-button";
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
			img.blendMode =  BlendMode.MULTIPLY;
			button.addChild(img);
			// add to Vector to assign width post draw
			_tilesInBtns.push(img);

			button.name = item.name;
			button.label =  item.label;
			button.addEventListener(Event.TRIGGERED, patientProfileBtnHandler)
		}


        var temp : String
		var __screen:HivivaPatientHelpScreen;

		private function patientProfileBtnHandler(e:Event):void
		{
			var __arr : Array =  new Array();
			var btn:Button = e.target as Button;

			trace(btn.name.substring(0 ,btn.name.indexOf(" patient-profile-nav-buttons")));
			// when refactoring to own class we can use a local instance instead of storing the identifier in btn.name
		//	trace("THIS IS THE CASE   ::::: " + btn.name.substring(0 ,btn.name.indexOf(" patient-profile-nav-buttons")))
             var _searchString : String = btn.name.substring(0 ,btn.name.indexOf(" patient-profile-nav-buttons"))
/*
			// if(this.owner.hasScreen(String(temp)))
			if(this.owner.hasScreen(getStr(_searchString)))
						{
					  trace("this screen already exists ::::::::: ")

				//	  this.owner.removeScreen(String(temp));
				// 	 this.owner.showScreen(String(temp));
							this.owner.showScreen(getStr(_searchString));

			 return;
				 }
				 */
			var scrManager : ScreenManager =  new ScreenManager(e);
            scrManager._sNav = this.owner;
			var __exists : Boolean  = scrManager.setStatus(_searchString) ;

			if(__exists)return;

			switch(_searchString)
			{

				case "help1" :
					scrManager.init( HivivaPatient_help_help1_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_HELP1_SCREEN)
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
					scrManager.init(  HivivaPatient_help_help2_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_HELP2_SCREEN)
					break;
				case "help3" :
						/*
					var screenNavItem3:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatient_help_help3_Screen);
					// temp = String(HivivaScreens.PATIENT_HELP_HELP3_SCREEN);
					this.owner.addScreen(HivivaScreens.PATIENT_HELP_HELP3_SCREEN, screenNavItem3);
					this.owner.showScreen(HivivaScreens.PATIENT_HELP_HELP3_SCREEN);
					// __arr.push(temp);
					*/
					scrManager.init( HivivaPatient_help_help2_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_HELP3_SCREEN)
					break;
				case "help4" :
				/*	var screenNavItem4:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatient_help_help4_Screen);
					// temp = String(HivivaScreens.PATIENT_HELP_HELP4_SCREEN);
					this.owner.addScreen(HivivaScreens.PATIENT_HELP_HELP4_SCREEN, screenNavItem4);
					this.owner.showScreen(HivivaScreens.PATIENT_HELP_HELP4_SCREEN);
					// __arr.push(temp);*/
					scrManager.init( HivivaPatient_help_help4_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_HELP4_SCREEN)
						break;
				case "help5" :
						/*
					var screenNavItem5:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatient_help_help5_Screen);
				// 	temp = String(HivivaScreens.PATIENT_HELP_HELP5_SCREEN);
					this.owner.addScreen(HivivaScreens.PATIENT_HELP_HELP5_SCREEN, screenNavItem5);
					this.owner.showScreen(HivivaScreens.PATIENT_HELP_HELP5_SCREEN);
				// 	__arr.push(temp);
						*/
					scrManager.init(  HivivaPatient_help_help5_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_HELP5_SCREEN)
					break;
				case "help6" :
						/*
					 var screenNavItem6:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatient_help_help6_Screen);
					//   temp = String(HivivaScreens.PATIENT_HELP_HELP6_SCREEN);
					  this.owner.addScreen(HivivaScreens.PATIENT_HELP_HELP6_SCREEN, screenNavItem6);
					  this.owner.showScreen(HivivaScreens.PATIENT_HELP_HELP6_SCREEN);
					// __arr.push(temp);
					*/
					scrManager.init(  HivivaPatient_help_help6_Screen)
					scrManager.__addScreen(HivivaScreens.PATIENT_HELP_HELP6_SCREEN)
					    break;
			}

/*
				//	temp = HivivaScreens.PATIENT_HELP_HELP3_SCREEN;
	 	  	//	  this.owner.addScreen(HivivaScreens.PATIENT_HELP_HELP3_SCREEN, HivivaPatient_help_help3_Screen);
				//	this.owner.showScreen(HivivaScreens.PATIENT_HELP_HELP3_SCREEN);

			//if(this.owner.hasScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN))
									//	{			var screenNavItem:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatientHelpDetailScreen, null, {title:btn.label});

							//				this.owner.removeScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN);
							//			}
							//	this.owner.addScreen(HivivaScreens.PATIENT_HELP_DETAIL_SCREEN, screenNavItem);
						//		this.owner.showScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN);
						*/
		}

	}
}
