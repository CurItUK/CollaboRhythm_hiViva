package collaboRhythm.hiviva.view
{

	import feathers.controls.Header;
	import feathers.controls.Screen;


	public class HivivaPatientHomeScreen extends ScreenBase
	{
		private var _header:Header;

		public function HivivaPatientHomeScreenScreen()
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
			this._header.title = "Home Screen";
			addChild(this._header);
		}
	}
}
