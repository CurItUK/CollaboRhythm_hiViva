package collaboRhythm.hiviva.view.screens
{
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

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

	public class PatientResultCellHome extends FeathersControl
	{
		private var _scale:Number = 1;
		private var _isResult:Boolean;
		private var _patientData:XML;
		private var _bg:Scale9Image;
		private var _patientImageBg:Quad;
		private var _photoHolder:Image;
		private var _patientName:Label;
		private var _adherenceTolerabilityLabel:Label;
		private var _viewProfileBtn:Button;




		private const IMAGE_SIZE:Number = 100;
		private const PADDING:Number = 32;

		public function PatientResultCellHome()
		{
			super();
		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this._scale,
				gap:Number = scaledPadding * 0.5;
				fullHeight:Number;

			super.draw();

			doImageLoad("media/patients/" + patientData.picture);
			this._patientName.validate();

			this._bg.x = scaledPadding;
			this._bg.width = this.actualWidth - (scaledPadding * 2);
			this._bg.height = scaledPadding + this._patientImageBg.height;

			this._patientImageBg.x = this._bg.x + gap;
			this._patientImageBg.y = this._bg.y + gap;

			this._patientName.x = this._patientImageBg.x + this._patientImageBg.width + gap;
			this._patientName.y = this._patientImageBg.y + gap;
			this._patientName.width = this._bg.width - this._patientName.x;

			this._adherenceTolerabilityLabel.validate();
			this._adherenceTolerabilityLabel.width = 200;
			this._adherenceTolerabilityLabel.x = this._bg.x + this._bg.width - this._adherenceTolerabilityLabel.width - gap;
			this._adherenceTolerabilityLabel.y = this._patientName.y;

			this._viewProfileBtn.validate();
			this._viewProfileBtn.width = this._bg.width;
			this._viewProfileBtn.height = this._bg.height;
			this._viewProfileBtn.x =  this._bg.x;
			this._viewProfileBtn.y = this._bg.y;
			setSizeInternal(this.actualWidth, this._bg.height, true);
		}

		override protected function initialize():void
		{
			super.initialize();
			var bgTexture:Scale9Textures = new Scale9Textures(Main.assets.getTexture("input_field"), new Rectangle(11,11,32,32));
			this._bg = new Scale9Image(bgTexture, this._scale);
			addChild(this._bg);

			this._patientImageBg = new Quad(IMAGE_SIZE * this._scale, IMAGE_SIZE * this._scale, 0x000000);
			this._patientImageBg.touchable = false;
			addChild(this._patientImageBg);

			this._patientName = new Label();
			this._patientName.name = "";
			this._patientName.text = patientData.name;

			addChild(this._patientName);

//			var avgTolerability:Number = HivivaModifier.calculateOverallTolerability(patientData.medicationHistory.history);
//			var avgAdherence:Number = HivivaModifier.calculateOverallAdherence(patientData.medicationHistory.history);
			this._adherenceTolerabilityLabel = new Label();
			this._adherenceTolerabilityLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._adherenceTolerabilityLabel.text = "Adherence: " + String(patientData.adherence) +  "%\n" +
													"Tolerability: " + String(patientData.tolerability) + "%";

			addChild(this._adherenceTolerabilityLabel);

			this._viewProfileBtn = new Button();
			this._viewProfileBtn.label = "";
			this._viewProfileBtn.alpha = 0;
			this._viewProfileBtn.addEventListener(Event.TRIGGERED , patientCellSelectHandler);
			addChild(this._viewProfileBtn);

		}

		private function patientCellSelectHandler(e:Event):void
		{
			var evt:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.PATIENT_PROFILE_SELECTED);
			evt.evtData.profile = patientData;
			this.dispatchEvent(evt);
		}

		private function onPatientDelete(e:Event):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}

		private function doImageLoad(url:String):void
		{
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoaded);
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadFailed);
			imageLoader.load(new URLRequest(url));
		}

		private function imageLoaded(e:flash.events.Event):void
		{
			trace("Image loaded.");

			var suitableBm:Bitmap = getSuitableBitmap(e.target.content as Bitmap);

			this._photoHolder = new Image(Texture.fromBitmap(suitableBm));
			this._photoHolder.touchable = false;
			constrainToProportion(this._photoHolder, IMAGE_SIZE * this._scale);
			// TODO : Check if if (img.height >= img.width) then position accordingly. right now its only Ypos
			this._photoHolder.x = this._patientImageBg.x;
			this._photoHolder.y = this._patientImageBg.y + (this._patientImageBg.height / 2) - (this._photoHolder.height / 2);
			if (!contains(this._photoHolder)) addChild(this._photoHolder);
		}

		private function imageLoadFailed(e:Event):void
		{
			trace("Image load failed.");
		}

		private function getSuitableBitmap(sourceBm:Bitmap):Bitmap
		{
			var bm:Bitmap;
			// if source bitmap is larger than starling size limit of 2048x2048 than resize
			if (sourceBm.width >= 2048 || sourceBm.height >= 2048)
			{
				// TODO: may need to remove size adjustment from bm! only adjust the data (needs formula)
				constrainToProportion(sourceBm, 2040);
				// copy source bitmap at adjusted size
				var bmd:BitmapData = new BitmapData(sourceBm.width, sourceBm.height);
				var m:Matrix = new Matrix();
				m.scale(sourceBm.scaleX, sourceBm.scaleY);
				bmd.draw(sourceBm, m, null, null, null, true);
				bm = new Bitmap(bmd, 'auto', true);
			}
			else
			{
				bm = sourceBm;
			}
			return bm;
		}

		private function constrainToProportion(img:Object, size:Number):void
		{
			if (img.height >= img.width)
			{
				img.height = size;
				img.scaleX = img.scaleY;
			}
			else
			{
				img.width = size;
				img.scaleY = img.scaleX;
			}
		}

		override public function dispose():void
		{
			this._bg.removeEventListener(Event.TRIGGERED , patientCellSelectHandler);
			this._patientImageBg.dispose();
			this._photoHolder.dispose();

			removeChildren(0,-1,true);
			removeEventListeners();

			this._patientImageBg = null;
			this._photoHolder = null;

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

		public function set isResult(value:Boolean):void
		{
			this._isResult = value;
		}

		public function get isResult():Boolean
		{
			return this._isResult;
		}

		public function set patientData(value:XML):void
		{
			this._patientData = value;
		}

		public function get patientData():XML
		{
			return this._patientData;
		}
	}
}
