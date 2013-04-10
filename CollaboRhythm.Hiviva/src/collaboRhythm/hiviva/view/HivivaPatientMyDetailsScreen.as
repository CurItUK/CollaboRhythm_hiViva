package collaboRhythm.hiviva.view
{

	import feathers.controls.Header;
	import feathers.controls.Screen;


	public class HivivaPatientMyDetailsScreen extends Screen
	{
		private var _header:Header;

		public function HivivaPatientMyDetailsScreen()
		{

		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
		}

		override protected function initialize():void
		{
			this._header = new Header();
			this._header.title = "My Details";
			addChild(this._header);


		}


	}
}
