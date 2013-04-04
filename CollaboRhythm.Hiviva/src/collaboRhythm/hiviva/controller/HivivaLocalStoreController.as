package collaboRhythm.hiviva.controller
{
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.model.HivivaLocalStoreService;
	import collaboRhythm.hiviva.view.HivivaHomeView;
	import collaboRhythm.shared.model.CodedValueFactory;

	import flash.events.EventDispatcher;

	import mx.rpc.soap.WebService;

	import spark.components.View;


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

		public function resetApplication():void
		{
			service.resetApplication();
		}

		private function profileTypeUpdateHandler(e:LocalDataStoreEvent):void
		{
			_hivivaLocalStoreService.updateAppProfileType(e.data);
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
