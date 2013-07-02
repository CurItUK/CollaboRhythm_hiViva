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
			this.dispatchEvent(evt)
		}

		public function get service():HivivaRemoteStoreService
		{
			return _hivivaRemoteStoreService;
		}
	}
}
