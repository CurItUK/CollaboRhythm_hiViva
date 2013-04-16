package collaboRhythm.hiviva.view
{

	import feathers.controls.Button;
	import feathers.controls.Header;

	import starling.display.DisplayObject;

	import starling.events.Event;

	public class HivivaPatientHelpScreen extends ScreenBase
	{
		private var _header:Header;

		public function HivivaPatientHelpScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
		}

		override protected function initialize():void
		{
			super.initialize()
			this._header = new Header();
			this._header.title = "Help Screen";
			addChild(this._header);

			var homeBtn:Button = new Button();
			homeBtn.label = "Home";
			homeBtn.addEventListener(Event.TRIGGERED , homeBtnHandler);



			this._header.leftItems =  new <DisplayObject>[homeBtn];

		}

		private function homeBtnHandler():void
		{
			this.dispatchEventWith("navGoHome");
		}

	}
}
