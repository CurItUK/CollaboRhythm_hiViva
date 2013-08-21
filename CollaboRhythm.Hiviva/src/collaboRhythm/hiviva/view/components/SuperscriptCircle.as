package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.Main;

	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.text.BitmapFontTextFormat;

	import flash.text.TextFormatAlign;

	import starling.display.Image;
	import starling.text.TextField;
	import starling.utils.Color;

	public class SuperscriptCircle extends FeathersControl
	{
		private var _scale:Number = 1;
		private var _img:Image;
		private var _text:String;
		private var _label:Label;
		private var _imgOrigWidth:Number;

		public function SuperscriptCircle()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._label.validate();

			this._img.width = this._imgOrigWidth + (this.scale * 4);
			this._img.scaleY = this._img.scaleX;

			this._label.x = (this._img.width * 0.5) - (this._label.width * 0.5);
			this._label.y = (this._img.height * 0.5) - (this._label.height * 0.5);

			setSizeInternal(this._img.width,this._img.height,false);
		}

		override protected function initialize():void
		{
			super.initialize();

			this._img = new Image(Main.assets.getTexture("superscript_circle"));
			this.addChild(this._img);
			this._imgOrigWidth = this._img.width;

			this._label = new Label();
			this._label.text = this._text;
			this.addChild(this._label);
			this._label.textRendererProperties.textFormat = new BitmapFontTextFormat(TextField.getBitmapFont("normal-white-regular"), 13 + this.scale, Color.WHITE,TextFormatAlign.CENTER);
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
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
