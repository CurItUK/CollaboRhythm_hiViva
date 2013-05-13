package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaAssets;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.ScrollText;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	import flash.geom.Rectangle;

	import starling.events.Event;

	public class HivivaPopUp extends FeathersControl
	{
		private var _scale:Number;

		public function set scale(value:Number):void
		{
			this._scale = value;
		}
		public function get scale():Number
		{
			return this._scale;
		}

		private var _message:String;

		public function set message(value:String):void
		{
			this._message = value;
		}
		public function get message():String
		{
			return this._message;
		}

		private var _confirmLabel:String;

		public function set confirmLabel(value:String):void
		{
			this._confirmLabel = value;
		}
		public function get confirmLabel():String
		{
			return this._confirmLabel;
		}

		private var _bg:Scale9Image;
		private var _label:Label;
		private var _confirmButton:Button;
		private var _closeButton:Button;

		private const PADDING:Number = 40;
		private const GAP:Number = 20;

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

			this._bg.width = this.actualWidth;

			this._label.width = this.actualWidth - (scaledPadding * 2);
			//this._label.x = scaledPadding;
			//this._label.y = scaledPadding;
			this._label.validate();

			this._confirmButton.validate();
			this._confirmButton.x = (this.actualWidth / 2) - (this._confirmButton.width / 2);
			this._confirmButton.y = this._label.y + this._label.height + scaledGap;

			fullHeight = this._confirmButton.y + this._confirmButton.height + scaledGap + scaledPadding;

			//this._bg.height = this.height = fullHeight;
			setSizeInternal(this.actualWidth, fullHeight, true);

		}

		override protected function initialize():void
		{
			super.initialize();

			var bgTexture:Scale9Textures = new Scale9Textures(HivivaAssets.POPUP_PANEL, new Rectangle(60,60,344,229));
			this._bg = new Scale9Image(bgTexture, this._scale);
			addChild(this._bg);

			this._label = new Label();
			this._label.textRendererProperties.padding = PADDING * this._scale;
			this._label.text = this._message;
			addChild(this._label);

			this._confirmButton = new Button();
			this._confirmButton.label = this._confirmLabel;
			this._confirmButton.addEventListener(Event.TRIGGERED, confirmButtonHandler);
			addChild(this._confirmButton);

			this._closeButton = new Button();
			this._closeButton.name = "close-button";
			this._closeButton.addEventListener(Event.TRIGGERED, closeButtonHandler);
			addChild(this._closeButton);
		}

		public function drawCloseButton():void
		{
			var scaledPadding:Number = PADDING * this._scale;
			this._closeButton.validate();
			this._closeButton.x = this.actualWidth - (this._closeButton.width / 2) - scaledPadding;
			this._closeButton.y = 0 - (this._closeButton.height / 2) + scaledPadding;
		}

		private function confirmButtonHandler(e:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function closeButtonHandler(e:Event):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}
