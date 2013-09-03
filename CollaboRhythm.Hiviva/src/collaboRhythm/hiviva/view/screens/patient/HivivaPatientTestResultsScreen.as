package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.components.Calendar;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.controls.TextInput;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.layout.VerticalLayout;
	import feathers.layout.ViewPortBounds;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;

	import flash.filesystem.File;
	import flash.text.TextFormat;

	import source.themes.HivivaTheme;

	import starling.display.DisplayObject;
	import starling.display.Sprite;

	import starling.events.Event;

	public class HivivaPatientTestResultsScreen extends ValidationScreen
	{
		private var _cd4Count:LabelAndInput;
		private var _viralLoad:LabelAndInput;
		private var _date:LabelAndInput;
		private var _dateButton:Button;
		private var _cancelAndSave:BoxedButtons;
		private var _backButton:Button;
		private var _calendar:Calendar;

		public function HivivaPatientTestResultsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._dateButton.x = this._date.x + this._date._labelRight.x;
			this._dateButton.y = this._date.y + this._date._labelRight.y - (this._dateButton.height * 0.5);

			this._content.height = this._cancelAndSave.y - this._content.y - this._componentGap;
			this._content.validate();
			// property here is for show / hide validation
			this._contentHeight = this._content.height;
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();

			this._cd4Count._labelLeft.text = "CD4 Count:";
			this._cd4Count._labelRight.text = "Cells/mm3";
			labelAndInputDrawProperties(this._cd4Count);

			this._viralLoad._labelLeft.text = "Viral load:";
			this._viralLoad._labelRight.text = "Copies/ML";
			labelAndInputDrawProperties(this._viralLoad);

			this._date._labelLeft.textRendererProperties.multiline = true;
			this._date._labelLeft.text = "Date of \nlast test:";
			this._date._labelRight.text = "";
			labelAndInputDrawProperties(this._date);

			this._cancelAndSave.width = this._innerWidth;
			this._cancelAndSave.validate();
			this._cancelAndSave.x = Constants.PADDING_LEFT;
			this._cancelAndSave.y = Constants.STAGE_HEIGHT - Constants.PADDING_BOTTOM - this._cancelAndSave.height;
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Test Results";

			this._cd4Count = new LabelAndInput();
			this._cd4Count.scale = this.dpiScale;
			this._cd4Count.labelStructure = "leftAndRight";
			this._content.addChild(this._cd4Count);

			this._viralLoad = new LabelAndInput();
			this._viralLoad.scale = this.dpiScale;
			this._viralLoad.labelStructure = "leftAndRight";
			this._content.addChild(this._viralLoad);

			this._date = new LabelAndInput();
			this._date.scale = this.dpiScale;
			this._date.labelStructure = "leftAndRight";
			this._content.addChild(this._date);
			this._date._input.isEnabled = false;

			this._calendar = new Calendar();
			this._calendar.addEventListener(FeathersScreenEvent.CALENDAR_BUTTON_TRIGGERED, calendarButtonHandler)

			this._dateButton = new Button();
			this._dateButton.addEventListener(Event.TRIGGERED, dateCalendarHandler);
			this._dateButton.name = HivivaThemeConstants.CALENDAR_BUTTON;
			this._content.addChild(this._dateButton);

			this._cancelAndSave = new BoxedButtons();
			this._cancelAndSave.labels = ["Cancel","Save"];
			this._cancelAndSave.addEventListener(Event.TRIGGERED, cancelAndSaveHandler);
			addChild(this._cancelAndSave);

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			getPatientLatestTestResult();
		}

		private function labelAndInputDrawProperties(landi:LabelAndInput):void
		{
			landi.width = this.actualWidth;
			landi._input.width = this.actualWidth * 0.3;
			landi._input.validate();
			landi._input.x = (this.actualWidth * 0.5) - (landi._input.width / 2);
			landi.validate();
		}

		private function dateCalendarHandler(e:Event):void
		{
			PopUpManager.addPopUp(this._calendar,true,false);
			this._calendar.width = this.actualWidth;
			this._calendar.validate();
		}

		private function calendarButtonHandler(e:FeathersScreenEvent):void
		{
			PopUpManager.removePopUp(this._calendar);
			this._date._input.text = e.evtData.date;
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
					saveTestResults();
					break;
			}
		}

		private function backBtnHandler(e:Event = null):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function saveTestResults():void
		{
			var formValidation:String = patientTestResultsCheck();
			if(formValidation.length == 0)
			{
				var cd4CountData:Number = Number(this._cd4Count._input.text);
				var viralLoadData:Number = Number(this._viralLoad._input.text);

				//TODO add this date format to modifier class
				var pattern:RegExp = /\//g;
				var dateData:String = this._date._input.text;
				var formatedDate:String = dateData.replace(pattern ,"-");
				var ukDate:String = HivivaModifier.toUKDateFromUS(formatedDate) + "T00:00:00";

				var userGuid:String = HivivaStartup.userVO.guid;

				var resultData:XML =
						<DCUserTestResults>
							<UserGuid>{userGuid}</UserGuid>
							<Results>
								<DCTestResult>
									<TestDate>{ukDate}</TestDate>
									<TestDescription>Cd4 count</TestDescription>
									<Result>{cd4CountData}</Result>
								</DCTestResult>
								<DCTestResult>
									<TestDate>{ukDate}</TestDate>
									<TestDescription>Viral load</TestDescription>
									<Result>{viralLoadData}</Result>
								</DCTestResult>
							</Results>
						</DCUserTestResults>;

				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.ADD_TEST_RESULTS_COMPLETE , addTestResultsCompleteHandler);
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addTestResults(resultData);
			}
			else
			{
				showFormValidation(formValidation);
			}
		}

		private function addTestResultsCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.ADD_TEST_RESULTS_COMPLETE , addTestResultsCompleteHandler);
			showFormValidation("Your details have been saved");
		}

		private function patientTestResultsCheck():String
		{
			var validationArray:Array = [];

			if(this._cd4Count._input.text.length == 0 || isNaN(Number(this._cd4Count._input.text))) validationArray.push("Please enter valid CD4 Count data");
//			if(this._cd4._input.text.length == 0 || isNaN(Number(this._cd4._input.text))) validationArray.push("Please enter valid CD4 data");
			if(this._viralLoad._input.text.length == 0 || isNaN(Number(this._viralLoad._input.text))) validationArray.push("Please enter valid Viral load data");
			if(this._date._input.text.length == 0) validationArray.push("Please select a date");

			return validationArray.join("\n");
		}

		private function getPatientLatestTestResult():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_LATEST_RESULTS_COMPLETE, getPatientLatestTestResultsCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatientLastTestResult(escape("Cd4 count,Viral load"));
		}

		private function getPatientLatestTestResultsCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_LATEST_RESULTS_COMPLETE, getPatientLatestTestResultsCompleteHandler);

			var testResults:XMLList = e.data.xmlResponse.Results.DCTestResult;
			/*
			<DCTestResult xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			  <TestDate>2013-01-01T00:00:00</TestDate>
			  <TestDescription>Cd4 count</TestDescription>
			  <Result>234234.00</Result>
			</DCTestResult>
			<DCTestResult xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			  <TestDate>2013-01-01T00:00:00</TestDate>
			  <TestDescription>Viral load</TestDescription>
			  <Result>34234.00</Result>
			</DCTestResult>
			*/

			if(testResults.children().length() > 0)
			{
				this._cd4Count._input.text = String(Math.floor(testResults[0].Result));
				this._viralLoad._input.text = String(Math.floor(testResults[1].Result));
				this._date._input.text = HivivaModifier.toUSDateFromUK(String(testResults[0].TestDate).substring(0,10));
			}
			else
			{
				this._cd4Count._input.text = "";
				this._viralLoad._input.text = "";
				this._date._input.text = "";
			}
		}
	}
}
