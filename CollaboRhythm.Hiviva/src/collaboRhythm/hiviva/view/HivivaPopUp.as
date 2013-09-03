package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.ScrollText;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;

	import starling.events.Event;

	public class HivivaPopUp extends FeathersControl
	{
		private var _scale:Number = 1;
		private var _message:String;
		private var _bg:Scale9Image;
		private var _label:Label;
		private var _buttons:Array = [];
		private var _btnVector:Vector.<Button> = new <Button>[];
		private var _closeButton:Button;

		private const PADDING:Number = 40;
		private const GAP:Number = 20;
		private const WIDTH:Number = Constants.STAGE_WIDTH * 0.8;

		public function HivivaPopUp()
		{
			super();
		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this._scale;
			var scaledGap:Number = GAP * this._scale;
			var fullHeight:Number;

			super.draw();

			this._bg.width = WIDTH;

			this._label.width = WIDTH - (scaledPadding * 4);
			this._label.x = this._label.y = scaledPadding * 2;
			this._label.validate();
/*
			this._confirmButton.validate();
			this._confirmButton.x = (WIDTH / 2) - (this._confirmButton.width / 2);
			this._confirmButton.y = this._label.y + this._label.height + scaledGap;
			*/
			drawButtons();

			fullHeight = _btnVector[0].y + _btnVector[0].height + scaledGap + scaledPadding;

			//this._bg.height = this.height = fullHeight;
			setSizeInternal(WIDTH, fullHeight, true);
		}

		override protected function initialize():void
		{
			super.initialize();

			var bgTexture:Scale9Textures = new Scale9Textures(Main.assets.getTexture("popup_panel"), new Rectangle(60,60,344,229));
			this._bg = new Scale9Image(bgTexture, this._scale);
			addChild(this._bg);

			this._label = new Label();
			this._label.name = HivivaThemeConstants.BODY_CENTERED_LABEL;
			this._label.text = this._message;
			addChild(this._label);

			initializeButtons();

			this._closeButton = new Button();
			this._closeButton.name = HivivaThemeConstants.CLOSE_BUTTON;
			this._closeButton.addEventListener(Event.TRIGGERED, buttonHandler);
			addChild(this._closeButton);
		}

		private function initializeButtons():void
		{
			var loop:int = this._buttons.length,
				btn:Button;
			for (var i:int = 0; i < loop; i++)
			{
				btn = new Button();
				btn.addEventListener(Event.TRIGGERED, buttonHandler);
				btn.label = _buttons[i];
				addChild(btn);
				_btnVector.push(btn);
			}
		}

		private function drawButtons():void
		{
			var loop:int = this._btnVector.length,
				btn:Button,
				gap:Number = (WIDTH * 0.04) * this._scale,
				minButtonWidth:Number = (WIDTH * 0.25) * this._scale,
				btnsWidth:Number = gap,
				btnsStartY:Number = this._label.y + this._label.height + GAP,
				i:int;
			for (i= 0; i < loop; i++)
			{
				btn = _btnVector[i];
				btn.validate();
				btn.width = btn.width < minButtonWidth ? minButtonWidth : btn.width;
				btn.y = btnsStartY;
				btnsWidth += btn.width + gap;
			}

			for (i = 0; i < _btnVector.length; i++)
			{
				btn = _btnVector[i];
				btn.x = (WIDTH * 0.5) - (btnsWidth * 0.5);
				btn.x += (btn.width * i) + gap;
			}
		}

		private function buttonHandler(e:Event):void
		{
			var btn:Button = e.target as Button;
			if(btn == this._closeButton)
			{
				dispatchEventWith(Event.TRIGGERED, false, {button:"Close"});
			}
			dispatchEventWith(Event.TRIGGERED, false, {button:btn.label});
		}

		public function drawCloseButton():void
		{
			var scaledPadding:Number = PADDING * this._scale;
			this._closeButton.validate();
			this._closeButton.x = WIDTH - (this._closeButton.width / 2) - scaledPadding;
			this._closeButton.y = 0 - (this._closeButton.height / 2) + scaledPadding;
		}

		public function set scale(value:Number):void
		{
			this._scale = value;
		}

		public function get scale():Number
		{
			return this._scale;
		}

		public function set message(value:String):void
		{
			this._message = value;
		}

		public function get message():String
		{
			return this._message;
		}

		public function get buttons():Array
		{
			return _buttons;
		}

		public function set buttons(value:Array):void
		{
			_buttons = value;
		}
	}
}
