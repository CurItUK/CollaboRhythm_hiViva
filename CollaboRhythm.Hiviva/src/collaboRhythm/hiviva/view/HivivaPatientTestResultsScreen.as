package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
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

	import starling.display.DisplayObject;
	import starling.display.Sprite;

	import starling.events.Event;

	public class HivivaPatientTestResultsScreen extends ScreenBase
	{
		private var _header:Header
		private var _cd4Count:Sprite;
		private var _cd4:Sprite;
		private var _viralLoad:Sprite;
		private var _date:Sprite;
		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _backButton:Button;
		private var _sqConn:SQLConnection;
		private var _sqStatement:SQLStatement;

		public function HivivaPatientTestResultsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = this.actualWidth;

			layoutInputWithLabelAndUnits(this._cd4Count);
			layoutInputWithLabelAndUnits(this._cd4);
			layoutInputWithLabelAndUnits(this._viralLoad);
			layoutInputWithLabelAndUnits(this._date);

			this._cancelButton.label = "Cancel";
			this._submitButton.label = "Save";
			this._backButton.label = "Back";

			var items:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			items.push(this._cd4Count);
			items.push(this._cd4);
			items.push(this._viralLoad);
			items.push(this._date);
			items.push(this._cancelButton);

			autoLayout(items, 50 * this.dpiScale);

			this._submitButton.y = this._cancelButton.y;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + (20 * this.dpiScale);

			populateOldData();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new Header();
			this._header.title = "Test Results";
			addChild(this._header);

			this._cd4Count = new Sprite();
			this._cd4 = new Sprite();
			this._viralLoad = new Sprite();
			this._date = new Sprite();

			createInputWithLabelAndUnits(this._cd4Count,"CD4 Count:","Cells/mm3");
			createInputWithLabelAndUnits(this._cd4,"CD4:","%");
			createInputWithLabelAndUnits(this._viralLoad,"Viral load:","Copies/ML");
			createInputWithLabelAndUnits(this._date,"Date of latest test:","Cal");

			this._cancelButton = new Button();
			this._cancelButton.addEventListener(Event.TRIGGERED, cancelButtonClick);
			addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
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

			var cd4CountInput:TextInput = this._cd4Count.getChildByName("input") as TextInput;
			var cd4Input:TextInput = this._cd4.getChildByName("input") as TextInput;
			var viralLoadInput:TextInput = this._viralLoad.getChildByName("input") as TextInput;
			var dateInput:TextInput = this._date.getChildByName("input") as TextInput;

			//trace("UPDATE test_results SET cd4_count='" + cd4CountInput.text + "', cd4='" + cd4Input.text + "', viral_load='" + viralLoadInput.text + "', date_of_last_test='" + dateInput.text + "'");

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "UPDATE test_results SET cd4_count=" + cd4CountInput.text + ", cd4=" + cd4Input.text + ", viral_load=" + viralLoadInput.text + ", date_of_last_test=" + dateInput.text;
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

			var cd4CountInput:TextInput = this._cd4Count.getChildByName("input") as TextInput;
			try
			{
				cd4CountInput.text = sqlRes.data[0].cd4_count;
			}
			catch(e:Error)
			{
				//trace("fail");
				cd4CountInput.text = "";
			}

			var cd4Input:TextInput = this._cd4.getChildByName("input") as TextInput;
			try
			{
				cd4Input.text = sqlRes.data[0].cd4;
			}
			catch(e:Error)
			{
				//trace("fail");
				cd4Input.text = "";
			}

			var viralLoadInput:TextInput = this._viralLoad.getChildByName("input") as TextInput;
			try
			{
				viralLoadInput.text = sqlRes.data[0].viral_load;
			}
			catch(e:Error)
			{
				//trace("fail");
				viralLoadInput.text = "";
			}

			var dateInput:TextInput = this._date.getChildByName("input") as TextInput;
			try
			{
				dateInput.text = sqlRes.data[0].date_of_last_test;
			}
			catch(e:Error)
			{
				//trace("fail");
				dateInput.text = "";
			}
		}

		private function createInputWithLabelAndUnits(inputContainer:Sprite, labelText:String, unitsText:String):void
		{
			var label:Label = new Label(),
				units:Label = new Label(),
				input:TextInput = new TextInput();

			label.name = "label";
			units.name = "units";
			input.name = "input";

			label.text = labelText;
			units.text = unitsText;

			inputContainer.addChild(label);
			inputContainer.addChild(units);
			inputContainer.addChild(input);

			inputContainer.name = name;
			addChild(inputContainer);
		}

		private function layoutInputWithLabelAndUnits(inputContainer:Sprite):void
		{
			var label:Label = inputContainer.getChildByName("label") as Label,
				units:Label = inputContainer.getChildByName("units") as Label,
				input:TextInput = inputContainer.getChildByName("input") as TextInput;

			label.width = this.actualWidth / 3;
			units.width = this.actualWidth / 3;
			input.width = this.actualWidth / 3;

			label.validate();
			units.validate();
			input.validate();

			input.x = label.x + label.width;
			units.x = input.x + input.width;
		}

		private function autoLayout(items:Vector.<DisplayObject>, gap:Number):void
		{
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.x = 0;
			bounds.y = this._header.height;
			bounds.maxHeight = this.actualHeight - this._header.height;
			bounds.maxWidth = this.actualWidth;

			var contentLayout:VerticalLayout = new VerticalLayout();
			contentLayout.gap = gap;
			contentLayout.layout(items,bounds);
		}
	}
}
