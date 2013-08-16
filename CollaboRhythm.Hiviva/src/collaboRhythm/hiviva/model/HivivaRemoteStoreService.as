package collaboRhythm.hiviva.model
{
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteServiceAPI;
	import collaboRhythm.hiviva.view.HivivaStartup;

	import flash.events.Event;

	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class HivivaRemoteStoreService extends EventDispatcher
	{
		//private static const RS_BASE_URL:String = "http://McGoohan/PWS.Health.Service/Services/";
//		private static const RS_BASE_URL:String = "http://pwshealthtest.dev/services/";
		private static const RS_BASE_URL:String = "http://collaborythm.pharmiwebsolutions.com/services/";

		public function HivivaRemoteStoreService()
		{


		}

		public function createUser(appType:String):void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_CREATE_USER + appType);
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
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_ADD_MEDICATION + query);
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
			var query:String = "userMedicationGuid=" + medicationId + "&userGuid=" + HivivaStartup.userVO.guid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_DELETE_MEDICATION + query);
			trace("deleteMedication " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, deleteUserMedicationCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function deleteUserMedicationCompleteHandler(e:Event):void
		{
			this.dispatchEvent(new RemoteDataStoreEvent(RemoteDataStoreEvent.DELETE_PATIENT_MEDICATION_COMPLETE));
		}

		public function takeMedication(medicationData:XML):void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_TAKE_PATIENT_MEDICATION);
			urlRequest.data = medicationData.toXMLString();
			urlRequest.contentType = "text/xml";
			urlRequest.method = URLRequestMethod.POST;

			trace("takeMedication " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, takeMedicationCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function takeMedicationCompleteHandler(e:Event):void
		{
			this.dispatchEvent(new RemoteDataStoreEvent(RemoteDataStoreEvent.TAKE_PATIENT_MEDICATION_COMPLETE));
		}

		public function getNumberDaysAdherence():void
		{
			var query:String = "userGuid=" + HivivaStartup.userVO.guid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_NUMBER_DAYS_ADHERENCE + query);
			trace("getNumberDaysAdherence " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getNumberDaysAdherenceComplete);
			urlLoader.load(urlRequest);
		}

		private function getNumberDaysAdherenceComplete(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_NUMBER_DAYS_ADHERENCE_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function getServerDate():void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_SERVER_DATE);
