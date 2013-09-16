package collaboRhythm.hiviva.model
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.model.vo.ConnectionsVO;
	import collaboRhythm.hiviva.model.vo.GalleryDataVO;
	import collaboRhythm.hiviva.model.vo.PatientAdherenceVO;
	import collaboRhythm.hiviva.model.vo.ReportVO;
	import collaboRhythm.hiviva.model.vo.UserAuthenticationVO;
	import collaboRhythm.hiviva.model.vo.UserVO;
	import collaboRhythm.hiviva.utils.HivivaModifier;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;
	import flash.events.SQLEvent;
	import flash.filesystem.File;


	public class HivivaLocalStoreService extends EventDispatcher
	{
		private var _sqStatement:SQLStatement;
		private var _sqConn:SQLConnection;

		private var _medicationSchedule:Array;
		private var _galleryImageUrls:Array;
		private var _medicationAdherenceToSet:Object;
		private var _testResultsToSet:Object;
		private var _medicationIdToDelete:int;
		private var _patientProfile:Object;
		private var _hcpProfile:Object;
		private var _displaySettings:Object;
		private var _alertSettings:Object;
		private var _viewedMessagesIds:Array;
		private var _userVO:UserVO;
		private var _reportVO:ReportVO;
		private var _patientAdherenceVO:PatientAdherenceVO;
		private var _connectionsVO:ConnectionsVO;
		private var _galleryDataVO:GalleryDataVO;
		private var _userAuthenticationVO:UserAuthenticationVO;

		public function HivivaLocalStoreService()
		{
			this._userVO = new UserVO();
			this._reportVO = new ReportVO();
			this._patientAdherenceVO = new PatientAdherenceVO();
			this._connectionsVO = new ConnectionsVO();
			this._galleryDataVO = new GalleryDataVO();
			this._userAuthenticationVO = new UserAuthenticationVO();
		}

		public function initDataLoad():void
		{
			if(getDBExits())
			{
				loadAppData();
			}
			else
			{
				createUserSettingsDatabase();
			}
		}

		private function loadAppData():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.addEventListener(SQLEvent.OPEN, dataFileOpenHandler);
			this._sqConn.open(dbFile);
		}

		private function getDBExits():Boolean
		{
			var localSettingsFile:File = File.applicationStorageDirectory;
			localSettingsFile = localSettingsFile.resolvePath("settings.sqlite");

			return localSettingsFile.exists;
		}

		public function resetApplication():void
		{
			this._sqConn.addEventListener(SQLEvent.CLOSE, dataFileCloseHandler);
			this._sqConn.close();
		}

		private function dataFileCloseHandler(e:SQLEvent):void
		{
			this._sqConn = null;
			var sourceFile:File = File.applicationDirectory.resolvePath("resources/settings.sqlite");
			var destination:File = File.applicationStorageDirectory.resolvePath("settings.sqlite");
			sourceFile.copyTo(destination , true);

			var reportSource:File = File.applicationDirectory.resolvePath("resources/report_template");
			var reportDestination:File = File.applicationStorageDirectory.resolvePath("report_template");
			reportSource.copyTo(reportDestination , true);

			this._userVO = null;
			this._userVO = new UserVO();
			this._userVO.type = Constants.APP_FIRST_TIME_USE;

			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.APPLICATION_RESET_COMPLETE);
			this.dispatchEvent(evt);
		}

		private function dataFileOpenHandler(e:SQLEvent):void
		{
			this._sqConn.removeEventListener(SQLEvent.OPEN, dataFileOpenHandler);
			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "SELECT * FROM app_settings";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, getAppSettingsHandler);
			this._sqStatement.execute();
		}

		private function getAppSettingsHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;

			if(result[0].profile_type == "appFirstTimeUse")
			{
				this._userVO.type = Constants.APP_FIRST_TIME_USE;
			} else
			{
				this._userVO.type = result[0].profile_type;
				this._userVO.appId= result[0].app_id;
				this._userVO.guid= result[0].guid;
			}

			getUserAuthenticationDetails();
		}



		private function sqlResultHandler(e:SQLEvent):void
		{
			trace("sqlResultHandler " + e);
		}

		public function setTypeAppIdGuidId(appId:String , guid:String , type:String):void
		{
			this._userVO.type = type;
			this._userVO.appId= appId;
			this._userVO.guid= guid;


			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "UPDATE app_settings SET profile_type='" + type + "' , app_id='" + appId + "' , guid='" + guid + "'";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, sqlResultHandler);
			this._sqStatement.execute();

			this.dispatchEvent(new LocalDataStoreEvent(LocalDataStoreEvent.APP_ID_SAVE_COMPLETE));
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

			this._userVO.type = Constants.APP_FIRST_TIME_USE;
			this._userAuthenticationVO.enabled = false;

			// move reports template to application storage directory for future writable access

			var reportSource:File = File.applicationDirectory.resolvePath("resources/report_template");
			var reportDestination:File = File.applicationStorageDirectory.resolvePath("report_template");
			reportSource.copyTo(reportDestination);


		}

		public function setConnectedPatientsFromXml(xmlResponse:XML):void
		{
			var xmlData:XMLList = xmlResponse.DCConnectionSummary;
			var loop:uint = xmlData.length();
			var approvedPatient:XML;

			this._connectionsVO.users = [];

			if(loop > 0)
			{
				for(var i:uint = 0 ; i <loop ; i++)
				{
					approvedPatient = xmlData[i];
					var establishedUser:Object = HivivaModifier.establishToFromId(approvedPatient);
					var appGuid:String = establishedUser.appGuid;
					var appId:String = establishedUser.appId;
					var adherence:String = approvedPatient.Adherence;
					var tolerability:String = approvedPatient.Tolerability;

					var data:XML = new XML
					(
							<patient>
								<name>{appId}</name>
								<email>{appId}@domain.com</email>
								<appid>{appId}</appid>
								<guid>{appGuid}</guid>
								<tolerability>{tolerability}</tolerability>
								<adherence>{adherence}</adherence>
								<picture>dummy.png</picture>
							</patient>
					);
					this._connectionsVO.users.push(data);
				}
			}

			trace('connectionsVO.users updated');
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
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE);
			evt.data.imageUrls = result;
			this.dispatchEvent(evt);
		}

		public function setGalleryImages(imageUrls:Array):void
		{
			this._galleryImageUrls = imageUrls;

//			if(this._galleryImageUrls.length > 0)
			{
				var dbFile:File = File.applicationStorageDirectory;
				dbFile = dbFile.resolvePath("settings.sqlite");

				this._sqConn = new SQLConnection();
				this._sqConn.open(dbFile);

				this._sqStatement = new SQLStatement();
				if(this._galleryImageUrls.length > 0)
				{
					this._sqStatement.addEventListener(SQLEvent.RESULT, deleteGalleryImagesHandler);
				}
				else
				{
					this._sqStatement.addEventListener(SQLEvent.RESULT, setGalleryImagesHandler);
				}
				this._sqStatement.text = "DELETE FROM homepage_photos";
				this._sqStatement.sqlConnection = this._sqConn;
				this._sqStatement.execute();
			}
		}

		private function deleteGalleryImagesHandler(e:SQLEvent):void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.addEventListener(SQLEvent.RESULT, setGalleryImagesHandler);

			var urlsLoop:uint = this._galleryImageUrls.length;
			for (var i:uint = 0; i < urlsLoop; i++)
			{
				if (i == 0)
				{
					this._sqStatement.text += "INSERT INTO homepage_photos ('url') SELECT '" + this._galleryImageUrls[i] + "'";
				}
				else
				{
					this._sqStatement.text += " UNION SELECT '" + this._galleryImageUrls[i] + "'";
				}
			}

			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();
		}

		private function setGalleryImagesHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.GALLERY_IMAGES_SAVE_COMPLETE);
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
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE);
			evt.data.timeStamp = result[0].gallery_submission_timestamp;
			this.dispatchEvent(evt);
		}

		public function setGalleryTimeStamp(date:String):void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.addEventListener(SQLEvent.RESULT, setGalleryTimeStampHandler);
			this._sqStatement.text = "UPDATE app_settings SET gallery_submission_timestamp='" + date + "'";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();
		}

		private function setGalleryTimeStampHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.GALLERY_TIMESTAMP_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getViewedSettingsAnimation():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.addEventListener(SQLEvent.RESULT, getViewedSettingsAnimationHandler);
			this._sqStatement.text = "SELECT viewed_settings_animation FROM app_settings";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();
		}

		private function getViewedSettingsAnimationHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.VIEWED_SETTINGS_ANIMATION_LOAD_COMPLETE);
			evt.data.settingsAnimationIsViewed = result[0].viewed_settings_animation;
			this.dispatchEvent(evt);
		}

		public function setViewedSettingsAnimation():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.addEventListener(SQLEvent.RESULT, setViewedSettingsAnimationHandler);
			this._sqStatement.text = "UPDATE app_settings SET viewed_settings_animation='true'";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();
		}

		private function setViewedSettingsAnimationHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.VIEWED_SETTINGS_ANIMATION_SAVE_COMPLETE);
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
			this._sqStatement.addEventListener(SQLEvent.RESULT, setAdherenceResultHandler);
			this._sqStatement.execute();
		}

		private function setAdherenceResultHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.ADHERENCE_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getTestResults():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "SELECT * FROM test_results";
			this._sqStatement.addEventListener(SQLEvent.RESULT, getTestResultsResultHandler);
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();
		}

		private function getTestResultsResultHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			trace("sqlResultHandler " + e);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.TEST_RESULTS_LOAD_COMPLETE);
			evt.data.adherence = result;
			this.dispatchEvent(evt);
		}

		public function setTestResults(testResults:Object):void
		{
			_testResultsToSet = testResults;

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM test_results";
			this._sqStatement.addEventListener(SQLEvent.RESULT, checkTestResultsResultHandler);
			this._sqStatement.execute();
		}

		private function checkTestResultsResultHandler(e:SQLEvent):void
		{
			/*
				this._sqStatement = new SQLStatement();
				this._sqStatement.sqlConnection = this._sqConn;

				trace(this._sqStatement.text);
				this._sqStatement.addEventListener(SQLEvent.RESULT, setTestResultsResultHandler);
				this._sqStatement.execute();
				*/
		}

		private function setTestResultsResultHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.TEST_RESULTS_SAVE_COMPLETE);
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

		public function addHCPConnection(patient:Object):void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "INSERT INTO patient_connection (name, email, appid, picture) VALUES (" +
					patient.name + ", " + patient.email + ", " + patient.appid + ", " + patient.picture + ")";

			trace(this._sqStatement.text);
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, addHCPConnectionHandler);
			this._sqStatement.execute();
		}

		private function addHCPConnectionHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.HCP_CONNECTION_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getPatientConnections():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "SELECT * FROM hcp_connection";
			this._sqStatement.addEventListener(SQLEvent.RESULT, getPatientConnectionsHandler);
			this._sqStatement.execute();

		}

		private function getPatientConnectionsHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_CONNECTIONS_LOAD_COMPLETE);
			evt.data.connections = result;
			this.dispatchEvent(evt);
		}

		public function deletePatientConnection(appid:String):void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.text = "DELETE FROM hcp_connection WHERE appid=" + appid;
			this._sqStatement.addEventListener(SQLEvent.RESULT, deletePatientConnectionHandler);
			this._sqStatement.execute();

		}

		private function deletePatientConnectionHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_CONNECTION_DELETE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function addPatientConnection(hcp:Object):void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "INSERT INTO hcp_connection (name, email, appid, picture) VALUES ('" +
					hcp.name + "', '" + hcp.email + "', '" + hcp.appid + "', '" + hcp.picture + "')";
			/*this._sqStatement.text = "UPDATE hcp_connection SET name='" +
								hcp.name + "', email='" + hcp.email + "', appid='" + hcp.appid + "', picture='" + hcp.picture + "'";*/

			trace(this._sqStatement.text);
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, addPatientConnectionHandler);
			this._sqStatement.execute();
		}

		private function addPatientConnectionHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_CONNECTION_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function loadPatientMessagesViewed():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "SELECT viewed_ids FROM patient_messages";

			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, loadPatientMessagesViewedHandler);
			this._sqStatement.execute();
		}

		private function loadPatientMessagesViewedHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_MESSAGES_VIEWED_LOAD_COMPLETE);
			evt.data.viewedIds = result;
			this.dispatchEvent(evt);
		}

		public function savePatientMessagesViewed(viewedIds:Array):void
		{
			this._viewedMessagesIds = viewedIds;

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "DELETE FROM patient_messages";

			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, deletePatientMessagesViewedHandler);
			this._sqStatement.execute();
		}

		private function deletePatientMessagesViewedHandler(e:SQLEvent):void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();

			this._sqStatement.text = "INSERT INTO patient_messages (viewed_ids) VALUES ('" + this._viewedMessagesIds.join(",") + "')";

			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, savePatientMessagesViewedHandler);
			this._sqStatement.execute();
		}

		private function savePatientMessagesViewedHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_MESSAGES_VIEWED_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getPatientKudosData():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();

			this._sqStatement.text = "SELECT * FROM patient_kudos";

			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, loadPatientKudosDataCompleteHandler);
			this._sqStatement.execute();
		}

		private function loadPatientKudosDataCompleteHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_LOAD_KUDOS_COMPLETE);
			evt.data.kudos = result;
			this.dispatchEvent(evt);
		}

		public function savePatientKudosData(date:String , count:String):void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "UPDATE patient_kudos SET medication_take_date='" + date + "' , count='" + count + "'";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, savePatientKudosDataCompleteHandler);
			this._sqStatement.execute();
		}

		private function savePatientKudosDataCompleteHandler(e:SQLEvent):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_SAVE_KUDOS_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function updatePatientBadges(id:uint):void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "UPDATE patient_badges SET badge_attained='true' , badge_viewed=false WHERE id='"+ id + "'";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();
		}

		public function getPatientBadges():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "SELECT * FROM patient_badges";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, loadPatientbadgesCompleteHandler);
			this._sqStatement.execute();
		}

		private function loadPatientbadgesCompleteHandler(e:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PATIENT_LOAD_BADGES_COMPLETE);
			evt.data.badges = result;
			this.dispatchEvent(evt);
		}

		public function clearDownBadgeAlerts():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "UPDATE patient_badges SET badge_viewed='true'";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, loadPatientbadgesCompleteHandler);
			this._sqStatement.execute();
		}

		public function enableDisablePasscode(b:Boolean):void
		{

		}

		public function savePasscodeDetails(passcode:String, answer:String ,  questionId:uint):void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "UPDATE user_authentication SET enabled='" + true + "' , passcode='" + passcode + "' , secret_answer='" + answer + "' , question_id='" + questionId + "'" ;
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, savePasscodeDetailsCompleteHandler);
			this._sqStatement.execute();
		}

		private function savePasscodeDetailsCompleteHandler(e:SQLEvent):void
		{
			userAuthenticationVO.enabled = true;
			this.dispatchEvent(new LocalDataStoreEvent(LocalDataStoreEvent.PASSCODE_SAVE_DETAILS_COMPLETE));
		}

		private function getUserAuthenticationDetails():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "SELECT * FROM user_authentication";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, userAuthenticationHandler);
			this._sqStatement.execute();
		}

		private function userAuthenticationHandler(event:SQLEvent):void
		{
			var result:Array = this._sqStatement.getResult().data;

			if(result[0].enabled == true)
			{
				userAuthenticationVO.enabled = true;
				userAuthenticationVO.passcode = result[0].passcode;
				userAuthenticationVO.answer = result[0].secret_answer;
				userAuthenticationVO.questionId = result[0].question_id;

			} else
			{
				userAuthenticationVO.enabled = false;
			}

		}

		public function get userVO():UserVO
		{
			return this._userVO;
		}

		public function get reportVO():ReportVO
		{
			return this._reportVO;
		}

		public function get patientAdherenceVO():PatientAdherenceVO
		{
			return this._patientAdherenceVO;
		}

		public function get connectionsVO():ConnectionsVO
		{
			return this._connectionsVO;
		}

		public function get galleryDataVO():GalleryDataVO
		{
			return this._galleryDataVO;
		}

		public function get userAuthenticationVO():UserAuthenticationVO
		{
			return _userAuthenticationVO;
		}

		public function set userAuthenticationVO(value:UserAuthenticationVO):void
		{
			_userAuthenticationVO = value;
		}



	}
}
