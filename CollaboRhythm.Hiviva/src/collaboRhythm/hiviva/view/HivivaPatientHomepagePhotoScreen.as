package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.galleryscreens.SportsGalleryScreen;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Header;
	import feathers.data.ListCollection;

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

	import starling.display.DisplayObject;

	import starling.display.Image;
	import starling.display.Quad;

	import starling.display.Sprite;

	import starling.events.Event;
	import starling.textures.Texture;

	public class HivivaPatientHomepagePhotoScreen extends ScreenBase
	{
		private var _header:Header;
		private var _gap:Number;
		private var _galleriesButtonGroup:ButtonGroup;
		private var _photoContainer:Sprite;
		private var _photoHolder:Image;
		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _backButton:Button;

		public function HivivaPatientHomepagePhotoScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._gap =  50 * this.dpiScale;

			this._header.width = this.actualWidth;
			this._header.validate();

			this._galleriesButtonGroup.validate();
			this._galleriesButtonGroup.x = (this.actualWidth - this._galleriesButtonGroup.width) / 2;
			this._galleriesButtonGroup.y = this._header.height + this._gap;

			this._photoContainer.y = this._galleriesButtonGroup.y + this._galleriesButtonGroup.height + this._gap;

			this._cancelButton.y = this._photoContainer.y + this._photoContainer.height + this._gap;

			this._cancelButton.label = "Cancel";
			this._submitButton.label = "Save";
			this._backButton.label = "Back";
			this._cancelButton.validate();
			this._submitButton.validate();
			this._backButton.validate();

			this._submitButton.y = this._cancelButton.y;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + (20 * this.dpiScale);
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new Header();
			this._header.title = "Homepage Photo";
			addChild(this._header);

			this._galleriesButtonGroup = new ButtonGroup();
			this._galleriesButtonGroup.dataProvider = new ListCollection(
			[
				{ label: "Sport", triggered: onOpenGallery },
				{ label: "Music", triggered: onOpenGallery },
				{ label: "Cinema", triggered: onOpenGallery },
				{ label: "History", triggered: onOpenGallery },
				{ label: "Traveling", triggered: onOpenGallery },
				{ label: "Art", triggered: onOpenGallery }
			]);
			this.addChild(this._galleriesButtonGroup);

			setupPhotoContainer(100 * this.dpiScale,100 * this.dpiScale,20 * this.dpiScale);

			this._cancelButton = new Button();
			this._cancelButton.addEventListener(Event.TRIGGERED, cancelButtonClick);
			addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}

		private function cancelButtonClick(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function submitButtonClick(e:Event):void
		{
			saveTempImageAsMain();
		}

		private function onOpenGallery(e:Event):void
		{
			const button:Button = Button(e.currentTarget);
			//trace(button.label + " triggered.");
			switch(button.label)
			{
				case "Sport" :
					var sportsScreen:SportsGalleryScreen = new SportsGalleryScreen();
					addChild(sportsScreen);
					break;
				case "Music" :
					break;
				case "Cinema" :
					break;
				case "History" :
					break;
				case "Traveling" :
					break;
				case "Art" :
					break;
			}
		}

		private function saveTempImageAsMain():void
		{
			var temp:File = File.applicationStorageDirectory.resolvePath("temphomepageimage.jpg");
			var main:File = File.applicationStorageDirectory.resolvePath("homepageimage.jpg");
			if (temp.exists) {temp.moveTo(main,true);} else { trace("temphomepageimage.jpg doesn't exist"); }
		}

		private function setupPhotoContainer(width:Number, height:Number, gap:Number):void
			{
				this._photoContainer = new Sprite();

				var quad:Quad = new Quad(width, height, 0x000000);
				this._photoContainer.addChild(quad);

				var destination:File = File.applicationStorageDirectory;
				destination = destination.resolvePath("homepageimage.jpg");
				if (destination.exists)
				{
					doImageLoad(destination.url);
				}

				var uploadPhotoButton:Button = new Button();
				uploadPhotoButton.x = width + gap;
				uploadPhotoButton.label = "Upload Photo";
				uploadPhotoButton.addEventListener(Event.TRIGGERED, onUploadClick);
				this._photoContainer.addChild(uploadPhotoButton);

				addChild(this._photoContainer);
			}

			private function onUploadClick(e:Event):void
			{
				if (CameraRoll.supportsBrowseForImage)
				{
					trace("Browsing for image...");
					var mediaSource:CameraRoll = new CameraRoll();
					mediaSource.addEventListener(MediaEvent.SELECT, imageSelected);
					mediaSource.addEventListener(Event.CANCEL, browseCanceled);
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

				//this._photoHolder.visible = false;

				var imageSource:MediaPromise = e.data;
				// get file extension
				var extension:String = imageSource.file.extension;
				// set destination location
				var destination:File = File.applicationStorageDirectory;
				destination = destination.resolvePath("temphomepageimage." + extension);
				// copy source to destination
				imageSource.file.copyTo(destination, true);
				var copiedFile:File = File.applicationStorageDirectory;
				copiedFile = copiedFile.resolvePath("temphomepageimage." + extension);

				doImageLoad(copiedFile.url);
			}

			private function doImageLoad(url:String):void
			{
				var imageLoader:Loader = new Loader();
				imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoaded);
				imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadFailed);
				imageLoader.load(new URLRequest(url));
			}

			private function browseCanceled(e:Event):void
			{
				trace("Image browse canceled.");
			}

			private function imageLoaded(e:flash.events.Event):void
			{
				trace("Image loaded.");

				var sourceBm:Bitmap = e.target.content as Bitmap,
						suitableBm:Bitmap,
						xRatio:Number,
						yRatio:Number;
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
					suitableBm = new Bitmap(bmd, 'auto', true);
				}
				else
				{
					suitableBm = sourceBm;
				}
				// use suitable bitmap for texture
				this._photoHolder = new Image(Texture.fromBitmap(suitableBm));
				constrainToProportion(this._photoHolder, 100 * this.dpiScale);

				if (!this._photoContainer.contains(this._photoHolder)) this._photoContainer.addChild(this._photoHolder);
			}

			private function imageLoadFailed(e:Event):void
			{
				trace("Image load failed.");
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
