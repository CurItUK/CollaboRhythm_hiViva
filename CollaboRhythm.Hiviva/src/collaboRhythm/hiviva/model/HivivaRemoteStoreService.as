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

		public function addUserMedication(medicationName:String , medicationSchedule:String):void
		{
			var query:String = "userGuid=" + HivivaStartup.userVO.guid + "&medicationInformation=medicationname:" + medicationName + "," + "schedule:" + medicationSchedule;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_ADD_MEDICATION + query);
			trace("AddUserMedication " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, addUserMedicationCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function addUserMedicationCompleteHandler(e:Event):void
		{
			this.dispatchEvent(new RemoteDataStoreEvent(RemoteDataStoreEvent.ADD_MEDICATION_COMPLETE));
		}

		public function deleteMedication(medicationId:String):void
		{
			var query:String = "userMedicationGuid=" + medicationId;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_DELETE_MEDICATION + query);
			trace("deleteMedication " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, deleteUserMedicationCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function deleteUserMedicationCompleteHandler(e:Event):void
		{
			this.dispatchEvent(new RemoteDataStoreEvent(RemoteDataStoreEvent.DELETE_PATIENT_MEDICATION_COMPLETE));
		}

		public function getPatientMedicationList():void
		{
			var query:String = "userGuid=" + HivivaStartup.userVO.guid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_GET_PATIENT_MEDICATION + query);
			trace("getPatientMedicationList " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getPatientMedicationListComplete);
			urlLoader.load(urlRequest);
		}

		private function getPatientMedicationListComplete(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function getHCP(appID:String):void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_GET_HCP + "AppId=" + appID);
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
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_GET_PATIENT + "AppId=" + appID);
			trace("getPatient " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getPatientCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function getPatientCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_PATIENT_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function establishConnection(fromGuid:String , toGuid:String):void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_CONNECTION_ESTABLISH + "From=" + fromGuid + "&To=" + toGuid);
			trace("establishConnection " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, establishConnectionCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function establishConnectionCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.ESTABLISH_CONNECTION_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function approveConnection(fromGuid:String):void
		{
			var query:String = "From=" + fromGuid + "&To=" + HivivaStartup.userVO.guid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_CONNECTION_APPROVE + query);
			trace("approveConnection " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, approveConnectionHandler);
			urlLoader.load(urlRequest);
		}

		private function approveConnectionHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.CONNECTION_APPROVE_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function getApprovedConnections():void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_GET_APPROVED_CONNECTIONS + "UserGuid=" + HivivaStartup.userVO.guid);
			trace("getApprovedConections " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getApprovedConectionsHandler);
			urlLoader.load(urlRequest);
		}

		private function getApprovedConectionsHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function getPendingConnections():void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_GET_PENDING_CONNECTIONS + "UserGuid=" + HivivaStartup.userVO.guid);
			trace("getPendingConnections " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getPendingConnectionsHandler);
			urlLoader.load(urlRequest);
		}

		private function getPendingConnectionsHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function getHCPSentMessages():void
		{
			var query:String = "From=" + HivivaStartup.userVO.guid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_GET_HCP_SENT_MESSAGES + query);
			trace("getHCPSentMessages " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getHCPSentMessagesComplete);
			urlLoader.load(urlRequest);
		}

		private function getHCPSentMessagesComplete(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_HCP_SENT_MESSAGES_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function getUserReceivedMessages():void
		{
			var query:String = "To=" + HivivaStartup.userVO.guid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_GET_USER_RECEIVED_MESSAGES + query);
			trace("getUserReceivedMessages " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getUserReceivedMessagesComplete);
			urlLoader.load(urlRequest);
		}

		private function getUserReceivedMessagesComplete(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function getMessages():void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_GET_MESSAGES);
			trace("getMessages " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getMessagesComplete);
			urlLoader.load(urlRequest);
		}

		private function getMessagesComplete(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_MESSAGES_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function sendUserMessage(toGuid:String,messageGuid:String):void
		{
			var query:String = "From=" + HivivaStartup.userVO.guid + "&To=" + toGuid + "&MessageGuid=" + messageGuid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_SEND_USER_MESSAGE + query);
			trace("sendUserMessage " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, sendUserMessageComplete);
			urlLoader.load(urlRequest);
		}

		private function sendUserMessageComplete(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.SEND_USER_MESSAGE_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function deleteUserMessage(messageGuid:String):void
		{
			var query:String = "MessageGuid=" + messageGuid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_DELETE_USER_MESSAGE + query);
			trace("deleteUserMessage " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, deleteUserMessageComplete);
			urlLoader.load(urlRequest);
		}

		private function deleteUserMessageComplete(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.DELETE_USER_MESSAGE_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}
	}
}




