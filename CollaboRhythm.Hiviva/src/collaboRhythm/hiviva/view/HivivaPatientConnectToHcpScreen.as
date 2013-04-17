package collaboRhythm.hiviva.view
{
	import feathers.controls.Header;

	public class HivivaPatientConnectToHcpScreen extends ScreenBase
	{
		private var _header:Header;

		public function HivivaPatientConnectToHcpScreen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new Header();
			this._header.title = "Connect to a care provider";
		}
	}
}
