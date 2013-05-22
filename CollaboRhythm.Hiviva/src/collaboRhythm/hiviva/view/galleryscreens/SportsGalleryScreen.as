package collaboRhythm.hiviva.view.galleryscreens
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.screens.shared.ScreenBase;

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.TiledColumnsLayout;
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
		private var _photoTotal:int;
		private var _photoCount:int;
		private var _images:Vector.<GalleryItem>;
		private var _container:ScrollContainer;
		private var _currItem:GalleryItem;

		private const PADDING:Number = 32;

		public function SportsGalleryScreen()
		{

		}

		override protected function draw():void
		{
			var scalePadding:Number = PADDING * this.dpiScale;
			super.draw();

			this._header.width = this.actualWidth;
			this._header.validate();

			this._cancelButton.validate();
			this._cancelButton.x = scalePadding;
			this._cancelButton.y = this.actualHeight - scalePadding - this._cancelButton.height;

			this._submitButton.validate();
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + scalePadding;
			this._submitButton.y = this._cancelButton.y;

			this._loadText.validate();
			this._loadText.x = (this.actualWidth / 2) - (this._loadText.width / 2);
			this._loadText.y = (this.actualHeight / 2) - (this._loadText.height / 2);
		}
		override protected function initialize():void
		{
			super.initialize();

			this._header = new Header();
			this._header.title = "Sports";
			addChild(this._header);

			this._loadText = new Label();
			this._loadText.text = "Loading...";
			addChild(this._loadText);

			this._cancelButton = new Button();
			this._cancelButton.label = "Cancel";
			this._cancelButton.addEventListener(Event.TRIGGERED, cancelButtonClick);
			addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.label = "Apply";
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			getImageList();
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
			saveImageAsTemp();
			this.owner.showScreen(HivivaScreens.PATIENT_HOMEPAGE_PHOTO_SCREEN);
		}

		private function saveImageAsTemp():void
		{
			var chosenImage:File = File.applicationDirectory.resolvePath("media/stock_images/" + this._category + "/" + this._currItem.filename);
			var temp:File = File.applicationStorageDirectory.resolvePath("temphomepageimage.jpg");
			if (chosenImage.exists) {chosenImage.moveTo(temp,true);} else { trace(this._currItem.filename + " doesn't exist or hasn't been selected"); }
		}

		private function getImageList():void
		{
			var categoryDir:File = File.applicationDirectory.resolvePath("media/stock_images/" + this._category);
			categoryDir.getDirectoryListing();
			categoryDir.addEventListener(FileListEvent.DIRECTORY_LISTING, directoryListingHandler);
		}

		private function directoryListingHandler(e:FileListEvent):void
		{
			var imageFiles:Array = e.files;
			var imageFile:File, image:GalleryItem;
			this._images = new <GalleryItem>[];
			this._photoCount = 0;
			this._photoTotal =  imageFiles.length;
			for(var i:int = 0; i < this._photoTotal; i++)
			{
				imageFile = imageFiles[i];

				image = new GalleryItem();
				image.id = i + 1;
				image.url = imageFile.url;
				image.filename = imageFile.name;

				image.addEventListener(Event.COMPLETE, imageLoaded);
				image.doImageLoad();
			}
		}

		private function imageLoaded(e:Event):void
		{
			var image:GalleryItem = e.target as GalleryItem,
				imageId:int = e.data.id as int,
				scalePadding:Number = PADDING * this.dpiScale;

			this._images.push(image);

			this._photoCount++;
			if(this._photoCount == this._photoTotal)
			{
				trace("all images loaded");
				removeChild(this._loadText,true);

				const layout:TiledRowsLayout = new TiledRowsLayout();
				layout.paging = TiledColumnsLayout.PAGING_NONE;
				layout.gap = scalePadding;
				layout.paddingTop = 0;
				layout.paddingLeft = scalePadding;
				layout.paddingBottom = 0;
				layout.paddingRight = scalePadding;
				layout.horizontalAlign = TiledColumnsLayout.HORIZONTAL_ALIGN_CENTER;
				layout.verticalAlign = TiledColumnsLayout.VERTICAL_ALIGN_MIDDLE;
				layout.tileHorizontalAlign = TiledColumnsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
				layout.tileVerticalAlign = TiledColumnsLayout.TILE_VERTICAL_ALIGN_TOP;
				layout.useSquareTiles = false;


				this._container = new ScrollContainer();
				this._container.layout = layout;
				addChild(this._container);

				this._images.sort(function (x:GalleryItem, y:GalleryItem):Number{return x.id - y.id;});
				for (var i:int = 0; i < this._images.length; i++)
				{
					image = this._images[i];
					image.addEventListener(Event.TRIGGERED, selectImage);
					this._container.addChild(image);
					image.width = (this.actualWidth * 0.5) - (scalePadding * 3);
					image.validate();
				}

				drawGallery();
			}
		}

		private function drawGallery():void
		{
			var scalePadding:Number = PADDING * this.dpiScale;

			this._container.y = this._header.height;
			this._container.width = this.actualWidth;
			this._container.height = this.actualHeight - this._container.y - this._cancelButton.height - (scalePadding * 2);
			this._container.validate();
		}

		private function selectImage(e:Event):void
		{
			if(this._currItem != null) this._currItem.isActive = false;

			this._currItem = e.target as GalleryItem;
			this._currItem.isActive = true;
		}
	}
}
