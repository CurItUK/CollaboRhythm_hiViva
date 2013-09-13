package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;

	import feathers.controls.Button;

	import starling.display.DisplayObject;

	import starling.events.Event;

	public class InchPasscodeRecoverQuestion extends ValidationScreen
	{
		private var _backButton:Button;

		public function InchPasscodeRecoverQuestion()
		{
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header.title = "Fogotten your passcode?";


			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}


		override protected function draw():void
		{
			super.draw();
			this._content.validate();
			this._contentHeight = this._content.height;
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.SPLASH_SCREEN);
		}

	}
}
