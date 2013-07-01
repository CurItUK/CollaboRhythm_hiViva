package collaboRhythm.hiviva.model
{
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteServiceAPI;
	import collaboRhythm.hiviva.view.HivivaStartup;

	import flash.events.Event;

	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class HivivaRemoteStoreService extends EventDispatcher
	{
		private static const RS_BASE_URL_DEV:String = "http://pwshealthtest.dev/services/";

		public function HivivaRemoteStoreService()
		{

		}

		public function createUser(appType:String):void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_CREATE_USER + appType);
			trace("createUser " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, createUserCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function createUserCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.CREATE_USER_COMPLETE);
			evt.data.appid = xmlResponse.AppId;
			evt.data.guid = xmlResponse.AppGuid;
			this.dispatchEvent(evt)

		}

		//userGuid=7953E538-28B1-420F-A660-22068ABCBE3F&medicationInformation= medicationname:Atazanavir 300 MG Oral Capsule [Reyataz],schedule:count=1|time=18;count=2|time=12
		public function addUserMedication(medicationName:String , medicationSchedule:String):void
		{
			var query:String = "userGuid=296e8221-9de3-4db8-8fb5-1e129397b041&medicationInformation=medicationname:" + medicationName + "," + "schedule:" + medicationSchedule;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_ADD_MEDICATION + query);
			trace("AddUserMedication " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, addUserMedicationCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function addUserMedicationCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			trace(xmlResponse);
		}

		public function getHCP(appGuid:String):void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_GET_HCP + appGuid);
			trace("getHCP " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getHCPCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function getHCPCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_HCP_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function getPatient(appID:String):void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_GET_PATIENT + appID);
			trace("getPatient " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getPatientCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function getPatientCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			trace(xmlResponse);
		}

		public function establishConnection(from:String , to:String):void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_CONNECTION_ESTABLISH + "From=" + from + "&To=" + to);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, establishConnectionCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function establishConnectionCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			trace(xmlResponse);
		}


	}
}




