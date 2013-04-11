package collaboRhythm.hiviva.view
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;

	import starling.display.DisplayObject;
	import starling.events.Event;


	public class HivivaPatientSideNavScreen extends Screen
	{
		private var _header:Header;

		public function HivivaPatientSideNavScreen()
		{
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
		}

		override protected function initialize():void
		{

			this._header = new Header();
			this._header.title = "Side Nav";
			addChild(this._header);


		}

	}
}
