package collaboRhythm.hiviva.view.screens.patient.VirusModel
{
	import collaboRhythm.hiviva.view.Main;

	import flash.utils.Timer;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class VirusView extends Sprite
	{

		private var _alive:Boolean;
		private var _animationTimer:Timer;
		private var _virusImage:Image;

		public function VirusView()
		{
			this._virusImage= new Image(Main.assets.getTexture("vs_virus"));
			this.addChild(this._virusImage);
		}

		public function init(alive:Boolean):void
		{
			_alive = alive;

			if (alive)
			{
				//TODO Animate virus movement;
			}
			else
			{
				this._virusImage.width = 46;
				this._virusImage.height = 46;
				this._virusImage.x = -23;
				this._virusImage.y = -23;
			}

		}
	}
}
