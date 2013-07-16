package collaboRhythm.hiviva.view.components
{

	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.Main;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.ScreenNavigator;
	import feathers.data.ListCollection;

	import starling.display.Image;
	import starling.events.Event;

	public class HCPFooterBtnGroup extends ButtonGroup implements IFooterBtnGroup
	{

		private var _mainScreenNav:ScreenNavigator;
		private var _scaleFactor:Number;
		private var _currFooterBtn:Button;


		public function HCPFooterBtnGroup(mainScreenNav:ScreenNavigator, scaleFactor:Number)
		{

			this._mainScreenNav = mainScreenNav;
			this._scaleFactor = scaleFactor;
			this.addEventListener(Event.ADDED_TO_STAGE, initFooterBtnGroup);
		}

		private function initFooterBtnGroup(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initFooterBtnGroup);
			drawComponent();
		}

		private function drawComponent():void
		{
			var footerBtnHeight:Number = Main.assets.getTexture("footer_icon_base").height * this._scaleFactor;
			var footerBtnWidth:Number = Main.assets.getTexture("footer_icon_base").width * this._scaleFactor;

			this.customButtonName = "home-footer-buttons";
			this.customFirstButtonName = "home-footer-buttons";
			this.customLastButtonName = "home-footer-buttons";

			this.dataProvider = new ListCollection(
					[
						{ width: footerBtnWidth, height: footerBtnHeight, name: "home"},
						{ width: footerBtnWidth, height: footerBtnHeight, name: "adherence"},
						{ width: footerBtnWidth, height: footerBtnHeight, name: "reports"},
						{ width: footerBtnWidth, height: footerBtnHeight, name: "messages"}
					]
			);

			this.buttonInitializer = function(button:Button, item:Object):void
			{
				var img:Image;

				button.name = item.name;
				button.addEventListener(Event.TRIGGERED, footerBtnHandler);

				switch(item.name)
				{
					case "home" :
						img = new Image(Main.assets.getTexture("footer_icon_1"));
						button.isSelected = true;
						_currFooterBtn = button;
						_mainScreenNav.showScreen(HivivaScreens.HCP_HOME_SCREEN);
						break;
					case "adherence" :
						img = new Image(Main.assets.getTexture("footer_icon_6"));
						break;
					case "reports" :
						img = new Image(Main.assets.getTexture("footer_icon_5"));
						break;
					case "messages" :
						img = new Image(Main.assets.getTexture("footer_icon_7"));
						break;
				}

				button.defaultIcon = img;
			};

			this.direction = ButtonGroup.DIRECTION_HORIZONTAL;
		}

		private function footerBtnHandler(e:Event):void
		{
			var btn:Button = e.target as Button;
			if(!btn.isSelected)
			{
				// when refactoring to own class we can use a local property instead of storing the identifier in btn.name
				switch(btn.name.substring(0 ,btn.name.indexOf(" home-footer-buttons")))
				{
					case "home" :
						this._mainScreenNav.showScreen(HivivaScreens.HCP_HOME_SCREEN);
						break;
					case "adherence" :
						this._mainScreenNav.showScreen(HivivaScreens.HCP_ADHERENCE_SCREEN);
						break;
					case "reports" :
						this._mainScreenNav.showScreen(HivivaScreens.HCP_REPORTS_SCREEN);
						break;
					case "messages" :
						this._mainScreenNav.showScreen(HivivaScreens.HCP_MESSAGE_SCREEN);
						break;
				}
				this._currFooterBtn.isSelected = false;
				this._currFooterBtn = e.target as Button;
				this._currFooterBtn.isSelected = true;
			}
		}

		public function resetToHomeState():void
		{
			this._currFooterBtn.isSelected = false;
			this._currFooterBtn = this.getChildAt(0) as Button;
			this._currFooterBtn.isSelected = true;
		}

		public function asButtonGroup():ButtonGroup
		{
			return this;
		}

		//TODO Ugly hack needs tidy up
		public function navigateToMessages():void
		{
			trace("HCP Messages")
			this._currFooterBtn.isSelected = false;
			this._currFooterBtn = this.getChildAt(3) as Button;
			this._currFooterBtn.isSelected = true;
			this._mainScreenNav.showScreen(HivivaScreens.HCP_MESSAGE_SCREEN);
		}


	}
}
