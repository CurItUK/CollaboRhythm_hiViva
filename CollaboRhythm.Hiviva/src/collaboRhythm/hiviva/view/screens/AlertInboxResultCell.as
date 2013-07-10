package collaboRhythm.hiviva.view.screens
{
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
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

	public class AlertInboxResultCell extends FeathersControl
	{
		private var _scale:Number;
		private var _seperator:Image;
		private var _viewMessageBtn:Button;
		private var _label:Label;
		private var _text:String = "";
		private var _guid:String;
		private const PADDING:Number = 32;

		public function AlertInboxResultCell()
		{
			super();
		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this._scale,
				gap:Number = scaledPadding * 0.5;

			super.draw();

			this._label.validate();

			this._seperator.width = this.actualWidth;

			this._label.y = gap;
			this._label.x = gap;
			this._label.width = this.actualWidth - scaledPadding;

			this._viewMessageBtn.width = this.actualWidth;
			this._viewMessageBtn.height = this._label.y + this._label.height + gap;

			setSizeInternal(this.actualWidth, this._viewMessageBtn.height, true);
		}

		override protected function initialize():void
		{
			super.initialize();
			this._seperator = new Image(Main.assets.getTexture("header_line"));
			addChild(this._seperator);

			this._label = new Label();
			this._label.text = _text;
			this.addChild(this._label);

			this._viewMessageBtn = new Button();
			this._viewMessageBtn.label = "";
			this._viewMessageBtn.alpha = 0;
			this._viewMessageBtn.addEventListener(Event.TRIGGERED , alertCellSelectHandler);
			addChild(this._viewMessageBtn);
		}

		private function alertCellSelectHandler(e:Event):void
		{
			var evt:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.MESSAGE_SELECT);
			evt.evtData.guid = this._guid;
			this.dispatchEvent(evt);
		}

		override public function dispose():void
		{
			this._seperator.removeEventListener(Event.TRIGGERED , alertCellSelectHandler);
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

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

		public function get guid():String
		{
			return _guid;
		}

		public function set guid(value:String):void
		{
			_guid = value;
		}
	}

}
