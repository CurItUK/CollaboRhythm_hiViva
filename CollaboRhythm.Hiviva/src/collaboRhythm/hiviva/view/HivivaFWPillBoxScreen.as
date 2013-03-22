package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaFWPillBoxScreen extends Screen
	{
		private var header:Header;
		private var list:List;


		public function HivivaFWPillBoxScreen()
		{


		}

		override protected function draw():void
		{
			header.width = actualWidth;
		}

		override protected function initialize():void
		{

			header = new Header();
			header.title = "Pill Box Screen";

			var backButton:Button = new Button();
			backButton.label = "Back";
			backButton.addEventListener(starling.events.Event.TRIGGERED , onBackHandler)

			header.leftItems = new <DisplayObject>[backButton];
			addChild(header);

		}


		private function onBackHandler(e:Event):void
		{
			owner.showScreen(HivivaScreens.CLOCK_SCREEN);
		}
	}
}
