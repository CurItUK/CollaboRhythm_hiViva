package collaboRhythm.hiviva.controller
{
	import collaboRhythm.hiviva.global.Constants;

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.osmf.events.TimeEvent;

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

		public function enableAutoPatientHomePageMessageCheck():void
		{
			this._timer = new Timer(Constants.PATIENT_HOMEPAGE_MESSAGE_CHECK_TIME);
			this._timer.addEventListener(TimerEvent.TIMER, onPatientMessageCheck);
			this._timer.start();
		}

		public function disbaleAutoPatientHomePageMessageCheck():void
		{
			this._timer.removeEventListener(TimerEvent.TIMER, onPatientMessageCheck);
			this._timer.stop();
			this._timer = null;
		}

		private function onPatientMessageCheck(e:TimeEvent):void
		{

		}
	}
}
