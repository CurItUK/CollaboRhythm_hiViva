package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.MedicationCell;
	import collaboRhythm.hiviva.view.media.Assets;
	import collaboRhythm.hiviva.view.screens.hcp.messages.HivivaHCPPatientMessageCompose;

	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientReportsScreen;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.display.Scale9Image;
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

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;

	import starling.textures.Texture;


	public class HivivaHCPPatientProfileScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _backButton:Button;


		private var _bg:Scale9Image;
		private var _patientImageBg:Quad;
		private var _photoHolder:Image;
		private var _spoofData:Image;
		private var _patientEmail:Label;
		private var _patientData:XML;
		private var _adherenceLabel:Label;
		private var _tolerabilityLabel:Label;
		private var _generateReportBtn:Button;
		private var _sendMessageBtn:Button;


		private const IMAGE_SIZE:Number = 100;
		private const PADDING:Number = 32;

		public function HivivaHCPPatientProfileScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			initPatientXMLData();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = Main.selectedHCPPatientProfile.name;
			this.addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}

		private function initPatientXMLData():void
		{
			var patientToLoadURL:String = "/resources/patient_" +  Main.selectedHCPPatientProfile.appID + ".xml";
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE , patientXMLFileLoadHandler);
			loader.load(new URLRequest(patientToLoadURL));
		}

		private function patientXMLFileLoadHandler(e:flash.events.Event):void
		{
			_patientData = XML(e.target.data);
			drawPatientProfile();

		}

		private function drawPatientProfile():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var gap:Number = scaledPadding * 0.5;
			var fullHeight:Number;

			var bgTexture:Scale9Textures = new Scale9Textures(Main.assets.getTexture("input_field"), new Rectangle(11, 11, 32, 32));
			this._bg = new Scale9Image(bgTexture, this.dpiScale);
			this.addChild(this._bg);

			this._patientImageBg = new Quad(IMAGE_SIZE * this.dpiScale, IMAGE_SIZE * this.dpiScale, 0x000000);
			this._patientImageBg.touchable = false;
			this.addChild(this._patientImageBg);

			this._bg.x = scaledPadding;
			this._bg.y = this._header.height + scaledPadding;
			this._bg.width = this.actualWidth - (scaledPadding * 2);


			this._patientImageBg.x = this._bg.x + gap;
			this._patientImageBg.y = this._bg.y + gap;

			this._patientEmail = new Label();
			this._patientEmail.text = _patientData.email;
			this.addChild(this._patientEmail);
			this._patientEmail.validate();

			this._patientEmail.x = this._patientImageBg.x + this._patientImageBg.width + gap;
			this._patientEmail.y = this._patientImageBg.y;
			this._patientEmail.width = this._bg.width - this._patientEmail.x;

			var avgAdherence:Number = HivivaModifier.calculateOverallAdherence(_patientData.medicationHistory.history);
			this._adherenceLabel = new Label();
			this._adherenceLabel.text = "<font face='ExoBold'>Overall adherence:</font>  " + String(avgAdherence) + "%";
			this.addChild(this._adherenceLabel);
			this._adherenceLabel.validate();

			this._adherenceLabel.x = this._patientEmail.x;
			this._adherenceLabel.y = this._patientEmail.y + this._adherenceLabel.height + gap;
			this._adherenceLabel.width = this._bg.width - this._adherenceLabel.x;

			var avgTolerability:Number = HivivaModifier.calculateOverallTolerability(_patientData.medicationHistory.history);
			this._tolerabilityLabel = new Label();
			this._tolerabilityLabel.text = "<font face='ExoBold'>Overall tolerability:</font>  " + String(avgTolerability) + "%";
			this.addChild(this._tolerabilityLabel);
			this._tolerabilityLabel.validate();

			this._tolerabilityLabel.x = this._patientEmail.x;
			this._tolerabilityLabel.y = this._adherenceLabel.y + this._adherenceLabel.height + gap;
			this._tolerabilityLabel.width = this._bg.width - this._tolerabilityLabel.x;

			this._sendMessageBtn = new Button();
			this._sendMessageBtn.label = "Send message";
			this._sendMessageBtn.addEventListener(starling.events.Event.TRIGGERED, sendMessageBtnHandler);
			this.addChild(this._sendMessageBtn);

			this._sendMessageBtn.validate();
			this._sendMessageBtn.x = this.actualWidth/2 - this._sendMessageBtn.width - gap/2;
			this._sendMessageBtn.y = _tolerabilityLabel.y + _tolerabilityLabel.height + 2 * gap;

			this._generateReportBtn = new Button();
			this._generateReportBtn.label = "Generate report";
			this._generateReportBtn.addEventListener(starling.events.Event.TRIGGERED, generateReportsBtnHandler);
			this.addChild(this._generateReportBtn);

			this._generateReportBtn.validate();
			this._generateReportBtn.x = this._sendMessageBtn.x + this._sendMessageBtn.width + gap;
			this._generateReportBtn.y = this._sendMessageBtn.y;

			var sendMessageBtnY:Number = this._sendMessageBtn.y - (this._header.height + scaledPadding);
			var bgFinalHeight:Number =  sendMessageBtnY + this._sendMessageBtn.height + gap;
			this._bg.height = bgFinalHeight;