//			var urlRequest:URLRequest = new URLRequest("http://flashdev1/test/currentdatetime.xml");
			trace("getServerDate " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getServerDateComplete);
			urlLoader.load(urlRequest);
		}

		private function getServerDateComplete(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_SERVER_DATE_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function getPatientMedicationList():void
		{
			var query:String = "userGuid=" + HivivaStartup.userVO.guid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_PATIENT_MEDICATION + query);
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
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_HCP + "AppId=" + appID);
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
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_PATIENT + "AppId=" + appID);
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
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_CONNECTION_ESTABLISH + "From=" + fromGuid + "&To=" + toGuid);
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
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_CONNECTION_APPROVE + query);
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

		public function deleteConnection(fromGuid:String , toGuid:String):void
		{
			var query:String = "From=" + fromGuid + "&To=" + toGuid + "&deletedByGuid=" + HivivaStartup.userVO.guid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_CONNECTION_DELETE + query);
			trace("deleteConnection " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, deleteConnectionHandler);
			urlLoader.load(urlRequest);
		}

		private function deleteConnectionHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.CONNECTION_DELETE_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function getApprovedConnections():void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_APPROVED_CONNECTIONS + "UserGuid=" + HivivaStartup.userVO.guid);
			trace("getApprovedConnections " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getApprovedConnectionsHandler);
			urlLoader.load(urlRequest);
		}

		private function getApprovedConnectionsHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function getApprovedConnectionsWithSummary():void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_APPROVED_CONNECTIONS_WITH_SUMMARY + "UserGuid=" + HivivaStartup.userVO.guid);
			trace("getApprovedConnectionsWithSummary " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getApprovedConnectionsWithSummaryHandler);
			urlLoader.load(urlRequest);
		}

		private function getApprovedConnectionsWithSummaryHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.service.setConnectedPatientsFromXml(xmlResponse);

			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_WITH_SUMMARY_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt);
		}

		public function getPendingConnections():void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_PENDING_CONNECTIONS + "UserGuid=" + HivivaStartup.userVO.guid);
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
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_HCP_SENT_MESSAGES + query);
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
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_USER_RECEIVED_MESSAGES + query);
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
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_MESSAGES);
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

		public function getPatientBadgeAlerts():void
		{
			var query:String = "userGuid=" + HivivaStartup.userVO.guid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_PATIENT_BADGE_ALERTS + query);
			trace("getPatientBadgeAlerts " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getPatientBadgeAlertsComplete);
			urlLoader.load(urlRequest);
		}

		private function getPatientBadgeAlertsComplete(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_PATIENT_BADGE_ALERTS_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function getHCPAlerts():void
		{
			var query:String = "hcpUserGuid=" + HivivaStartup.userVO.guid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_HCP_ALERTS + query);
			trace("getHCPAlerts " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getHCPAlertsComplete);
			urlLoader.load(urlRequest);
		}

		private function getHCPAlertsComplete(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_HCP_ALERTS_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function markAlertMessageAsRead(alertMessageGuid:String):void
		{
			var query:String = "alertMessageGuid=" + alertMessageGuid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_MARK_ALERT_MESSAGE_AS_READ + query);
			trace("markAlertMessageAsRead " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, markAlertMessageAsReadComplete);
			urlLoader.load(urlRequest);
		}

		private function markAlertMessageAsReadComplete(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.MARK_ALERT_MESSAGE_AS_READ_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function sendUserMessage(toGuid:String, messageGuid:String):void
		{
			var query:String = "From=" + HivivaStartup.userVO.guid + "&To=" + toGuid + "&MessageGuid=" + messageGuid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_SEND_USER_MESSAGE + query);
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
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_DELETE_USER_MESSAGE + query);
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

		public function markMessageAsRead(messageGuid:String):void
		{
			var query:String = "MessageGuid=" + messageGuid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_MARK_MESSAGE_AS_READ + query);
			trace("markMessageAsRead " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, markMessageAsReadComplete);
			urlLoader.load(urlRequest);
		}

		private function markMessageAsReadComplete(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.MARK_MESSAGE_AS_READ_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function addTestResults(testResultData:XML):void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_ADD_TEST_RESULTS );
			urlRequest.data = testResultData.toXMLString();
			urlRequest.contentType = "text/xml";
			urlRequest.method = URLRequestMethod.POST;

			trace("addTestResults " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, addTestResultsCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function addTestResultsCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.ADD_TEST_RESULTS_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt)
		}

		public function getPatientLastTestResult(testData:String):void
		{
			var query:String = "userGuid=" + HivivaStartup.userVO.guid + "&testDescriptions=" + testData;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_PATIENT_LATEST_RESULTS + query);
			trace("getPatientLastTestResult " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getPatientLatestTestResultsCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function getPatientLatestTestResultsCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_PATIENT_LATEST_RESULTS_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt);
		}

		public function getPatientTestResultsRange(userGuid:String, startIsoDate:String, endIsoDate:String):void
		{
			var query:String = "userGuid=" + userGuid + "&startDate=" + startIsoDate + "&endDate=" + endIsoDate;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_PATIENT_RESULTS_RANGE + query);
			trace("getPatientTestResultsRange " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getPatientTestResultsRangeCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function getPatientTestResultsRangeCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_PATIENT_RESULTS_RANGE_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt);
		}

		public function getUserMedicationHistory(userGuid:String):void
		{
			var query:String = "userGuid=" + userGuid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_USER_MEDICATION_HISTORY + query);
			trace("getUserMedicationHistory " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getUserMedicationHistoryCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function getUserMedicationHistoryCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_USER_MEDICATION_HISTORY_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt);
		}

		public function getDailyMedicationHistory(userGuid:String):void
		{
			var query:String = "userGuid=" + userGuid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_DAILY_MEDICATION_HISTORY + query);
			trace("getDailyMedicationHistory " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getDailyMedicationHistoryCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function getDailyMedicationHistoryCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_DAILY_MEDICATION_HISTORY_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt);
		}

		public function getDailyMedicationHistoryRange(userGuid:String, startIsoDate:String, endIsoDate:String):void
		{
			var query:String = "userGuid=" + userGuid + "&startDate=" + startIsoDate + "&endDate=" + endIsoDate;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_DAILY_MEDICATION_HISTORY_RANGE + query);
			trace("getDailyMedicationHistoryRange " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getDailyMedicationHistoryRangeCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function getDailyMedicationHistoryRangeCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_DAILY_MEDICATION_HISTORY_RANGE_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt);
		}

		public function getWeeklyMedicationHistory(userGuid:String):void
		{
			var query:String = "userGuid=" + userGuid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_WEEKLY_MEDICATION_HISTORY + query);
			trace("getWeeklyMedicationHistory " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getWeeklyMedicationHistoryCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function getWeeklyMedicationHistoryCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_WEEKLY_MEDICATION_HISTORY_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt);
		}

		public function getAllWeeklyMedicationHistory(noOfWeeks:int):void
		{
			var query:String = "userGuid=" + HivivaStartup.userVO.guid + "&numberOfWeeks=" + noOfWeeks;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_ALL_WEEKLY_MEDICATION_HISTORY + query);
			trace("getAllWeeklyMedicationHistory " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getAllWeeklyMedicationHistoryCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function getAllWeeklyMedicationHistoryCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_ALL_WEEKLY_MEDICATION_HISTORY_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt);
		}

		public function getUserDisplaySettings():void
		{
			var query:String = "userGuid=" + HivivaStartup.userVO.guid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_DISPLAY_SETTINGS + query);
			trace("getUserDisplaySettings " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getUserDisplaySettingsCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function getUserDisplaySettingsCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_DISPLAY_SETTINGS_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt);
		}

		public function addUserDisplaySettings(displaySettings:XML):void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_ADD_DISPLAY_SETTINGS);
			urlRequest.data = displaySettings.toXMLString();
			urlRequest.contentType = "text/xml";
			urlRequest.method = URLRequestMethod.POST;

			trace("addUserDisplaySettings " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, addUserDisplaySettingsCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function addUserDisplaySettingsCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			trace(xmlResponse);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.ADD_DISPLAY_SETTINGS_COMPLETE);
			this.dispatchEvent(evt);
		}


		public function getUserAlertSettings():void
		{
			var query:String = "userGuid=" + HivivaStartup.userVO.guid;
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_GET_ALERT_SETTINGS + query);
			trace("getUserAlertSettings " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getUserAlertSettingsCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function getUserAlertSettingsCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_ALERT_SETTINGS_COMPLETE);
			evt.data.xmlResponse = xmlResponse;
			this.dispatchEvent(evt);
		}

		public function addUserAlertSettings(alertSettings:XML):void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL + RemoteServiceAPI.RS_ADD_ALERT_SETTINGS);
			urlRequest.data = alertSettings.toXMLString();
			urlRequest.contentType = "text/xml";
			urlRequest.method = URLRequestMethod.POST;

			trace("addUserAlertSettings " + urlRequest.url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, addUserAlertSettingsCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function addUserAlertSettingsCompleteHandler(e:Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			trace(xmlResponse);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.ADD_ALERT_SETTINGS_COMPLETE);
			this.dispatchEvent(evt);
		}
	}
}




