package collaboRhythm.hiviva.view.screens
{
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.utils.HivivaModifier;

	import feathers.controls.Button;
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
		private var _messageData:XML;
		private var _bg:Scale9Image;
		private var _viewMessageBtn:Button;
		private var _messageDetail:Label;
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
				fullHeight:Number;

			super.draw();

			this._messageDetail.validate();


			this._bg.x = scaledPadding;
			this._bg.width = this.actualWidth - (scaledPadding * 2);
			this._bg.height = scaledPadding + this._messageDetail.height;

			this._messageDetail.x = this._bg.x + scaledPadding;
			this._messageDetail.y = this._bg.y + scaledPadding;
			this._messageDetail.width = this._bg.width - scaledPadding;


			this._viewMessageBtn.validate();
			this._viewMessageBtn.width = this._bg.width;
			this._viewMessageBtn.height = this._bg.height;
			this._viewMessageBtn.x =  this._bg.x;
			this._viewMessageBtn.y = this._bg.y;
			setSizeInternal(this.actualWidth, this._bg.height, true);
		}

		override protected function initialize():void
		{
			super.initialize();
			var bgTexture:Scale9Textures = new Scale9Textures(HivivaAssets.INPUT_FIELD, new Rectangle(11,11,32,32));
			this._bg = new Scale9Image(bgTexture, this._scale);
			addChild(this._bg);

			this._messageDetail = new Label();
			this._messageDetail.text = "<font face='ExoBold'>" + messageData.date + " :</font>  " + messageData.body;
			this.addChild(this._messageDetail);


			this._viewMessageBtn = new Button();
			this._viewMessageBtn.label = "";
			this._viewMessageBtn.alpha = 0;
			this._viewMessageBtn.addEventListener(Event.TRIGGERED , messageCellSelectHandler);
			addChild(this._viewMessageBtn);
		}

		private function messageCellSelectHandler(e:Event):void
		{

			//var evt:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.PATIENT_PROFILE_SELECTED);
			//evt.evtData.profile = patientData;
			//this.dispatchEvent(evt);
		}

		override public function dispose():void
		{
			this._bg.removeEventListener(Event.TRIGGERED , messageCellSelectHandler);
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

		public function set messageData(value:XML):void
		{
			this._messageData = value;
		}

		public function get messageData():XML
		{
			return this._messageData;
		}
	}
}
