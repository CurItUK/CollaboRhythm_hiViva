package collaboRhythm.hiviva.controller
{
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
			this.dispatchEvent(evt)
		}

		public function getHCP(appGuid):void
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
