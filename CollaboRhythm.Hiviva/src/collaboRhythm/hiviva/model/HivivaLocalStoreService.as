package collaboRhythm.hiviva.model
{
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.vo.AppDataVO;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;
	import flash.events.SQLEvent;
	import flash.filesystem.File;

	public class HivivaLocalStoreService extends EventDispatcher
	{
		public static const APP_FIRST_TIME_USE:String					= "appFirstTimeUse";
		public static const USER_APP_TYPE_PATIENT:String = "Patient";
		public static const USER_APP_TYPE_HCP:String = "HCP";

		private var _sqStatement:SQLStatement;
		private var _sqConn:SQLConnection;
		private var _appDataVO:AppDataVO;

		private var _medicationSchedule:Array;
		private var _medicationAdherenceToSet:Object;
		private var _medicationIdToDelete:int;
		private var _patientProfile:Object;
		private var _hcpProfile:Object;
		private var _displaySettings:Object;
		private var _alertSettings:Object;

		public function HivivaLocalStoreService()
		{

		}

		public function initDataLoad():void
		{
			var localSettingsFile:File = File.applicationStorageDirectory;
			localSettingsFile = localSettingsFile.resolvePath("settings.sqlite");
			if(localSettingsFile.exists)
			{
				loadAppData();
			} else
			{
				createUserSettingsDatabase();
			}
		}

		private function loadAppData():void
		{
			trace("Load User Data");

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.addEventListener(SQLEvent.OPEN, dataFileOpenHandler);
			this._sqConn.open(dbFile);

		}

		private function dataFileOpenHandler(e:SQLEvent):void
		{
			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "SELECT * FROM app_settings";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();

			_appDataVO = new AppDataVO();

			try
			{
				_appDataVO._userAppType = this._sqStatement.getResult().data[0].profile_type;
			}
			catch(e:Error)
			{
				_appDataVO._userAppType = HivivaLocalStoreService.APP_FIRST_TIME_USE;
			}

			// TODO: remove this check when HCP is working; HCP is not supported yet
//			if (_appDataVO._userAppType == USER_APP_TYPE_HCP)
//				_appDataVO._userAppType = HivivaLocalStoreService.APP_FIRST_TIME_USE;



			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.DATA_LOAD_COMPLETE);
			evt.message = "dataLoaded";
			dispatchEvent(evt);
		}

		private function sqlResultHandler(e:SQLEvent):void
		{
			trace("sqlResultHandler " + e);
		}

		public function setAppId(appId:String):void
		{
			trace("appId generated " + appId);
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "UPDATE app_settings SET app_id='" + appId + "'";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, sqlResultHandler);
			this._sqStatement.execute();
		}

		public function getAppId():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "SELECT app_id FROM app_settings";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, getAppIdHandler);
			this._sqStatement.execute();
		}

		private function getAppIdHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			trace("sqlResultHandler " + e);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.APP_ID_LOAD_COMPLETE);
			evt.data.app_id = result[0].app_id;
			this.dispatchEvent(evt);
		}

		private function createUserSettingsDatabase():void
		{
			trace("create local user settings file");

			var sourceFile:File = File.applicationDirectory;
			sourceFile = sourceFile.resolvePath("resources/settings.sqlite");

			var destination:File = File.applicationStorageDirectory;
			destination = destination.resolvePath("settings.sqlite");

			sourceFile.copyTo(destination);

			_appDataVO = new AppDataVO();
			_appDataVO._userAppType = HivivaLocalStoreService.APP_FIRST_TIME_USE;

			setAppId(HivivaModifier.generateAppId());

			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.DATA_LOAD_COMPLETE);
			evt.message = HivivaLocalStoreService.APP_FIRST_TIME_USE;
			dispatchEvent(evt);
		}

		public function updateAppProfileType(data:String):void
		{
			appDataVO._userAppType = data;

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "UPDATE app_settings SET profile_type='" + data + "'";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, sqlResultHandler);
			this._sqStatement.execute();

		}

		public function getGalleryImages():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.addEventListener(SQLEvent.RESULT, getGalleryImagesHandler);
			this._sqStatement.text = "SELECT url FROM homepage_photos";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();
		}

		private function getGalleryImagesHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			trace("sqlResultHandler " + e);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE);
			evt.data.imageUrls = result;
			this.dispatchEvent(evt);
		}

		public function getGalleryTimeStamp():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.addEventListener(SQLEvent.RESULT, getGalleryTimeStampHandler);
			this._sqStatement.text = "SELECT gallery_submission_timestamp FROM app_settings";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();
		}

		private function getGalleryTimeStampHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			trace("sqlResultHandler " + e);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE);
			evt.data.timeStamp = result[0].gallery_submission_timestamp;
			this.dispatchEvent(evt);
		}

		public function getMedicationList():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM medications";
			this._sqStatement.addEventListener(SQLEvent.RESULT, getMedicationsResultHandler);
			this._sqStatement.execute();
		}

		private function getMedicationsResultHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			trace("sqlResultHandler " + e);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE);
			evt.data.medications = result;
			this.dispatchEvent(evt);
		}

		public function setMedicationList(medicationSchedule:Array , medicationName:String):void
		{
			_medicationSchedule = medicationSchedule;

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text =  "INSERT INTO medications ('medication_name') VALUES ('" + medicationName + "') ";
			this._sqStatement.addEventListener(SQLEvent.RESULT, setMedicationsResultHandler);
			this._sqStatement.execute();

		}

		private function setMedicationsResultHandler(e:SQLEvent):void
		{
			var lastInsertRowID:Number = this._sqStatement.getResult().lastInsertRowID;

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "";

			var medicationLoop:uint = _medicationSchedule.length;
			for (var i:uint = 0; i < medicationLoop; i++)
			{
				if (i == 0)
				{
					this._sqStatement.text += "INSERT INTO medication_schedule ('time' , 'tablet_count' , 'medication_id') SELECT '" +
							_medicationSchedule[i].time + "', '" + _medicationSchedule[i].count + "' , " + lastInsertRowID + "";
				}
				else
				{
					this._sqStatement.text += " UNION SELECT '" + _medicationSchedule[i].time + "', '" +
							_medicationSchedule[i].count + "' , "+ lastInsertRowID +"";
				}
			}
			this._sqStatement.addEventListener(SQLEvent.RESULT, setMedicationsScheduleResultHandler);
			this._sqStatement.execute();
		}

		private function setMedicationsScheduleResultHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.MEDICATIONS_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function deleteMedication(medicationId:int):void
		{
			this._medicationIdToDelete = medicationId;

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text =  "DELETE FROM medications WHERE id=" + this._medicationIdToDelete;
			this._sqStatement.addEventListener(SQLEvent.RESULT, deleteMedicationHandler);
			this._sqStatement.execute();
		}

		private function deleteMedicationHandler(e:SQLEvent):void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text =  "DELETE FROM medication_schedule WHERE medication_id=" + this._medicationIdToDelete;
			this._sqStatement.addEventListener(SQLEvent.RESULT, deleteMedicationScheduleHandler);
			this._sqStatement.execute();
		}

		private function deleteMedicationScheduleHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.MEDICATIONS_DELETE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getMedicationsSchedule():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text =  "select * from medications m left join medication_schedule ms on ms.medication_id = m.id";
			this._sqStatement.addEventListener(SQLEvent.RESULT, getMedicationsScheduleResultHandler);
			this._sqStatement.execute();

		}

		private function getMedicationsScheduleResultHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			trace("sqlResultHandler " + e);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE);
			evt.data.medicationSchedule = result;
			this.dispatchEvent(evt);
		}

		public function getAdherence():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM medication_adherence";
			this._sqStatement.addEventListener(SQLEvent.RESULT, getAdherenceResultHandler);
			this._sqStatement.execute();
		}

		private function getAdherenceResultHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			trace("sqlResultHandler " + e);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE);
			evt.data.adherence = result;
			this.dispatchEvent(evt);
		}

		public function setAdherence(medicationAdherence:Object):void
		{
			_medicationAdherenceToSet = medicationAdherence;

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM medication_adherence";
			this._sqStatement.addEventListener(SQLEvent.RESULT, checkAdherenceResultHandler);
			this._sqStatement.execute();
		}

		private function checkAdherenceResultHandler(e:SQLEvent):void
		{
			var sqResult:SQLResult = this._sqStatement.getResult();
			var lastIndex:Number = sqResult.lastInsertRowID;
			var result:Array = sqResult.data;

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			try
			{
				if(_medicationAdherenceToSet.date == result[lastIndex].date)
				{
					this._sqStatement.text =  	"UPDATE medication_adherence SET data='" + _medicationAdherenceToSet.data +
												"', adherence_percentage='" + _medicationAdherenceToSet.adherence_percentage +
												"' WHERE date='" + _medicationAdherenceToSet.date + "'";
				}
				else
				{
					this._sqStatement.text =  	"INSERT INTO medication_adherence ('date' , 'data' , 'adherence_percentage') SELECT '" + _medicationAdherenceToSet.date +
												"', '" + _medicationAdherenceToSet.data +
												"', '" + _medicationAdherenceToSet.adherence_percentage + "'";
				}
			}
			catch(e:Error)
			{
				this._sqStatement.text =  	"INSERT INTO medication_adherence ('date' , 'data' , 'adherence_percentage') SELECT '" + _medicationAdherenceToSet.date +
											"', '" + _medicationAdherenceToSet.data +
											"', '" + _medicationAdherenceToSet.adherence_percentage + "'";
			}
			trace(this._sqStatement.text);
			this._sqStatement.addEventListener(SQLEvent.RESULT, setAdherenceResultHandler);
			this._sqStatement.execute();
		}

		private function setAdherenceResultHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.ADHERENCE_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getPatientProfile():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM patient_profile";
			this._sqStatement.addEventListener(SQLEvent.RESULT, getPatientProfileHandler);
			this._sqStatement.execute();
		}

		private function getPatientProfileHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			trace("sqlResultHandler " + e);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_PROFILE_LOAD_COMPLETE);
			evt.data.patientProfile = result;
			this.dispatchEvent(evt);
		}

		public function setPatientProfile(patientProfile:Object):void
		{
			this._patientProfile = patientProfile;

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM patient_profile";
			this._sqStatement.addEventListener(SQLEvent.RESULT, checkPatientProfileHandler);
			this._sqStatement.execute();
		}

		private function checkPatientProfileHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, setPatientProfileHandler);

			try
			{
				if(result != null)
				{
					this._sqStatement.text = "UPDATE patient_profile SET name=" +
							this._patientProfile.name + ", email=" +
							this._patientProfile.email + ", updates=" +
							this._patientProfile.updates + ", research=" +
							this._patientProfile.research;
				}
				else
				{
					this._sqStatement.text = "INSERT INTO patient_profile (name, email, updates, research) VALUES (" +
							this._patientProfile.name + ", " + this._patientProfile.email + ", " + this._patientProfile.updates + ", " + this._patientProfile.research + ")";
				}
			}
			catch(e:Error)
			{
				this._sqStatement.text = "INSERT INTO patient_profile (name, email, updates, research) VALUES (" +
						this._patientProfile.name + ", " + this._patientProfile.email + ", " + this._patientProfile.updates + ", " + this._patientProfile.research + ")";
			}

			this._sqStatement.execute();
		}

		private function setPatientProfileHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_PROFILE_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getHcpProfile():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM hcp_profile";
			this._sqStatement.addEventListener(SQLEvent.RESULT, getHcpProfileHandler);
			this._sqStatement.execute();
		}

		private function getHcpProfileHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			trace("sqlResultHandler " + e);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_PROFILE_LOAD_COMPLETE);
			evt.data.hcpProfile = result;
			this.dispatchEvent(evt);
		}

		public function setHcpProfile(hcpProfile:Object):void
		{
			this._hcpProfile = hcpProfile;

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM hcp_profile";
			this._sqStatement.addEventListener(SQLEvent.RESULT, checkHcpProfileHandler);
			this._sqStatement.execute();
		}

		private function checkHcpProfileHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, setHcpProfileHandler);

			try
			{
				if(result != null)
				{
					this._sqStatement.text = "UPDATE hcp_profile SET name=" +
							this._hcpProfile.name + ", email=" +
							this._hcpProfile.email + ", updates=" +
							this._hcpProfile.updates + ", research=" +
							this._hcpProfile.research;
				}
				else
				{
					this._sqStatement.text = "INSERT INTO hcp_profile (name, email, updates, research) VALUES (" +
							this._hcpProfile.name + ", " + this._hcpProfile.email + ", " + this._hcpProfile.updates + ", " + this._hcpProfile.research + ")";
				}
			}
			catch(e:Error)
			{
				this._sqStatement.text = "INSERT INTO hcp_profile (name, email, updates, research) VALUES (" +
						this._hcpProfile.name + ", " + this._hcpProfile.email + ", " + this._hcpProfile.updates + ", " + this._hcpProfile.research + ")";
			}

			this._sqStatement.execute();
		}

		private function setHcpProfileHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_PROFILE_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getHcpDisplaySettings():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM hcp_display_settings";
			this._sqStatement.addEventListener(SQLEvent.RESULT, getHcpDisplaySettingsHandler);
			this._sqStatement.execute();
		}

		private function getHcpDisplaySettingsHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			trace("sqlResultHandler " + e);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_DISPLAY_SETTINGS_LOAD_COMPLETE);
			evt.data.settings = result;
			this.dispatchEvent(evt);
		}

		public function setHcpDisplaySettings(displaySettings:Object):void
		{
			this._displaySettings = displaySettings;

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM hcp_display_settings";
			this._sqStatement.addEventListener(SQLEvent.RESULT, checkHcpDisplaySettingsHandler);
			this._sqStatement.execute();
		}

		private function checkHcpDisplaySettingsHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, setHcpDisplaySettingsHandler);

			try
			{
				if(result != null)
				{
					this._sqStatement.text = "UPDATE hcp_display_settings SET stat_type='" +
							this._displaySettings.stat_type + "', direction='" +
							this._displaySettings.direction + "', from_date='" +
							this._displaySettings.from_date + "'";
				}
				else
				{
					this._sqStatement.text = "INSERT INTO hcp_display_settings (stat_type, direction, from_date) VALUES ('" +
							this._displaySettings.stat_type + "', '" + this._displaySettings.direction + "', '" + this._displaySettings.from_date + "')";
				}
			}
			catch(e:Error)
			{
				this._sqStatement.text = "INSERT INTO hcp_display_settings (stat_type, direction, from_date) VALUES ('" +
						this._displaySettings.stat_type + "', '" + this._displaySettings.direction + "', '" + this._displaySettings.from_date + "')";
			}

			this._sqStatement.execute();
		}

		private function setHcpDisplaySettingsHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_DISPLAY_SETTINGS_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getHcpAlertSettings():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM hcp_alert_settings";
			this._sqStatement.addEventListener(SQLEvent.RESULT, getHcpAlertSettingsHandler);
			this._sqStatement.execute();
		}

		private function getHcpAlertSettingsHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			trace("sqlResultHandler " + e);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_ALERT_SETTINGS_LOAD_COMPLETE);
			evt.data.settings = result;
			this.dispatchEvent(evt);
		}

		public function setHcpAlertSettings(alertSettings:Object):void
		{
			this._alertSettings = alertSettings;

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM hcp_alert_settings";
			this._sqStatement.addEventListener(SQLEvent.RESULT, checkHcpAlertSettingsHandler);
			this._sqStatement.execute();
		}

		private function checkHcpAlertSettingsHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, setHcpAlertSettingsHandler);

			try
			{
				if(result != null)
				{
					this._sqStatement.text = "UPDATE hcp_alert_settings SET requests='" +
							this._alertSettings.requests + "', adherence='" +
							this._alertSettings.adherence + "', tolerability='" +
							this._alertSettings.tolerability + "'";
				}
				else
				{
					this._sqStatement.text = "INSERT INTO hcp_alert_settings (requests, adherence, tolerability) VALUES ('" +
							this._alertSettings.requests + "', '" + this._alertSettings.adherence + "', '" + this._alertSettings + "')";
				}
			}
			catch(e:Error)
			{
				this._sqStatement.text = "INSERT INTO hcp_alert_settings (requests, adherence, tolerability) VALUES ('" +
						this._alertSettings.requests + "', '" + this._alertSettings.adherence + "', '" + this._alertSettings + "')";
			}

			this._sqStatement.execute();
		}

		private function setHcpAlertSettingsHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_ALERT_SETTINGS_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getHCPConnections():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM patient_connection";
			this._sqStatement.addEventListener(SQLEvent.RESULT, getHcpConnectionsHandler);
			this._sqStatement.execute();

		}

		private function getHcpConnectionsHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE);
			evt.data.connections = result;
			this.dispatchEvent(evt);
		}

		public function deleteHCPConnection(appid:String):void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "DELETE FROM patient_connection WHERE appid=" + appid;
			this._sqStatement.addEventListener(SQLEvent.RESULT, deleteHcpConnectionHandler);
			this._sqStatement.execute();

		}

		private function deleteHcpConnectionHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_CONNECTION_DELETE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function resetApplication():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "DELETE FROM app_settings";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, sqlResultHandler);
			this._sqStatement.execute();

			_appDataVO = null;
			_appDataVO = new AppDataVO();
			_appDataVO._userAppType = HivivaLocalStoreService.APP_FIRST_TIME_USE;
		}


		public function get appDataVO ():AppDataVO
		{
			return _appDataVO;
		}

	}
}
