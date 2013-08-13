package collaboRhythm.hiviva.controller
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.NotificationsEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class HivivaNotificationsController extends EventDispatcher
	{
		private var _timer:Timer;
		private var _globalTimer:Timer;
		private var _deactivatedDate:Date;


		public function HivivaNotificationsController()
		{
			trace("HivivaNotificationsController construct");
		}

		public function initNotificationService():void
		{
			this._globalTimer = new Timer(Constants.GLOBAL_CHECK_DATETIME);
			this._globalTimer.addEventListener(TimerEvent.TIMER , onGlobalTimerTick);
			this._globalTimer.start();

			HivivaStartup.hivivaStartup.addEventListener(NotificationsEvent.APPLICATION_ACTIVATE, activate);
			HivivaStartup.hivivaStartup.addEventListener(NotificationsEvent.APPLICATION_DEACTIVATE, deActivate);
		}

		private function onGlobalTimerTick(e:TimerEvent):void
		{
			trace("GLOBAL TICK");
			this.dispatchEvent(new NotificationsEvent(NotificationsEvent.GLOBAL_TICK));

			getServerDate();
		}

		public function enableAutoHomePageMessageCheck():void
		{
			this._timer = new Timer(Constants.HOMEPAGE_MESSAGE_CHECK_TIME);
			this._timer.addEventListener(TimerEvent.TIMER, onMessageCheck);
			this._timer.start();
		}

		public function disableAutoHomePageMessageCheck():void
		{
			this._timer.removeEventListener(TimerEvent.TIMER, onMessageCheck);
			this._timer.stop();
			this._timer = null;
		}

		private function onMessageCheck(e:TimerEvent):void
		{
			this.dispatchEvent(new NotificationsEvent(NotificationsEvent.HOMEPAGE_TICK_COMPLETE));
		}

		public function activate(e:NotificationsEvent):void
		{
			getServerDate();
		}

		private function getServerDate():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_SERVER_DATE_COMPLETE, getServerDateComplete);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getServerDate();
		}

		public function deActivate(e:NotificationsEvent = null):void
		{
			// to midnight
			// incase deactivate triggered before server date has been retrieved for the first time
			if(HivivaStartup.userVO.serverDate != null)
			{
				this._deactivatedDate = new Date(HivivaStartup.userVO.serverDate.getFullYear(),HivivaStartup.userVO.serverDate.getMonth(),HivivaStartup.userVO.serverDate.getDate(),0,0,0,0);
			}
		}

		private function getServerDateComplete(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_SERVER_DATE_COMPLETE, getServerDateComplete);

			if(e.data.xmlResponse.children().length() > 0)
			{
				HivivaStartup.userVO.serverDate = HivivaModifier.getDateFromIsoString(String(e.data.xmlResponse));
			}
			isNewDayCheck();
		}

		private function isNewDayCheck():void
		{
			if (this._deactivatedDate != null)
			{
				// to midnight
				var activateDate:Date = new Date(HivivaStartup.userVO.serverDate.getFullYear(),HivivaStartup.userVO.serverDate.getMonth(),HivivaStartup.userVO.serverDate.getDate(),0,0,0,0);
				if (HivivaModifier.getDaysDiff(activateDate, this._deactivatedDate) > 0)
				{
					dispatchEvent(new NotificationsEvent(NotificationsEvent.UPDATE_DAILY_VO_DATA));
					trace("UPDATE_VO_DATA");
				}
				deActivate();
			}
		}
	}
}
