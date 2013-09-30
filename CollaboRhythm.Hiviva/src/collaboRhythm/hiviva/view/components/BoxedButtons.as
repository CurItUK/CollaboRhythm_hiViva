package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.view.Main;

	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.textures.Scale9Textures;

	import flash.geom.Rectangle;

	import starling.events.Event;

	public class BoxedButtons extends FeathersControl
	{
		private var _bg:Scale9Image;
		private var _btnHolder:ScrollContainer;
		private var _labels:Array = [];
		private var _scale:Number = 1;
		private var _buttonThemeStyle:String;

		public function BoxedButtons(buttonThemeStyle:String = "")
		{
			_buttonThemeStyle = buttonThemeStyle;
			super();
		}

		override protected function draw():void
		{
			super.draw();

			drawButtons();

			this._bg.width = this.actualWidth;
			this._bg.height = this._btnHolder.height;

			setSizeInternal(this._bg.width, this._bg.height, true);
		}

		override protected function initialize():void
		{
			super.initialize();

			var bgTexture:Scale9Textures = new Scale9Textures(Main.assets.getTexture("input_field"), new Rectangle(11,11,32,32));
			this._bg = new Scale9Image(bgTexture, this._scale);
			this._bg.touchable = false;
			addChild(this._bg);
		}

		private function drawButtons():void
		{
			var btn:Button;
			const 	loop:int = this._labels.length,
					gap:Number = (this.actualWidth * 0.02) * this._scale,
					minButtonWidth:Number = (this.actualWidth * 0.25) * this._scale,
					hLayout:HorizontalLayout = new HorizontalLayout();
			hLayout.gap = gap;
			hLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			hLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;

			this._btnHolder = new ScrollContainer();
			this._btnHolder.layout = hLayout;
			this._btnHolder.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			addChild(this._btnHolder);

			for (var i:int = 0; i < loop; i++)
			{
				btn = new Button();
				if(_buttonThemeStyle.length > 0) btn.name = _buttonThemeStyle;
				btn.addEventListener(Event.TRIGGERED, buttonHandler);
				btn.label = _labels[i];
				this._btnHolder.addChild(btn);
				btn.validate();
				btn.width = btn.width < minButtonWidth ? minButtonWidth : btn.width;
			}

			this._btnHolder.height = btn.height * 1.8;
			this._btnHolder.width = this.actualWidth;
			this._btnHolder.validate();
		}

		private function buttonHandler(e:Event):void
		{
			var btn:Button = e.target as Button;
			dispatchEventWith(Event.TRIGGERED, false, {button:btn.label});
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
		}

		public function get labels():Array
		{
			return _labels;
		}

		public function set labels(value:Array):void
		{
			_labels = value;
		}
	}
}
