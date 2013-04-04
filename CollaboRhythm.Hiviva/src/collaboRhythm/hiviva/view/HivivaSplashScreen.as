package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.model.HivivaLocalStoreService;

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import starling.events.Event;

	public class HivivaSplashScreen extends Screen
	{

		private var _applicationController:HivivaApplicationController;
		private var _appType:String;
		private var _header:Header;

		private const SPLASH_TIMEOUT:uint						= 4000;

		public function HivivaSplashScreen()
		{
			super();
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
		}

		override protected function initialize():void
		{
			this._appType = applicationController.hivivaLocalStoreController.service.appDataVO._userAppType;

			this._header = new Header();
			this._header.title = "Splash Screen " + this._appType;

			addChild(this._header);

			if(this._appType == HivivaLocalStoreService.APP_FIRST_TIME_USE)
			{
				initFirstUseSplash();
			} else
			{
				initDefaultSplash();
			}
		}

		private function initFirstUseSplash():void
		{
			var hcpButton:Button = new Button();
			hcpButton.label = "HCP";
			hcpButton.y = 100;
			hcpButton.addEventListener(Event.TRIGGERED , hcpButtonHandler);

			var patientButton:Button = new Button();
			patientButton.label = "Patient";
			patientButton.y = 300;
			patientButton.addEventListener(Event.TRIGGERED , patientButtonHandler);

			this.addChild(hcpButton);
			this.addChild(patientButton);
		}

		private function hcpButtonHandler(e:Event):void
		{
			//TODO move string values to Constants in a data file
			notifyLocalStoreController("HCP")
		}

		private function patientButtonHandler(e:Event):void
		{
			//TODO move string values to Constants in a data file
			notifyLocalStoreController("Patient")
		}

		private function notifyLocalStoreController(userValue:String):void
		{
			var evt:LocalDataStoreEvent = new LocalDataStoreEvent(LocalDataStoreEvent.PROFILE_TYPE_UPDATE);
			evt.data = userValue;
			applicationController.hivivaLocalStoreController.dispatchEvent(evt);
			this._appType = userValue;
			closeDownScreen();
		}

		private function initDefaultSplash():void
		{
			var timer:Timer = new Timer(SPLASH_TIMEOUT , 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer.start()
		}

		private function timerCompleteHandler(e:TimerEvent):void
		{
			var timer:Timer = e.currentTarget as Timer;
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer = null;
			closeDownScreen();
		}

		private function closeDownScreen():void
		{
			this.dispatchEventWith("complete" , false , {profileType:this._appType});
		}

		public function get applicationController ():HivivaApplicationController
		{
			return _applicationController;
		}

		public function set applicationController (value:HivivaApplicationController):void
		{
			_applicationController = value;
		}
	}
}
