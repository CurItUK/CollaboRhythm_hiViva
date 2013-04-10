package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.utils.TextureLoader;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.display.TiledImage;

	import starling.display.Image;
	import starling.textures.Texture;

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
			_tileImage = new TiledImage(TextureLoader.getInstance().getBitmapTexture("gridBackground" , Assets.grid));
			addChild(_tileImage);
		}
	}
}
