package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Screen;
	import feathers.display.TiledImage;

	public class ScreenBase extends Screen
	{
		private var _tiledBackground:TiledImage;


		public function ScreenBase()
		{
			super();
		}

		override protected function draw():void
		{
/*
			this._tiledBackground.width = this.actualWidth;
			this._tiledBackground.height = this.actualHeight;
			*/
		}

		override protected function initialize():void
		{

			drawBackground();
		}

		private function drawBackground():void
		{
			/*
			this._tiledBackground = new TiledImage(Assets.getTexture("grid"));
			addChild(this._tiledBackground);
			*/
		}
	}
}
