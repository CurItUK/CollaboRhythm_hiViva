package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.ImageLoader;

	import feathers.controls.Label;

	import feathers.core.FeathersControl;

	import starling.display.Image;

	public class SubscriptCircle extends FeathersControl
	{
		//private var _img:Image;
		private var _img:Image;
		private var _text:String;
		private var _label:Label

		public function SubscriptCircle()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._label.validate();
			this._label.x = (this._img.width * 0.5) - (this._label.width * 0.5);
			this._label.y = (this._img.height * 0.5) - (this._label.height * 0.5);
		}

		override protected function initialize():void
		{
			super.initialize();

			this._img = new Image(Main.assets.getTexture("suberscript_circle"));
			this.addChild(this._img);

			this._label = new Label();
			this._label.name = HivivaThemeConstants.SUPERSCRIPT_LABEL;
			this._label.text = this._text;
			this.addChild(this._label);
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}
	}
}
