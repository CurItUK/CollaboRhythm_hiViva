package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;

	import source.themes.HivivaTheme;

	import starling.display.DisplayObject;
	import starling.display.Image;

	import starling.events.Event;

	public class HivivaPatientHomeScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _messagesButton:Button;
		private var _badgesButton:Button;

		public function HivivaPatientHomeScreenScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._messagesButton.width = 130 * this.dpiScale;
			this._messagesButton.height = 110 * this.dpiScale;

			this._badgesButton.width = 130 * this.dpiScale;
			this._badgesButton.height = 110 * this.dpiScale;
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "";
			addChild(this._header);

			this._messagesButton = new Button();
			this._messagesButton.nameList.add(HivivaTheme.NONE_THEMED);
			this._messagesButton.defaultIcon = new Image(HivivaAssets.TOPNAV_ICON_MESSAGES);
			this._messagesButton.addEventListener(Event.TRIGGERED , messagesButtonHandler);

			this._badgesButton = new Button();
			this._badgesButton.nameList.add(HivivaTheme.NONE_THEMED);
			this._badgesButton.defaultIcon = new Image(HivivaAssets.TOPNAV_ICON_BADGES);
			this._badgesButton.addEventListener(Event.TRIGGERED , rewardsButtonHandler);

			this._header.rightItems =  new <DisplayObject>[this._messagesButton,this._badgesButton];
		}

		private function messagesButtonHandler(e:Event):void
		{
			
		}

		private function rewardsButtonHandler(e:Event):void
		{

		}
	}
}
