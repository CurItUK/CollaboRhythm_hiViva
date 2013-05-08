package collaboRhythm.hiviva.view.galleryscreens
{
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledRowsLayout;

	import flash.events.FileListEvent;

	import flash.filesystem.File;

	import starling.events.Event;

	public class Gallery extends ScrollContainer
	{
		private var _scale:Number;
		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
		}

		private var _itemList:Vector.<GalleryItem>;
		private var _imageTotal:int;
		private var _imageCount:int;

		public function Gallery(category:String)
		{
			super();
			getImageList(category);
		}

		override protected function draw():void
		{
			super.draw();
		}

		override protected function initialize():void
		{
			super.initialize();
		}

		private function getImageList(category:String):void
		{
			var categoryDir:File = File.applicationDirectory.resolvePath("media/stock_images/" + category);
			categoryDir.addEventListener(FileListEvent.DIRECTORY_LISTING, directoryListingHandler);
			categoryDir.getDirectoryListingAsync();
		}

		private function directoryListingHandler(e:FileListEvent):void
		{
			var imageFiles:Array = e.files,
				imageFile:File,
				image:GalleryItem;

			this._itemList = new <GalleryItem>[];
			this._imageCount = 0;
			this._imageTotal =  imageFiles.length;
			for(var i:int = 0; i < this._imageTotal; i++)
			{
				imageFile = imageFiles[i];

				image = new GalleryItem();
				image.id = i + 1;
				image.url = imageFile.url;
				image.filename = imageFile.name;

				image.addEventListener(Event.COMPLETE, imageLoaded);
				image.doImageLoad();

				this._itemList.push(image);
			}
		}

		private function imageLoaded(e:Event):void
		{
			var image:GalleryItem = e.target as GalleryItem;
			image.removeEventListener(Event.COMPLETE, imageLoaded);

			this._imageCount++;

			if(this._imageCount == this._imageTotal)
			{
				for (var i:int = 0; i < this._imageTotal; i++)
				{
					image = this._itemList[i];
					addChild(image);
					image.addEventListener(Event.TRIGGERED, selectImage);
				}

				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		public function drawGallery():void
		{
			//trace("drawGallery");
			var image:GalleryItem;
			for (var i:int = 0; i < this._imageTotal; i++)
			{
				image = this._itemList[i];
				image.height = this.actualHeight;
				image.validate();

				//trace(image.filename + ".height " + image.height);
				//trace(image.filename + ".width " + image.width);
			}
		}

		private function selectImage(e:Event):void
		{
			var currItem:GalleryItem = e.target as GalleryItem;
			currItem.isActive = !currItem.isActive;
		}
	}
}
