package collaboRhythm.hiviva.view.galleryscreens
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;

	import flash.events.FileListEvent;
	import flash.filesystem.File;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class GalleryScreen extends ValidationScreen
	{
		private var _category:String;
		private var _urls:Array;
		private var _itemList:Vector.<GalleryItem>;
		private var _imageTotal:int;
		private var _imageCount:int;
		private var _cancelAndSave:BoxedButtons;
		private var _backButton:Button;

		public function GalleryScreen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._content.height = this._cancelAndSave.y - this._content.y - this._componentGap;
			this._content.validate();
			// property here is for show / hide validation
			this._contentHeight = this._content.height;
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();

			this._cancelAndSave.width = this._innerWidth;
			this._cancelAndSave.validate();
			this._cancelAndSave.x = Constants.PADDING_LEFT;
			this._cancelAndSave.y = Constants.STAGE_HEIGHT - Constants.PADDING_BOTTOM - this._cancelAndSave.height;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();

			selectPrePopulatedImages();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = this._category + " gallery";

			this._cancelAndSave = new BoxedButtons();
			this._cancelAndSave.labels = ["Cancel","Save"];
			this._cancelAndSave.addEventListener(Event.TRIGGERED, cancelAndSaveHandler);
			addChild(this._cancelAndSave);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			_urls = GalleryData.getUrlsByCategory(this._category);
			getImagesFromDirectory();
		}

		private function cancelAndSaveHandler(e:Event):void
		{
			var button:String = e.data.button;

			switch(button)
			{
				case "Cancel" :
					backBtnHandler();
					break;

				case "Save" :
					saveGalleryPhotos();
					break;
			}
		}

		private function backBtnHandler(e:Event = null):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_HOMEPAGE_PHOTO_SCREEN);
		}

		private function saveGalleryPhotos():void
		{
			GalleryData.galleryDataChanged = true;
			GalleryData.setUrlsByCategory(this._category,_urls);
			backBtnHandler();
		}

		private function getImagesFromDirectory():void
		{
			var categoryDir:File = File.applicationDirectory.resolvePath("media/stock_images/" + this._category);
			categoryDir.addEventListener(FileListEvent.DIRECTORY_LISTING, directoryListingHandler);
			categoryDir.getDirectoryListingAsync();
		}

		private function directoryListingHandler(e:FileListEvent):void
		{
			var thumbFiles:Array = [],
				imageFiles:Array = [],
				files:Array = e.files,
				file:File,
				thumbFile:File,
				imageFile:File,
				image:GalleryItem;

			for (var j:int = 0; j < files.length; j++)
			{
				file = files[j];
				// file is a not a thumbnail, add it to imageFiles and remove it from thumbFiles
				if (file.name.indexOf("-thumb") == -1)
				{
					imageFiles.push(files[j]);
				}
				else
				{
					thumbFiles.push(files[j]);
				}
			}

			this._itemList = new <GalleryItem>[];
			this._imageCount = 0;
			this._imageTotal =  thumbFiles.length;
			for(var i:int = 0; i < this._imageTotal; i++)
			{
				thumbFile = thumbFiles[i];
				imageFile = imageFiles[i];

				image = new GalleryItem();
				image.id = i + 1;
				image.url = thumbFile.url;
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
			drawImages();
		}

		private function drawImages():void
		{
			var image:GalleryItem,
				yPos:Number = this._verticalPadding,
				xPos:Number = this._horizontalPadding, gap:Number = this._componentGap * 0.5,
				imageWidth:Number = (this._innerWidth - gap - 30) / 3,
				currUrl:String, currImageUrl:String;
			if (this._imageCount == this._imageTotal)
			{
				this._imageCount = 0;
				for (var i:int = 0; i < this._imageTotal; i++)
				{
					image = this._itemList[i];
					image.addEventListener(Event.TRIGGERED, selectImage);
					this._content.addChild(image);
					image.givenWidth = imageWidth;

					currImageUrl = this._category + "/" + image.filename;
					for (var j:int = 0; j < _urls.length; j++)
					{
						currUrl = this._urls[j];
						if(currImageUrl == currUrl)
						{
							image.isActive = true;
							trace(currImageUrl + " is active");
						}
					}

					image.validate();

					image.y = yPos;
					image.x = xPos;
					xPos += imageWidth + gap;
					if(this._imageCount == 2)
					{
						xPos = this._horizontalPadding;
						yPos += image.height + gap;
						this._imageCount = 0;
					}
					else
					{
						this._imageCount++;
					}
				}
			}
		}

		private function selectImage(e:Event):void
		{
			var currItem:GalleryItem = e.target as GalleryItem;

			currItem.isActive = !currItem.isActive;

			if(currItem.isActive)
			{
				addToSelectedItems(currItem.filename);
			}
			else
			{
				removeFromSelectedItems(currItem.filename);
			}
		}

		private function addToSelectedItems(galleryItemFilename:String):void
		{
			var currItem:String, itemExists:Boolean = false,
				url:String = this._category + "/" + galleryItemFilename;

			for (var i:int = 0; i < _urls.length; i++)
			{
				currItem = this._urls[i];
				if(url == currItem)
				{
					itemExists = true;
				}
			}

			if(!itemExists)
			{
				this._urls.push(url);
			}
		}

		private function removeFromSelectedItems(galleryItemFilename:String):void
		{
			var currItem:String, url:String = this._category + "/" + galleryItemFilename;
			if(_urls.length > 0)
			{
				for (var i:int = 0; i < _urls.length; i++)
				{
					currItem = this._urls[i];
					if(url == currItem)
					{
						this._urls.splice(i,1);
					}
				}

			}
		}

		private function selectPrePopulatedImages():void
		{
			var currUrl:String, currImageUrl:String, currImage:GalleryItem;

			if(_urls.length > 0)
			{
				for(var j:int = 0; j < this._imageTotal; j++)
				{
					currImage = this._itemList[j];
					currImageUrl = this._category + "/" + currImage.filename;
					for (var i:int = 0; i < _urls.length; i++)
					{
						currUrl = this._urls[i];
						if(currImageUrl == currUrl)
						{
							currImage.isActive = true;
							currImage.validate();
						}
					}
				}
			}
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
