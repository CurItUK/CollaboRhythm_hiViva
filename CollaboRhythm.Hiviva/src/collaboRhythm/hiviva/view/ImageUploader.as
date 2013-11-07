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
	import flash.display.BlendMode;
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

	import jp.shichiseki.exif.ExifInfo;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	import starling.utils.rad2deg;

	public class ImageUploader extends FeathersControl
	{
		private var _scale:Number = 1;
		private var _fileName:String;
		private var _bg:Scale9Image;
		private var _uploadButton:Button;
		private var _trashButton:Button;
//		private var _imageBg:Quad;
		private var _defaultImageHolder:Image;
		private var _defaultImage:String;
		private var _imageHolder:Image;
		private var _dataSource:IDataInput;
		private var _imagePromise:MediaPromise;
		private var _outStream:FileStream;
		private var _deleteTarget:File;
		private var _radiansOffset:Number;
		private var _savableImageBytes:ByteArray;

		private const IMAGE_SIZE:Number = 150;
		private const PADDING:Number = 32;

		public function ImageUploader()
		{
			super();
		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this._scale;

			super.draw();

			this._bg.width = this.actualWidth;

			this._defaultImageHolder.x = this._bg.x + (scaledPadding * 0.5);
			this._defaultImageHolder.y = this._bg.y + (scaledPadding * 0.5);

			this._bg.height = this._defaultImageHolder.y + this._defaultImageHolder.height + (scaledPadding * 0.5);

			this._trashButton.validate();
			this._trashButton.x = this._bg.width - scaledPadding - this._trashButton.width;
			this._trashButton.y = (this._bg.height / 2) - (this._trashButton.height / 2);

			this._uploadButton.validate();
			this._uploadButton.width += this._uploadButton.defaultIcon.width;
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

//			this._imageBg = new Quad(IMAGE_SIZE * this._scale, IMAGE_SIZE * this._scale, 0x000000);

			this._defaultImageHolder = new Image(Main.assets.getTexture(_defaultImage));
			addChild(this._defaultImageHolder);
			HivivaModifier.clipImage(this._defaultImageHolder);
			this._defaultImageHolder.width = this._defaultImageHolder.height = IMAGE_SIZE;

			this._uploadButton = new Button();
//			this._uploadButton.defaultIcon = new Image(Main.assets.getTexture("icon_upload"));
			this._uploadButton.defaultIcon = new Image(Main.assets.getTexture("v2_icon_upload"));
			this._uploadButton.iconPosition = Button.ICON_POSITION_LEFT;
			this._uploadButton.label = "UPLOAD PHOTO";
			this._uploadButton.addEventListener(starling.events.Event.TRIGGERED, uploadButtonHandler);
			addChild(this._uploadButton);

			this._trashButton = new Button();
			this._trashButton.visible = false;
			this._trashButton.name = HivivaThemeConstants.DELETE_CELL_BUTTON;
			this._trashButton.addEventListener(starling.events.Event.TRIGGERED, deleteImageData);
			addChild(this._trashButton);

			this._deleteTarget = File.applicationStorageDirectory.resolvePath("temp" + this._fileName);
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

			if(this._savableImageBytes != null)
			{
				this._savableImageBytes.clear();
				this._savableImageBytes = null;
			}

			this._trashButton.visible = false;
			dispatchEventWith("uploadedImageChanged");
		}

		public function getMainImage():void
		{
			var destination:File = File.applicationStorageDirectory.resolvePath(this._fileName);
			if (destination.exists)
			{
				loadImageFromUrl(destination.url);
				this._trashButton.visible = true;
				this._deleteTarget = destination;
			}
		}

		public function saveTempImageAsMain():Boolean
		{
			var temp:File = File.applicationStorageDirectory.resolvePath("temp" + this._fileName);
			var main:File = File.applicationStorageDirectory.resolvePath(this._fileName);
			if(temp.exists)
			{
				temp.moveTo(main,true);
				this._deleteTarget = main;
			}
			return main.exists;
		}

		public static function removeUploadedImageFile(file_name:String):void
		{
			var temp:File = File.applicationStorageDirectory.resolvePath("temp" + file_name);
			if(temp.exists) temp.deleteFile();

			var main:File = File.applicationStorageDirectory.resolvePath(file_name);
			if(main.exists) main.deleteFile();
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
			}
		}

		private function onMediaLoaded( e:flash.events.Event ):void
		{
			trace("Media load complete");
			readMediaData();
		}

		private function readMediaData():void
		{
			var loadedImageBytes:ByteArray = new ByteArray();
			this._dataSource.readBytes( loadedImageBytes );

			setCorrectedRotationFromExifInfo(loadedImageBytes);
			loadImageFromBytes(loadedImageBytes);
		}

		private function setCorrectedRotationFromExifInfo(imageBytes:ByteArray):void
		{
			var exif:ExifInfo = new ExifInfo(imageBytes);
			/*trace("exif =");
			  trace(exif);
			  trace("exif trace");
			  trace(exif.ifds);
			  trace(exif.ifds.primary);
			  trace(exif.ifds.exif);
			  trace(exif.ifds.gps);
			  trace(exif.ifds.thumbnail);*/

			switch (exif.ifds.primary.Orientation)
			{
				case 3 :
					trace("_orientation = 180");
					_radiansOffset = deg2rad(180);
					break;
				case 6 :
					trace("_orientation = 90");
					_radiansOffset = deg2rad(90);
					break;
				case 8 :
					trace("_orientation = 270");
					_radiansOffset = deg2rad(270);
					break;
				default :
					trace("_orientation = 0");
					_radiansOffset = deg2rad(0);
					break;
			}
		}

		private function browseCanceled(e:flash.events.Event):void
		{
			trace("Image browse canceled.");
		}

		private function loadImageFromUrl(url:String):void
		{
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoadedFromUrl);
			imageLoader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, imageLoadFailed);
			imageLoader.load(new URLRequest(url));
		}

		private function loadImageFromBytes(imageBytes:ByteArray):void
		{
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoadedFromBytes);
			imageLoader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, imageLoadFailed);
			imageLoader.loadBytes(imageBytes);
		}

		private function imageLoadedFromUrl(e:flash.events.Event):void
		{
			trace("Image loaded from url.");
			createPreviewFromBitmap(e.target.content as Bitmap);
		}

		private function imageLoadedFromBytes(e:flash.events.Event):void
		{
			trace("Image loaded from bytes.");
			var suitableBm:Bitmap = fixRawBitmap(e.target.content as Bitmap);
			if(_savableImageBytes != null)
			{
				_savableImageBytes.clear();
				_savableImageBytes = null;
			}
			_savableImageBytes = suitableBm.bitmapData.encode(new Rectangle(0,0,suitableBm.width,suitableBm.height), new JPEGEncoderOptions(100));
			writeSavableBytesToFile();
			createPreviewFromBitmap(suitableBm);
		}

		private function createPreviewFromBitmap(suitableBm:Bitmap):void
		{
			this._imageHolder = new Image(Texture.fromBitmap(suitableBm));
			HivivaModifier.clipImage(this._imageHolder);
			this._imageHolder.height = this._imageHolder.width = IMAGE_SIZE;
			this._imageHolder.x = this._defaultImageHolder.x;
			this._imageHolder.y = this._defaultImageHolder.y;
			if (!contains(this._imageHolder)) addChild(this._imageHolder);
		}

		private function imageLoadFailed(e:flash.events.IOErrorEvent):void
		{
			trace("Image load failed.");
		}

		private function fixRawBitmap(sourceBm:Bitmap):Bitmap
		{
			var bm:Bitmap;
			var bmd:BitmapData;
			var m:Matrix = new Matrix();

			// if source bitmap is larger than IMAGE_SIZE than resize so smaller side is equal to IMAGE_SIZE
			if (sourceBm.width >= IMAGE_SIZE || sourceBm.height >= IMAGE_SIZE)
			{
				if (sourceBm.height <= sourceBm.width)
				{
					sourceBm.height = IMAGE_SIZE;
					sourceBm.scaleX = sourceBm.scaleY;
				}
				else
				{
					sourceBm.width = IMAGE_SIZE;
					sourceBm.scaleY = sourceBm.scaleX;
				}
				m.scale(sourceBm.scaleX, sourceBm.scaleY);
			}
			m.rotate(_radiansOffset);
			// offset to compensate for the rotate, (note : the x = height and y = width below intentionally)
			switch(rad2deg(_radiansOffset))
			{
				case 180 :
					m.translate(sourceBm.height, sourceBm.width);
					bmd = new BitmapData(sourceBm.width, sourceBm.height);
					break;
				case 90 :
					m.translate(sourceBm.height, 0);
					bmd = new BitmapData(sourceBm.height, sourceBm.width);
					break;
				case 270 :
					m.translate(0, sourceBm.width);
					bmd = new BitmapData(sourceBm.height, sourceBm.width);
					break;
				default :
					bmd = new BitmapData(sourceBm.width, sourceBm.height);
					break;
			}

			// copy source bitmap at adjusted size
			bmd.draw(sourceBm, m, null, BlendMode.NORMAL, null, true);
			bm = new Bitmap(bmd, 'auto', true);
			return bm;
		}

		private function writeSavableBytesToFile():void
		{
			var temp:File = File.applicationStorageDirectory.resolvePath("temp" + this._fileName);
			this._outStream = new FileStream();
			// open output file stream in WRITE mode
			this._outStream.open(temp, FileMode.WRITE);
			// write out the file
			trace('this._outStream.writeBytes()');
			this._outStream.writeBytes(_savableImageBytes, 0, _savableImageBytes.length);
			// close it
			trace('this._outStream.close()');
			this._outStream.close();

			this._trashButton.visible = true;
			this._deleteTarget = temp;

			// event for parent to know a new temp image has been saved and is available
			dispatchEventWith("uploadedImageChanged");
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
		}
		public function get fileName():String
		{
			return this._fileName;
		}

		public function get defaultImage():String
		{
			return _defaultImage;
		}

		public function set defaultImage(value:String):void
		{
			_defaultImage = value;
		}

		public function get savableImageBytes():ByteArray
		{
			return _savableImageBytes;
		}

		public function set savableImageBytes(value:ByteArray):void
		{
			_savableImageBytes = value;
		}
	}
}
