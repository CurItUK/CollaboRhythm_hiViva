package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaAssets;

	import feathers.controls.Button;

	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import flash.display.Loader;
	import flash.events.IOErrorEvent;

	import flash.events.MediaEvent;

	import flash.filesystem.File;
	import flash.geom.Matrix;

	import flash.geom.Rectangle;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.net.URLRequest;

	import starling.display.Image;
	import starling.display.Quad;

	import starling.events.Event;
	import starling.textures.Texture;

	public class ImageUploader extends FeathersControl
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

		private var _fileName:String;
		public function set fileName(value:String):void
		{
			this._fileName = value;
		}
		public function get fileName():String
		{
			return this._fileName;
		}

		private var _bg:Scale9Image;
		private var _uploadButton:Button;
		private var _imageBg:Quad;
		private var _imageHolder:Image;

		private const IMAGE_SIZE:Number = 150;
		private const PADDING:Number = 32;

		public function ImageUploader()
		{
			super();
		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this._scale;
			var imageBgEnd:Number, remainingCenterX:Number;

			super.draw();

			this._bg.width = this.actualWidth;

			this._imageBg.x = this._bg.x + (scaledPadding * 0.5);
			this._imageBg.y = this._bg.y + (scaledPadding * 0.5);

			this._bg.height = this._imageBg.y + this._imageBg.height + (scaledPadding * 0.5);

			imageBgEnd = (this._imageBg.x + this._imageBg.width);
			remainingCenterX = (this._bg.x + this._bg.width - imageBgEnd) / 2;

			this._uploadButton.validate();
			this._uploadButton.x =  imageBgEnd + remainingCenterX - (this._uploadButton.width / 2);
			this._uploadButton.y = (this._bg.height / 2) - (this._uploadButton.height / 2);

			setSizeInternal(this._bg.width, this._bg.height, true);
		}

		override protected function initialize():void
		{
			super.initialize();
			var bgTexture:Scale9Textures = new Scale9Textures(HivivaAssets.INPUT_FIELD, new Rectangle(11,11,32,32));
			this._bg = new Scale9Image(bgTexture, this._scale);
			addChild(this._bg);

			this._imageBg = new Quad(IMAGE_SIZE * this._scale, IMAGE_SIZE * this._scale, 0x000000);
			addChild(this._imageBg);

			this._uploadButton = new Button();
			this._uploadButton.defaultIcon = new Image(HivivaAssets.UPLOAD_ICON);
			this._uploadButton.iconPosition = Button.ICON_POSITION_LEFT;
			this._uploadButton.label = "UPLOAD PHOTO";
			this._uploadButton.addEventListener(Event.TRIGGERED, uploadButtonHandler);
			addChild(this._uploadButton);
		}

		public function getMainImage():void
		{
			var destination:File = File.applicationStorageDirectory;
			destination = destination.resolvePath(this._fileName);
			if (destination.exists)
			{
				doImageLoad(destination.url);
			}
		}

		public function saveTempImageAsMain():Boolean
		{
			var temp:File = File.applicationStorageDirectory.resolvePath("temp" + this._fileName);
			var main:File = File.applicationStorageDirectory.resolvePath(this._fileName);
			if(temp.exists) temp.moveTo(main,true);
			return main.exists;
		}

		private function uploadButtonHandler(e:Event):void
		{
			if (CameraRoll.supportsBrowseForImage)
			{
				trace("Browsing for image...");
				var mediaSource:CameraRoll = new CameraRoll();
				mediaSource.addEventListener(flash.events.MediaEvent.SELECT, imageSelected);
				mediaSource.addEventListener(flash.events.Event.CANCEL, browseCanceled);
				mediaSource.browseForImage();
			}
			else
			{
				trace("Browsing in camera roll is not supported.");
			}
		}

		private function imageSelected(e:MediaEvent):void
		{
			trace("Image selected...");

			var imageSource:MediaPromise = e.data;
			// set destination location
			var destination:File = File.applicationStorageDirectory;
			destination = destination.resolvePath("temp" + this._fileName);
			// copy source to destination
			imageSource.file.copyTo(destination, true);
			var copiedFile:File = File.applicationStorageDirectory;
			copiedFile = copiedFile.resolvePath("temp" + this._fileName);

			doImageLoad(copiedFile.url);
		}

		private function browseCanceled(e:flash.events.Event):void
		{
			trace("Image browse canceled.");
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
			this._imageHolder = new Image(Texture.fromBitmap(suitableBm));
			constrainToProportion(this._imageHolder, IMAGE_SIZE * this._scale);
			// TODO : Check if if (img.height >= img.width) then position accordingly. right now its only Ypos
			this._imageHolder.x = this._imageBg.x;
			this._imageHolder.y = this._imageBg.y + (this._imageBg.height / 2) - (this._imageHolder.height / 2);
			if (!contains(this._imageHolder)) addChild(this._imageHolder);
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
	}
}
