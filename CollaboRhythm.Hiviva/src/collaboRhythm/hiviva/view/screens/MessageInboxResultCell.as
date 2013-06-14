package collaboRhythm.hiviva.view.screens
{
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.Radio;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.textures.Scale9Textures;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;

	public class MessageInboxResultCell extends FeathersControl
	{
		private var _scale:Number;
		private var _seperator:Image;
		private var _viewMessageBtn:Button;
		private var _primaryLabel:Label;
		private var _primaryText:String = "";
		private var _secondaryLabel:Label;
		private var _secondaryText:String = "";
		private var _dateLabel:Label;
		private var _dateText:String = "";
		private var _check:Check;
		private var _uniqueId:String;
		private const IMAGE_SIZE:Number = 100;
		private const PADDING:Number = 32;

		public function MessageInboxResultCell()
		{
			super();
		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this._scale,
				gap:Number = scaledPadding * 0.5;

			super.draw();

			this._primaryLabel.validate();
			this._secondaryLabel.validate();
			this._dateLabel.validate();
			this._check.validate();

			this._seperator.width = this.actualWidth;

			_check.x = scaledPadding;

			this._primaryLabel.y = gap;
			this._primaryLabel.x = this._check.x + this._check.width + gap;
			this._primaryLabel.width = this.actualWidth - this._primaryLabel.x - scaledPadding - _dateLabel.width - gap;

			this._secondaryLabel.y = this._primaryLabel.y + this._primaryLabel.height;
			this._secondaryLabel.x = this._primaryLabel.x;
			this._secondaryLabel.width = this._primaryLabel.width;

			_dateLabel.x = this.actualWidth - this._dateLabel.width - scaledPadding;
			_dateLabel.y = this._primaryLabel.y + (this._primaryLabel.height + this._secondaryLabel.height) * 0.5;
			_dateLabel.y -= this._dateLabel.height * 0.5;

			_check.y = this._primaryLabel.y + (this._primaryLabel.height + this._secondaryLabel.height) * 0.5;
			_check.y -= this._check.height * 0.5;

			this._viewMessageBtn.x =  this._primaryLabel.x;
			this._viewMessageBtn.width = this.actualWidth - this._viewMessageBtn.x;
			this._viewMessageBtn.height = this._primaryLabel.y + this._primaryLabel.height + this._secondaryLabel.height + gap;

			setSizeInternal(this.actualWidth, this._viewMessageBtn.height, true);
		}

		override protected function initialize():void
		{
			super.initialize();
			this._seperator = new Image(Main.assets.getTexture("header_line"));
			addChild(this._seperator);

			this._primaryLabel = new Label();
			this._primaryLabel.text = _primaryText;
			this.addChild(this._primaryLabel);

			this._secondaryLabel = new Label();
			this._secondaryLabel.name = "message-date-label";
			this._secondaryLabel.text = _secondaryText;
			this.addChild(this._secondaryLabel);

			this._dateLabel = new Label();
			this._dateLabel.name = "message-date-label";
			this._dateLabel.text = _dateText;
			this.addChild(this._dateLabel);

			this._check = new Check();
			this.addChild(this._check);

			this._viewMessageBtn = new Button();
			this._viewMessageBtn.label = "";
			this._viewMessageBtn.alpha = 0;
			this._viewMessageBtn.addEventListener(Event.TRIGGERED , messageCellSelectHandler);
			addChild(this._viewMessageBtn);
		}

		private function messageCellSelectHandler(e:Event):void
		{
			var evt:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.HCP_MESSAGE_SELECTED);
			this.dispatchEvent(evt);
		}

		override public function dispose():void
		{
			this._seperator.removeEventListener(Event.TRIGGERED , messageCellSelectHandler);
			super.dispose();
		}

		public function set scale(value:Number):void
		{
			this._scale = value;
		}

		public function get scale():Number
		{
			return this._scale;
		}

		public function get primaryText():String
		{
			return _primaryText;
		}

		public function set primaryText(value:String):void
		{
			_primaryText = value;
		}

		public function get secondaryText():String
		{
			return _secondaryText;
		}

		public function set secondaryText(value:String):void
		{
			_secondaryText = value;
		}

		public function get dateText():String
		{
			return _dateText;
		}

		public function set dateText(value:String):void
		{
			_dateText = value;
		}

		public function get check():Check
		{
			return _check;
		}

		public function get uniqueId():String
		{
			return _uniqueId;
		}

		public function set uniqueId(value:String):void
		{
			_uniqueId = value;
		}
	}
}
