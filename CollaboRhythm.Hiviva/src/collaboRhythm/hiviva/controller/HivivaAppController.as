package collaboRhythm.hiviva.controller
{



	public class HivivaAppController
	{
		private var _hivivaLocalStoreController:HivivaLocalStoreController;
		private var _hivivaRemoteStoreController:HivivaRemoteStoreController;
		private var _hivivaNotificationsController:HivivaNotificationsController;


		public function HivivaAppController()
		{
			initLocalStore();
			initRemoteStore();
			initNotificationsController();
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

		private function initNotificationsController():void
		{
			this._hivivaNotificationsController = new HivivaNotificationsController();
			this._hivivaNotificationsController.initNotificationService();
		}

		public function get hivivaNotificationsController():HivivaNotificationsController
		{
			return this._hivivaNotificationsController
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
