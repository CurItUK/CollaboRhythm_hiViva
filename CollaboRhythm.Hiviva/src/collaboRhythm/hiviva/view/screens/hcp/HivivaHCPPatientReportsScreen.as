package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.Calendar;
	import collaboRhythm.hiviva.view.screens.shared.ReportPreview;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;

	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaHCPPatientReportsScreen extends ValidationScreen
	{
	//	private var _header:HivivaHeader;
		private var _footerHeight:Number;
		private var _startLabel:Label;
		private var _startDateButton:Button;
		private var _finishDateButton:Button;
		private var _startDateInput:LabelAndInput;
		private var _finishDateInput:LabelAndInput;
		private var _backButton:Button;
		private var _finishLabel:Label;
		private var _reportDatesLabel:Label;
		private var _includeLabel:Label;
		private var _adherenceCheck:Check;
		private var _feelingCheck:Check;
		private var _cd4Check:Check;
		private var _viralLoadCheck:Check;
		private var _previewAndSendBtn:Button;
		private var _calendar:Calendar;
		private var _activeCalendarInput:TextInput;
		private var _emailLabel:Label;
		private var _emailInput:TextInput;

		private var _patientLabel:Label;
		private var _selectedPatient:XML;

		private var _pdfFile:File;
		private var _stageWebView:StageWebView
		private var _applicationController:HivivaAppController;
		private var _settingsData:Object;


		private var _pdfPopupContainer:HivivaPDFPopUp;

		public function HivivaHCPPatientReportsScreen()
		{

		}

		override protected function draw():void
		{
			this._customHeight = this.actualHeight - this._footerHeight;
			super.draw();

			this._content.validate();

			// add calendar buttons post validate so scrollable area is correctly calculated
			if(!_content.contains(this._startDateButton))
			{
				addCalendarButtons();
			}
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();
			this._reportDatesLabel.width = this._innerWidth;

			this._startDateInput._labelLeft.text = "Start";
			this._startDateInput.width = this._innerWidth * 0.75;
			this._startDateInput._input.width = this._innerWidth * 0.5;

			this._finishDateInput._labelLeft.text = "Finish";
			this._finishDateInput.width = this._innerWidth * 0.75;
			this._finishDateInput._input.width = this._innerWidth * 0.5;

			this._includeLabel.width = this._innerWidth;

			this._adherenceCheck.defaultLabelProperties.width = this._innerWidth;
			this._feelingCheck.defaultLabelProperties.width = this._innerWidth;
			this._cd4Check.defaultLabelProperties.width = this._innerWidth;
			this._viralLoadCheck.defaultLabelProperties.width = this._innerWidth;

			this._emailLabel.width = this._innerWidth;
			this._emailInput.width = this._innerWidth * 0.75;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();
			/*
			this._patientLabel.width += this._componentGap;
			this._startDateButton.x = this._startDateInput.width + this._componentGap;
			this._startDateButton.y = this._startDateInput.y + this._startDateInput._input.y + (this._startDateInput._input.height * 0.5);
			this._startDateButton.y -= this._startDateButton.height * 0.5;

			this._finishDateInput.y = this._startDateInput.y + this._startDateInput.height + this._componentGap;

			this._finishDateButton.x = this._finishDateInput.width + this._componentGap;
			this._finishDateButton.y = this._finishDateInput.y + this._finishDateInput._input.y + (this._finishDateInput._input.height * 0.5);
			this._finishDateButton.y -= this._finishDateButton.height * 0.5;

			this._includeLabel.y = this._finishDateInput.y + this._finishDateInput.height + this._componentGap;
			this._adherenceCheck.y = this._includeLabel.y + this._includeLabel.height + this._componentGap;
			this._feelingCheck.y = this._adherenceCheck.y + this._adherenceCheck.height + this._componentGap;
			this._cd4Check.y = this._feelingCheck.y + this._feelingCheck.height + this._componentGap;
			this._viralLoadCheck.y = this._cd4Check.y + this._cd4Check.height + this._componentGap;
			this._previewAndSendBtn.y = this._viralLoadCheck.y + this._viralLoadCheck.height + this._componentGap;
			*/
			this._previewAndSendBtn.x = (this.actualWidth * 0.5) - (this._previewAndSendBtn.width * 0.5);
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Generate Reports";

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._patientLabel = new Label();
			this._patientLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._patientLabel.text = "Patient: " + selectedPatient.name;
			this._content.addChild(this._patientLabel);

			this._reportDatesLabel = new Label();
			this._reportDatesLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._reportDatesLabel.text = "Report dates";
			this._content.addChild(this._reportDatesLabel);

			this._startDateInput = new LabelAndInput();
			this._startDateInput.scale = this.dpiScale;
			this._startDateInput.labelStructure = "left";
			this._content.addChild(this._startDateInput);
			this._startDateInput._input.isEnabled = false;

			this._finishDateInput = new LabelAndInput();
			this._finishDateInput.scale = this.dpiScale;
			this._finishDateInput.labelStructure = "left";
			this._content.addChild(this._finishDateInput);
			this._finishDateInput._input.isEnabled = false;

			this._includeLabel = new Label();
			this._includeLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._includeLabel.text = "Include";
			this._content.addChild(this._includeLabel);

			this._adherenceCheck = new Check();
			this._adherenceCheck.isSelected = false;
			this._adherenceCheck.label = "Adherence";
			this._content.addChild(this._adherenceCheck);

			this._feelingCheck = new Check();
			this._feelingCheck.isSelected = false;
			this._feelingCheck.label = "How I am feeling";
			this._content.addChild(this._feelingCheck);

			this._cd4Check = new Check();
			this._cd4Check.isSelected = false;
			this._cd4Check.label = "CD4 count test results";
			this._content.addChild(this._cd4Check);

			this._viralLoadCheck = new Check();
			this._viralLoadCheck.isSelected = false;
			this._viralLoadCheck.label = "Viral load test results";
			this._content.addChild(this._viralLoadCheck);

			this._emailLabel = new Label();
			this._emailLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._emailLabel.text = "Send report to";
			this._content.addChild(this._emailLabel);

			this._emailInput = new TextInput();
			this._content.addChild(this._emailInput);

			this._previewAndSendBtn = new Button();
			this._previewAndSendBtn.label = "Preview and send";
			this._previewAndSendBtn.addEventListener(Event.TRIGGERED, previewSendHandler);
			this._content.addChild(this._previewAndSendBtn);

			this._calendar = new Calendar();
			this._calendar.addEventListener(FeathersScreenEvent.CALENDAR_BUTTON_TRIGGERED, calendarButtonHandler);

			_settingsData = HivivaStartup.reportVO.settingsData;
			if(_settingsData == null)
			{
				populateDefaults();
			}
			else
			{
				prePopulateData();
			}
		}

		private function populateDefaults():void
		{
			this._adherenceCheck.isSelected =
			this._feelingCheck.isSelected =
			this._cd4Check.isSelected =
			this._viralLoadCheck.isSelected = true;
			this._startDateInput._input.text = this._calendar.getMonthBefore();
			this._finishDateInput._input.text = this._calendar.getCurrentDate();
			this._emailInput.text = "";
		}

		private function prePopulateData():void
		{
			this._adherenceCheck.isSelected = _settingsData.adherenceIsChecked;
			this._feelingCheck.isSelected = _settingsData.feelingIsChecked;
			this._cd4Check.isSelected = _settingsData.cd4IsChecked;
			this._viralLoadCheck.isSelected = _settingsData.viralLoadIsChecked;
			this._startDateInput._input.text = _settingsData.startDate;
			this._finishDateInput._input.text = _settingsData.endDate;
			this._emailInput.text = _settingsData.emailAddress;
		}

		private function addCalendarButtons():void
		{
			this._startDateButton = new Button();
			this._startDateButton.addEventListener(Event.TRIGGERED, startDateCalendarHandler);
			this._startDateButton.name = "calendar-button";
			this._content.addChild(this._startDateButton);
			this._startDateButton.validate();
			this._startDateButton.x = this._startDateInput.width + this._componentGap;
			this._startDateButton.y = this._startDateInput.y + this._startDateInput._input.y + (this._startDateInput._input.height * 0.5) - (this._startDateButton.height * 0.5);

			this._finishDateButton = new Button();
			this._finishDateButton.addEventListener(Event.TRIGGERED, finishDateCalendarHandler);
			this._finishDateButton.name = "calendar-button";
			this._content.addChild(this._finishDateButton);
			this._finishDateButton.validate();
			this._finishDateButton.x = this._finishDateInput.width + this._componentGap;
			this._finishDateButton.y = this._finishDateInput.y + this._finishDateInput._input.y + (this._finishDateInput._input.height * 0.5) - (this._finishDateButton.height * 0.5);
		}


		private function calendarButtonHandler(e:FeathersScreenEvent):void
		{
			PopUpManager.removePopUp(this._calendar);
			this._activeCalendarInput.text = e.evtData.date;
		}

		private function startDateCalendarHandler(e:Event):void
		{
			this._activeCalendarInput = this._startDateInput._input;
			PopUpManager.addPopUp(this._calendar,true,false);
			this._calendar.width = this.actualWidth;
			this._calendar.cType = "start";
			this._calendar.validate();
			//PopUpManager.centerPopUp(this._calendar);
		}

		private function finishDateCalendarHandler(e:Event):void
		{
			this._activeCalendarInput = this._finishDateInput._input;
			PopUpManager.addPopUp(this._calendar,true,false);
			this._calendar.width = this.actualWidth;
			this._calendar.cType = "finish";
			this._calendar.validate();
			//PopUpManager.centerPopUp(this._calendar);
		}


		private function backBtnHandler(e:Event):void
		{
			this._owner.showScreen(HivivaScreens.HCP_PATIENT_PROFILE);
		}

		private function previewSendHandler(e:Event):void
		{
			//TODO move PDF creating into UTILS class
			//TODO move fileStream - report PDF file creation to local service class

			var formValidation:String = patientReportsCheck();
			if(formValidation.length == 0)
			{
				HivivaStartup.reportVO.settingsData =
				{
					adherenceIsChecked:this._adherenceCheck.isSelected,
					feelingIsChecked:this._feelingCheck.isSelected,
					cd4IsChecked:this._cd4Check.isSelected,
					viralLoadIsChecked:this._viralLoadCheck.isSelected,
					startDate:this._startDateInput._input.text,
					endDate:this._finishDateInput._input.text,
					patientGuid:selectedPatient.guid,
					patientAppId:selectedPatient.appid,
					emailAddress:this._emailInput.text
				};
				if(this.owner.hasScreen(HivivaScreens.REPORT_PREVIEW))
				{
					this.owner.removeScreen(HivivaScreens.REPORT_PREVIEW);
				}
				this.owner.addScreen(HivivaScreens.REPORT_PREVIEW, new ScreenNavigatorItem(ReportPreview, null, {parentScreen:this.owner.activeScreenID}));
				this.owner.showScreen(HivivaScreens.REPORT_PREVIEW);
			}
			else
			{
				showFormValidation(formValidation);
			}
		}

		private function patientReportsCheck():String
		{
			var validationArray:Array = [];

			if(this._startDateInput._input.text.length == 0) validationArray.push("Please select a start date");
			if(this._finishDateInput._input.text.length == 0) validationArray.push("Please select an end date");

			if(this._startDateInput._input.text.length != 0 && this._finishDateInput._input.text.length != 0)
			{
				var isValidDate:Boolean = validateDates();
				if(!isValidDate)validationArray.push("Invalid date selection - start and end dates");
			}
			if(this._emailInput.text.length == 0) validationArray.push("Please enter a valid email address");

			return validationArray.join("\n");
		}

		private function validateDates():Boolean
		{
			var tempStart:Array = new Array();
			var tempFinish:Array = new Array();

			tempStart = this._startDateInput._input.text.split('/');
			tempFinish = this._finishDateInput._input.text.split('/');

			var startAdd:Number = tempStart[2]*1300 + tempStart[0]*100 + tempStart[1];
			var endAdd:Number = tempFinish[2]*1300 + tempFinish[0]*100 + tempFinish[1];

			if(startAdd > endAdd){
				return false;
			}
			else{
				return true;
			}
		}

		private function displaySavedPDF():void
		{
			this._pdfPopupContainer = new HivivaPDFPopUp();
			this._pdfPopupContainer.scale = this.dpiScale;
			this._pdfPopupContainer.width = this.actualWidth;
			this._pdfPopupContainer.height = this.actualHeight;
			this._pdfPopupContainer.addEventListener("sendMail", mailBtnHandler);
			this._pdfPopupContainer.addEventListener(Event.CLOSE, closePopup);
			this._pdfPopupContainer.validate();

			PopUpManager.addPopUp(this._pdfPopupContainer, true, true);
			this._pdfPopupContainer.validate();


			var padding:Number = 150;
			this._stageWebView = new StageWebView();
			this._stageWebView.stage = Starling.current.nativeStage.stage;
			this._stageWebView.viewPort = new Rectangle(20, 20, Starling.current.nativeStage.stage.stageWidth - 30, Starling.current.nativeStage.stage.stageHeight - padding);
			//var pdf:File = File.applicationStorageDirectory.resolvePath("patient_report.pdf");
			var pdf:File = File.applicationDirectory.resolvePath("resources/patient_report.pdf");
			this._stageWebView.loadURL(pdf.nativePath);

		}

		private function closePopup(e:Event):void
		{
			this._stageWebView.viewPort = null;
			this._stageWebView.dispose();
			this._stageWebView = null;

			PopUpManager.removePopUp(this._pdfPopupContainer);

		}



		private function mailBtnHandler(e:Event):void
		{
			closePopup(e);
			//TODO add mail native extentions for IOS and Android
			//http://diadraw.com/projects/adobe-air-native-e-mail-extension/

			var mailURL:String = "mailto:?subject='My Patient Report'&body='My Patient Report'";
			var urlReq:URLRequest = new URLRequest(mailURL);
			navigateToURL(urlReq);
		}

		public function get selectedPatient():XML
		{
			return this._selectedPatient;
		}

		public function set selectedPatient(patient:XML):void
		{
			this._selectedPatient = patient;
		}


	}
}
