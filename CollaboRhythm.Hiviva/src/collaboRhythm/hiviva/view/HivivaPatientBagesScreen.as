package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Button;
	import feathers.controls.Screen;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaPatientBagesScreen extends Screen
	{

		private var _header:HivivaHeader;


		public function HivivaPatientBagesScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Badges";
			addChild(this._header);

			var homeBtn:Button = new Button();
			homeBtn.name = "home-button";
			homeBtn.addEventListener(Event.TRIGGERED, homeBtnHandler);
			this._header.leftItems = new <DisplayObject>[homeBtn];
		}

		private function homeBtnHandler():void
		{
			this.dispatchEventWith("navGoHome");
		}


	}
}
