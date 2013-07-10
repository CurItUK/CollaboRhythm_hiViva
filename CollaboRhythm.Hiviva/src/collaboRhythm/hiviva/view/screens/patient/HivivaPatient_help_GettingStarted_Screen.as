package collaboRhythm.hiviva.view.screens.patient
{
	import feathers.controls.Screen;
	import collaboRhythm.hiviva.global.HivivaAssets;
		import collaboRhythm.hiviva.global.HivivaScreens;
		import collaboRhythm.hiviva.view.*;
		import collaboRhythm.hiviva.view.media.Assets;
	    import collaboRhythm.hiviva.view.screens.patient.HelpScreens.ScreenManager;
		import feathers.controls.Button;
		import feathers.controls.ButtonGroup;
		import feathers.controls.Header;
		import feathers.controls.Screen;
		import feathers.controls.ScrollText;
		import feathers.data.ListCollection;
		import feathers.display.TiledImage;
		import feathers.events.FeathersEventType;
		import feathers.layout.AnchorLayoutData;
	import starling.textures.TextureSmoothing;
	    import starling.events.Event;
	import starling.display.DisplayObject;
	import starling.display.BlendMode;
	public class HivivaPatient_help_GettingStarted_Screen extends Screen
		{
			private var _header:HivivaHeader;
			private var _title:String;
			private var _scrollText:ScrollText;
			private var _backButton:Button;
			private var _scaledPadding:Number;
			private var _menuBtnGroup:ButtonGroup;
			private var _tilesInBtns:Vector.<TiledImage>;
			public function HivivaPatient_help_GettingStarted_Screen()
			{
				 super();
			}

			override protected function draw():void
					{
						super.draw();

						this._scaledPadding = (this.actualWidth * 0.04) * this.dpiScale;

						this._header.width = this.actualWidth;
				this._header.paddingLeft = this._scaledPadding;
						this._header.initTrueTitle();
						drawMenuBtnGroup();
					//	this._scrollText.y = this._header.y + this._header.height;
					//	this._scrollText.x = this._scaledPadding;
					//	this._scrollText.width = this.actualWidth - (this._scaledPadding * 2);
					//	this._scrollText.height = this.actualHeight - this._scrollText.y - this._scaledPadding;
					//	this._scrollText.validate();
					}
			override protected function initialize():void
				{
					super.initialize();
					this._header = new HivivaHeader();
				    this._header.bold = true ;
					this._header.title = "Getting Started" //this._title;
					addChild(this._header);
					this._tilesInBtns = new <TiledImage>[];
				        // 	this._scrollText.text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.\n\nNeque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?\n\nAt vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.";
				        //	this._scrollText.text = "";
	                 	this._menuBtnGroup = new ButtonGroup();
				this._menuBtnGroup.customButtonName = "patient-profile-nav-buttons";
				this._menuBtnGroup.customFirstButtonName = "patient-profile-nav-buttons";
				this._menuBtnGroup.customLastButtonName = "patient-profile-nav-buttons";
				addChild(this._menuBtnGroup);
			//	initProfileMenuButtons();
					    //	this.addChild(this._scrollText);

					this._backButton = new Button();
					this._backButton.name = "back-button";
					this._backButton.label = "Back";
					this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);
					this.initProfileMenuButtons();
					this._header.leftItems = new <DisplayObject>[_backButton];
				}


			private function initProfileMenuButtons():void
			{
				var lc:ListCollection = new ListCollection(
					[
						{name: "dailyMedicines", label: "Daily Medicines"},
					    {name: "privacy", label: "Homepage photo"},
					 	{name: "gettingstarted", label: "Connect to care provider"}
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

	case "dailyMedicines" :
	scrManager.init( HivivaPatient_help_About_Screen)


	scrManager.__addScreen(HivivaScreens.PATIENT_HELP_ABOUT_SCREEN)
	break;
	case "privacy" :
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
	scrManager.init(  HivivaPatient_help_Privacy_Screen)
	scrManager.__addScreen(HivivaScreens.PATIENT_HELP_PRIVACY_SCREEN)
	break;
	case "gettingstarted" :
	/*
	var screenNavItem3:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatient_help_help3_Screen);
	// temp = String(HivivaScreens.PATIENT_HELP_HELP3_SCREEN);
	this.owner.addScreen(HivivaScreens.PATIENT_HELP_HELP3_SCREEN, screenNavItem3);
	this.owner.showScreen(HivivaScreens.PATIENT_HELP_HELP3_SCREEN);
	// __arr.push(temp);
	*/
	scrManager.init( HivivaPatient_help_GettingStarted_Screen)
	scrManager.__addScreen(HivivaScreens.PATIENT_HELP_GETTINGSTARTED_SCREEN)
	break;
	case "whatcanIdowithhiviva" :
	/*	var screenNavItem4:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatient_help_help4_Screen);
	// temp = String(HivivaScreens.PATIENT_HELP_HELP4_SCREEN);
	this.owner.addScreen(HivivaScreens.PATIENT_HELP_HELP4_SCREEN, screenNavItem4);
	this.owner.showScreen(HivivaScreens.PATIENT_HELP_HELP4_SCREEN);
	// __arr.push(temp);*/
	scrManager.init( HivivaPatient_help_Wcidwh_Screen)
	scrManager.__addScreen(HivivaScreens.PATIENT_HELP_WCIDWH_SCREEN)
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
