package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.components.GalleryButton;
	import collaboRhythm.hiviva.view.screens.patient.galleryscreens.GalleryScreen;
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
		private var _cancelAndSave:BoxedButtons;
		private var _backButton:Button;
		private var _imageUrls:Array;
		private var _customImageWasDeleted:Boolean = false;

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
			if(HivivaStartup.galleryDataVO.changed)
			{
				this._cancelAndSave.visible = true;
				this._content.height = this._cancelAndSave.y - this._content.y - this._componentGap;
			}
			else
			{
				this._cancelAndSave.visible = false;
				this._content.height = Constants.STAGE_HEIGHT - Constants.PADDING_BOTTOM - this._verticalPadding - Constants.HEADER_HEIGHT;
			}
			this._content.validate();
			// property here is for show / hide validation
			this._contentHeight = this._content.height;
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();

			this._instructions.width = this._innerWidth;
			this._categoryMenuLabel.width = this._innerWidth;

			if(this._galleryBtnContainer.numChildren == 0) initGalleryBtns();

			this._uploadLabel.width = this._innerWidth;
			this._photoContainer.width = this._innerWidth;

			this._cancelAndSave.width = this._innerWidth;
			this._cancelAndSave.validate();
			this._cancelAndSave.x = Constants.PADDING_LEFT;
			this._cancelAndSave.y = Constants.STAGE_HEIGHT - Constants.PADDING_BOTTOM - this._cancelAndSave.height;
		}

		override protected function initialize():void
		{
			super.initialize();
			trace("HivivaPatientHomepagePhotoScreen initialize");

			this._header.title = "Homepage photo";

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
			this._photoContainer.defaultImage = "v2_profile_img";
			this._photoContainer.addEventListener("uploadedImageChanged", imageChangedHandler);
//			this._photoContainer.scale = this.dpiScale;
			this._photoContainer.fileName = CUSTOM_HOME_IMAGE;
			this._content.addChild(this._photoContainer);
			this._photoContainer.getMainImage();

			this._cancelAndSave = new BoxedButtons();
			this._cancelAndSave.labels = ["Cancel","Save"];
			this._cancelAndSave.addEventListener(Event.TRIGGERED, cancelAndSaveHandler);
			addChild(this._cancelAndSave);

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			if(!HivivaStartup.galleryDataVO.changed)
			{
				trace("populate first time");
				initImageData();
				populateOldData();
			}
		}

		private function saveHomepagePhotos():void
		{
			var saveData:Array = compileAllImageData();
//			trace(saveData.join(','));
//			if(saveData.length > 0)
			{
				localStoreController.addEventListener(LocalDataStoreEvent.GALLERY_IMAGES_SAVE_COMPLETE,setGalleryImagesHandler);
				localStoreController.setGalleryImages(saveData);
			}
			/*else
			{
				showFormValidation("No Images were selected");
				// re instate custom image if all other images were deselected and custom image was deleted
				if(this._customImageWasDeleted)
				{
					this._photoContainer.saveTempImageAsMain();
					this._photoContainer.getMainImage();
					this._customImageWasDeleted = false;
				}
			}*/
		}

		private function imageChangedHandler(e:Event = null):void
		{
			this._customImageWasDeleted = true;
			HivivaStartup.galleryDataVO.changed = true;
			draw();
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
					saveHomepagePhotos();
					break;
			}
		}

		private function backBtnHandler(e:Event = null):void
		{
			HivivaStartup.galleryDataVO.changed = false;
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function compileAllImageData():Array
		{
			var allImageData:Array = [],
				imageData:Array = HivivaStartup.galleryDataVO.imageData,
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
			if (customImageExists)
			{
				if(Math.random() < 0.5)
				{
					allImageData.push(CUSTOM_HOME_IMAGE);
				}
				else
				{
					allImageData.unshift(CUSTOM_HOME_IMAGE);
				}
			}
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

			var sqDate:String = HivivaModifier.getSQLStringFromDate(HivivaStartup.userVO.serverDate);

			localStoreController.addEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_SAVE_COMPLETE,setGalleryTimeStampHandler);
			localStoreController.setGalleryTimeStamp(sqDate);
		}

		private function setGalleryTimeStampHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_SAVE_COMPLETE,setGalleryTimeStampHandler);

			HivivaStartup.galleryDataVO.changed = false;
			draw();

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
			var category:String, imageData:Array = HivivaStartup.galleryDataVO.imageData;
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
				HivivaStartup.galleryDataVO.setUrlsByCategory(category,urls);
			}
		}

		private function initGalleryBtns():void
		{
			var category:String,
				categoryCount:int,
				categoryLength:int = GALLERY_CATEGORIES.length,
				button:GalleryButton,
				yPos:Number = 0;

			for (categoryCount = 0; categoryCount < categoryLength; categoryCount++)
			{
				category = GALLERY_CATEGORIES[categoryCount];

				button = new GalleryButton();
				button.category = category.toUpperCase();
				button.imageSelectedCount = HivivaStartup.galleryDataVO.getUrlsByCategory(category).length;
				button.addEventListener(Event.TRIGGERED, galleryBtnHandler);
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
