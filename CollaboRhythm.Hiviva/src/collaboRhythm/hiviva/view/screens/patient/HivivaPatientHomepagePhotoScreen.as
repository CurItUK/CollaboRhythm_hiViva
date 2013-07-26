package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.galleryscreens.GalleryData;
	import collaboRhythm.hiviva.view.galleryscreens.GalleryScreen;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.ScreenNavigatorItem;

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
			 trace("HivivaPatientHomepagePhotoScreen construct");
		}

		override protected function draw():void
		{
			super.draw();
			trace("HivivaPatientHomepagePhotoScreen draw");
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
			trace("HivivaPatientHomepagePhotoScreen initialize");

			this._header.title = "Homepage Photo";

			this._instructions = new Label();
			this._instructions.text = 	"The clarity of this image will adjust to " +
										"how well you stay on track with your " +
										"medication.";
			this._content.addChild(this._instructions);

			this._categoryMenuLabel = new Label();
			this._categoryMenuLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._categoryMenuLabel.text = "App image categories";
			this._content.addChild(this._categoryMenuLabel);

			this._galleryBtnContainer = new Sprite();
			this._content.addChild(this._galleryBtnContainer);

			this._uploadLabel = new Label();
			this._uploadLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._uploadLabel.text = "Select your own image";
			this._content.addChild(this._uploadLabel);

			this._photoContainer = new ImageUploader();
			this._photoContainer.scale = this.dpiScale;
			this._photoContainer.fileName = CUSTOM_HOME_IMAGE;
			this._content.addChild(this._photoContainer);
			this._photoContainer.getMainImage();

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

			if(!GalleryData.galleryDataChanged)
			{
				trace("populate first time");
				initImageData();
				populateOldData();
			}
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
			trace(saveData.join(','));
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
					// basic randomisation
					if(Math.random() < 0.5)
					{
						allImageData.push(categoryUrls[i]);
					}
					else
					{
						allImageData.unshift(categoryUrls[i]);
					}
//					trace(categoryUrls[i]);
				}
			}
//			trace("customImageExists = " + customImageExists);
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
						button.defaultIcon = new Image(Main.assets.getTexture("icon_sports"));
						break;
					case "MUSIC" :
						button.defaultIcon = new Image(Main.assets.getTexture("icon_music"));
						break;
					case "CINEMA" :
						button.defaultIcon = new Image(Main.assets.getTexture("icon_cinema"));
						break;
					case "HISTORY" :
						button.defaultIcon = new Image(Main.assets.getTexture("icon_history"));
						break;
					case "TRAVEL" :
						button.defaultIcon = new Image(Main.assets.getTexture("icon_travel"));
						break;
					case "ART" :
						button.defaultIcon = new Image(Main.assets.getTexture("icon_art"));
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

	}
}
