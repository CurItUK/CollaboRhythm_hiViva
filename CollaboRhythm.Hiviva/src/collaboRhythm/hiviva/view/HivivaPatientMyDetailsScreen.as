package collaboRhythm.hiviva.view
{

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import flash.display.Loader;
	import flash.events.IOErrorEvent;

	import flash.events.MediaEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;

	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.net.URLRequest;

	import starling.display.Image;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;


	public class HivivaPatientMyDetailsScreen extends Screen
	{
		private var _header:Header;
		private var _instructionsText:Label;
		private var _nameLabel:Label;
		private var _nameInput:TextInput;
		private var _emailLabel:Label;
		private var _emailInput:TextInput;
		private var _photoContainer:Sprite;
		private var _photoHolder:Image;
		private var _mediaSource:CameraRoll;

		public function HivivaPatientMyDetailsScreen()
		{

		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;

			this._instructionsText.text = "All fields are optional except to connect to a care provider";
			this._instructionsText.y = this._header.height;
			this._instructionsText.width = this.actualWidth;

			this._nameLabel.text = "Name";
			this._nameLabel.y = 100;
			this._nameLabel.width = this.actualWidth / 2;

			this._nameInput.y = 100;
			this._nameInput.x = this.actualWidth / 2;
			this._nameInput.width = this.actualWidth / 2;

			this._emailLabel.text = "Email";
			this._emailLabel.y = 150;
			this._emailLabel.width = this.actualWidth / 2;

			this._emailInput.y = 150;
			this._emailInput.x = this.actualWidth / 2;
			this._emailInput.width = this.actualWidth / 2;

			this._photoContainer.y = 200;
		}

		override protected function initialize():void
		{
			this._header = new Header();
			this._header.title = "My Details";
			addChild(this._header);

			this._instructionsText = new Label();
			addChild(this._instructionsText);

			this._nameLabel = new Label();
			addChild(this._nameLabel);

			this._nameInput = new TextInput();
			addChild(this._nameInput);

			this._emailLabel = new Label();
			addChild(this._emailLabel);

			this._emailInput = new TextInput();
			addChild(this._emailInput);

			setupPhotoContainer();
		}

		private function setupPhotoContainer():void
		{
			this._photoContainer = new Sprite();

			//this._photoHolder = new Image(Texture.empty(100,100));

			var uploadPhotoButton:Button = new Button();
			uploadPhotoButton.x = 120;
			uploadPhotoButton.label = "Upload Photo";
			uploadPhotoButton.addEventListener(Event.TRIGGERED, onUploadClick);
			this._photoContainer.addChild(uploadPhotoButton);

			addChild(this._photoContainer);
		}

		private function onUploadClick(e:Event):void
		{
			if (CameraRoll.supportsBrowseForImage)
			{
				trace( "Browsing for image..." );
				this._mediaSource = new CameraRoll();

				this._mediaSource.addEventListener( MediaEvent.SELECT, imageSelected );
				this._mediaSource.addEventListener( Event.CANCEL, browseCanceled );
				this._mediaSource.browseForImage();
			}
			else
			{
				trace( "Browsing in camera roll is not supported.");
			}
		}

		private function imageSelected( e:MediaEvent ):void
		{
			trace( "Image selected..." );

			//this._photoHolder.visible = false;

			var imageSource:MediaPromise = e.data;
			// get file extension
			var extension:String = imageSource.file.extension;
			// set destination location
			var destination:File = File.applicationStorageDirectory;
			destination = destination.resolvePath("profileimage." + extension);
			// copy source to destination
			imageSource.file.copyTo(destination, true);
			var copiedFile:File = File.applicationStorageDirectory;
			copiedFile = copiedFile.resolvePath("profileimage." + extension);
			trace("destination : " + copiedFile.url);

			// using raw as3 Loader for mediapromise compatibility
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener( flash.events.Event.COMPLETE, imageLoaded );
			imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, imageLoadFailed );
			imageLoader.load(new URLRequest(copiedFile.url));
		}
		private function browseCanceled( e:Event ):void
		{
			trace( "Image browse canceled." );
		}

		private function imageLoaded( e:flash.events.Event ):void
		{
			trace( "Image loaded." );

			var bm:Bitmap = e.target.content as Bitmap;
			var xRatio:Number;
			var yRatio:Number;
			// dont apply size adjustmnet to bm! only adjust the data (needs formula)
			if (bm.width >= 2048 || bm.height >= 2048)
			{
				if (bm.height >= bm.width)
				{
					bm.height = 2040;
					bm.scaleX = bm.scaleY;
				}
				else
				{
					bm.width = 2040;
					bm.scaleY = bm.scaleX;
				}
			}
			var bmd:BitmapData = new BitmapData(bm.width, bm.height);
			var m:Matrix = new Matrix();
			m.scale(bm.scaleX, bm.scaleY);
			bmd.draw(bm,m,null,null,null,true);
			var actualbm:Bitmap = new Bitmap(bmd,'auto',true);
			trace(actualbm.width);
			trace(actualbm.height);
			this._photoHolder = new Image(Texture.fromBitmap(actualbm));
			this._photoHolder.width = 100;
			this._photoHolder.height = 100;

			if (!this._photoContainer.contains(this._photoHolder)) this._photoContainer.addChild(this._photoHolder);

			//this._photoHolder.visible = true;
		}

		private function imageLoadFailed( e:Event ):void
		{
			trace( "Image load failed." );
		}
	}
}
