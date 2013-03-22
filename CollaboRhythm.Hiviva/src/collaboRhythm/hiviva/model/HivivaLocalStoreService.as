package collaboRhythm.hiviva.model
{
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.vo.AppDataVO;

	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;
	import flash.events.SQLEvent;
	import flash.filesystem.File;

	public class HivivaLocalStoreService extends EventDispatcher
	{
		public static const APP_FIRST_TIME_USE:String					= "appFirstTimeUse";

		private var _sqStatement:SQLStatement;
		private var _sqConn:SQLConnection;
		private var _appDataVO:AppDataVO;

		public function HivivaLocalStoreService()
		{

		}

		public function initDataLoad():void
		{
			var localDocumentsSettingsFile:File = File.applicationStorageDirectory;
			localDocumentsSettingsFile = localDocumentsSettingsFile.resolvePath("settings.sqlite");
			if(localDocumentsSettingsFile.exists)
			{
				loadAppData();
			} else
			{
				createUserDatabase();
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

		private function createUserDatabase():void
		{
			trace("create local user file");

			var sourceFile:File = File.applicationDirectory;
			sourceFile = sourceFile.resolvePath("resources/settings.sqlite");

			var destination:File = File.applicationStorageDirectory;
			destination = destination.resolvePath("settings.sqlite");

			sourceFile.copyTo(destination);

			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.DATA_LOAD_COMPLETE);
			evt.message = HivivaLocalStoreService.APP_FIRST_TIME_USE;
			dispatchEvent(evt);

			_appDataVO = new AppDataVO();
			_appDataVO._userAppType = HivivaLocalStoreService.APP_FIRST_TIME_USE;


		}

		private function dataFileOpenHandler(e:SQLEvent):void
		{
			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "SELECT * FROM app_settings";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();

			/*
			var dataObj:Object = new Object(); //new Object();
			dataObj.userAppType = this._sqStatement.getResult().data[0];
			appLocalData = new AppDataVO(dataObj);
			*/

			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.DATA_LOAD_COMPLETE);
			evt.message = "dataLoaded";
			dispatchEvent(evt);
		}

		public function get appDataVO ():AppDataVO
		{
			return _appDataVO;
		}

		public function set appDataVO (value:AppDataVO):void
		{
			_appDataVO = value;
		}
	}
}
