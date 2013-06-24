package collaboRhythm.hiviva.controller
{
	import collaboRhythm.hiviva.model.HivivaRemoteStoreService;

	import starling.events.EventDispatcher;

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

		public function get service():HivivaRemoteStoreService
		{
			return _hivivaRemoteStoreService;
		}
	}
}
