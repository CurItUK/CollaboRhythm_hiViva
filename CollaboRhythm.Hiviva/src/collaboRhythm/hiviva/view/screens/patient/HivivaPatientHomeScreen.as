package collaboRhythm.hiviva.view.screens.patient
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.global.NotificationsEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.PreloaderSpinner;
	import collaboRhythm.hiviva.view.components.TopNavButton;

	import feathers.controls.Label;
	import feathers.controls.Screen;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
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
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class HivivaPatientHomeScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _messagesButton:TopNavButton;
		private var _badgesButton:TopNavButton;
		private var _homeImageInstructions:Label;
		private var _lens:Image;
		private var _lensImageHolder:Sprite;
		private var _dayDiff:Number;
		private var _adherencePercent:Number;

		private var IMAGE_SIZE:Number = Constants.STAGE_WIDTH;
		private var LENS_SHADOW_RADIUS:Number = 40;
		private var _usableHeight:Number;
//		private var _today:Date;
		private var _asynchronousCallMade:Boolean = false;
		private var _remoteCallCount:int = 0;

		private var _messageCount:uint = 0;
		private var _badgesAwarded:Number = 0;
		private var _preloader:PreloaderSpinner;


		public function HivivaPatientHomeScreen():void
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;

			this._usableHeight = Constants.STAGE_HEIGHT - Constants.FOOTER_BTNGROUP_HEIGHT - Constants.HEADER_HEIGHT;

			this._lens.width = IMAGE_SIZE;
			this._lens.scaleY = this._lens.scaleX;
			this._lens.x = (Constants.STAGE_WIDTH * 0.5) - (this._lens.width * 0.5);
			this._lens.y = (this._usableHeight * 0.5) + Constants.HEADER_HEIGHT - (this._lens.height * 0.5);

			this._homeImageInstructions.width = IMAGE_SIZE - (LENS_SHADOW_RADIUS * 2);
			this._homeImageInstructions.validate();
			this._homeImageInstructions.x =  (Constants.STAGE_WIDTH * 0.5) - (this._homeImageInstructions.width * 0.5);
			this._homeImageInstructions.y =  (this._usableHeight * 0.5) + Constants.HEADER_HEIGHT - (this._homeImageInstructions.height * 0.5);



			if (!this._asynchronousCallMade)
			{
				enableAutoHomePageMessageCheck();
				getAllMessagesFromRemoteService();
				checkForNewBadges();
				getGalleryTimeStamp();
				getApprovedConnections();
				this._asynchronousCallMade = true;
			}
		}

		private function initHomeScreenPreloader():void
		{
			this._preloader = new PreloaderSpinner();
			this.addChild(this._preloader) ;
			this._preloader.y = this._header.height + 30;
			this._preloader.x = this.actualWidth - this._preloader.width - 30;
		}

		private function updateVODataHandler(e:NotificationsEvent):void
		{
			if(HivivaStartup.hivivaAppController.hivivaNotificationsController.hasEventListener(NotificationsEvent.HOMEPAGE_TICK_COMPLETE))
			{
				HivivaStartup.hivivaAppController.hivivaNotificationsController.disableAutoHomePageMessageCheck();
				HivivaStartup.hivivaAppController.hivivaNotificationsController.removeEventListener(NotificationsEvent.HOMEPAGE_TICK_COMPLETE , homePageTickHandler);
			}

			HivivaStartup.patientAdherenceVO.percentage = 0;
			this._asynchronousCallMade = false;
			this.draw();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = " ";
			addChild(this._header);

			this._lensImageHolder = new Sprite();
			addChild(this._lensImageHolder);

			this._lens = new Image(Main.assets.getTexture("home_lens"));
			addChild(this._lens);

			this._homeImageInstructions = new Label();
			this._homeImageInstructions.name = HivivaThemeConstants.HOME_LENS_LABEL;
			this._homeImageInstructions.text = "Go to profile then Homepage Photo to upload or set your home page image \n\nThe clarity of this image will adjust to how well you stay on track with your medication.";
			addChild(this._homeImageInstructions);

			this._messagesButton = new TopNavButton();
			this._messagesButton.hivivaImage = new Image(Main.assets.getTexture("top_nav_icon_02"));
			this._messagesButton.visible = false;
			this._messagesButton.addEventListener(Event.TRIGGERED , messagesButtonHandler);

			this._badgesButton = new TopNavButton();
			this._badgesButton.hivivaImage = new Image(Main.assets.getTexture("top_nav_icon_03"));
			this._badgesButton.visible = false;
			this._badgesButton.addEventListener(Event.TRIGGERED , rewardsButtonHandler);

			this._header.rightItems =  new <DisplayObject>[this._messagesButton, this._badgesButton];


			HivivaStartup.hivivaAppController.hivivaNotificationsController.addEventListener(NotificationsEvent.UPDATE_DAILY_VO_DATA, updateVODataHandler);
		}

		private function messagesButtonHandler(e:Event):void
		{
			this.dispatchEventWith("navGoSettings", false, {screen:HivivaScreens.PATIENT_MESSAGES_SCREEN});
		}

		private function rewardsButtonHandler(e:Event):void
		{
			this.dispatchEventWith("navGoSettings", false, {screen:HivivaScreens.PATIENT_BADGES_SCREEN});
		}



		private function getAllMessagesFromRemoteService():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE, getUserReceivedMessagesHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getUserReceivedMessages();

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE, getPendingConnectionsHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPendingConnections();
		}

		private function getUserReceivedMessagesHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE, getUserReceivedMessagesHandler);

			var messages:uint = e.data.xmlResponse.DCMessageRecord.length();
			if(messages > 0)
			{
				for(var i:uint = 0 ; i < messages ; i++)
				{
					if(e.data.xmlResponse.DCMessageRecord[i].read == "false")
					{
						this._messageCount += 1;
					}
				}
			}

			this._remoteCallCount++;
			allDataLoadedCheck();
		}

		private function getPendingConnectionsHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE, getPendingConnectionsHandler);

			if(e.data.xmlResponse.children().length() > 0)
			{
				this._messageCount += e.data.xmlResponse.DCConnection.length();
			}

			this._remoteCallCount++;
			allDataLoadedCheck();
		}

		private function allDataLoadedCheck():void
		{
			if(this._remoteCallCount == 2)
			{
				this._remoteCallCount = 0;

				if(this._messageCount > 0 )
				{
					this._messagesButton.visible = true;
					this._messagesButton.subScript = String(this._messageCount);
				}
			}
		}

		private function checkForNewBadges():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_BADGE_ALERTS_COMPLETE , getPatientBadgeAlertsCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatientBadgeAlerts();
		}

		private function getPatientBadgeAlertsCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_BADGE_ALERTS_COMPLETE , getPatientBadgeAlertsCompleteHandler);

			trace(e.data.xmlResponse);

			HivivaStartup.userVO.badges = e.data.xmlResponse.DCAlertMessageRecord;
			var badgesAwardedLength:int = HivivaStartup.userVO.badges.length();
			var newBadCount:int = 0;

			if(badgesAwardedLength > 0)
			{
				for (var badgeCount:int = 0; badgeCount < badgesAwardedLength; badgeCount++)
				{
					if(HivivaStartup.userVO.badges[badgeCount].Read == "false")
					{
						newBadCount++;
					}
				}
				if(newBadCount > 0)
				{
					this._badgesButton.visible = true;
					this._badgesButton.subScript = String(newBadCount);
				}
			}
		}

		private function enableAutoHomePageMessageCheck():void
		{
			HivivaStartup.hivivaAppController.hivivaNotificationsController.addEventListener(NotificationsEvent.HOMEPAGE_TICK_COMPLETE, homePageTickHandler);
			HivivaStartup.hivivaAppController.hivivaNotificationsController.enableAutoHomePageMessageCheck();
		}

		private function getGalleryTimeStamp():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE, getGalleryTimeStampHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.getGalleryTimeStamp();
		}

		private function homePageTickHandler(e:NotificationsEvent = null):void
		{
			this._messageCount = 0;
			getAllMessagesFromRemoteService();
		}

		private function getGalleryTimeStampHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE,getGalleryTimeStampHandler);

			var timeStamp:String = e.data.timeStamp,
				date:Date = new Date(),
				serverDate:Date = new Date(HivivaStartup.userVO.serverDate.getFullYear(),HivivaStartup.userVO.serverDate.getMonth(),HivivaStartup.userVO.serverDate.getDate(),0,0,0,0);

			try
			{
				if(timeStamp != null && timeStamp.length > 0)
				{
					date = HivivaModifier.getAS3DatefromString(timeStamp);

					this._dayDiff = HivivaModifier.getDaysDiff(serverDate, date);

					this._adherencePercent = HivivaStartup.patientAdherenceVO.percentage;

					this._homeImageInstructions.visible = false;

					HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);
					HivivaStartup.hivivaAppController.hivivaLocalStoreController.getGalleryImages();


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
			}
		}

		private function getApprovedConnections():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE, getApprovedHCPCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getApprovedConnections();
		}

		private function getApprovedHCPCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE , getApprovedHCPCompleteHandler);

			var xml:XML = e.data.xmlResponse;

			if(xml.children().length() > 0)
			{
				HivivaStartup.connectionsVO.users = [];
				var loop:uint = xml.children().length();
				var approvedHCPList:XMLList  = xml.DCConnection;
				for(var i:uint = 0 ; i <loop ; i++)
				{
					var establishedUser:Object = HivivaModifier.establishToFromId(approvedHCPList[i]);
					var appGuid:String = establishedUser.appGuid;
					var appId:String = establishedUser.appId;
					var userEstablishedConnection:Boolean = approvedHCPList[i].FromAppId == HivivaStartup.userVO.appId;

					var data:XML = new XML
					(
							<patient>
								<name>{appId}</name>
								<email>{appId}@domain.com</email>
								<appid>{appId}</appid>
								<guid>{appGuid}</guid>
								<picture>dummy.png</picture>
								<establishedConnection>{userEstablishedConnection}</establishedConnection>
							</patient>
					);
					HivivaStartup.connectionsVO.users.push(data);
				}
			}
			else
			{
				trace("No Approved Connections");
			}
		}

		private function getGalleryImagesHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);

			var resultDataLength:int, chosenImageUrl:String, chosenImageInd:int, daysToImagesRatio:Number, imageUrls:Array;
			if(e.data.imageUrls != null)
			{
				imageUrls = e.data.imageUrls;
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
				}
				else
				{
					trace("no images available");
					this._homeImageInstructions.visible = true;
				}
			}
			else
			{
				trace("no images available");
				this._homeImageInstructions.visible = true;
			}
		}

		private function doImageLoad(url:String):void
		{


			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			var imageLoader:Loader = new Loader();

			imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoaded);
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadFailed);
			imageLoader.load(new URLRequest(url) , loaderContext);

		}

		private function imageLoaded(e:flash.events.Event):void
		{



			var sourceBm:Bitmap = e.target.content as Bitmap;

			 drawBgHomeImage(sourceBm);

			 drawLensHomeImage(sourceBm);

			//clean up
			sourceBm.bitmapData.dispose();
			sourceBm.bitmapData = null;
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


		private function imageLoadFailed(e:IOErrorEvent):void
		{
			trace("Image load failed.");
		}
/*
		private function imageLoaded(e:flash.events.Event):void
				{
					var imageLoader:LoaderInfo = e.target as LoaderInfo;

					var bm:Bitmap = imageLoader.content as Bitmap;
					bm.scaleX = bm.scaleY = 0.3;
					trace("Image loaded.");

					//this._photo = new Image(getStarlingCompatibleTexture(e.target.content));
					this._photo = new Image(Texture.fromBitmap(bm));
					bm.bitmapData.dispose();
					bm = null;

					this._tint = new Quad(this._photo.width, this._photo.height, 0x0073ff);
					this._tint.alpha = this._isActive ? 1 : 0;

					addChild(this._tint);
					addChild(this._photo);

					dispatchEventWith(Event.COMPLETE, false, {id:this._id});
				}
*/



		private function drawBgHomeImage(sourceBm:Bitmap):void
		{
			var bgHolder:flash.display.Sprite = new flash.display.Sprite();

			var bgBm:Bitmap = new Bitmap(sourceBm.bitmapData.clone(),"auto",true);
			cropToFit(bgBm, Constants.STAGE_WIDTH, this._usableHeight);
			//bgBm.alpha = 0.35;
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
			this._lensImageHolder.addChild(bgImage);

			//clean up
			bgBm.bitmapData.dispose();
			bgBm.bitmapData = null;
			bgBm = null;

			bgMask.graphics.clear();
			bgMask = null;

			bmd.dispose();
			bmd = null;

			bgHolder = null;
		}

		private function drawLensHomeImage(sourceBm:Bitmap):void
		{
			var circleHolder:flash.display.Sprite = new flash.display.Sprite();

			var circleBm:Bitmap = new Bitmap(sourceBm.bitmapData.clone(),"auto",true);
			cropToFit(circleBm, Constants.STAGE_WIDTH, this._usableHeight);
			circleHolder.addChild(circleBm);

			var blurValue:int = 20 - int(0.2 * this._adherencePercent);
			var blurFilter:BitmapFilter = new BlurFilter(blurValue, blurValue, BitmapFilterQuality.HIGH);
			var myFilters:Array = [];
			myFilters.push(blurFilter);
			circleBm.filters = myFilters;

			var circleMask:flash.display.Sprite = new flash.display.Sprite();
			var circleDiameter:Number = IMAGE_SIZE - (LENS_SHADOW_RADIUS * 2);
			circleMask.graphics.beginFill(0x000000);
			circleMask.graphics.drawCircle(circleBm.width * 0.5, circleBm.height * 0.5, circleDiameter * 0.5);
			circleHolder.addChild(circleMask);
			circleBm.mask = circleMask;

			var bmd:BitmapData = new BitmapData(circleHolder.width, circleHolder.height, true,  0x00000000);
			bmd.draw(circleHolder, new Matrix(), null, null, null, true);

 			var bgImage:Image = new Image(Texture.fromBitmapData(bmd));
			bgImage.touchable = false;
			bgImage.x = (Constants.STAGE_WIDTH * 0.5) - (bgImage.width * 0.5);
			bgImage.y = (this._usableHeight * 0.5) + Constants.HEADER_HEIGHT - (bgImage.height * 0.5);
			this._lensImageHolder.addChild(bgImage);

/*		var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
			trace("colorFilter.adjustSaturation = " + (-1 + (this._adherencePercent / 100)));
			colorFilter.adjustSaturation(-1 + (this._adherencePercent / 100));
			this._lensImageHolder.filter = colorFilter;*/

			//clean up
			circleBm.bitmapData.dispose();
			circleBm.bitmapData = null;
			circleBm = null;

			circleMask.graphics.clear();
			circleMask = null;

			bmd.dispose();
			bmd = null;

			circleHolder = null;
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
			closeDownApplicationNotifications();

			this._lensImageHolder.dispose();

			this._lens.dispose();
			this._lens = null;

			super.dispose();
			System.gc();
		}

		private function closeDownApplicationNotifications():void
		{
			HivivaStartup.hivivaAppController.hivivaNotificationsController.disableAutoHomePageMessageCheck();
			HivivaStartup.hivivaAppController.hivivaNotificationsController.removeEventListener(NotificationsEvent.HOMEPAGE_TICK_COMPLETE , homePageTickHandler);

			HivivaStartup.hivivaAppController.hivivaNotificationsController.removeEventListener(NotificationsEvent.UPDATE_DAILY_VO_DATA, updateVODataHandler);
		}
	}
}
