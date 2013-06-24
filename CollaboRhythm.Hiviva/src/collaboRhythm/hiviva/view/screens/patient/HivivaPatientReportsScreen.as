package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.Calendar;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.events.FeathersEventType;

	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;

	import mx.collections.ArrayCollection;

	import org.alivepdf.colors.RGBColor;

	import org.alivepdf.data.Grid;

	import org.alivepdf.data.GridColumn;
	import org.alivepdf.drawing.Joint;

	import org.alivepdf.fonts.CoreFont;

	import org.alivepdf.fonts.FontFamily;

	import org.alivepdf.fonts.IFont;
	import org.alivepdf.layout.Align;

	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Method;

	import starling.core.Starling;
	import starling.events.Event;


	public class HivivaPatientReportsScreen extends ValidationScreen
	{

		private var _startDateInput:LabelAndInput;
		private var _startDateButton:Button;
		private var _finishDateInput:LabelAndInput;
		private var _finishDateButton:Button;
		private var _reportDatesLabel:Label;
		private var _includeLabel:Label;
		private var _adherenceCheck:Check;
		private var _feelingCheck:Check;
		private var _cd4Check:Check;
		private var _viralLoadCheck:Check;
		private var _previewAndSendBtn:Button;
		private var _calendar:Calendar;
		private var _activeCalendarInput:TextInput;

		private var _pdfFile:File;
		private var _stageWebView:StageWebView;
		private var _calendarActive:Boolean;




		private var _pdfPopupContainer:HivivaPDFPopUp;

		public function HivivaPatientReportsScreen()
		{

		}

		override protected function draw():void
		{
			this._customHeight = this.actualHeight - Constants.FOOTER_BTNGROUP_HEIGHT;
			super.draw();
			this._content.validate();
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

			this._adherenceCheck.defaultLabelProperties.width = this._innerWidth * 0.9;
			this._feelingCheck.defaultLabelProperties.width = this._innerWidth * 0.9;
			this._cd4Check.defaultLabelProperties.width = this._innerWidth * 0.9;
			this._viralLoadCheck.defaultLabelProperties.width = this._innerWidth * 0.9;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();

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
		}

		override protected function initialize():void
		{
			super.initialize();
			this._calendarActive = false;
			this._header.title = "Generate Reports";

			this._reportDatesLabel = new Label();
			this._reportDatesLabel.text = "<font face='ExoBold'>Report dates</font>";
			this._content.addChild(this._reportDatesLabel);

			this._startDateInput = new LabelAndInput();
			this._startDateInput.scale = this.dpiScale;
			this._startDateInput.labelStructure = "left";
			this._content.addChild(this._startDateInput);
			this._startDateInput._input.isEnabled = false;

			this._startDateButton = new Button();
			this._startDateButton.addEventListener(Event.TRIGGERED, startDateCalendarHandler);
			this._startDateButton.name = "calendar-button";
			this._content.addChild(this._startDateButton);

			this._finishDateInput = new LabelAndInput();
			this._finishDateInput.scale = this.dpiScale;
			this._finishDateInput.labelStructure = "left";
			this._content.addChild(this._finishDateInput);
			this._finishDateInput._input.isEnabled = false;

			this._finishDateButton = new Button();
			this._finishDateButton.addEventListener(Event.TRIGGERED, finishDateCalendarHandler);
			this._finishDateButton.name = "calendar-button";
			this._content.addChild(this._finishDateButton);

			this._includeLabel = new Label();
			this._includeLabel.text = "<font face='ExoBold'>Include</font>";
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

			this._previewAndSendBtn = new Button();
			this._previewAndSendBtn.label = "Preview and send";
			this._previewAndSendBtn.addEventListener(starling.events.Event.TRIGGERED, previewSendHandler);
			this._content.addChild(this._previewAndSendBtn);

			this._calendar = new Calendar();
			this._calendar.addEventListener(FeathersScreenEvent.CALENDAR_BUTTON_TRIGGERED, calendarButtonHandler)
		}

		private function calendarButtonHandler(e:FeathersScreenEvent):void
		{
			PopUpManager.removePopUp(this._calendar);
			this._activeCalendarInput.text = e.evtData.date;
		}

		private function startDateCalendarHandler(e:Event):void
		{

			this._activeCalendarInput = this._startDateInput._input;
			this._calendar.cType = "start";

			PopUpManager.addPopUp(this._calendar,true,false);
			this._calendar.width = this.actualWidth;
			this._calendar.validate();

			if(this._calendarActive) this._calendar.resetCalendar();

			this._calendarActive = true;
			//PopUpManager.centerPopUp(this._calendar);
		}

		private function finishDateCalendarHandler(e:Event):void
		{
			this._activeCalendarInput = this._finishDateInput._input;
			this._calendar.cType = "finish";

			PopUpManager.addPopUp(this._calendar,true,false);
			this._calendar.width = this.actualWidth;
			this._calendar.validate();

			if(this._calendarActive) this._calendar.resetCalendar();

			this._calendarActive = true;
			//PopUpManager.centerPopUp(this._calendar);
		}

		private function previewSendHandler(e:starling.events.Event):void
		{
			var formValidation:String = patientReportsCheck();
			if (formValidation.length == 0)
			{
				localStoreController.addEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE, adherenceLoadCompleteHandler);
				localStoreController.getAdherence();
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

			return validationArray.join("<br/>");
		}

		private function adherenceLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE, adherenceLoadCompleteHandler);
			if(this._cd4Check.isSelected || this._viralLoadCheck.isSelected)
			{
				getTestResults();
			}
			else
			{
				generatePDFReport();
			}
		}

		private function getTestResults():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.TEST_RESULTS_LOAD_COMPLETE, testResultsLoadCompleteHandler);
			localStoreController.getTestResults();
		}

		private function testResultsLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.TEST_RESULTS_LOAD_COMPLETE, testResultsLoadCompleteHandler);
			generatePDFReport();

		}

		private function generatePDFReport():void
		{
			var pdf:PDF = new PDF(Orientation.PORTRAIT, Unit.MM, Size.A4);
			var helveticaNomal:IFont = new CoreFont ( FontFamily.HELVETICA );
			var helveticaBold:IFont = new CoreFont ( FontFamily.HELVETICA_BOLD );

			var date:Date = new Date();

			pdf.addPage();

			//Title
			pdf.setFont(helveticaBold , 14);
			pdf.writeText(12, "Patient: ");
			pdf.setFont(helveticaNomal , 12);
			pdf.writeText(12, "Patient Name / AppID\n");


			//Date
			pdf.setFont(helveticaBold , 14);
			pdf.writeText(12, "Date: ");
			pdf.setFont(helveticaNomal , 12);
			pdf.writeText(12, date.getMonth() + "/" + date.getDay() + "/" + date.getFullYear() + "\n");

			//Subject
			pdf.setFont(helveticaBold , 14);
			pdf.writeText(12, "Subject: ");
			pdf.setFont(helveticaNomal , 12);
			pdf.writeText(12, "Please find below details of ... record of their HIV tracking via the HiVIVA application. This covers the time period between: "
					+ this._startDateInput._input.text + " - "
					+ this._finishDateInput._input.text + "\n");


			//Test Results

			var dp:ArrayCollection = new ArrayCollection ();
			dp.addItem( { date : "15/06/2013", cd4 : "350", viralLoad : "<50,000" } );



			var gridColumnDate:GridColumn = new GridColumn("Date", "date", 20, Align.LEFT, Align.LEFT);
			var gridColumnCd4:GridColumn = new GridColumn("CD4 count (cells/mm3)", "cd4", 20, Align.LEFT, Align.LEFT);
			var gridColumnViralLoad:GridColumn = new GridColumn("Viral Load (copies/ml)", "viralLoad", 20, Align.LEFT, Align.LEFT);


			var columns:Array = new Array ( gridColumnDate , gridColumnCd4 , gridColumnViralLoad);

			var grid:Grid = new Grid ( dp.toArray(), 200, 100, new RGBColor (0x00CCFF), new RGBColor (0xFFFFFF), new RGBColor ( 0x0 ) , new RGBColor ( 0x0 ) , 1);

			grid.columns = columns;

			pdf.setFont(helveticaNomal , 12);
			pdf.textStyle(new RGBColor ( 0x0 ),1);

			pdf.addGrid(grid);


			var fileStream:FileStream = new FileStream();

			this._pdfFile = File.applicationStorageDirectory.resolvePath("patient_report.pdf");

			fileStream.open(this._pdfFile, FileMode.WRITE);
			var bytes:ByteArray = pdf.save(Method.LOCAL);
			fileStream.writeBytes(bytes);
			fileStream.close();
			displaySavedPDF();

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
			var pdf:File = File.applicationStorageDirectory.resolvePath("patient_report.pdf");

			this._stageWebView.loadURL(pdf.nativePath);

		}

		private function closePopup(e:Event):void
		{

			this._stageWebView.viewPort = null;
			this._stageWebView.dispose();
			this._stageWebView = null;

			PopUpManager.removePopUp(this._pdfPopupContainer);

		}



		private function mailBtnHandler(e:starling.events.Event):void
		{
			closePopup(e);
			//TODO add mail native extentions for IOS and Android
			//http://diadraw.com/projects/adobe-air-native-e-mail-extension/

			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;

			trace(iOS);



			//var mailURL:String = "mailto:?subject='My Patient Report'&body='My Patient Report'";
			//var urlReq:URLRequest = new URLRequest(mailURL);
			//navigateToURL(urlReq);


		}

		public override function dispose():void
		{
			trace("HivivaPatientReportsScreen dispose");
			super.dispose();
		}


	}
}
