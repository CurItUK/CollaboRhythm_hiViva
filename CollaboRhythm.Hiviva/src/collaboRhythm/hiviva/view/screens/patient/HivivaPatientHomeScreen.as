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
	import feathers.controls.ScreenNavigatorItem;
	import feathers.core.PopUpManager;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.system.System;

	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;

	public class HivivaPatientHomeScreen extends Screen
	{
		/*[Embed(source="/assets/imagesv2/temp/v2_homePageMask.png")]
		public static const HomePageMaskPng:Class;*/

		private var _header:HivivaHeader;
		private var _messagesButton:TopNavButton;
		private var _badgesButton:TopNavButton;
		private var _homeImageInstructions:Label;
		private var _lensBg:Image;
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
		private var _userMedSchedPopup:HivivaPopUp;
		private var _medicationPopupNeedShowing:Boolean;
		private var _renderTexture:RenderTexture;


		public function HivivaPatientHomeScreen():void
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;

			this._usableHeight = Constants.STAGE_HEIGHT - Constants.FOOTER_BTNGROUP_HEIGHT - Constants.HEADER_HEIGHT;

			this._lensBg.width = IMAGE_SIZE;
			this._lensBg.scaleY = this._lensBg.scaleX;
			this._lensBg.x = (Constants.STAGE_WIDTH * 0.5) - (this._lensBg.width * 0.5);
			this._lensBg.y = (this._usableHeight * 0.5) + Constants.HEADER_HEIGHT - (this._lensBg.height * 0.5);

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
				checkMedicationScheduleExist();
				getApprovedConnections();
				this._asynchronousCallMade = true;
			}
		}

		private function checkMedicationScheduleExist():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatientMedicationList();
		}

		private function getPatientMedicationListComplete(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);

			var medicationData:XML = e.data.xmlResponse;
			_medicationPopupNeedShowing = medicationData.children().length() == 0;
			getGalleryTimeStamp();
		}

		private function showAddMedicationPopup():void
		{
			if (_medicationPopupNeedShowing)
			{
				if (!this.owner.hasScreen(HivivaScreens.PATIENT_EDIT_MEDICATION_SCREEN)) this.owner.addScreen(HivivaScreens.PATIENT_EDIT_MEDICATION_SCREEN,
						new ScreenNavigatorItem(HivivaPatientEditMedsScreen));
				if (!this.owner.hasScreen(HivivaScreens.PATIENT_ADD_MEDICATION_SCREEN)) this.owner.addScreen(HivivaScreens.PATIENT_ADD_MEDICATION_SCREEN,
						new ScreenNavigatorItem(HivivaPatientAddMedsScreen));
				initAddMedicationPopup();
			}
			else
			{
				// remove screen if returning from edit meds screen
				if (this.owner.hasScreen(HivivaScreens.PATIENT_EDIT_MEDICATION_SCREEN)) this.owner.removeScreen(HivivaScreens.PATIENT_EDIT_MEDICATION_SCREEN);
				if (this.owner.hasScreen(HivivaScreens.PATIENT_ADD_MEDICATION_SCREEN)) this.owner.removeScreen(HivivaScreens.PATIENT_ADD_MEDICATION_SCREEN);
			}
		}

		private function initAddMedicationPopup():void
		{
			this._userMedSchedPopup = new HivivaPopUp();
			this._userMedSchedPopup.buttons = ["Enter medicines","Do later"];
			this._userMedSchedPopup.addEventListener(Event.TRIGGERED, userMedSchedPopupHandler);
//			this._userMedSchedPopup.width = Constants.STAGE_WIDTH * 0.75;
			this._userMedSchedPopup.validate();
			this._userMedSchedPopup.message = "You will need to input your daily medicines to begin";

			PopUpManager.addPopUp(this._userMedSchedPopup,true,true);
			this._userMedSchedPopup.validate();
			PopUpManager.centerPopUp(this._userMedSchedPopup);

			this._userMedSchedPopup.drawCloseButton();
		}

		private function userMedSchedPopupHandler(e:Event):void
		{
			var btn:String = e.data.button as String;
			switch(btn)
			{
				case "Enter medicines" :
					this.owner.showScreen(HivivaScreens.PATIENT_EDIT_MEDICATION_SCREEN);
				case "Do later" :
				case "Close" :
					PopUpManager.removePopUp(this._userMedSchedPopup);
			}
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

			this._lensBg = new Image(Main.assets.getTexture("v2_home_lens_bg"));
			addChild(this._lensBg);

			this._lensImageHolder = new Sprite();
			addChild(this._lensImageHolder);

			this._homeImageInstructions = new Label();
			this._homeImageInstructions.name = HivivaThemeConstants.HOME_LENS_LABEL;
			this._homeImageInstructions.text = "Go to profile then Homepage Photo to upload or set your home page image \n\nThe clarity of this image will adjust to how well you stay on track with your medication.";
			addChild(this._homeImageInstructions);

			this._lens = new Image(Main.assets.getTexture("home_lens"));
			addChild(this._lens);

			this._messagesButton = new TopNavButton();
//			this._messagesButton.hivivaImage = new Image(Main.assets.getTexture("top_nav_icon_02"));
			this._messagesButton.hivivaImage = new Image(Main.assets.getTexture("v2_top_nav_icon_02"));
			this._messagesButton.visible = false;
			this._messagesButton.addEventListener(Event.TRIGGERED , messagesButtonHandler);

			this._badgesButton = new TopNavButton();
//			this._badgesButton.hivivaImage = new Image(Main.assets.getTexture("top_nav_icon_03"));
			this._badgesButton.hivivaImage = new Image(Main.assets.getTexture("v2_top_nav_icon_03"));
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
					this._lensBg.visible = false;

					HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);
					HivivaStartup.hivivaAppController.hivivaLocalStoreController.getGalleryImages();


				}
				else
				{
					this._homeImageInstructions.visible = true;
					this._lensBg.visible = true;
					showAddMedicationPopup();
				}
				trace("gallery_submission_timestamp = " + timeStamp);
			}
			catch(e:Error)
			{
				trace("date stamp not there");
				this._homeImageInstructions.visible = true;
				this._lensBg.visible = true;
				showAddMedicationPopup();
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
					this._lensBg.visible = true;
					showAddMedicationPopup();
				}
			}
			else
			{
				trace("no images available");
				this._homeImageInstructions.visible = true;
				this._lensBg.visible = true;
				showAddMedicationPopup();
			}
		}

		private function doImageLoad(url:String):void
		{
			initHomeScreenPreloader();
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			var imageLoader:Loader = new Loader();

			//imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoaded);
			imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, galleryImageLoadCompleteHandler);
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadFailed);
			imageLoader.load(new URLRequest(url) , loaderContext);
		}

		private function galleryImageLoadCompleteHandler(e:flash.events.Event):void
		{
			var maskHoleDimensions:Number = 572;

			var blurValue:int = 20 - int(0.2 * this._adherencePercent);
			var sourceBm:Bitmap = e.target.content as Bitmap;
			var canvasTexture:Texture = Texture.fromBitmap(sourceBm , false , false);
			var canvas:Image = new Image(canvasTexture);

			if (canvas.height >= canvas.width)
			{
				// + 40 for maximum blur
				canvas.width = maskHoleDimensions + 40;
				canvas.scaleY = canvas.scaleX;
				// center the y pos because height is bigger
				canvas.y = (maskHoleDimensions / 2) - (canvas.height / 2);
			}
			else
			{
				// + 40 for maximum blur
				canvas.height = maskHoleDimensions + 40;
				canvas.scaleX = canvas.scaleY;
				// center the x pos because width is bigger
				canvas.x = (maskHoleDimensions / 2) - (canvas.width / 2);
			}

			canvas.filter = new BlurFilter(blurValue, blurValue);
			canvas.blendMode = BlendMode.NORMAL;

			PopUpManager.addPopUp(canvas, false, false);
			var canvasBlurredTexture:Texture = Texture.fromBitmapData(HivivaModifier.copyStageAsBitmapData(), false);
			var canvasBlurred:Image = new Image(canvasBlurredTexture);
			PopUpManager.removePopUp(canvas);

			// clip away bg
			// targetSize / currentImageSize
			var viewport:Rectangle = Starling.current.viewPort;
			var right:Number = maskHoleDimensions / viewport.width;
			var bottom:Number = maskHoleDimensions / viewport.height;
			canvasBlurred.setTexCoords(0, new Point(0, 0));
			canvasBlurred.setTexCoords(1, new Point(right, 0));
			canvasBlurred.setTexCoords(2, new Point(0, bottom));
			canvasBlurred.setTexCoords(3, new Point(right, bottom));
			canvasBlurred.width = canvasBlurred.height = maskHoleDimensions;

			canvasBlurred.blendMode = BlendMode.NORMAL;
			canvasBlurred.x = (Constants.STAGE_WIDTH / 2) - (canvasBlurred.width / 2);
			canvasBlurred.y = (this._usableHeight / 2) - (canvasBlurred.height / 2);

			var homeLensMaskImage:Image = new Image(Main.assets.getTexture("v2_homePageMask"));
			homeLensMaskImage.width = Constants.STAGE_WIDTH;
			homeLensMaskImage.scaleY = homeLensMaskImage.scaleX;
			homeLensMaskImage.blendMode = BlendMode.ERASE;

			this._renderTexture = new RenderTexture(Constants.STAGE_WIDTH, this._usableHeight);
			this._renderTexture.drawBundled
			(
					function():void
					{
						_renderTexture.draw(canvasBlurred);
						_renderTexture.draw(homeLensMaskImage);
					}
			);

			var galleryImage:Image = new Image(this._renderTexture);
			galleryImage.addEventListener(Event.ADDED_TO_STAGE, removePreloder);

			this._lensImageHolder.addChild(galleryImage);
			this._lensImageHolder.y =(this._usableHeight * 0.5) + Constants.HEADER_HEIGHT - (this._lensImageHolder.height * 0.5);
			this._lensImageHolder.flatten();
		}

		private function initHomeScreenPreloader():void
		{
			this._preloader = new PreloaderSpinner();
			this.addChild(this._preloader) ;
			this._preloader.y = this._header.height + 30;
			this._preloader.x = this.actualWidth - this._preloader.width - 30;
		}

		private function removePreloder(event:Event):void
		{
			this._preloader.disposePreloader();
			this.removeChild(this._preloader);

			showAddMedicationPopup();
		}


		private function imageLoadFailed(e:IOErrorEvent):void
		{
			trace("Image load failed.");
			showAddMedicationPopup();
		}

		override public function dispose():void
		{
			trace("HivivaPatientHomeScreenScreen dispose" );
			closeDownApplicationNotifications();

			this._lensImageHolder.dispose();
			this._lensBg.dispose();
			this._lensBg = null;
			this._lens.dispose();
			this._lens = null;

			if(this._renderTexture != null)
			{
				this._renderTexture.dispose();
				this._renderTexture = null;
			}

			super.dispose();
			System.gc();
		}

		private function closeDownApplicationNotifications():void
		{
			HivivaStartup.hivivaAppController.hivivaNotificationsController.disableAutoHomePageMessageCheck();
			HivivaStartup.hivivaAppController.hivivaNotificationsController.removeEventListener(NotificationsEvent.HOMEPAGE_TICK_COMPLETE , homePageTickHandler);
			HivivaStartup.hivivaAppController.hivivaNotificationsController.removeEventListener(NotificationsEvent.UPDATE_DAILY_VO_DATA, updateVODataHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_BADGE_ALERTS_COMPLETE , getPatientBadgeAlertsCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE , getApprovedHCPCompleteHandler);

		}
	}
}
