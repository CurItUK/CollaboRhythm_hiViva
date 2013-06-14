package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.media.Assets;

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

	import starling.display.BlendMode;

	import starling.display.DisplayObject;

	import starling.events.Event;
	import starling.textures.TextureSmoothing;

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
					{name: "help1", label: "Report an adverse event"},
					{name: "help2", label: "Fusce pellentesque"},
					{name: "help3", label: "Praesent elementum convallis turpis"},
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

		private function patientProfileBtnHandler(e:Event):void
		{
			var btn:Button = e.target as Button;
			trace(btn.name.substring(0 ,btn.name.indexOf(" patient-profile-nav-buttons")));
			// when refactoring to own class we can use a local instance instead of storing the identifier in btn.name
			/*switch(btn.name.substring(0 ,btn.name.indexOf(" patient-profile-nav-buttons")))
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
			}*/
			var screenNavItem:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatientHelpDetailScreen, null, {title:btn.label});
			if(this.owner.hasScreen(HivivaScreens.PATIENT_HELP_DETAIL_SCREEN))
			{
				this.owner.removeScreen(HivivaScreens.PATIENT_HELP_DETAIL_SCREEN);
			}
			this.owner.addScreen(HivivaScreens.PATIENT_HELP_DETAIL_SCREEN, screenNavItem);
			this.owner.showScreen(HivivaScreens.PATIENT_HELP_DETAIL_SCREEN);
		}

	}
}
