package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.controls.TextInput;
	import feathers.controls.TextInput;
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

	public class HivivaPatientTestResultsScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _cd4Count:LabelAndInput;
		private var _cd4:LabelAndInput;
		private var _viralLoad:LabelAndInput;
		private var _date:LabelAndInput;
		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _backButton:Button;
		private var _sqConn:SQLConnection;
		private var _sqStatement:SQLStatement;

		private var _rightLabelFormat:TextFormat;

		public function HivivaPatientTestResultsScreen()
		{

		}

		override protected function draw():void
		{
			var padding:Number = (32 * this.dpiScale);

			super.draw();
			this._rightLabelFormat = new TextFormat("ExoRegular", Math.round(24 * this.dpiScale), 0x495c72);

			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._cd4Count.y = this._header.y + this._header.height;
			this._cd4Count._labelLeft.text = "CD4 Count:";
			this._cd4Count._labelRight.text = "Cells/mm3";
			labelAndInputDrawProperties(this._cd4Count);

			this._cd4.y = this._cd4Count.y + this._cd4Count.height;
			this._cd4._labelLeft.text = "CD4:";
			this._cd4._labelRight.text = "%";
			labelAndInputDrawProperties(this._cd4);

			this._viralLoad.y = this._cd4.y + this._cd4.height;
			this._viralLoad._labelLeft.text = "Viral load:";
			this._viralLoad._labelRight.text = "Copies/ML";
			labelAndInputDrawProperties(this._viralLoad);

			this._date.y = this._viralLoad.y + this._viralLoad.height;
			this._date._labelLeft.textRendererProperties.multiline = true;
			this._date._labelLeft.text = "Date of \nlast test:";
			this._date._labelRight.text = "Cal";
			labelAndInputDrawProperties(this._date);

			this._submitButton.validate();
			this._cancelButton.validate();
			this._backButton.validate();

			this._cancelButton.y = this._submitButton.y = this._date.y + this._date.height;
			this._cancelButton.x = padding;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + padding;

			populateOldData();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Test Results";
			addChild(this._header);

			this._cd4Count = new LabelAndInput();
			this._cd4Count.scale = this.dpiScale;
			this._cd4Count.labelStructure = "leftAndRight";
			addChild(this._cd4Count);

			this._cd4 = new LabelAndInput();
			this._cd4.scale = this.dpiScale;
			this._cd4.labelStructure = "leftAndRight";
			addChild(this._cd4);

			this._viralLoad = new LabelAndInput();
			this._viralLoad.scale = this.dpiScale;
			this._viralLoad.labelStructure = "leftAndRight";
			addChild(this._viralLoad);

			this._date = new LabelAndInput();
			this._date.scale = this.dpiScale;
			this._date.labelStructure = "leftAndRight";
			addChild(this._date);

			this._cancelButton = new Button();
			this._cancelButton.label = "Cancel";
			this._cancelButton.addEventListener(Event.TRIGGERED, cancelButtonClick);
			addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.label = "Save";
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}

		private function labelAndInputDrawProperties(landi:LabelAndInput):void
		{
			landi.width = this.actualWidth;
			landi._labelRight.textRendererProperties.textFormat = this._rightLabelFormat;
			landi._input.width = this.actualWidth * 0.3;
			landi._input.validate();
			landi._input.x = (this.actualWidth * 0.5) - (landi._input.width / 2);
			landi.validate();
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
			// TODO : display confirmation dialogue

			//trace("UPDATE test_results SET cd4_count='" + cd4CountInput.text + "', cd4='" + cd4Input.text + "', viral_load='" + viralLoadInput.text + "', date_of_last_test='" + dateInput.text + "'");

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "UPDATE test_results SET cd4_count=" + this._cd4Count._input.text + ", cd4=" + this._cd4._input.text + ", viral_load=" + this._viralLoad._input.text + ", date_of_last_test=" + this._date._input.text;
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, sqlResultHandler);
			this._sqStatement.execute();
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

			try
			{
				this._cd4Count._input.text = sqlRes.data[0].cd4_count;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._cd4Count._input.text = "";
			}

			try
			{
				this._cd4._input.text = sqlRes.data[0].cd4;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._cd4._input.text = "";
			}

			try
			{
				this._viralLoad._input.text = sqlRes.data[0].viral_load;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._viralLoad._input.text = "";
			}

			try
			{
				this._date._input.text = sqlRes.data[0].date_of_last_test;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._date._input.text = "";
			}
		}
	}
}
