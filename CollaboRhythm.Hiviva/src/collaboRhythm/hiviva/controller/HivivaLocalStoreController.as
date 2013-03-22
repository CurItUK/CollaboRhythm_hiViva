package collaboRhythm.hiviva.controller
{
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.model.HivivaLocalStoreService;
	import collaboRhythm.shared.model.CodedValueFactory;

	import mx.rpc.soap.WebService;


	public class HivivaLocalStoreController
	{
		private var _hivivaLocalStoreService:HivivaLocalStoreService;


		public function HivivaLocalStoreController()
		{
			trace("HivivaLocalStoreController construct");
		}

		public function initApplicationFirstUse():void
		{
			_hivivaLocalStoreService = new HivivaLocalStoreService();
			_hivivaLocalStoreService.addEventListener(LocalDataStoreEvent.DATA_LOAD_COMPLETE , dataLoadCompleteHandler);
			_hivivaLocalStoreService.initDataLoad();
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
