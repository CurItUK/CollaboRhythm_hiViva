package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.galleryscreens.Gallery;
	import collaboRhythm.hiviva.view.galleryscreens.GalleryData;
	import collaboRhythm.hiviva.view.galleryscreens.GalleryScreen;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledColumnsLayout;
	import feathers.skins.Scale9ImageStateValueSelector;
	import feathers.textures.Scale9Textures;

	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class HivivaPatientHomepagePhotoScreen extends ValidationScreen
	{

		private var _instructions:Label;
		private var _categoryMenuLabel:Label;
		private var _uploadLabel:Label;
		private var _galleryBtnContainer:Sprite;
		private var _photoContainer:ImageUploader;
		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _backButton:Button;
		private var _imageUrls:Array;

		private const GALLERY_CATEGORIES:Array = ["sport","music","cinema","history","travel","art"];
		private const CUSTOM_HOME_IMAGE:String = "homepageimage.jpg";

		public function HivivaPatientHomepagePhotoScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
/*			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._cancelButton.validate();
			this._cancelButton.y = this.actualHeight - this._cancelButton.height - scaledPadding;
			this._cancelButton.x = scaledPadding;

			this._submitButton.validate();
			this._submitButton.y = this._cancelButton.y;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + (20 * this.dpiScale);

			this._photoContainer.width = this.actualWidth;
			this._photoContainer.validate();
			this._photoContainer.y = this._cancelButton.y - scaledPadding - this._photoContainer.height;


			this._loadText.width = this.actualWidth;
			this._loadText.validate();
			this._loadText.x = (this.actualWidth * 0.5) - (this._loadText.width * 0.5);
			this._loadText.y = (this._photoContainer.y * 0.5) - (this._loadText.height * 0.5);

			if (this._galleries.length == 0) initGallery();
*/
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();

			this._instructions.width = this._innerWidth;
			this._categoryMenuLabel.width = this._innerWidth;

			if(this._galleryBtnContainer.numChildren == 0) initGalleryBtns();

			this._uploadLabel.width = this._innerWidth;
			this._photoContainer.width = this._innerWidth;
			this._submitButton.width = this._cancelButton.width = this._innerWidth * 0.25;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();

			this._submitButton.y = this._cancelButton.y;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + this._componentGap;
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Homepage Photo";

			this._instructions = new Label();
			this._instructions.text = 	"The clarity of this image will adjust to " +
										"how well you stay on track with your " +
										"medication.";
			this._content.addChild(this._instructions);

			this._categoryMenuLabel = new Label();
			this._categoryMenuLabel.text = "<font face='ExoBold'>App image categories</font>";
			this._content.addChild(this._categoryMenuLabel);

			this._galleryBtnContainer = new Sprite();
			this._content.addChild(this._galleryBtnContainer);

			this._uploadLabel = new Label();
			this._uploadLabel.text = "<font face='ExoBold'>Select your own image</font>";
			this._content.addChild(this._uploadLabel);

			this._photoContainer = new ImageUploader();
			this._photoContainer.scale = this.dpiScale;
			this._photoContainer.fileName = CUSTOM_HOME_IMAGE;
			this._content.addChild(this._photoContainer);

			this._cancelButton = new Button();
			this._cancelButton.label = "Cancel";
			this._cancelButton.addEventListener(Event.TRIGGERED, cancelButtonClick);
			this._content.addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.label = "Save";
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			this._content.addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			initImageData();
			populateOldData();
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
			var saveData:Array = compileAllImageData();
			if(saveData.length > 0)
			{
				localStoreController.addEventListener(LocalDataStoreEvent.GALLERY_IMAGES_SAVE_COMPLETE,setGalleryImagesHandler);
				localStoreController.setGalleryImages(saveData);
			}
			else
			{
				showFormValidation("No Images were selected");
			}
		}

		private function compileAllImageData():Array
		{
			var allImageData:Array = [],
				imageData:Array = GalleryData.ImageData,
				categoryUrls:Array,
				customImageExists:Boolean = this._photoContainer.saveTempImageAsMain();

			for (var j:int = 0; j < imageData.length; j++)
			{
				categoryUrls = imageData[j].urls;
				for (var i:int = 0; i < categoryUrls.length; i++)
				{
					allImageData.push(categoryUrls[i]);
				}
			}

			if (customImageExists) allImageData.push(CUSTOM_HOME_IMAGE);
			// basic randomisation
			allImageData.sort(
					function(a:*, b:*):Number
					{
					    if (Math.random() < 0.5) return -1;
					    else return 1;
					}
			);

			return allImageData;
		}

		private function setGalleryImagesHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.GALLERY_IMAGES_SAVE_COMPLETE,setGalleryImagesHandler);

			var sqDate:String = HivivaModifier.getSQLStringFromDate(new Date());

			localStoreController.addEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_SAVE_COMPLETE,setGalleryTimeStampHandler);
			localStoreController.setGalleryTimeStamp(sqDate);
		}

		private function setGalleryTimeStampHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_SAVE_COMPLETE,setGalleryTimeStampHandler);
			showFormValidation("Your selection has been saved");
		}

		private function populateOldData():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);
			localStoreController.getGalleryImages();
		}

		private function getGalleryImagesHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);
			this._imageUrls = e.data.imageUrls;
			try
			{
				if(this._imageUrls != null)
				{
					applyCurrentImageData();
				}
				else
				{
					trace("no images in database");
				}
			}
			catch(e:Error)
			{
				trace("no images in database");
			}
		}

		private function initImageData():void
		{
			var category:String, imageData:Array = GalleryData.ImageData;
			if(imageData.length == 0)
			{
				for (var j:int = 0; j < GALLERY_CATEGORIES.length; j++)
				{
					category = GALLERY_CATEGORIES[j];
					imageData.push({category:category, urls:[]});
				}
			}
		}

		private function applyCurrentImageData():void
		{
			var url:String, category:String, urls:Array;
			for (var j:int = 0; j < GALLERY_CATEGORIES.length; j++)
			{
				category = GALLERY_CATEGORIES[j];
				urls = [];
				for (var i:int = 0; i < this._imageUrls.length; i++)
				{
					url = this._imageUrls[i].url;
					if(url.search(category) > -1)
					{
						urls.push(url);
					}
				}
				GalleryData.setUrlsByCategory(category,urls);
			}
		}

		private function initGalleryBtns():void
		{
			var category:String,
				categoryCount:int,
				categoryLength:int = GALLERY_CATEGORIES.length,
				button:Button,
				yPos:Number = 0;
			for (categoryCount = 0; categoryCount < categoryLength; categoryCount++)
			{
				category = String(GALLERY_CATEGORIES[categoryCount]).toUpperCase();
				button = new Button;
				button.iconPosition = Button.ICON_POSITION_LEFT;
				button.label = category;
				button.addEventListener(Event.TRIGGERED, galleryBtnHandler);
				switch(category)
				{
					case "SPORT" :
						button.defaultIcon = new Image(HivivaAssets.SPORTS_ICON);
						break;
					case "MUSIC" :
						button.defaultIcon = new Image(HivivaAssets.MUSIC_ICON);
						break;
					case "CINEMA" :
						button.defaultIcon = new Image(HivivaAssets.CINEMA_ICON);
						break;
					case "HISTORY" :
						button.defaultIcon = new Image(HivivaAssets.HISTORY_ICON);
						break;
					case "TRAVEL" :
						button.defaultIcon = new Image(HivivaAssets.TRAVEL_ICON);
						break;
					case "ART" :
						button.defaultIcon = new Image(HivivaAssets.ART_ICON);
						break;
				}
				this._galleryBtnContainer.addChild(button);
				button.width = (this._innerWidth * 0.5) - (this._componentGap * 0.5);
				// two column layout
				if(categoryCount == 3) yPos = 0;
				if(categoryCount >= 3)
				{
					button.x = button.width + (this._componentGap * 0.5);
				}
				button.validate();
				button.y = yPos;
				yPos += button.height;
			}
		}

		private function galleryBtnHandler(e:Event):void
		{
			var btn:Button = e.target as Button,
				category:String = btn.label.toLowerCase();

			if(this.owner.hasScreen("galleryScreen")) this.owner.removeScreen("galleryScreen");
			this.owner.addScreen("galleryScreen", new ScreenNavigatorItem(GalleryScreen, null, {category:category}));
			this.owner.showScreen("galleryScreen");
		}
