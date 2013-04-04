package collaboRhythm.hiviva.view
{

	import feathers.controls.Header;
	import feathers.controls.Screen;


	public class HivivaPatientClockScreen extends Screen
	{
		private var _header:Header;

		public function HivivaPatientClockScreen()
		{

		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
		}

		override protected function initialize():void
		{
			this._header = new Header();
			this._header.title = "Clock Screen";
			addChild(this._header);


		}


	}
}
