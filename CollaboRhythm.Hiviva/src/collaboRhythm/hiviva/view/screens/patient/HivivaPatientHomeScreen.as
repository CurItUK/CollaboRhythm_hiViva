package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;

	import feathers.controls.Label;
	import feathers.controls.Screen;

	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
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
	import flash.system.System;

	import source.themes.HivivaTheme;

	import starling.display.DisplayObject;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;

	public class HivivaPatientHomeScreen extends Screen
	{
		private var _footerHeight:Number;
		private var _applicationController:HivivaApplicationController;

		private var _header:HivivaHeader;
		private var _messagesButton:Button;
		private var _badgesButton:Button;
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

			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._usableHeight = this.actualHeight - this._footerHeight - this._header.height;
/*
			this._messagesButton.width = 130 * this.dpiScale;
			this._messagesButton.height = 110 * this.dpiScale;

			this._badgesButton.width = 130 * this.dpiScale;
			this._badgesButton.height = 110 * this.dpiScale;
*/
			// 90% of stage width
			IMAGE_SIZE = this.actualWidth * 0.9;

			this._bg.width = IMAGE_SIZE;
			this._bg.scaleY = this._bg.scaleX;
			this._bg.x = (this.actualWidth * 0.5) - (this._bg.width * 0.5);
			this._bg.y = (this._usableHeight * 0.5) + this._header.height - (this._bg.height * 0.5);

			this._rim.scaleX = this._bg.scaleX;
			this._rim.scaleY = this._bg.scaleY;
			this._rim.x = (this.actualWidth * 0.5) - (this._rim.width * 0.5);
			this._rim.y = (this._usableHeight * 0.5) + this._header.height - (this._rim.height * 0.5);

			this._shine.scaleX = this._bg.scaleX;
			this._shine.scaleY = this._bg.scaleY;
			this._shine.x = (this.actualWidth * 0.5) - (this._shine.width * 0.5);
			this._shine.y = (this._usableHeight * 0.5) + this._header.height - (this._shine.height * 0.5);

			this._homeImageInstructions.width = IMAGE_SIZE;
			this._homeImageInstructions.validate();
			this._homeImageInstructions.x =  (this.actualWidth * 0.5) - (this._homeImageInstructions.width * 0.5);
			this._homeImageInstructions.y =  (this._usableHeight * 0.5) + this._header.height - (this._homeImageInstructions.height * 0.5);

			if(this._today == null)
			{
				this._today = new Date();
				initHomePhoto();
				checkForNewMessages();
				checkForNewBadges();
			}
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "";
			addChild(this._header);

			this._bgImageHolder = new Sprite();
			addChild(this._bgImageHolder);

			this._rim = new Image(Assets.getTexture(HivivaAssets.HOME_LENS_RIM));
			addChild(this._rim);

			this._bg = new Image(Assets.getTexture(HivivaAssets.HOME_LENS_BG));
			addChild(this._bg);

			this._lensImageHolder = new Sprite();
			addChild(this._lensImageHolder);

			this._shine = new Image(Assets.getTexture(HivivaAssets.HOME_LENS_SHINE));
			addChild(this._shine);

			this._homeImageInstructions = new Label();
			this._homeImageInstructions.name = "home-label";
			this._homeImageInstructions.text = "Go to <A HREF='http://www.google.com/'><FONT COLOR='#016cf9'>profile</FONT></A> then <FONT COLOR='#016cf9'>Homepage Photo</FONT> to upload or set your home page image <br/><br/>The clarity of this image will adjust to how well you stay on track with your medication.";
			addChild(this._homeImageInstructions);

			this._messagesButton = new Button();
			this._messagesButton.name = HivivaTheme.NONE_THEMED;
			this._messagesButton.defaultIcon = new Image(Assets.getTexture(HivivaAssets.TOPNAV_ICON_MESSAGES));
			this._messagesButton.addEventListener(Event.TRIGGERED , messagesButtonHandler);

			this._badgesButton = new Button();
			this._badgesButton.name = HivivaTheme.NONE_THEMED;
			this._badgesButton.defaultIcon = new Image(Assets.getTexture(HivivaAssets.TOPNAV_ICON_BADGES));
			this._badgesButton.addEventListener(Event.TRIGGERED , rewardsButtonHandler);

			this._header.rightItems =  new <DisplayObject>[this._messagesButton,this._badgesButton];

//			this._messagesButton.visible = false;
//			this._badgesButton.visible = false;
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
			localStoreController.addEventListener(LocalDataStoreEvent.PATIENT_PROFILE_LOAD_COMPLETE, getPatientProfileHandler);
			localStoreController.getPatientProfile();
		}

		private function getPatientProfileHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.PATIENT_PROFILE_LOAD_COMPLETE, getPatientProfileHandler);

			var patientProfile:Array = e.data.patientProfile,
				userIsSignedUp:Boolean;

			try
			{
				userIsSignedUp = patientProfile != null;
			}
			catch(e:Error)
			{
				userIsSignedUp = false;
			}
			if(userIsSignedUp) getMessages();
		}

		private function getMessages():void
		{
			
		}

		private function checkForNewBadges():void
		{

		}

		private function initHomePhoto():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE, getGalleryTimeStampHandler);
			localStoreController.getGalleryTimeStamp();
		}

		private function getGalleryTimeStampHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE,getGalleryTimeStampHandler);

			var timeStamp:String = e.data.timeStamp,
				date:Date = new Date();

			try
			{
				if(timeStamp != null)
				{
					date = HivivaModifier.getAS3DatefromString(timeStamp);

					this._dayDiff = HivivaModifier.getDaysDiff(this._today, date);

					localStoreController.addEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE,getAdherenceHandler);
					localStoreController.getAdherence();

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
			localStoreController.removeEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE,getAdherenceHandler);

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

			localStoreController.addEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);
			localStoreController.getGalleryImages();
		}

		private function getGalleryImagesHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);

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
				// TODO: boolean to define difference between custom photo and stock photo locations in homepage photo screen

			}
		}

		private function doImageLoad(url:String):void
		{
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoaded);
			imageLoader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, imageLoadFailed);
			imageLoader.load(new URLRequest(url));
		}

		private function imageLoaded(e:flash.events.Event):void
		{
			trace("Image loaded.");
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
			cropToFit(bgBm, this.actualWidth, this._usableHeight);
			bgBm.alpha = 0.35;
			bgHolder.addChild(bgBm);

			var bgMask:flash.display.Sprite = new flash.display.Sprite();
			bgMask.graphics.beginFill(0x000000);
			bgMask.graphics.drawRect((bgBm.width * 0.5) - (this.actualWidth * 0.5),(bgBm.height * 0.5) - (this._usableHeight * 0.5),this.actualWidth, this._usableHeight);
			bgHolder.addChild(bgMask);

			bgBm.mask = bgMask;

			var bmd:BitmapData = new BitmapData(bgHolder.width, bgHolder.height, true, 0x00000000);
			bmd.draw(bgHolder, new Matrix(), null, null, null, true);

			var bgImage:Image = new Image(Texture.fromBitmapData(bmd));
			bgImage.touchable = false;
			bgImage.x = (this.actualWidth * 0.5) - (bgImage.width * 0.5);
			bgImage.y = (this._usableHeight * 0.5) + this._header.height - (bgImage.height * 0.5);
			this._bgImageHolder.addChild(bgImage);

			bmd.dispose();
		}

		private function drawLensHomeImage(sourceBm:Bitmap):void
		{
			var circleHolder:flash.display.Sprite = new flash.display.Sprite();

			var circleBm:Bitmap = new Bitmap(sourceBm.bitmapData,"auto",true);
			cropToFit(circleBm, this.actualWidth, this._usableHeight);
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
			bgImage.x = (this.actualWidth * 0.5) - (bgImage.width * 0.5);
			bgImage.y = (this._usableHeight * 0.5) + this._header.height - (bgImage.height * 0.5);
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

		public function get localStoreController():HivivaLocalStoreController
		{
			return applicationController.hivivaLocalStoreController;
		}

		public function get applicationController():HivivaApplicationController
		{
			return _applicationController;
		}

		public function set applicationController(value:HivivaApplicationController):void
		{
			_applicationController = value;
		}

		public function get footerHeight():Number
		{
			return _footerHeight;
		}

		public function set footerHeight(value:Number):void
		{
			_footerHeight = value;
		}

		override public function dispose():void
		{
			super.dispose();
			System.gc();
		}
	}
}
