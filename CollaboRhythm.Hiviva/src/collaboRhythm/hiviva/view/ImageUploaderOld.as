package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;

	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	import mx.graphics.codec.JPEGEncoder;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;

	public class ImageUploaderOld extends FeathersControl
	{
		private var _scale:Number = 1;
		private var _fileName:String;
		private var _bg:Scale9Image;
		private var _uploadButton:Button;
		private var _trashButton:Button;
		private var _imageBg:Quad;
		private var _imageHolder:Image;
		private var _dataSource:IDataInput;
		private var _imagePromise:MediaPromise;
		private var _outStream:FileStream;
		private var _deleteTarget:File;
		private var _imageLoader:Loader;
		private var _mainDestination:File;
		private var _tempDestination:File;

		private const IMAGE_SIZE:Number = 150;
		private const PADDING:Number = 32;

		public function ImageUploaderOld()
		{
			super();
		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this._scale;

			super.draw();

			this._bg.width = this.actualWidth;

			this._imageBg.x = this._bg.x + (scaledPadding * 0.5);
			this._imageBg.y = this._bg.y + (scaledPadding * 0.5);

			this._bg.height = this._imageBg.y + this._imageBg.height + (scaledPadding * 0.5);

			this._trashButton.validate();
			this._trashButton.x = this._bg.width - scaledPadding - this._trashButton.width;
			this._trashButton.y = (this._bg.height / 2) - (this._trashButton.height / 2);

			this._uploadButton.validate();
			this._uploadButton.x =  this._trashButton.x - scaledPadding - this._uploadButton.width;
			this._uploadButton.y = (this._bg.height / 2) - (this._uploadButton.height / 2);

			setSizeInternal(this._bg.width, this._bg.height, true);

		}

		override protected function initialize():void
		{
			super.initialize();
			var bgTexture:Scale9Textures = new Scale9Textures(Main.assets.getTexture("input_field"), new Rectangle(11,11,32,32));
			this._bg = new Scale9Image(bgTexture, this._scale);
			addChild(this._bg);

			this._imageBg = new Quad(IMAGE_SIZE * this._scale, IMAGE_SIZE * this._scale, 0x000000);
			addChild(this._imageBg);

			this._uploadButton = new Button();
			this._uploadButton.defaultIcon = new Image(Main.assets.getTexture("icon_upload"));
			this._uploadButton.iconPosition = Button.ICON_POSITION_LEFT;
			this._uploadButton.label = "UPLOAD PHOTO   ";
			this._uploadButton.addEventListener(starling.events.Event.TRIGGERED, uploadButtonHandler);
			addChild(this._uploadButton);

			this._trashButton = new Button();
			this._trashButton.visible = false;
			this._trashButton.name = HivivaThemeConstants.DELETE_CELL_BUTTON;
			this._trashButton.addEventListener(starling.events.Event.TRIGGERED, deleteImageData);
			addChild(this._trashButton);

			this._deleteTarget = this._tempDestination;
		}

		private function deleteImageData(e:starling.events.Event = null):void
		{
			if(this._imagePromise != null) this._imagePromise.close();
			if(this._outStream != null) this._outStream.close();

			if(this._deleteTarget.exists)
			{
				this._deleteTarget.deleteFile();
			}

			if(this._imageHolder != null)
			{
				this._imageHolder.texture.dispose();
				this._imageHolder.dispose();
				this._imageHolder = null;
			}

			this._trashButton.visible = false;
			dispatchEventWith("uploadedImageChanged");
		}

		public function getMainImage():void
		{
			if (this._mainDestination.exists)
			{
				loadImageFromUrl(this._mainDestination.url);
				this._trashButton.visible = true;
				this._deleteTarget = this._mainDestination;
			}
		}

		public function saveTempImageAsMain():Boolean
		{
			if(this._tempDestination.exists)
			{
				this._tempDestination.moveTo(this._mainDestination,true);
				this._deleteTarget = this._mainDestination;
			}
			return this._mainDestination.exists;
		}

		private function uploadButtonHandler(e:starling.events.Event):void
		{
			if (CameraRoll.supportsBrowseForImage)
			{
				trace("Browsing for image...");
				var mediaSource:CameraRoll = new CameraRoll();
				mediaSource.addEventListener(MediaEvent.SELECT, imageSelected);
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

			deleteImageData();

			this._imagePromise = e.data;
			var targetFile:File = this._imagePromise.file;

			this._imageLoader = new Loader();
			if (this._imagePromise.isAsync)
			{
				// display target image
				this._imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoaded, false, 0, true);
				this._imageLoader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, imageLoadFailed, false, 0, true);
				this._imageLoader.loadFilePromise(this._imagePromise);


				// save target image in temp location
//				targetFile.addEventListener(flash.events.Event.COMPLETE, imageSaved, false, 0, true);
//				targetFile.copyToAsync(this._tempDestination, true);
			}
			else
			{
				// display target image
				this._imageLoader.loadFilePromise(this._imagePromise);
				imageLoaded();

				// save target image in temp location
				targetFile.copyTo(this._tempDestination, true);
				imageSaved();
			}



			// below solution doesn't work because AIR hijacks the image bytearray oreintation!
			/*
			this._dataSource = this._imagePromise.open();

			if (this._imagePromise.isAsync)
			{
				trace( "Asynchronous media promise." );
				var eventSource:IEventDispatcher = this._dataSource as IEventDispatcher;
				eventSource.addEventListener( flash.events.Event.COMPLETE, onMediaLoaded );
			}
			else
			{
				trace( "Synchronous media promise." );
				readMediaData();
			}*/
		}

		private function imageSaved(e:flash.events.Event = null):void
		{
			trace("image saved to temp destination");

			this._trashButton.visible = true;
			this._deleteTarget = this._tempDestination;

			// event for parent to know a new temp image has been saved and is available
			dispatchEventWith("uploadedImageChanged");
		}

		private function onMediaLoaded( e:flash.events.Event ):void
		{
			trace("Media load complete");
			readMediaData();
		}

		private function readMediaData():void
		{
		    var imageBytes:ByteArray = new ByteArray();
			this._dataSource.readBytes( imageBytes );

			loadImageFromBytes(imageBytes);

			this._outStream = new FileStream();
			// open output file stream in WRITE mode
			this._outStream.open(this._tempDestination, FileMode.WRITE);
			// write out the file
			this._outStream.writeBytes(imageBytes, 0, imageBytes.length);
			// close it
			this._outStream.close();

			this._trashButton.visible = true;
			this._deleteTarget = this._tempDestination;

			// event for parent to know a new temp image has been saved and is available
			dispatchEventWith("uploadedImageChanged");
		}

		private function browseCanceled(e:flash.events.Event):void
		{
			trace("Image browse canceled.");
		}

		private function loadImageFromUrl(url:String):void
		{
			this._imageLoader = new Loader();
			this._imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoaded);
			this._imageLoader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, imageLoadFailed);
			this._imageLoader.load(new URLRequest(url));
		}

		private function loadImageFromBytes(imageBytes:ByteArray):void
		{
			this._imageLoader = new Loader();
			this._imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.INIT, imageLoaded);
			this._imageLoader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, imageLoadFailed);
			this._imageLoader.loadBytes(imageBytes);
		}

		private function imageLoaded(e:flash.events.Event = null):void
		{
			trace("Image loaded.");

			var suitableBm:Bitmap = getSuitableBitmap(this._imageLoader.contentLoaderInfo.content as Bitmap);
			this._imageHolder = new Image(Texture.fromBitmap(suitableBm));
			HivivaModifier.clipImage(this._imageHolder);
			this._imageHolder.width = this._imageHolder.height = IMAGE_SIZE * this._scale;
			this._imageHolder.x = this._imageBg.x;
			this._imageHolder.y = this._imageBg.y;
			if (!contains(this._imageHolder)) addChild(this._imageHolder);


			/*if (this._imagePromise.isAsync)
			{
				var targetFile:File = this._imagePromise.file;
				// save target image in temp location
				targetFile.addEventListener(flash.events.Event.COMPLETE, imageSaved, false, 0, true);
				targetFile.copyToAsync(this._tempDestination, true);
			}*/
		}

		private function imageLoadFailed(e:flash.events.IOErrorEvent):void
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
		public function set scale(value:Number):void
		{
			this._scale = value;
		}
		public function get scale():Number
		{
			return this._scale;
		}
		public function set fileName(value:String):void
		{
			this._fileName = value;
			this._mainDestination = File.applicationStorageDirectory.resolvePath(this._fileName);
			this._tempDestination = File.applicationStorageDirectory.resolvePath("temp" + this._fileName);
		}
		public function get fileName():String
		{
			return this._fileName;
		}
	}
}
