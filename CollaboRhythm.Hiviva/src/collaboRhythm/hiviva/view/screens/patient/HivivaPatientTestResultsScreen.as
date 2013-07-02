package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.global.HivivaScreens;
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
//		private var _cd4:LabelAndInput;
		private var _viralLoad:LabelAndInput;
		private var _date:LabelAndInput;
		private var _dateButton:Button;
		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _backButton:Button;
		private var _sqConn:SQLConnection;
		private var _sqStatement:SQLStatement;
		private var _dataExists:Boolean;
		private var _calendar:Calendar;

//		private var _rightLabelFormat:TextFormat;

		public function HivivaPatientTestResultsScreen()
		{

		}

		override protected function draw():void
		{
//			this._rightLabelFormat = new TextFormat("ExoRegular", Math.round(24 * this.dpiScale), 0x495c72);
			super.draw();

			this._dateButton.x = this._date.x + this._date._labelRight.x;
			this._dateButton.y = this._date.y + this._date._labelRight.y - (this._dateButton.height * 0.5);

			this._content.validate();
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();

			this._cd4Count._labelLeft.text = "CD4 Count:";
			this._cd4Count._labelRight.text = "Cells/mm3";
			labelAndInputDrawProperties(this._cd4Count);
/*

			this._cd4._labelLeft.text = "CD4:";
			this._cd4._labelRight.text = "%";
			labelAndInputDrawProperties(this._cd4);
*/

			this._viralLoad._labelLeft.text = "Viral load:";
			this._viralLoad._labelRight.text = "Copies/ML";
			labelAndInputDrawProperties(this._viralLoad);

			this._date._labelLeft.textRendererProperties.multiline = true;
			this._date._labelLeft.text = "Date of \nlast test:";
			this._date._labelRight.text = "";
			labelAndInputDrawProperties(this._date);

			this._submitButton.width = this._cancelButton.width = this._innerWidth * 0.25;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();

			this._submitButton.y = this._cancelButton.y = this._dateButton.y;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + this._componentGap;
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Test Results";

			this._cd4Count = new LabelAndInput();
			this._cd4Count.scale = this.dpiScale;
			this._cd4Count.labelStructure = "leftAndRight";
			this._content.addChild(this._cd4Count);
/*

			this._cd4 = new LabelAndInput();
			this._cd4.scale = this.dpiScale;
			this._cd4.labelStructure = "leftAndRight";
			this._content.addChild(this._cd4);
*/

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
			this._dateButton.name = "calendar-button";
			this._content.addChild(this._dateButton);

			this._cancelButton = new Button();
			this._cancelButton.label = "Cancel";
			this._cancelButton.addEventListener(Event.TRIGGERED, cancelButtonClick);
			this._content.addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.label = "Save";
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			this._content.addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			populateOldData();
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
			//PopUpManager.centerPopUp(this._calendar);
		}

		private function calendarButtonHandler(e:FeathersScreenEvent):void
		{
			PopUpManager.removePopUp(this._calendar);
			this._date._input.text = e.evtData.date;
		}

		private function cancelButtonClick(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function submitButtonClick(e:Event):void
		{
			var formValidation:String = patientTestResultsCheck();
			if(formValidation.length == 0)
			{

			//trace("UPDATE test_results SET cd4_count='" + cd4CountInput.text + "', cd4='" + cd4Input.text + "', viral_load='" + viralLoadInput.text + "', date_of_last_test='" + dateInput.text + "'");

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();

			var cd4CountData:Number = Number(this._cd4Count._input.text);
//			var cd4Data:Number = Number(this._cd4._input.text);
			var viralLoadData:Number = Number(this._viralLoad._input.text);
			var dateData:String = "'" + this._date._input.text + "'";
				if(this._dataExists)
				{
					this._sqStatement.text = "UPDATE test_results SET cd4_count=" + cd4CountData + ", cd4=" + 0 + ", viral_load=" + viralLoadData + ", date_of_last_test=" + dateData;
				}
				else
				{
					this._sqStatement.text = "INSERT INTO test_results (cd4_count, cd4, viral_load, date_of_last_test) VALUES (" + cd4CountData + ", " + 0 + ", " + viralLoadData + ", " + dateData + ")";
				}
				trace(this._sqStatement.text);
				this._sqStatement.sqlConnection = this._sqConn;
				this._sqStatement.addEventListener(SQLEvent.RESULT, sqlResultHandler);
				this._sqStatement.execute();


				showFormValidation("Your details have been saved");
			}
			else
			{
				showFormValidation(formValidation);
			}
		}

		private function patientTestResultsCheck():String
		{
			var validationArray:Array = [];

			if(this._cd4Count._input.text.length == 0 || isNaN(Number(this._cd4Count._input.text))) validationArray.push("Please enter valid CD4 Count data");
//			if(this._cd4._input.text.length == 0 || isNaN(Number(this._cd4._input.text))) validationArray.push("Please enter valid CD4 data");
			if(this._viralLoad._input.text.length == 0 || isNaN(Number(this._viralLoad._input.text))) validationArray.push("Please enter valid Viral load data");
			if(this._date._input.text.length == 0) validationArray.push("Please select a date");

			return validationArray.join("<br/>");
		}

		private function sqlResultHandler(e:SQLEvent):void
		{
			trace("sqlResultHandler " + e);
		}
		private function populateOldData():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "SELECT * FROM test_results";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();

			var sqlRes:SQLResult = this._sqStatement.getResult();
			//trace(sqlRes.data[0].cd4_count);
			//trace(sqlRes.data[0].cd4);
			//trace(sqlRes.data[0].viral_load);
			//trace(sqlRes.data[0].date_of_last_test);
			this._dataExists = true;

			try
			{
				this._cd4Count._input.text = sqlRes.data[0].cd4_count;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._cd4Count._input.text = "";
				this._dataExists = false;
			}


/*

			try
			{
				this._cd4._input.text = sqlRes.data[0].cd4;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._cd4._input.text = "";
				this._dataExists = false;
			}
*/

			try
			{
				this._viralLoad._input.text = sqlRes.data[0].viral_load;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._viralLoad._input.text = "";
				this._dataExists = false;
			}

			try
			{
				this._date._input.text = sqlRes.data[0].date_of_last_test;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._date._input.text = "";
				this._dataExists = false;
			}
		}
	}
}
