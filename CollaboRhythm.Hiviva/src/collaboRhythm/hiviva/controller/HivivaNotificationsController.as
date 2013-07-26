package collaboRhythm.hiviva.controller
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.NotificationsEvent;
	import collaboRhythm.hiviva.global.NotificationsEvent;

	import flash.events.Event;

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.osmf.events.TimeEvent;


	public class HivivaNotificationsController extends EventDispatcher
	{
		private var _timer:Timer;
		private var _globalTimer:Timer;


		public function HivivaNotificationsController()
		{
			trace("HivivaNotificationsController construct");
		}

		public function initNotificationService():void
		{
			this._globalTimer = new Timer(Constants.GLOBAL_CHECK_DATETIME);
			this._globalTimer.addEventListener(TimerEvent.TIMER , onGlobalTimerTick);

		}

		private function onGlobalTimerTick(e:TimerEvent):void
		{
			trace("GLOBAL TICK");
			this.dispatchEvent(new NotificationsEvent(NotificationsEvent.GLOBAL_TICK));
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
