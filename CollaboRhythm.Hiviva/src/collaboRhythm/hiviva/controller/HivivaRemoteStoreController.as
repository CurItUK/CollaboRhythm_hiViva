package collaboRhythm.hiviva.controller
{
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.model.HivivaRemoteStoreService;

	import flash.events.Event;
	import flash.events.EventDispatcher;


	public class HivivaRemoteStoreController extends EventDispatcher
	{
		private var _hivivaRemoteStoreService:HivivaRemoteStoreService;

		public function HivivaRemoteStoreController()
		{
			trace("HivivaRemoteStoreController construct");
		}

		public function initStoreService():void
		{
			_hivivaRemoteStoreService = new HivivaRemoteStoreService();

		}

		public function createUser(appType:String):void
		{
			service.addEventListener(RemoteDataStoreEvent.CREATE_USER_COMPLETE , userCreateCompleteHandler);
			service.createUser(appType);
		}

		private function userCreateCompleteHandler(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.CREATE_USER_COMPLETE , userCreateCompleteHandler);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.CREATE_USER_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function addUserMedication(medicationName:String , medicationSchedule:String):void
		{
			service.addEventListener(RemoteDataStoreEvent.ADD_MEDICATION_COMPLETE , addMedicationCompleteHandler);
			service.addUserMedication(medicationName, medicationSchedule);
		}

		private function addMedicationCompleteHandler(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.ADD_MEDICATION_COMPLETE , addMedicationCompleteHandler);
			this.dispatchEvent(new RemoteDataStoreEvent(RemoteDataStoreEvent.ADD_MEDICATION_COMPLETE));
		}

		public function getPatientMedicationList():void
		{
			service.addEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			service.getPatientMedicationList();
		}

		private function getPatientMedicationListComplete(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function getHCP(appGuid:String):void
		{
			service.addEventListener(RemoteDataStoreEvent.GET_HCP_COMPLETE , getHCPCompleteHandler);
			service.getHCP(appGuid);
		}

		private function getHCPCompleteHandler(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.GET_HCP_COMPLETE , getHCPCompleteHandler);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_HCP_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function getPatient(appGuid:String):void
		{
			service.addEventListener(RemoteDataStoreEvent.GET_PATIENT_COMPLETE , getPatientCompleteHandler);
			service.getPatient(appGuid);
		}

		private function getPatientCompleteHandler(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_COMPLETE , getHCPCompleteHandler);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_PATIENT_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function establishConnection(fromGuid:String , toGuid:String):void
		{
			service.addEventListener(RemoteDataStoreEvent.ESTABLISH_CONNECTION_COMPLETE , establishConnectionCompleteHandler);
			service.establishConnection(fromGuid , toGuid);
		}

		private function establishConnectionCompleteHandler(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.ESTABLISH_CONNECTION_COMPLETE , establishConnectionCompleteHandler);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.ESTABLISH_CONNECTION_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function approveConnection(fromGuid:String):void
		{
			service.addEventListener(RemoteDataStoreEvent.CONNECTION_APPROVE_COMPLETE , approveConnectionHandler);
			service.approveConnection(fromGuid);
		}

		private function approveConnectionHandler(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.CONNECTION_APPROVE_COMPLETE , approveConnectionHandler);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.CONNECTION_APPROVE_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function getApprovedConnections():void
		{
			service.addEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE , getApprovedConectionsHandler);
			service.getApprovedConnections();
		}

		private function getApprovedConectionsHandler(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE , getApprovedConectionsHandler);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function getPendingConnections():void
		{
			service.addEventListener(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE , getPendingConnectionsHandler);
			service.getPendingConnections();
		}

		private function getPendingConnectionsHandler(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE , getPendingConnectionsHandler);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function getHCPSentMessages():void
		{
			service.addEventListener(RemoteDataStoreEvent.GET_HCP_SENT_MESSAGES_COMPLETE , getHCPSentMessagesHandler);
			service.getHCPSentMessages();
		}

		private function getHCPSentMessagesHandler(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.GET_HCP_SENT_MESSAGES_COMPLETE , getHCPSentMessagesHandler);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_HCP_SENT_MESSAGES_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function getUserReceivedMessages():void
		{
			service.addEventListener(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE , getUserReceivedMessagesHandler);
			service.getUserReceivedMessages();
		}

		private function getUserReceivedMessagesHandler(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE , getUserReceivedMessagesHandler);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function getMessages():void
		{
			service.addEventListener(RemoteDataStoreEvent.GET_MESSAGES_COMPLETE , getMessagesHandler);
			service.getMessages();
		}

		private function getMessagesHandler(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.GET_MESSAGES_COMPLETE , getMessagesHandler);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.GET_MESSAGES_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function sendUserMessage(toGuid:String,messageGuid:String):void
		{
			service.addEventListener(RemoteDataStoreEvent.SEND_USER_MESSAGE_COMPLETE , sendUserMessageHandler);
			service.sendUserMessage(toGuid,messageGuid);
		}

		private function sendUserMessageHandler(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.SEND_USER_MESSAGE_COMPLETE , sendUserMessageHandler);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.SEND_USER_MESSAGE_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function deleteUserMessage(messageGuid:String):void
		{
			service.addEventListener(RemoteDataStoreEvent.DELETE_USER_MESSAGE_COMPLETE , deleteUserMessageHandler);
			service.deleteUserMessage(messageGuid);
		}

		private function deleteUserMessageHandler(e:RemoteDataStoreEvent):void
		{
			service.removeEventListener(RemoteDataStoreEvent.DELETE_USER_MESSAGE_COMPLETE , deleteUserMessageHandler);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.DELETE_USER_MESSAGE_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function get service():HivivaRemoteStoreService
		{
			return _hivivaRemoteStoreService;
		}
	}
}
