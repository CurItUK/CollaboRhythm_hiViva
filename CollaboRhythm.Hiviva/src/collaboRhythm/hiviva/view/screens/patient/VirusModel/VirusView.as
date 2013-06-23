package collaboRhythm.hiviva.view.screens.patient.VirusModel
{
	import collaboRhythm.hiviva.view.Main;

	import com.greensock.TweenLite;

	import flash.utils.Timer;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;


	public class VirusView extends Sprite
	{

		private var _alive:Boolean;
		private var _animationTimer:Timer;
		private var _virusImage:Image;
		private var _holder:Sprite;

		public function VirusView(texture:Texture)
		{
			this._holder = new Sprite();

			this._virusImage = new Image(texture);
			this._virusImage.width = 46;
			this._virusImage.height = 46;


			this._holder.addChild(this._virusImage);
			this._virusImage.x = this._virusImage.width >> 2;
			this._virusImage.y = this._virusImage.height >> 2;
			this.addChild(this._holder);
			this._holder.x = -this._holder.width / 2;
			this._holder.y = -this._holder.height / 2;

		}

		public function init(alive:Boolean):void
		{
			_alive = alive;

			if (alive)
			{
				this.addEventListener(Event.ENTER_FRAME, aliveVirusAnimation);
			}
			else
			{

				this._holder.x = -40;
				this._holder.y = -40;
			}
		}

		private function aliveVirusAnimation(e:Event):void
		{
			TweenLite.to(this._holder, 0.2, {x: -this._holder.width / 2 + (Math.random() * 3) - 1 , y:-this._holder.height / 2 + (Math.random() * 3) - 1});


		}
	}
}
