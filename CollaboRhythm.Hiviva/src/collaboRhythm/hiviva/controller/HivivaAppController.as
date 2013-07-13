package collaboRhythm.hiviva.controller
{
	import collaboRhythm.hiviva.controller.HivivaRemoteStoreController;


	public class HivivaAppController
	{
		private var _hivivaLocalStoreController:HivivaLocalStoreController;
		private var _hivivaRemoteStoreController:HivivaRemoteStoreController;


		public function HivivaAppController()
		{
			initLocalStore();
			initRemoteStore();
		}

		private function initLocalStore():void
		{
			_hivivaLocalStoreController = new HivivaLocalStoreController();
			_hivivaLocalStoreController.initStoreService();
		}

		private function initRemoteStore():void
		{
			this._hivivaRemoteStoreController = new HivivaRemoteStoreController();
			this._hivivaRemoteStoreController.initStoreService();
		}

		public function get hivivaLocalStoreController():HivivaLocalStoreController
		{
			return this._hivivaLocalStoreController;
		}

		public function get hivivaRemoteStoreController():HivivaRemoteStoreController
		{
			return this._hivivaRemoteStoreController;
		}
	}
}
