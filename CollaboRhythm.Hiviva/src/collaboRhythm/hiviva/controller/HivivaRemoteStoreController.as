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

		private function userCreateCompleteHandler(e:Event):void
		{
			service.removeEventListener(RemoteDataStoreEvent.CREATE_USER_COMPLETE , userCreateCompleteHandler);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.CREATE_USER_COMPLETE);
			this.dispatchEvent(evt)
		}

		public function get service():HivivaRemoteStoreService
		{
			return _hivivaRemoteStoreService;
		}
	}
}
