package collaboRhythm.hiviva.view
{

	import feathers.controls.Header;
	import feathers.controls.Screen;


	public class HivivaPatientVirusModelScreen extends Screen
	{

		private var _header:HivivaHeader;

		public function HivivaPatientVirusModelScreen()
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
			this._header.title = "Virus Model";
			addChild(this._header);
		}


	}
}
