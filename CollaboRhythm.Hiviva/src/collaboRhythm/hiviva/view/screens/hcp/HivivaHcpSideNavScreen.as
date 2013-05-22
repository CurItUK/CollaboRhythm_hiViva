package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;

	import starling.display.Image;
	import starling.events.Event;


	public class HivivaHcpSideNavScreen extends Screen
	{

		private var WIDTH:Number;
		private var SCALE:Number;
		private var _sideBtnGroup:ButtonGroup;

		public function HivivaHcpSideNavScreen(gWidth:Number, scale:Number)
		{
			WIDTH = gWidth;
			SCALE = scale;
		}

		override protected function draw():void
		{
			this._sideBtnGroup.width = WIDTH;
		}

		override protected function initialize():void
		{
			// needs own class
			var btnHeight:Number = HivivaAssets.SIDENAV_BASE.height * SCALE;
			var btnWidth:Number = HivivaAssets.SIDENAV_BASE.width * SCALE;

			this._sideBtnGroup = new ButtonGroup();
			this._sideBtnGroup.customButtonName = "side-nav-buttons";
			this._sideBtnGroup.customFirstButtonName = "side-nav-buttons";
			this._sideBtnGroup.customLastButtonName = "side-nav-buttons";

			this._sideBtnGroup.dataProvider = new ListCollection(
				[
					{ width: btnWidth, height: btnHeight, name: "profile", label: "PROFILE" },
					{ width: btnWidth, height: btnHeight, name: "display", label: "DISPLAY SETTINGS"},
					{ width: btnWidth, height: btnHeight, name: "alerts", label: "ALERTS"},
					{ width: btnWidth, height: btnHeight, name: "connect", label: "CONNECT TO PATIENT"}
				]
			);
			this._sideBtnGroup.buttonInitializer = function(button:Button, item:Object):void
			{
				var img:Image;

				button.name = item.name;
				button.label = item.label;
				button.addEventListener(Event.TRIGGERED, sideNavBtnHandler);

				switch(item.name)
				{
					case "profile" :
						img = new Image(HivivaAssets.SIDENAV_ICON_PATIENTPROFILE);
						break;
					case "display" :
						img = new Image(HivivaAssets.SIDENAV_ICON_HELP);
						break;
					case "alerts" :
						img = new Image(HivivaAssets.SIDENAV_ICON_MESSAGES);
						break;
					case "connect" :
						img = new Image(HivivaAssets.SIDENAV_ICON_BADGES);
						break;
				}

				img.width = item.width;
				img.height = item.height;
				button.addChild(img);
			};

			this.addChild(this._sideBtnGroup);
			this._sideBtnGroup.width = this.stage.width;
			this._sideBtnGroup.direction = ButtonGroup.DIRECTION_VERTICAL;
		}

		private function sideNavBtnHandler(e:Event):void
		{
			var navAwayEvent:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.NAVIGATE_AWAY);
			var btn:Button = e.target as Button;
			// when refactoring to own class we can use a local instance instead of storing the identifier in btn.name
			switch(btn.name.substring(0 ,btn.name.indexOf(" side-nav-buttons")))
			{
				case "profile" :
					navAwayEvent.message = HivivaScreens.PATIENT_PROFILE_SCREEN;
					break;
				case "display" :
					navAwayEvent.message = HivivaScreens.PATIENT_HELP_SCREEN;
					break;
				case "alerts" :
					navAwayEvent.message = HivivaScreens.PATIENT_MESSAGES_SCREEN;
					break;
				case "connect" :
					navAwayEvent.message = HivivaScreens.PATIENT_BADGES_SCREEN;
					break;
			}

			this.dispatchEvent(navAwayEvent);
		}

	}
}
