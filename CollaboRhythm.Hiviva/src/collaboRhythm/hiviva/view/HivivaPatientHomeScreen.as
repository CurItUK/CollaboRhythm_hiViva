package collaboRhythm.hiviva.view
{

	import feathers.controls.Header;
	import feathers.controls.Screen;

	import starling.display.Sprite;






	public class HivivaPatientHomeScreen extends Screen
	{
		private var _header:Header;


		public function HivivaPatientHomeScreenScreen()
		{

		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
		}

		override protected function initialize():void
		{
			this._header = new Header();
			this._header.title = "Home Screen";
			addChild(this._header);

		}

		private function drawBackground():void
		{


		}


	}
}
