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

	public class PatientFooterBtnGroup extends ButtonGroup implements IFooterBtnGroup
	{

		private var _mainScreenNav:ScreenNavigator;
		private var _scaleFactor:Number;
		private var _currFooterBtn:Button;


		public function PatientFooterBtnGroup(mainScreenNav:ScreenNavigator , scaleFactor:Number)
		{
			this._mainScreenNav = mainScreenNav;
			this._scaleFactor = scaleFactor;
			this.addEventListener(Event.ADDED_TO_STAGE,initFooterBtnGroup);
		}

		private function initFooterBtnGroup(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,initFooterBtnGroup);
			drawComponent();
		}

		private function drawComponent():void
		{
			var footerBtnHeight:Number = Main.assets.getTexture("footer_icon_base").height * this._scaleFactor;
			var footerBtnWidth:Number =  Main.assets.getTexture("footer_icon_base").width * this._scaleFactor;

			this.customButtonName = "home-footer-buttons";
			this.customFirstButtonName = "home-footer-buttons";
			this.customLastButtonName = "home-footer-buttons";

			this.dataProvider = new ListCollection(
					[
						{ width: footerBtnWidth, height: footerBtnHeight, name: "home"},
						{ width: footerBtnWidth, height: footerBtnHeight, name: "clock"},
						{ width: footerBtnWidth, height: footerBtnHeight, name: "takemeds"},
						{ width: footerBtnWidth, height: footerBtnHeight, name: "virus"},
						{ width: footerBtnWidth, height: footerBtnHeight, name: "report"}
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
//						img = new Image(Main.assets..getTexture("footer_icon_1"));
						img = new Image(Main.assets.getTexture("v2_footer_icon_1"));
						button.isSelected = true;
						_currFooterBtn = button;
						_mainScreenNav.showScreen(HivivaScreens.PATIENT_HOME_SCREEN);
						break;
					case "clock" :
//						img = new Image(Main.assets..getTexture("footer_icon_2"));
						img = new Image(Main.assets.getTexture("v2_footer_icon_2"));
						break;
					case "takemeds" :
//						img = new Image(Main.assets..getTexture("footer_icon_3"));
						img = new Image(Main.assets.getTexture("v2_footer_icon_3"));
						break;
					case "virus" :
//						img = new Image(Main.assets..getTexture("footer_icon_4"));
						img = new Image(Main.assets.getTexture("v2_footer_icon_4"));
						break;
					case "report" :
//						img = new Image(Main.assets..getTexture("footer_icon_5"));
						img = new Image(Main.assets.getTexture("v2_footer_icon_5"));
						break;
				}

				button.defaultIcon = img;
			};

			this.direction = ButtonGroup.DIRECTION_HORIZONTAL;
		}

		private function footerBtnHandler(e:Event):void
		{
			trace("footerBtnHandler " + e.target )
			var btn:Button = e.target as Button;
			if(!btn.isSelected)
			{
				switch(btn.name)
				{
					case "home" :
						this._mainScreenNav.showScreen(HivivaScreens.PATIENT_HOME_SCREEN);
						break;
					case "clock" :
						this._mainScreenNav.showScreen(HivivaScreens.PATIENT_VIEW_MEDICATION_SCREEN);
						break;
					case "takemeds" :
						this._mainScreenNav.showScreen(HivivaScreens.PATIENT_MEDICATION_SCREEN);
						break;
					case "virus" :
						this._mainScreenNav.showScreen(HivivaScreens.PATIENT_VIRUS_MODEL_SCREEN);
						break;
					case "report" :
						this._mainScreenNav.showScreen(HivivaScreens.PATIENT_REPORTS_SCREEN);
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

		}
	}
}
