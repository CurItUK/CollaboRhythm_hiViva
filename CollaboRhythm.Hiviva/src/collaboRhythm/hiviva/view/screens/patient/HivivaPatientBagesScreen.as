package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.view.*;

	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.screens.shared.BaseScreen;

	import feathers.controls.Button;
	import feathers.controls.Screen;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaPatientBagesScreen extends BaseScreen
	{
		public function HivivaPatientBagesScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Badges";

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
