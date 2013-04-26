package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;
	import feathers.controls.Header;

	import source.themes.HivivaTheme;

	import starling.display.DisplayObject;
	import starling.display.Image;

	import starling.events.Event;

	public class HivivaPatientHomeScreen extends ScreenBase
	{
		private var _header:Header;
		private var _messagesButton:Button;
		private var _badgesButton:Button;

		public function HivivaPatientHomeScreenScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;

			this._messagesButton.width = 130 * this.dpiScale;
			this._messagesButton.height = 110 * this.dpiScale;

			this._badgesButton.width = 130 * this.dpiScale;
			this._badgesButton.height = 110 * this.dpiScale;
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new Header();
			addChild(this._header);

			this._messagesButton = new Button();
			this._messagesButton.nameList.add(HivivaTheme.NONE_THEMED_BUTTON);
			this._messagesButton.defaultIcon = new Image(Assets.getTexture("TopNavIconMessagesPng"));
			this._messagesButton.addEventListener(Event.TRIGGERED , messagesButtonHandler);

			this._badgesButton = new Button();
			this._badgesButton.nameList.add(HivivaTheme.NONE_THEMED_BUTTON);
			this._badgesButton.defaultIcon = new Image(Assets.getTexture("TopNavIconBadgesPng"));
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
