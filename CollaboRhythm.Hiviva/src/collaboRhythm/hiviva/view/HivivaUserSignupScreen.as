package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.ScrollText;
	import feathers.controls.TextInput;
	import feathers.layout.VerticalLayout;
	import feathers.layout.ViewPortBounds;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.net.URLRequest;

	import starling.display.DisplayObject;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;


	public class HivivaUserSignupScreen extends ScreenBase
	{
		private var _header:Header;
		private var _instructionsText:ScrollText;
		private var _nameLabel:Label;
		private var _nameInput:TextInput;
		private var _emailLabel:Label;
		private var _emailInput:TextInput;
		private var _updatesCheck:Check;
		private var _researchCheck:Check;
		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _sqConn:SQLConnection;
		private var _sqStatement:SQLStatement;
		private var _backButton:Button;
		private var _dataExists:Boolean;


		public function HivivaUserSignupScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = this.actualWidth;

			this._instructionsText.text = "By clicking the button above, you agree to the Terms of Use <br>View our Privacy Policy";
			//this._instructionsText.y = this._header.height;
			this._instructionsText.width = this.actualWidth;

			this._nameLabel.text = "Name";
			//this._nameLabel.y = 100;
			this._nameLabel.width = this.actualWidth / 2;

			//this._nameInput.y = 100;
			this._nameInput.width = this.actualWidth / 2;

			this._emailLabel.text = "Email";
			//this._emailLabel.y = 150;
			this._emailLabel.width = this.actualWidth / 2;

			//this._emailInput.y = 150;
			this._emailInput.width = this.actualWidth / 2;

			//this._photoContainer.y = 200;

			//this._updatesCheck.y = 250;
			this._updatesCheck.isSelected = false;
			this._updatesCheck.label = "Send me updates";

			//this._updatesCheck.y = 300;
			this._researchCheck.isSelected = false;
			this._researchCheck.label = "Allow anonymised data for research purposes";

			this._cancelButton.label = "Cancel";
			this._submitButton.label = "Create my Account";
			this._backButton.label = "Back";

			var items:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			items.push(this._nameInput);
			items.push(this._emailInput);
			items.push(this._updatesCheck);
			items.push(this._researchCheck);
			items.push(this._cancelButton);
			items.push(this._instructionsText);

			autoLayout(items, 50 * this.dpiScale);

			this._nameLabel.y = this._nameInput.y;
			this._emailLabel.y = this._emailInput.y;
			this._nameInput.x = this.actualWidth / 2;
			this._emailInput.x = this.actualWidth / 2;
			this._submitButton.y = this._cancelButton.y;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + (20 * this.dpiScale);

			populateOldData();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new Header();
			this._header.title = "Sign up";
			addChild(this._header);

			this._instructionsText = new ScrollText();
			this._instructionsText.isHTML = true;
			addChild(this._instructionsText);

			this._nameLabel = new Label();
			addChild(this._nameLabel);

			this._nameInput = new TextInput();
			addChild(this._nameInput);

			this._emailLabel = new Label();
			addChild(this._emailLabel);

			this._emailInput = new TextInput();
			addChild(this._emailInput);

			this._updatesCheck = new Check();
			addChild(this._updatesCheck);

			this._researchCheck = new Check();
			addChild(this._researchCheck);

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

			//trace("UPDATE user_details SET user_name='" + this._nameInput.text + "', user_email='" + this._emailInput.text + "', user_updates=" + int(this._updatesCheck.isSelected) + ", user_research=" + int(this._researchCheck.isSelected));

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();

			var userName:String = "'" + this._nameInput.text + "'";
			var userEmail:String = "'" + this._emailInput.text + "'";
			var userUpdates:int = int(this._updatesCheck.isSelected);
			var userResearch:int = int(this._researchCheck.isSelected);
			if(this._dataExists)
			{
				this._sqStatement.text = "UPDATE connect_user_details SET user_name=" + userName + ", user_email=" + userEmail + ", user_updates=" + userUpdates + ", user_research=" + userResearch;
			}
			else
			{
				this._sqStatement.text = "INSERT INTO connect_user_details (user_name, user_email, user_updates, user_research) VALUES (" + userName + ", " + userEmail + ", " + userUpdates + ", " + userResearch + ")";
			}
			trace(this._sqStatement.text);
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, sqlResultHandler);
			this._sqStatement.execute();
		}

		private function populateOldData():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "SELECT * FROM connect_user_details";
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
				this._nameInput.text = sqlRes.data[0].user_name;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._nameInput.text = "";
				this._dataExists = false;
			}
			this._nameInput.invalidate();

			try
			{
				this._emailInput.text = sqlRes.data[0].user_email;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._emailInput.text = "";
			}
			this._emailInput.invalidate();

			try
			{
				this._updatesCheck.isSelected = sqlRes.data[0].user_updates as Boolean;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._updatesCheck.isSelected = false;
			}
			this._updatesCheck.invalidate();

			try
			{
				this._researchCheck.isSelected = sqlRes.data[0].user_research as Boolean;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._researchCheck.isSelected = false;
			}
			this._researchCheck.invalidate();

		}

		private function sqlResultHandler(e:SQLEvent):void
		{
			trace("sqlResultHandler " + e);
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