/*

			this._spoofData = new Image(Assets.getTexture(HivivaAssets.SPOOF_DATA));
			this._spoofData.y = this._generateReportBtn.y + this._generateReportBtn.height + gap;
			this.addChild(_spoofData);
*/

			drawPatientTable();

			doImageLoad("media/patients/" + _patientData.picture);

		}

		private function drawPatientTable():void
		{
			var verticalScrollContainer:ScrollContainer = new ScrollContainer();
			verticalScrollContainer.layout = new VerticalLayout();
			addChild(verticalScrollContainer);

			var medications:XMLList = _patientData.medications.medication as XMLList;
			var medicationCount:uint = medications.length();
			var medicationCell:MedicationCell;
			for (var i:int = 0; i < medicationCount; i++)
			{
				medicationCell = new MedicationCell();
				medicationCell.scale = this.dpiScale;
				medicationCell.brandName = medications[i].brandname;
				medicationCell.genericName = medications[i].genericname;

			}

/*
			var history:XMLList = _patientData.medicationHistory.history as XMLList;
			var historyCount:int = history.length();
			var medications:XMLList;
			var medicationCount:uint;
			for (var i:int = 0; i < historyCount; i++)
			{
				trace(history[i].date);
				trace(history[i].tolerability);
				medications = history[i].medication;
				medicationCount = medications.length();
				for (var j:int = 0; j < medicationCount; j++)
				{

					trace(medications[j].brandname);
					trace(medications[j].genericname);
					trace(medications[j].adhered);
				}
			}*/

		}

		private function backBtnHandler(e:starling.events.Event):void
		{
			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.SHOW_MAIN_NAV,true));
			this.dispatchEventWith("navGoHome");
		}

		private function sendMessageBtnHandler(e:starling.events.Event):void
		{
			//this.owner.showScreen(HivivaScreens.HCP_MESSAGE_COMPOSE_SCREEN);

			var selectedPatient:XML = _patientData;
			var screenParams:Object = {selectedPatient: selectedPatient};
			var screenNavigatorItem:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaHCPPatientMessageCompose , null , screenParams);

			if (this.owner.getScreenIDs().indexOf(HivivaScreens.HCP_PATIENT_MESSAGE_COMPOSE_SCREEN) == -1)
			{
				this.owner.addScreen(HivivaScreens.HCP_PATIENT_MESSAGE_COMPOSE_SCREEN, screenNavigatorItem);
			}
			else
			{
				this.owner.removeScreen(HivivaScreens.HCP_PATIENT_MESSAGE_COMPOSE_SCREEN);
				this.owner.addScreen(HivivaScreens.HCP_PATIENT_MESSAGE_COMPOSE_SCREEN, screenNavigatorItem);
			}
			this.owner.showScreen(HivivaScreens.HCP_PATIENT_MESSAGE_COMPOSE_SCREEN);
		}

		private function generateReportsBtnHandler(e:starling.events.Event):void
		{

			var selectedPatient:XML = _patientData;
			var screenParams:Object = {selectedPatient: selectedPatient};
			var screenNavigatorItem:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaHCPPatientReportsScreen, null, screenParams);

			if (this.owner.getScreenIDs().indexOf(HivivaScreens.HCP_PATIENT_PROFILE_REPORT) == -1)
			{
				this.owner.addScreen(HivivaScreens.HCP_PATIENT_PROFILE_REPORT, screenNavigatorItem);
			}
			else
			{
				this.owner.removeScreen(HivivaScreens.HCP_PATIENT_PROFILE_REPORT);
				this.owner.addScreen(HivivaScreens.HCP_PATIENT_PROFILE_REPORT, screenNavigatorItem);
			}
			this.owner.showScreen(HivivaScreens.HCP_PATIENT_PROFILE_REPORT);
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

		public function set patientData(value:XML):void
		{
			this._patientData = value;
		}

		public function get patientData():XML
		{
			return this._patientData;
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
