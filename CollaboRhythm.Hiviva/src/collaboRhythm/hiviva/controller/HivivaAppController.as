package collaboRhythm.hiviva.controller
{
	import collaboRhythm.hiviva.global.Constants;

	import com.distriqt.extension.message.Message;
	import com.distriqt.extension.message.events.MessageEvent;



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
			initMailFunctionality();
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

		private function initMailFunctionality():void
		{
			try
			{
				Message.init(Constants.DISTRIQT_ANE_DEVELOPER_LIC);
				trace("PDFReportMailer Message Supported: " + String(Message.isSupported));
				trace("PDFReportMailer Message Version: " + String(Message.service.version));
				trace("PDFReportMailer Mail Supported: " + String(Message.isMailSupported));

				Message.service.addEventListener(MessageEvent.MESSAGE_MAIL_ATTACHMENT_ERROR , messageErrorHandler);
				Message.service.addEventListener(MessageEvent.MESSAGE_MAIL_COMPOSE , messageComposeHandler);

			}
			catch (e:Error)
			{
				trace("PDFReportMailer " + e.message);
			}
		}

		private function messageComposeHandler(event:MessageEvent):void
		{
			trace(event);
		}

		private function messageErrorHandler(event:MessageEvent):void
		{
			trace(event);
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