/*
		private function submitButtonClick(e:Event):void
		{
			getSqDataFromGalleries();
			getSqDataFromCustomImage();

			if(this._sqDataToWrite.length > 0)
			{
				if(this._dataPreExists)
				{
					this._sqStatement = new SQLStatement();
					this._sqStatement.text = "DELETE FROM homepage_photos";
					this._sqStatement.sqlConnection = this._sqConn;
					this._sqStatement.addEventListener(SQLEvent.RESULT, tableDataDeleted);
					this._sqStatement.execute();
				}
				else
				{
					writeImageData();
				}
			}
			else
			{
				trace("nothing selected");
			}
		}


		private function getSqDataFromGalleries():void
		{
			var currGallery:Gallery,
				currGallerySelectedItems:Array,
				selectedItem:String,
				isFirstItem:Boolean = true;

			this._selectedItemsCount = 0;
			this._sqDataToWrite = "";

			//shuffleList(this._galleries);

			for (var i:int = 0; i < this._galleryLength; i++)
			{
				currGallery = this._galleries[i];
				currGallerySelectedItems = currGallery.selectedItems;
				//shuffleList(currGallerySelectedItems);

				if (currGallerySelectedItems.length > 0)
				{
					for (var j:int = 0; j < currGallerySelectedItems.length; j++)
					{
						this._selectedItemsCount++;
						selectedItem = currGallerySelectedItems[j];
						if (isFirstItem)
						{
							this._sqDataToWrite += "SELECT " + this._selectedItemsCount + " AS 'photoid', '" + selectedItem + "' AS 'url' ";
							isFirstItem = false;
						}
						else
						{
							this._sqDataToWrite += "UNION SELECT " + this._selectedItemsCount + ", '" + selectedItem + "' ";
						}
					}
				}
			}
		}

		private function shuffleList(list:Object):void
		{
			var listLength:int = list.length;
			if (listLength > 1)
			{
				var i:int = listLength - 1;
				while (i > 0)
				{
					var s:Number = Math.floor(Math.random()*(listLength));
					var temp:* = list[s];
					list[s] = list[i];
					list[i] = temp;
					i--;
				}
			}
		}

		private function getSqDataFromCustomImage():void
		{
			this._photoContainer.saveTempImageAsMain();
			var main:File = File.applicationStorageDirectory.resolvePath(this._photoContainer.fileName);

			if (main.exists)
			{
				if (this._sqDataToWrite.length > 0)
				{
					this._sqDataToWrite += "UNION SELECT " + (this._selectedItemsCount + 1) + ", '" + main.url + "'";
				}
				else
				{
					this._sqDataToWrite += "SELECT " + (this._selectedItemsCount + 1) + " AS 'photoid', '" + main.url +	"' AS 'url' ";
				}
			}
		}


		private function tableDataDeleted(e:SQLEvent):void
		{
			this._sqStatement.removeEventListener(SQLEvent.RESULT, tableDataDeleted);
			trace("image data deleted");
			writeImageData();
		}

		private function writeImageData():void
		{
			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "INSERT INTO homepage_photos " + this._sqDataToWrite;
			trace(this._sqStatement.text);
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, tableDataWritten);
			this._sqStatement.execute();
		}

		private function tableDataWritten(e:SQLEvent):void
		{
			this._sqStatement.removeEventListener(SQLEvent.RESULT, tableDataWritten);

			writeDateStamp();
		}

		private function writeDateStamp():void
		{
			var today:Date = new Date();
			var sqDate:String = HivivaModifier.getSQLStringFromDate(today);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "UPDATE app_settings SET gallery_submission_timestamp='" + sqDate + "'";
			trace(this._sqStatement.text);
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, sqlResultHandler);
			this._sqStatement.execute();
		}

		private function sqlResultHandler(e:SQLEvent):void
		{
			trace("sqlResultHandler " + e);
		}

		private function oldDataCheck():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.addEventListener(SQLEvent.RESULT, getDate);
			this._sqStatement.text = "SELECT gallery_submission_timestamp FROM app_settings";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();
		}


		private function getDate(e:SQLEvent):void
		{
			this._sqStatement.removeEventListener(SQLEvent.RESULT, getDate);
			this._resultData = this._sqStatement.getResult().data;

			try
			{
				this._dataPreExists = this._resultData[0].gallery_submission_timestamp != null;
				trace("gallery_submission_timestamp = " + this._resultData[0].gallery_submission_timestamp);
			}
			catch(e:Error)
			{
				trace("date stamp not there");
				this._dataPreExists = false;
			}

			if(this._dataPreExists)
			{
				populateOldData();
			}
			else
			{

			}
		}

		private function initGallery():void
		{
			var currGalleryContainer:Gallery;

			this._galleryPadding = 15 * this.dpiScale;

			const horizontalLayout:HorizontalLayout = new HorizontalLayout();
			horizontalLayout.gap = this._galleryPadding;
			horizontalLayout.padding = 0;
			horizontalLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			horizontalLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;

			this._galleryCount = 0;
			this._galleryLength = GALLERY_CATEGORIES.length;
			for (var i:int = 0; i < this._galleryLength; i++)
			{
				currGalleryContainer = new Gallery();
				currGalleryContainer.category = GALLERY_CATEGORIES[i];
				currGalleryContainer.layout = horizontalLayout;
				currGalleryContainer.addEventListener(Event.COMPLETE, galleryReady);
				currGalleryContainer.getImageList();
				this._galleries.push(currGalleryContainer);
			}
		}

		private function galleryReady(e:Event):void
		{
			var currGalleryContainer:Gallery = e.target as Gallery;
			currGalleryContainer.removeEventListener(Event.COMPLETE, galleryReady);

			this._galleryCount++;

			if(this._galleryCount == this._galleryLength)
			{
				removeChild(this._loadText,true);

				initGalleriesContainer();
				this._galleries.forEach(drawGalleries);
			}
		}

		private function initGalleriesContainer():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var startYPosition:Number = this._header.y + this._header.height;

			this._galleriesContainer = new ScrollContainer();
			addChild(this._galleriesContainer);

			this._galleriesContainer.x = scaledPadding;
			this._galleriesContainer.y = startYPosition;
			this._galleriesContainer.width = this.actualWidth - (scaledPadding * 2);
			this._galleriesContainer.height = this._photoContainer.y - startYPosition - scaledPadding;
		}

		private function drawGalleries(item:Gallery, index:int, vector:Vector.<Gallery>):void
		{
			var galleryHeight:Number = 125 * this.dpiScale;

			this._galleriesContainer.addChild(item);
			item.height = galleryHeight;
			item.width = this._galleriesContainer.width;
			item.y = (galleryHeight + this._galleryPadding) * index;
			item.drawGallery();
		}

		private function onOpenGallery(e:Event):void
		{
			const button:Button = Button(e.currentTarget);
			var category:String;
			//trace(button.label + " triggered.");
			switch(button.label)
			{
				case "Sport" :
					//var sportsScreen:SportsGalleryScreen = new SportsGalleryScreen();
					//addChild(sportsScreen);
					category = "sport";
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
			if(this.owner.hasScreen("gallery")) this.owner.removeScreen("gallery");
			this.owner.addScreen("gallery", new ScreenNavigatorItem(SportsGalleryScreen, null, {category:category}));
			this.owner.showScreen("gallery");
		}
		*/
	}
}
