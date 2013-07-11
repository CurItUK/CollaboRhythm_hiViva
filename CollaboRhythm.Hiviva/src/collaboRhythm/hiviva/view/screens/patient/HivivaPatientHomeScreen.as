package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.components.TopNavButton;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;
	import feathers.controls.Screen;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.system.System;

	import starling.display.DisplayObject;
	import starling.display.Image;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;

	public class HivivaPatientHomeScreen extends Screen
	{



		private var _header:HivivaHeader;
		private var _messagesButton:TopNavButton;
		private var _badgesButton:TopNavButton;
		private var _homeImageInstructions:Label;
		private var _rim:Image;
		private var _bg:Image;
		private var _shine:Image;
		private var _bgImageHolder:Sprite;
		private var _lensImageHolder:Sprite;
		private var _dayDiff:Number;
		private var _adherencePercent:Number;

		private var IMAGE_SIZE:Number;
		private var _usableHeight:Number;
		private var _today:Date;

		public function HivivaPatientHomeScreenScreen():void
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;

			this._usableHeight = Constants.STAGE_HEIGHT - Constants.FOOTER_BTNGROUP_HEIGHT - Constants.HEADER_HEIGHT;

			// 90% of stage width
			IMAGE_SIZE = Constants.STAGE_WIDTH * 0.9;


			this._bg.width = IMAGE_SIZE;
			this._bg.scaleY = this._bg.scaleX;
			this._bg.x = (Constants.STAGE_WIDTH * 0.5) - (this._bg.width * 0.5);
			this._bg.y = (this._usableHeight * 0.5) + Constants.HEADER_HEIGHT - (this._bg.height * 0.5);

			this._rim.scaleX = this._bg.scaleX;
			this._rim.scaleY = this._bg.scaleY;
			this._rim.x = (Constants.STAGE_WIDTH * 0.5) - (this._rim.width * 0.5);
			this._rim.y = (this._usableHeight * 0.5) + Constants.HEADER_HEIGHT - (this._rim.height * 0.5);

			this._shine.scaleX = this._bg.scaleX;
			this._shine.scaleY = this._bg.scaleY;
			this._shine.x = (Constants.STAGE_WIDTH * 0.5) - (this._shine.width * 0.5);
			this._shine.y = (this._usableHeight * 0.5) + Constants.HEADER_HEIGHT - (this._shine.height * 0.5);

			this._homeImageInstructions.width = IMAGE_SIZE;
			this._homeImageInstructions.validate();
			this._homeImageInstructions.x =  (Constants.STAGE_WIDTH * 0.5) - (this._homeImageInstructions.width * 0.5);
			this._homeImageInstructions.y =  (this._usableHeight * 0.5) + Constants.HEADER_HEIGHT - (this._homeImageInstructions.height * 0.5);


			if(this._today == null)
			{
				this._today = new Date();
				checkForNewMessages();
				checkForNewBadges();
				initHomePhoto();
			}
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = " ";
			addChild(this._header);

			this._bgImageHolder = new Sprite();
			addChild(this._bgImageHolder);

			//this._rim = new Image(Assets.getTexture(HivivaAssets.HOME_LENS_RIM));
			this._rim = new Image(Main.assets.getTexture("home_lens_rim"));
			addChild(this._rim);

			//this._bg = new Image(Assets.getTexture(HivivaAssets.HOME_LENS_BG));
			this._bg = new Image(Main.assets.getTexture("home_lens_bg"));
			addChild(this._bg);

			this._lensImageHolder = new Sprite();
			addChild(this._lensImageHolder);

			//this._shine = new Image(Assets.getTexture(HivivaAssets.HOME_LENS_SHINE));
			this._shine = new Image(Main.assets.getTexture("home_lens_shine"));
			addChild(this._shine);

			this._homeImageInstructions = new Label();
			this._homeImageInstructions.name = HivivaThemeConstants.HOME_LENS_LABEL;
			this._homeImageInstructions.text = "Go to profile then Homepage Photo to upload or set your home page image \n\nThe clarity of this image will adjust to how well you stay on track with your medication.";
			addChild(this._homeImageInstructions);

			this._messagesButton = new TopNavButton();
			this._messagesButton.hivivaImage = new Image(Main.assets.getTexture("top_nav_icon_02"));
			this._messagesButton.addEventListener(Event.TRIGGERED , messagesButtonHandler);

			this._badgesButton = new TopNavButton();
			this._badgesButton.hivivaImage = new Image(Main.assets.getTexture("top_nav_icon_03"));
			this._badgesButton.addEventListener(Event.TRIGGERED , rewardsButtonHandler);

			this._header.rightItems =  new <DisplayObject>[this._messagesButton, this._badgesButton];

		}

		private function messagesButtonHandler(e:Event):void
		{
			this.dispatchEventWith("navGoSettings", false, {screen:HivivaScreens.PATIENT_MESSAGES_SCREEN});
		}

		private function rewardsButtonHandler(e:Event):void
		{
			this.dispatchEventWith("navGoSettings", false, {screen:HivivaScreens.PATIENT_BADGES_SCREEN});
		}

		private function checkForNewMessages():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE, getMessagesCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getUserReceivedMessages();
		}

		private function getMessagesCompleteHandler(e:RemoteDataStoreEvent):void
		{

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE , getMessagesCompleteHandler);
			trace("getMessagesCompleteHandler " + e.data.xmlResponse);
			var messageCount:uint = e.data.xmlResponse.children().length();
			if(messageCount > 0)
			{
				trace("messageCount " + messageCount);
				this._messagesButton.subScript = String(messageCount);
			}
		}

		private function checkForNewBadges():void
		{
			// dummy data
			//this._badgesButton.subScript = "1";
		}

		private function initHomePhoto():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE, getGalleryTimeStampHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.getGalleryTimeStamp();
		}

		private function getGalleryTimeStampHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE,getGalleryTimeStampHandler);

			var timeStamp:String = e.data.timeStamp,
				date:Date = new Date();

			try
			{
				if(timeStamp != null && timeStamp.length > 0)
				{
					date = HivivaModifier.getAS3DatefromString(timeStamp);

					this._dayDiff = HivivaModifier.getDaysDiff(this._today, date);

					HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE,getAdherenceHandler);
					HivivaStartup.hivivaAppController.hivivaLocalStoreController.getAdherence();

					this._homeImageInstructions.visible = false;
				}
				else
				{
					this._homeImageInstructions.visible = true;
				}
				trace("gallery_submission_timestamp = " + timeStamp);
			}
			catch(e:Error)
			{
				trace("date stamp not there");
				this._homeImageInstructions.visible = true;
				//TODO: delete all old image entries in sql
			}
		}

		private function getAdherenceHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE,getAdherenceHandler);

			var allAdherenceData:Array = e.data.adherence,
				latestAdherenceData:Object;

			this._adherencePercent = 0;
			if (allAdherenceData != null)
			{
				latestAdherenceData = allAdherenceData[allAdherenceData.length - 1];
				if(latestAdherenceData.date == HivivaModifier.getSQLStringFromDate(this._today))
				{
					this._adherencePercent = allAdherenceData[allAdherenceData.length - 1].adherence_percentage;
				}
			}
			trace("this._adherencePercent = " + this._adherencePercent);

			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.getGalleryImages();
		}

		private function getGalleryImagesHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);

			var imageUrls:Array = e.data.imageUrls;

			var resultDataLength:int, chosenImageUrl:String, chosenImageInd:int, daysToImagesRatio:Number;

			resultDataLength = imageUrls.length;
			if(resultDataLength > 0)
			{
				// start again if the dayDiff exceeds the amount of images
				daysToImagesRatio = Math.floor(this._dayDiff / resultDataLength);
				if(daysToImagesRatio >= 1)
				{
					chosenImageInd = this._dayDiff - (daysToImagesRatio * resultDataLength);
				}
				else
				{
					chosenImageInd = this._dayDiff;
				}

				chosenImageUrl = imageUrls[chosenImageInd].url;
				if(chosenImageUrl == "homepageimage.jpg")
				{
					var appStoreDir:File = File.applicationStorageDirectory;
					trace(appStoreDir.url + chosenImageUrl);
					doImageLoad(appStoreDir.url + chosenImageUrl);
				}
				else
				{
					trace("media/stock_images/" + chosenImageUrl);
					doImageLoad("media/stock_images/" + chosenImageUrl);
				}
				//

			}
		}

		private function doImageLoad(url:String):void
		{

			trace("Image load start");
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			var imageLoader:Loader = new Loader();

			imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoaded);
			imageLoader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, imageLoadFailed);
			imageLoader.load(new URLRequest(url) , loaderContext);

		}

		private function imageLoaded(e:flash.events.Event):void
		{
			trace("Image load finish");


			var sourceBm:Bitmap = e.target.content as Bitmap;

			drawBgHomeImage(sourceBm);

			drawLensHomeImage(sourceBm);

			//clean up
			sourceBm.bitmapData.dispose();
			sourceBm = null;
			System.gc();

			/*var suitableBm:Bitmap = getSuitableBitmap(sourceBm);
			this._imageHolder = new Image(Texture.fromBitmap(suitableBm));
			sourceBm.bitmapData.dispose();
			suitableBm.bitmapData.dispose();

			constrainToProportion(this._imageHolder, IMAGE_SIZE);
			// TODO : Check if if (img.height >= img.width) then position accordingly. right now its only Ypos
			this._imageHolder.x = this._imageBg.x;
			this._imageHolder.y = this._imageBg.y + (this._imageBg.height / 2) - (this._imageHolder.height / 2);
			if (!contains(this._imageHolder)) addChild(this._imageHolder);*/
		}

		private function imageLoadFailed(e:flash.events.IOErrorEvent):void
		{
			trace("Image load failed.");
		}

		private function drawBgHomeImage(sourceBm:Bitmap):void
		{
			var bgHolder:flash.display.Sprite = new flash.display.Sprite();

			var bgBm:Bitmap = new Bitmap(sourceBm.bitmapData,"auto",true);
			cropToFit(bgBm, Constants.STAGE_WIDTH, this._usableHeight);
			bgBm.alpha = 0.35;
			bgHolder.addChild(bgBm);

			var bgMask:flash.display.Sprite = new flash.display.Sprite();
			bgMask.graphics.beginFill(0x000000);
			bgMask.graphics.drawRect((bgBm.width * 0.5) - (Constants.STAGE_WIDTH * 0.5),(bgBm.height * 0.5) - (this._usableHeight * 0.5),Constants.STAGE_WIDTH, this._usableHeight);
			bgHolder.addChild(bgMask);

			bgBm.mask = bgMask;

			var bmd:BitmapData = new BitmapData(bgHolder.width, bgHolder.height, true, 0x00000000);
			bmd.draw(bgHolder, new Matrix(), null, null, null, true);

			var bgImage:Image = new Image(Texture.fromBitmapData(bmd));
			bgImage.touchable = false;
			bgImage.x = (Constants.STAGE_WIDTH * 0.5) - (bgImage.width * 0.5);
			bgImage.y = (this._usableHeight * 0.5) + Constants.HEADER_HEIGHT - (bgImage.height * 0.5);
			this._bgImageHolder.addChild(bgImage);


			bgHolder.removeChild(bgBm);
			bgHolder.removeChild(bgMask);

			bgMask = null;
			bgHolder = null;


			bmd.dispose();
			bmd = null;
		}

		private function drawLensHomeImage(sourceBm:Bitmap):void
		{
			var circleHolder:flash.display.Sprite = new flash.display.Sprite();

			var circleBm:Bitmap = new Bitmap(sourceBm.bitmapData,"auto",true);
			cropToFit(circleBm, Constants.STAGE_WIDTH, this._usableHeight);
			circleHolder.addChild(circleBm);

			var blurValue:Number = Math.ceil((20 / 100) * this._adherencePercent);

			var blurFilter:BitmapFilter = new flash.filters.BlurFilter(20 - blurValue, 20 - blurValue, BitmapFilterQuality.HIGH);
			var myFilters:Array = [];
			myFilters.push(blurFilter);

			circleBm.filters = myFilters;

			var circleMask:flash.display.Sprite = new flash.display.Sprite();
			circleMask.graphics.beginFill(0x000000);
			circleMask.graphics.drawCircle(circleBm.width * 0.5, circleBm.height * 0.5, IMAGE_SIZE * 0.5);
			circleHolder.addChild(circleMask);

			circleBm.mask = circleMask;

			var bmd:BitmapData = new BitmapData(circleHolder.width, circleHolder.height, true, 0x00000000);
			bmd.draw(circleHolder, new Matrix(), null, null, null, true);

			var bgImage:Image = new Image(Texture.fromBitmapData(bmd));
			bgImage.touchable = false;
			bgImage.x = (Constants.STAGE_WIDTH * 0.5) - (bgImage.width * 0.5);
			bgImage.y = (this._usableHeight * 0.5) + Constants.HEADER_HEIGHT - (bgImage.height * 0.5);
			this._lensImageHolder.addChild(bgImage);

			var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
			trace("colorFilter.adjustSaturation = " + (-1 + (this._adherencePercent / 100)));
			colorFilter.adjustSaturation(-1 + (this._adherencePercent / 100));
			this._lensImageHolder.filter = colorFilter;

			bmd.dispose();
		}

		private function cropToFit(img:Object, w:Number, h:Number):void
		{
			if (img.height >= img.width)
			{
				// portrait
				img.width = w;
				img.scaleY = img.scaleX;
			}
			else
			{
				// landscape
				img.height = h;
				img.scaleX = img.scaleY;
			}
		}




		override public function dispose():void
		{
			trace("HivivaPatientHomeScreenScreen dispose" );


			//this._bg.texture.base.dispose();
			//this._bg.texture.dispose();
			this._bg.dispose();
			this._bg = null;

			//this._rim.texture.base.dispose();
			//this._rim.texture.dispose();
			this._rim.dispose();
			this._rim = null;

			//this._shine.texture.base.dispose();
			//this._shine.texture.dispose();
			this._shine.dispose();
			this._shine = null;

			Assets.clearTexture(HivivaAssets.HOME_LENS_RIM);
			Assets.clearTexture(HivivaAssets.HOME_LENS_BG);
			Assets.clearTexture(HivivaAssets.HOME_LENS_SHINE);

			super.dispose();
			System.gc();

		}
	}
}
