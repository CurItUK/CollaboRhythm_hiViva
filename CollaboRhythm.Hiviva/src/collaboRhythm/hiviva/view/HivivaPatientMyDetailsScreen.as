package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.filesystem.File;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaPatientMyDetailsScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _instructionsText:ScrollText;
		private var _nameInput:LabelAndInput;
		private var _emailInput:LabelAndInput;
		private var _photoContainer:ImageUploader;
		private var _updatesCheck:Check;
		private var _researchCheck:Check;
		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _sqConn:SQLConnection;
		private var _sqStatement:SQLStatement;
		private var _backButton:Button;
		private var _dataExists:Boolean;


		public function HivivaPatientMyDetailsScreen()
		{

		}

		override protected function draw():void
		{
			var padding:Number = (32 * this.dpiScale);

			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._header.width = this.actualWidth;

			this._instructionsText.width = this.actualWidth;
			this._instructionsText.y = this._header.height;
			this._instructionsText.validate();

			this._nameInput._labelLeft.text = "Name";
			this._nameInput.width = this.actualWidth;
			this._nameInput.y = this._instructionsText.y + this._instructionsText.height;
			this._nameInput._input.width = this.actualWidth * 0.7;
			this._nameInput.validate();

			this._emailInput._labelLeft.text = "Email";
			this._emailInput.width = this.actualWidth;
			this._emailInput.y = this._nameInput.y + this._nameInput.height;
			this._emailInput._input.width = this.actualWidth * 0.7;
			this._emailInput.validate();

			this._photoContainer.width = this.actualWidth;
			this._photoContainer.validate();
			this._photoContainer.y = this._emailInput.y + this._emailInput.height;

			this._updatesCheck.width = this.actualWidth;
			this._updatesCheck.validate();
			this._updatesCheck.y = this._photoContainer.y + this._photoContainer.height + padding;

			this._researchCheck.width = this.actualWidth;
			this._researchCheck.validate();
			this._researchCheck.y = this._updatesCheck.y + this._updatesCheck.height;

			this._cancelButton.validate();
			this._submitButton.validate();
			this._backButton.validate();

			this._cancelButton.y = this._submitButton.y = this._researchCheck.y + this._researchCheck.height;
			this._cancelButton.x = padding;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + padding;

			populateOldData();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "My Details";
			addChild(this._header);

			this._instructionsText = new ScrollText();
			this._instructionsText.text = "All fields are optional except to connect to a care provider What's this?";
			addChild(this._instructionsText);

			this._nameInput = new LabelAndInput();
			this._nameInput.scale = this.dpiScale;
			this._nameInput.labelStructure = "left";
			addChild(this._nameInput);

			this._emailInput = new LabelAndInput();
			this._emailInput.scale = this.dpiScale;
			this._emailInput.labelStructure = "left";
			addChild(this._emailInput);

			this._photoContainer = new ImageUploader();
			this._photoContainer.scale = this.dpiScale;
			this._photoContainer.fileName = "userprofileimage.jpg";
			addChild(this._photoContainer);

			this._updatesCheck = new Check();
			this._updatesCheck.isSelected = false;
			this._updatesCheck.label = "Send me updates";
			addChild(this._updatesCheck);

			this._researchCheck = new Check();
			this._researchCheck.isSelected = false;
			this._researchCheck.label = "Allow anonymised data for research purposes";
			addChild(this._researchCheck);

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

			populateOldData();
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

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();

			var userName:String = "'" + this._nameInput._input.text + "'";
			var userEmail:String = "'" + this._emailInput._input.text + "'";
			var userUpdates:int = int(this._updatesCheck.isSelected);
			var userResearch:int = int(this._researchCheck.isSelected);
			if(this._dataExists)
			{
				this._sqStatement.text = "UPDATE user_details SET user_name=" + userName + ", user_email=" + userEmail + ", user_updates=" + userUpdates + ", user_research=" + userResearch;
			}
			else
			{
				this._sqStatement.text = "INSERT INTO user_details (user_name, user_email, user_updates, user_research) VALUES (" + userName + ", " + userEmail + ", " + userUpdates + ", " + userResearch + ")";
			}
			trace(this._sqStatement.text);
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, sqlResultHandler);
			this._sqStatement.execute();

			this._photoContainer.saveTempImageAsMain();
		}

		private function populateOldData():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "SELECT * FROM user_details";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();

			var sqlRes:SQLResult = this._sqStatement.getResult();
			//trace(sqlRes.data[0].user_name);
			//trace(sqlRes.data[0].user_email);
			//trace(sqlRes.data[0].user_updates);
			//trace(sqlRes.data[0].user_research);
			this._dataExists = true;
			try
			{
				this._nameInput._input.text = sqlRes.data[0].user_name;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._nameInput._input.text = "";
				this._dataExists = false;
			}

			try
			{
				this._emailInput._input.text = sqlRes.data[0].user_email;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._emailInput._input.text = "";
			}

			try
			{
				this._updatesCheck.isSelected = sqlRes.data[0].user_updates as Boolean;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._updatesCheck.isSelected = false;
			}

			try
			{
				this._researchCheck.isSelected = sqlRes.data[0].user_research as Boolean;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._researchCheck.isSelected = false;
			}

			this._photoContainer.getMainImage();
		}

		private function sqlResultHandler(e:SQLEvent):void
		{
			trace("sqlResultHandler " + e);
		}
	}
}
