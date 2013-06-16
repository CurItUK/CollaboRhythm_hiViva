package collaboRhythm.hiviva.controller
{


	public class HivivaAppController
	{
		private var _hivivaLocalStoreController:HivivaLocalStoreController;


		public function HivivaAppController()
		{

		}

		public function initLocalStore():void
		{
			_hivivaLocalStoreController = new HivivaLocalStoreController();
			_hivivaLocalStoreController.initStoreService();
		}

		public function get hivivaLocalStoreController():HivivaLocalStoreController
		{
			return _hivivaLocalStoreController;
		}

	}
}
