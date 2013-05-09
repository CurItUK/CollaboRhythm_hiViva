package collaboRhythm.hiviva.controller
{
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.model.HivivaLocalStoreService;

	import flash.events.EventDispatcher;

	public class HivivaLocalStoreController extends EventDispatcher
	{
		private var _hivivaLocalStoreService:HivivaLocalStoreService;

		public function HivivaLocalStoreController()
		{
			trace("HivivaLocalStoreController construct");
			initEventListeners();
		}

		private function initEventListeners():void
		{
			this.addEventListener(LocalDataStoreEvent.PROFILE_TYPE_UPDATE , profileTypeUpdateHandler);
		}

		public function initStoreService():void
		{
			_hivivaLocalStoreService = new HivivaLocalStoreService();
			_hivivaLocalStoreService.addEventListener(LocalDataStoreEvent.DATA_LOAD_COMPLETE , dataLoadCompleteHandler);
			_hivivaLocalStoreService.initDataLoad();
		}

		public function getMedicationList():void
		{
			service.addEventListener(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE,medicationsLoadCompleteHandler);
			service.getMedicationList();
		}

		private function medicationsLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE,medicationsLoadCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function setMedicationList():void
		{

		}


		public function resetApplication():void
		{
			service.resetApplication();
		}

		private function profileTypeUpdateHandler(e:LocalDataStoreEvent):void
		{
			_hivivaLocalStoreService.updateAppProfileType(e.data.user);
		}

		private function dataLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			trace("data loaded ok " + e.message)
		}

		public function get service():HivivaLocalStoreService
		{
			return _hivivaLocalStoreService;
		}

	}
}
