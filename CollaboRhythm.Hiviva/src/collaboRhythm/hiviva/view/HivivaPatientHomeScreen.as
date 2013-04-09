package collaboRhythm.hiviva.view
{

	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.display.TiledImage;

	import starling.display.Image;
	import starling.textures.Texture;

	public class HivivaPatientHomeScreen extends Screen
	{
		private var _header:Header;

		[Embed(source="/resources/grid.jpg")]
		private var grid:Class;

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

			var texture:Texture = Texture.fromBitmap(new grid());
			texture.repeat = true;

			_tileImage = new TiledImage(texture);


			addChild(_tileImage);
		}
	}
}
