package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;
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

	import flash.text.SoftKeyboardType;

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
		private var _emailLabel:Label;
		private var _emailInput:TextInput;
		private var _previewAndSendBtn:Button;
		private var _calendar:Calendar;
		private var _activeCalendarInput:TextInput;
		private var _calendarActive:Boolean;
		private var _settingsData:Object;

		public function HivivaPatientReportsScreen()
		{

		}

		override protected function draw():void
		{
			this._customHeight = this.actualHeight - Constants.FOOTER_BTNGROUP_HEIGHT;
			super.draw();

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
			this._previewAndSendBtn.x = (this._innerWidth * 0.5) - (this._previewAndSendBtn.width * 0.5);
		}

		override protected function initialize():void
		{
			super.initialize();
			this._calendarActive = false;
			this._header.title = "Generate Reports";

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
			this._adherenceCheck.label = "Adherence";
			this._content.addChild(this._adherenceCheck);

			this._feelingCheck = new Check();
			this._feelingCheck.label = "How I am feeling";
			this._content.addChild(this._feelingCheck);

			this._cd4Check = new Check();
			this._cd4Check.label = "CD4 count test results";
			this._content.addChild(this._cd4Check);

			this._viralLoadCheck = new Check();
			this._viralLoadCheck.label = "Viral load test results";
			this._content.addChild(this._viralLoadCheck);

			this._emailLabel = new Label();
			this._emailLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._emailLabel.text = "Send report to";
			this._content.addChild(this._emailLabel);

			this._emailInput = new TextInput();
			this._emailInput.textEditorProperties.softKeyboardType = SoftKeyboardType.EMAIL;
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
			this._startDateButton.name = HivivaThemeConstants.CALENDAR_BUTTON;
			this._content.addChild(this._startDateButton);
			this._startDateButton.validate();
			this._startDateButton.x = this._startDateInput.width + this._componentGap;
			this._startDateButton.y = this._startDateInput.y + this._startDateInput._input.y + (this._startDateInput._input.height * 0.5) - (this._startDateButton.height * 0.5);

			this._finishDateButton = new Button();
			this._finishDateButton.addEventListener(Event.TRIGGERED, finishDateCalendarHandler);
			this._finishDateButton.name = HivivaThemeConstants.CALENDAR_BUTTON;
			this._content.addChild(this._finishDateButton);
			this._finishDateButton.validate();
			this._finishDateButton.x = this._finishDateInput.width + this._componentGap;
			this._finishDateButton.y = this._finishDateInput.y + this._finishDateInput._input.y + (this._finishDateInput._input.height * 0.5) - (this._finishDateButton.height * 0.5);
		}


		private function calendarButtonHandler(e:FeathersScreenEvent):void
		{
			PopUpManager.removePopUp(this._calendar);

			if(e.evtData.date != "" )
			this._activeCalendarInput.text = e.evtData.date;
			trace("Active Date is  ::: " + e.evtData.date )

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
			this._calendar.x =    this.width/2  -  this._calendar.width/2 // + 10
		    trace(this , "width and height  ::: " ,  this.width , this._calendar.width );

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

		}

		private function previewSendHandler(e:Event):void
		{
			// TODO : validate medications and schedule when we have data from remote database

			var formValidation:String = patientReportsCheck();
			if (formValidation.length == 0)
			{
				HivivaStartup.reportVO.settingsData =
				{
					adherenceIsChecked:this._adherenceCheck.isSelected,
					feelingIsChecked:this._feelingCheck.isSelected,
					cd4IsChecked:this._cd4Check.isSelected,
					viralLoadIsChecked:this._viralLoadCheck.isSelected,
					startDate:this._startDateInput._input.text,
					endDate:this._finishDateInput._input.text,
					patientGuid:HivivaStartup.userVO.guid,
					patientAppId:HivivaStartup.userVO.appId,
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
				if(!isStartDateSmallerThanEndDate()) validationArray.push("Please select an end date that is\nlater than the start date");
				if(!isDateRangeSmallerThanSixMonths()) validationArray.push("Please select an end date that is\nwithin 6 months of the start date");
			}
			if(this._emailInput.text.length == 0) validationArray.push("Please enter a valid email address");

			return validationArray.join(",\n");
		}

		private function isStartDateSmallerThanEndDate():Boolean
		{
			var startDate:Date = HivivaModifier.getDateFromCalendarString(this._startDateInput._input.text);
			var endDate:Date = HivivaModifier.getDateFromCalendarString(this._finishDateInput._input.text);
			return (startDate.getTime() < endDate.getTime());
		}

		private function isDateRangeSmallerThanSixMonths():Boolean
		{
			var startDate:Date = HivivaModifier.getDateFromCalendarString(this._startDateInput._input.text);
			var endDate:Date = HivivaModifier.getDateFromCalendarString(this._finishDateInput._input.text);
			endDate.month -= 6;
			return startDate > endDate;
		}

		public override function dispose():void
		{
			trace("HivivaPatientReportsScreen dispose");
			super.dispose();
		}

	}
}
