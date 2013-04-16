package collaboRhythm.hiviva.view
{

	import feathers.controls.Header;

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
		}
	}
}
