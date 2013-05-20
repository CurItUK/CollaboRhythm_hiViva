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

		public function getGalleryImages():void
		{
			service.addEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);
			service.getGalleryImages()
		}

		private function getGalleryImagesHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE,getGalleryImagesHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.GALLERY_IMAGES_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function initStoreService():void
		{
			_hivivaLocalStoreService = new HivivaLocalStoreService();
			_hivivaLocalStoreService.addEventListener(LocalDataStoreEvent.DATA_LOAD_COMPLETE , dataLoadCompleteHandler);
			_hivivaLocalStoreService.initDataLoad();
		}

		public function getGalleryTimeStamp():void
		{
			service.addEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE,getGalleryTimeStampHandler);
			service.getGalleryTimeStamp()
		}

		private function getGalleryTimeStampHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE,getGalleryTimeStampHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.GALLERY_TIMESTAMP_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
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

		public function setMedicationList(medicationSchedule:Array , medicationName:String):void
		{
			service.addEventListener(LocalDataStoreEvent.MEDICATIONS_SAVE_COMPLETE , medicationSaveCompleteHandler);
			service.setMedicationList(medicationSchedule , medicationName);
		}

		private function medicationSaveCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.MEDICATIONS_SAVE_COMPLETE , medicationSaveCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.MEDICATIONS_SAVE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getMedicationsSchedule():void
		{
			service.addEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE,medicationScheduleLoadCompleteHandler);
			service.getMedicationsSchedule();
		}

		private function medicationScheduleLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE,medicationScheduleLoadCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function deleteMedication(medicationId:int):void
		{
			service.addEventListener(LocalDataStoreEvent.MEDICATIONS_DELETE_COMPLETE, deleteMedicationCompleteHandler);
			service.deleteMedication(medicationId);
		}

		private function deleteMedicationCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.MEDICATIONS_DELETE_COMPLETE , deleteMedicationCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.MEDICATIONS_DELETE_COMPLETE);
			this.dispatchEvent(evt);
		}

		public function getAdherence():void
		{
			service.addEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE , adherenceLoadCompleteHandler);
			service.getAdherence();
		}

		private function adherenceLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE , adherenceLoadCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE);
			evt.data = e.data;
			this.dispatchEvent(evt);
		}

		public function setAdherence(medicationAdherence:Object):void
		{
			service.addEventListener(LocalDataStoreEvent.ADHERENCE_SAVE_COMPLETE , adherenceSaveCompleteHandler);
			service.setAdherence(medicationAdherence);
		}

		private function adherenceSaveCompleteHandler(e:LocalDataStoreEvent):void
		{
			service.removeEventListener(LocalDataStoreEvent.ADHERENCE_SAVE_COMPLETE , adherenceSaveCompleteHandler);
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.ADHERENCE_SAVE_COMPLETE);
			this.dispatchEvent(evt);
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
