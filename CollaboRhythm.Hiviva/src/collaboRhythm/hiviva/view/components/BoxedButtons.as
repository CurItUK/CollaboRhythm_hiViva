package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	import flash.geom.Rectangle;

	import starling.events.Event;

	public class BoxedButtons extends FeathersControl
	{
		private var _bg:Scale9Image;
		private var _labels:Array = [];
		private var _btns:Vector.<Button> = new <Button>[];
		private var _scale:Number;

		public function BoxedButtons()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			drawButtons();

			this._bg.width = this.actualWidth;
			this._bg.height = this._btns[0].height * 1.8;

			setSizeInternal(this._bg.width, this._bg.height, true);
		}

		override protected function initialize():void
		{
			super.initialize();

			var bgTexture:Scale9Textures = new Scale9Textures(Main.assets.getTexture("input_field"), new Rectangle(11,11,32,32));
			this._bg = new Scale9Image(bgTexture, this._scale);
			this._bg.touchable = false;
			addChild(this._bg);

			initializeButtons();
		}

		private function initializeButtons():void
		{
			var loop:int = this._labels.length,
				btn:Button;
			for (var i:int = 0; i < loop; i++)
			{
				btn = new Button();
				btn.addEventListener(Event.TRIGGERED, buttonHandler);
				btn.label = _labels[i];
				addChild(btn);
				_btns.push(btn);
			}
		}

		private function drawButtons():void
		{
			var loop:int = this._btns.length,
				btn:Button,
				gap:Number = (this.actualWidth * 0.02) * this._scale,
				minButtonWidth:Number = (this.actualWidth * 0.25) * this._scale,
				btnsWidth:Number = gap,
				i:int;
			for (i= 0; i < loop; i++)
			{
				btn = _btns[i];
				btn.validate();
				btn.width = btn.width < minButtonWidth ? minButtonWidth : btn.width;
				btn.y = (_bg.height * 0.5) - (btn.height * 0.5);
				btnsWidth += btn.width + gap;
			}

			for (i = 0; i < _btns.length; i++)
			{
				btn = _btns[i];
				btn.x = (this.actualWidth * 0.5) - (btnsWidth * 0.5);
				btn.x += (btn.width * i) + gap;
			}
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

		override public function dispose():void
		{
			_btns = null;
			super.dispose();
		}
	}
}
