package collaboRhythm.hiviva.view
{


	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.display.TiledImage;

	public class HivivaPatientHomeScreen extends Screen
	{
		private var _header:Header;



		private var _tileImage:TiledImage;

		public function HivivaPatientHomeScreenScreen()
		{

		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;

			_tileImage.width = this.actualWidth;
			_tileImage.height = this.actualHeight;

			//_image.height = this.actualHeight;
		}

		override protected function initialize():void
		{
			this._header = new Header();
			this._header.title = "Home Screen";
			addChild(this._header);

			drawBackground();
		}

		private function drawBackground():void
		{
			_tileImage = new TiledImage(Assets.getTexture("grid"));
			addChild(_tileImage);
		}

	}
}
