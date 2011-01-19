package collaboRhythm.workstation.model
{
	import flash.filesystem.*;
	
	import mx.events.FileEvent;

	public class Settings
	{
		private const SETTINGS_FILE_NAME:String = "settings.xml";
		
		private var _userName:String;
		private var _password:String;
		private var _chromeConsumerKey:String;
		private var _chromeConsumerSecret:String;
		private var _indivoServerBaseURL:String;
		private var _mode:String;
		private var _rtmpBaseURI:String;
		private var _useSingleScreen:Boolean;
		private var _resetWindowSettings:Boolean;
		private var _targetDate:Date;
		private var _isWorkstationMode:Boolean;
		
		public function Settings()
		{
			readSettings();
		}

		public function get isWorkstationMode():Boolean
		{
			return _isWorkstationMode;
		}

		public function set isWorkstationMode(value:Boolean):void
		{
			_isWorkstationMode = value;
		}

		public function get indivoServerBaseURL():String
		{
			return _indivoServerBaseURL;
		}

		public function set indivoServerBaseURL(value:String):void
		{
			_indivoServerBaseURL = value;
		}

		public function get chromeConsumerKey():String
		{
			return _chromeConsumerKey;
		}

		public function set chromeConsumerKey(value:String):void
		{
			_chromeConsumerKey = value;
		}

		public function get chromeConsumerSecret():String
		{
			return _chromeConsumerSecret;
		}

		public function set chromeConsumerSecret(value:String):void
		{
			_chromeConsumerSecret = value;
		}

		public function get password():String
		{
			return _password;
		}

		public function set password(value:String):void
		{
			_password = value;
		}

		private function readSettings():void
		{
			var file:File = File.applicationDirectory.resolvePath("resources").resolvePath(SETTINGS_FILE_NAME);
			
			readSettingsFromFile(file);

			file = File.applicationStorageDirectory.resolvePath(SETTINGS_FILE_NAME);

			readSettingsFromFile(file);
		}
		
		private function readSettingsFromFile(file:File):void
		{
			if (!file.exists)
				return;
			
			var fileStream:FileStream = new FileStream();

			try
			{
				fileStream.open(file, FileMode.READ);
			}
			catch (error:Error)
			{
				trace("File exists but could not be read: ", file.nativePath);
				return;
			}
			
			var preferencesXML:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable)); 
			fileStream.close();
			
//			for each (var preference:XML in preferencesXML.children())
//			{
//				this["_" + preference.name()] = preference.valueOf();
//			}
			
			if (preferencesXML.userName.length() == 1)
				_userName = preferencesXML.userName;
			if (preferencesXML.username.length() == 1)
				_userName = preferencesXML.username;
			if (preferencesXML.password.length() == 1)
				_password = preferencesXML.password;
			if (preferencesXML.indivoServerBaseURL.length() == 1)
				_indivoServerBaseURL = preferencesXML.indivoServerBaseURL;
			if (preferencesXML.chromeConsumerKey.length() == 1)
				_chromeConsumerKey = preferencesXML.chromeConsumerKey;
			if (preferencesXML.chromeConsumerSecret.length() == 1)
				_chromeConsumerSecret = preferencesXML.chromeConsumerSecret;
			if (preferencesXML.mode.length() == 1)
				_mode = preferencesXML.mode;
			if (preferencesXML.rtmpBaseURI.length() == 1)
				_rtmpBaseURI = preferencesXML.rtmpBaseURI;
			if (preferencesXML.useSingleScreen.length() == 1)
				_useSingleScreen = preferencesXML.useSingleScreen.toString() == true.toString();
			if (preferencesXML.resetWindowSettings.length() == 1)
				_resetWindowSettings = preferencesXML.resetWindowSettings.toString() == true.toString();
			if (preferencesXML.targetDate.length() == 1)
				_targetDate = new Date(preferencesXML.targetDate.toString());
			
			_isWorkstationMode = true;
		}

		public function get userName():String
		{
			return _userName;
		}
		
		public function get mode():String
		{
			return _mode;
		}
		
		public function get rtmpBaseURI():String
		{
			return _rtmpBaseURI;
		}

		public function get useSingleScreen():Boolean
		{
			return _useSingleScreen;
		}

		public function set useSingleScreen(value:Boolean):void
		{
			_useSingleScreen = value;
		}
		
		public function get resetWindowSettings():Boolean
		{
			return _resetWindowSettings;
		}

		public function set resetWindowSettings(value:Boolean):void
		{
			_resetWindowSettings = value;
		}

		public function get targetDate():Date
		{
			return _targetDate;
		}

		public function set targetDate(value:Date):void
		{
			_targetDate = value;
		}
		
		public function get isClinicianMode():Boolean
		{
			return _mode == "clinician";
		}

		public function get isPatientMode():Boolean
		{
			return _mode == "patient";
		}

	}
}