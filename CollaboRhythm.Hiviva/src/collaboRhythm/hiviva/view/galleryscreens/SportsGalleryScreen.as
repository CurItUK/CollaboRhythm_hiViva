package collaboRhythm.hiviva.view.galleryscreens
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.ScreenBase;

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.TiledRowsLayout;
	import feathers.textures.Scale9Textures;

	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;

	public class SportsGalleryScreen extends Screen
	{
		private var _category:String;
		public function get category():String
		{
			return this._category;
		}

		public function set category(value:String):void
		{
			this._category = value;
		}

		private var _header:Header;
		private var _loadText:Label;
		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _backButton:Button;
		private var _chosenImage:String;
		private var _photoTotal:int;
		private var _photoCount:int;
		private var _list:List;
		private var _container:ScrollContainer;

		public function SportsGalleryScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = this.actualWidth;
			this._header.validate();

			setupGallery();

			this._cancelButton.label = "Cancel";
			this._submitButton.label = "Apply";
			this._backButton.label = "Back";
/*
			this._cancelButton.y = (50 * this.dpiScale);

			this._submitButton.y = this._cancelButton.y;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + 20;
			*/
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new Header();
			this._header.title = "Sports";
			addChild(this._header);

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
			this.owner.showScreen(HivivaScreens.PATIENT_HOMEPAGE_PHOTO_SCREEN);
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_HOMEPAGE_PHOTO_SCREEN);
		}

		private function submitButtonClick(e:Event):void
		{
			saveTempImageAsMain();
		}

		private function saveTempImageAsMain():void
		{
			var temp:File = File.applicationStorageDirectory.resolvePath(this._chosenImage);
			var main:File = File.applicationStorageDirectory.resolvePath("temphomepageimage.jpg");
			if (temp.exists) {temp.moveTo(main,true);} else { trace(this._chosenImage + " doesn't exist or hasn't been selected"); }
		}

		private function setupGallery():void
		{
			this._loadText = new Label();
			this._loadText.text = "Loading...";
			this._loadText.x = (this.actualWidth / 2) - (this._loadText.width / 2);
			this._loadText.y = (this.actualHeight / 2) - (this._loadText.height / 2);
			addChild(this._loadText);
			this._loadText.validate();
			getImageList("sport");
		}

		private function getImageList(folderName:String):void
		{
			var categoryDir:File = File.applicationDirectory.resolvePath("media/stock_images/" + folderName);
			trace(categoryDir.url);
			categoryDir.getDirectoryListingAsync();
			categoryDir.addEventListener(FileListEvent.DIRECTORY_LISTING, directoryListingHandler);
		}

		private function directoryListingHandler(e:FileListEvent):void
		{
			var imageFiles:Array = e.files;
			var imageFile:File, image:GalleryItem;
			this._photoCount = 0;
			this._photoTotal =  imageFiles.length;
			for(var i:int = 0; i < this._photoTotal; i++)
			{
				imageFile = imageFiles[i];
				image = new GalleryItem((i + 1), imageFile.url);
				image.addEventListener(Event.COMPLETE, positionAndAddImage);
			}
		}

		private function positionAndAddImage(e:Event):void
		{
			var image:GalleryItem, items:Vector.<GalleryItem> = new <GalleryItem>[];
			image = e.target as GalleryItem;
			//items.push(image);

			this._photoCount++;
			if(this._photoCount == this._photoTotal)
			{
				trace("all images loaded");
				removeChild(this._loadText,true);
			}
			// TODO: quick fix below, needs to be replaced
			var container:Sprite = new Sprite();
			image.x = container.width;
			container.addChild(image);


			container.y = this._header.height;

			trace("container.height" + container.height);
			trace("container.width" + container.width);
			addChild(container);

			this._cancelButton.y = container.height + (50 * this.dpiScale);

			this._submitButton.y = this._cancelButton.y;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + 20;
			this._cancelButton.invalidate();
			this._submitButton.invalidate();
			this._backButton.invalidate();
		}
	}
}
