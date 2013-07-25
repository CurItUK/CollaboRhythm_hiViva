package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.components.MedicationCell;
	import collaboRhythm.hiviva.view.components.PatientAdherenceTable;
	import collaboRhythm.hiviva.view.media.Assets;
	import collaboRhythm.hiviva.view.screens.hcp.messages.HivivaHCPMessageCompose;
	import collaboRhythm.hiviva.view.screens.hcp.messages.HivivaHCPPatientMessageCompose;

	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientReportsScreen;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.display.Scale9Image;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;

	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import starling.display.BlendMode;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;

	import starling.textures.Texture;


	public class HivivaHCPPatientProfileScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _backButton:Button;

		private var _patientImageBg:Quad;
		private var _photoHolder:Image;
		private var _patientEmail:Label;
		private var _patientProfileData:XML;
		private var _patientHistoryData:XML;
		private var _adherenceLabel:Label;
		private var _tolerabilityLabel:Label;
		private var _reportAndMessage:BoxedButtons;
		private var _weekNavHolder:ScrollContainer;
		private var _weekText:Label;
		private var _currWeekBeginning:Date;
		private var _dataColumnsWidth:Number;
		private var _patientAdherenceTable:PatientAdherenceTable;
		private var _viewLabel:Label;
		private var _leftArrow:Button;
		private var _rightArrow:Button;

		private const IMAGE_SIZE:Number = 125;
		private const PADDING:Number = 32;

		public function HivivaHCPPatientProfileScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = Constants.STAGE_WIDTH;
			this._header.initTrueTitle();

			this._dataColumnsWidth = (this.actualWidth * 0.65) / 8;

			drawPatientProfile();

			drawTableAndNav();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._patientProfileData = Main.selectedHCPPatientProfile;

			var currentDate:Date = HivivaStartup.userVO.serverDate;
			this._currWeekBeginning = new Date(currentDate.fullYear,currentDate.month,currentDate.date,currentDate.hours,currentDate.minutes,currentDate.seconds,currentDate.milliseconds);
			HivivaModifier.floorToClosestMonday(this._currWeekBeginning);

			this._header = new HivivaHeader();
			this._header.title = Main.selectedHCPPatientProfile.name;
			this.addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			initPatientProfile();

			initTableAndNav();
		}

		private function initPatientProfile():void
		{
			this._patientImageBg = new Quad(IMAGE_SIZE * this.dpiScale, IMAGE_SIZE * this.dpiScale, 0x000000);
			this.addChild(this._patientImageBg);

			this._patientEmail = new Label();
			this._patientEmail.text = _patientProfileData.email;
			this.addChild(this._patientEmail);

			this._adherenceLabel = new Label();
			this._adherenceLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._adherenceLabel.text = "Overall adherence:  " + Main.selectedHCPPatientProfile.adherence + "%";
			this.addChild(this._adherenceLabel);

			this._tolerabilityLabel = new Label();
			this._tolerabilityLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._tolerabilityLabel.text = "Overall tolerability:  " + Main.selectedHCPPatientProfile.tolerability + "%";
			this.addChild(this._tolerabilityLabel);

			this._reportAndMessage = new BoxedButtons();
			this._reportAndMessage.addEventListener(starling.events.Event.TRIGGERED, reportAndMessageHandler);
			this._reportAndMessage.scale = this.dpiScale;
			this._reportAndMessage.labels = ["Generate report", "Send message"];
			this.addChild(this._reportAndMessage);
		}

		private function drawPatientProfile():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var gap:Number = scaledPadding * 0.5;
			var innerWidth:Number = Constants.STAGE_WIDTH - (scaledPadding * 2);

			this._patientImageBg.x = scaledPadding;
			this._patientImageBg.y = this._header.height + gap;

			this._patientEmail.width = innerWidth - this._patientEmail.x;
			this._patientEmail.validate();
			this._patientEmail.x = this._patientImageBg.x + this._patientImageBg.width + gap;
			this._patientEmail.y = this._patientImageBg.y;

			this._adherenceLabel.width = innerWidth - this._adherenceLabel.x;
			this._adherenceLabel.validate();
			this._adherenceLabel.x = this._patientEmail.x;
			this._adherenceLabel.y = this._patientImageBg.y + (this._patientImageBg.height * 0.5) - (this._adherenceLabel.height * 0.5);

			this._tolerabilityLabel.width = innerWidth - this._tolerabilityLabel.x;
			this._tolerabilityLabel.validate();
			this._tolerabilityLabel.x = this._patientEmail.x;
			this._tolerabilityLabel.y = this._patientImageBg.y + this._patientImageBg.height - this._tolerabilityLabel.height;

			this._reportAndMessage.width = innerWidth;
			this._reportAndMessage.validate();
			this._reportAndMessage.x = scaledPadding;
			this._reportAndMessage.y = this._patientImageBg.y + this._patientImageBg.height + gap;

			doImageLoad("media/patients/" + _patientProfileData.picture);
		}

		private function initTableAndNav():void
		{
			this._weekNavHolder = new ScrollContainer();
			addChild(this._weekNavHolder);

			_viewLabel = new Label();
			_viewLabel.name = HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL;
			_viewLabel.text = "View:";
			this._weekNavHolder.addChild(_viewLabel);

			_leftArrow = new Button();
			_leftArrow.name = "calendar-arrows";
			_leftArrow.addEventListener(starling.events.Event.TRIGGERED, leftArrowHandler);
			this._weekNavHolder.addChild(_leftArrow);

			_rightArrow = new Button();
			_rightArrow.name = "calendar-arrows";
			_rightArrow.addEventListener(starling.events.Event.TRIGGERED, rightArrowHandler);
			this._weekNavHolder.addChild(_rightArrow);
			this._rightArrow.scaleX = -1;

			this._weekText = new Label();
			this._weekText.touchable = false;
			this._weekText.name = HivivaThemeConstants.BODY_CENTERED_LABEL;
			this._weekText.text = " ";
			this._weekNavHolder.addChild(this._weekText);

			layoutWeekNav();
			this._patientAdherenceTable = new PatientAdherenceTable();
			this.addChild(this._patientAdherenceTable);
		}

		private function layoutWeekNav():void
		{
			this._weekNavHolder.layout = new AnchorLayout();

			_viewLabel.validate();
			_leftArrow.validate();
			_rightArrow.validate();
			_weekText.validate();

			var viewLayoutData:AnchorLayoutData = new AnchorLayoutData();
			viewLayoutData.top = (_leftArrow.height * 0.5) - (_viewLabel.height * 0.5);
			_viewLabel.layoutData = viewLayoutData;

			var leftArrowLayoutData:AnchorLayoutData = new AnchorLayoutData();
			leftArrowLayoutData.left = _viewLabel.x + _viewLabel.width + 20;
			_leftArrow.layoutData = leftArrowLayoutData;

			var rightArrowLayoutData:AnchorLayoutData = new AnchorLayoutData();
			rightArrowLayoutData.right = 0;
			_rightArrow.layoutData = rightArrowLayoutData;

			var weekTextLayoutData:AnchorLayoutData = new AnchorLayoutData();
			weekTextLayoutData.top = (_leftArrow.height * 0.5) - (_weekText.height * 0.5);
			weekTextLayoutData.left = _leftArrow.x + _leftArrow.width + 20;
			weekTextLayoutData.right = _rightArrow.x - 20;
			_weekText.layoutData = weekTextLayoutData;
		}

		private function drawTableAndNav():void
		{
			this._weekNavHolder.x = this.actualWidth * 0.35;
			this._weekNavHolder.y = this._reportAndMessage.y + this._reportAndMessage.height + PADDING;
			this._weekNavHolder.width = this.actualWidth - this._weekNavHolder.x;
			this._weekNavHolder.validate();

			_patientAdherenceTable.y = this._weekNavHolder.y + this._weekNavHolder.height + PADDING;
			_patientAdherenceTable.width = Constants.STAGE_WIDTH;
			_patientAdherenceTable.height = this.actualHeight - _patientAdherenceTable.y;
			_patientAdherenceTable.validate();
			getDailyMedicationHistoryRange();
		}

		private function leftArrowHandler(e:starling.events.Event):void
		{
			this._currWeekBeginning.date -= 7;
			getDailyMedicationHistoryRange();
		}

		private function rightArrowHandler(e:starling.events.Event):void
		{
			this._currWeekBeginning.date += 7;
			getDailyMedicationHistoryRange();
		}

		private function getDailyMedicationHistoryRange():void
		{
			var startIsoDate:String = HivivaModifier.getIsoStringFromDate(this._currWeekBeginning);
			var endDate:Date = new Date(this._currWeekBeginning.getFullYear(),this._currWeekBeginning.getMonth(),this._currWeekBeginning.getDate(),0,0,0,0);
			endDate.date += 7;
			var endIsoDate:String = HivivaModifier.getIsoStringFromDate(endDate);

			// disable week navigation until we receive a response from database
			this._weekNavHolder.touchable = false;

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_DAILY_MEDICATION_HISTORY_RANGE_COMPLETE,getDailyMedicationHistoryRangeCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getDailyMedicationHistoryRange(this._patientProfileData.guid,startIsoDate,endIsoDate);
		}

		private function getDailyMedicationHistoryRangeCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_DAILY_MEDICATION_HISTORY_RANGE_COMPLETE,getDailyMedicationHistoryRangeCompleteHandler);

			this._patientHistoryData = e.data.xmlResponse;

			if (this._patientHistoryData.children().length() > 0)
			{
				if(_patientAdherenceTable.patientData == null)
				{
					_patientAdherenceTable.drawTable();
				}
				_patientAdherenceTable.patientData = this._patientHistoryData;
				_patientAdherenceTable.currWeekBeginning = this._currWeekBeginning;
				_patientAdherenceTable.updateTableData();
				setCurrentWeek();
			}
			else
			{
				// TODO : validation
				trace("no patient history");
			}

			this._weekNavHolder.touchable = true;
		}

		private function setCurrentWeek():void
		{
			this._weekText.text = "wc: " + HivivaModifier.getCalendarStringFromDate(this._currWeekBeginning);
			this._weekText.validate();
		}

		private function backBtnHandler(e:starling.events.Event):void
		{

			if (this.owner.hasScreen(HivivaScreens.HCP_PATIENT_MESSAGE_COMPOSE_SCREEN))
			{
				this.owner.removeScreen(HivivaScreens.HCP_PATIENT_MESSAGE_COMPOSE_SCREEN);
			}

			if (this.owner.hasScreen(HivivaScreens.HCP_PATIENT_PROFILE_REPORT))
			{
				this.owner.removeScreen(HivivaScreens.HCP_PATIENT_PROFILE_REPORT);
			}

			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.SHOW_MAIN_NAV,true));
			this.dispatchEventWith("navGoHome");
		}

		private function reportAndMessageHandler(e:starling.events.Event):void
		{
			var button:String = e.data.button;
			var screenParams:Object = {selectedPatient: _patientProfileData};
			var targetScreen:String;
			var screenNavigatorItem:ScreenNavigatorItem;
			switch(button)
			{
				case "Generate report" :
					targetScreen = HivivaScreens.HCP_PATIENT_PROFILE_REPORT;
					screenNavigatorItem = new ScreenNavigatorItem(HivivaHCPPatientReportsScreen, null, screenParams);
					break;
				case "Send message" :
					targetScreen = HivivaScreens.HCP_PATIENT_MESSAGE_COMPOSE_SCREEN;
					screenNavigatorItem = new ScreenNavigatorItem(HivivaHCPPatientMessageCompose , null , screenParams);
					break;
			}

			if (!this.owner.hasScreen(targetScreen))
			{
				this.owner.addScreen(targetScreen, screenNavigatorItem);
			}
			this.owner.showScreen(targetScreen);
		}

		private function doImageLoad(url:String):void
		{
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoaded);
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadFailed);
			imageLoader.load(new URLRequest(url));
		}

		private function imageLoaded(e:flash.events.Event):void
		{
			trace("Image loaded.");

			var suitableBm:Bitmap = getSuitableBitmap(e.target.content as Bitmap);

			this._photoHolder = new Image(Texture.fromBitmap(suitableBm));
			this._photoHolder.touchable = false;
			constrainToProportion(this._photoHolder, IMAGE_SIZE * this.dpiScale);
			// TODO : Check if if (img.height >= img.width) then position accordingly. right now its only Ypos
			this._photoHolder.x = this._patientImageBg.x;
			this._photoHolder.y = this._patientImageBg.y + (this._patientImageBg.height / 2) -
					(this._photoHolder.height / 2);
			if (!contains(this._photoHolder)) addChild(this._photoHolder);
		}

		private function imageLoadFailed(e:flash.events.Event):void
		{
			trace("Image load failed.");
		}

		private function getSuitableBitmap(sourceBm:Bitmap):Bitmap
		{
			var bm:Bitmap;
			// if source bitmap is larger than starling size limit of 2048x2048 than resize
			if (sourceBm.width >= 2048 || sourceBm.height >= 2048)
			{
				// TODO: may need to remove size adjustment from bm! only adjust the data (needs formula)
				constrainToProportion(sourceBm, 2040);
				// copy source bitmap at adjusted size
				var bmd:BitmapData = new BitmapData(sourceBm.width, sourceBm.height);
				var m:Matrix = new Matrix();
				m.scale(sourceBm.scaleX, sourceBm.scaleY);
				bmd.draw(sourceBm, m, null, null, null, true);
				bm = new Bitmap(bmd, 'auto', true);
			}
			else
			{
				bm = sourceBm;
			}
			return bm;
		}

		private function constrainToProportion(img:Object, size:Number):void
		{
			if (img.height >= img.width)
			{
				img.height = size;
				img.scaleX = img.scaleY;
			}
			else
			{
				img.width = size;
				img.scaleY = img.scaleX;
			}
		}

		override public function dispose():void
		{

			this._patientImageBg.dispose();
			if(this._photoHolder != null)
			{
				this._photoHolder.dispose();
			}


			removeChildren(0, -1, true);
			removeEventListeners();

			this._patientImageBg = null;
			this._photoHolder = null;

			super.dispose();
		}
	}
}
