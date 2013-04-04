package collaboRhythm.hiviva.view
{

	import feathers.controls.Header;
	import feathers.controls.Screen;


	public class HivivaPatientVirusModelScreen extends Screen
	{

		private var _header:Header;

		public function HivivaPatientVirusModelScreen()
		{

		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
		}

		override protected function initialize():void
		{
			this._header = new Header();
			this._header.title = "Virus Model Screen";
			addChild(this._header);
		}


	}
}
