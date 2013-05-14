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

		private var _category:String;
		private var _selectedItems:Array;
		private var _itemList:Vector.<GalleryItem>;
		private var _imageTotal:int;
		private var _imageCount:int;

		public function Gallery()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();
		}

		override protected function initialize():void
		{
			super.initialize();
		}

		public function getImageList():void
		{
			var categoryDir:File = File.applicationDirectory.resolvePath("media/stock_images/" + this._category);
			categoryDir.addEventListener(FileListEvent.DIRECTORY_LISTING, directoryListingHandler);
			categoryDir.getDirectoryListingAsync();
		}

		private function directoryListingHandler(e:FileListEvent):void
		{
			var imageFiles:Array = e.files,
				imageFile:File,
				image:GalleryItem;

			this._selectedItems = [];
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

			currItem.removeEventListener(Event.TRIGGERED, selectImage);

			currItem.isActive = !currItem.isActive;

			if(currItem.isActive)
			{
				addToSelectedItems(currItem.filename);
			}
			else
			{
				removeFromSelectedItems(currItem.filename);
			}

			currItem.addEventListener(Event.TRIGGERED, selectImage);
		}

		private function addToSelectedItems(galleryItemFilename:String):void
		{
			var selectedGalleryItemsLength:int = this._selectedItems.length,
				currItem:String, itemExists:Boolean = false,
				url:String = this._category + "/" + galleryItemFilename;

			for (var i:int = 0; i < selectedGalleryItemsLength; i++)
			{
				currItem = this._selectedItems[i];
				if(url == currItem)
				{
					itemExists = true;
				}
			}

			if(!itemExists)
			{
				this._selectedItems.push(url);
			}
		}

		private function removeFromSelectedItems(galleryItemFilename:String):void
		{
			var selectedGalleryItemsLength:int = this._selectedItems.length,
				currItem:String, url:String = this._category + "/" + galleryItemFilename;
			if(selectedGalleryItemsLength > 0)
			{
				for (var i:int = 0; i < selectedGalleryItemsLength; i++)
				{
					currItem = this._selectedItems[i];
					if(url == currItem)
					{
						this._selectedItems.splice(i,1);
					}
				}

			}
		}

		override public function dispose():void
		{
			/*var image:GalleryItem;
			for(var i:int = 0; i < this._imageTotal; i++)
			{
				image = this._itemList[i];
				image.removeEventListener(Event.TRIGGERED, selectImage);
				image.dispose();
				removeChild(image);
				image = null;
				this._itemList[i] = null;
			}*/
			this._itemList = null;
			this._selectedItems = null;

			super.dispose();
		}

		public function get selectedItems():Array
		{
			return _selectedItems;
		}

		public function set selectedItems(value:Array):void
		{
			_selectedItems = value;
		}

		public function get category():String
		{
			return _category;
		}

		public function set category(value:String):void
		{
			_category = value;
		}
	}
}
