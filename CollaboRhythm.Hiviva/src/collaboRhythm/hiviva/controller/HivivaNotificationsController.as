package collaboRhythm.hiviva.controller
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.NotificationsEvent;
	import collaboRhythm.hiviva.global.NotificationsEvent;

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;



	public class HivivaNotificationsController extends EventDispatcher
	{
		private var _timer:Timer;


		public function HivivaNotificationsController()
		{
			trace("HivivaNotificationsController construct");
		}

		public function initNotificationService():void
		{

		}

		public function enableAutoHomePageMessageCheck():void
		{
			this._timer = new Timer(Constants.HOMEPAGE_MESSAGE_CHECK_TIME);
			this._timer.addEventListener(TimerEvent.TIMER, onMessageCheck);
			this._timer.start();
		}

		public function disbaleAutoHomePageMessageCheck():void
		{
			this._timer.removeEventListener(TimerEvent.TIMER, onMessageCheck);
			this._timer.stop();
			this._timer = null;
		}

		private function onMessageCheck(e:TimerEvent):void
		{
			this.dispatchEvent(new NotificationsEvent(NotificationsEvent.HOMEPAGE_TICK_COMPLETE));
		}
	}
}
