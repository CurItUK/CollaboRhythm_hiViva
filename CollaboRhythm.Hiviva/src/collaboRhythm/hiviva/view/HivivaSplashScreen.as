package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.model.HivivaLocalStoreService;

	import feathers.controls.Button;
	import feathers.controls.Screen;

	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	import source.themes.HivivaTheme;

	import starling.animation.Transitions;
	import starling.animation.Tween;

	import starling.animation.Tween;
	import starling.core.Starling;

	import starling.display.Image;

	import starling.events.Event;

	public class HivivaSplashScreen extends Screen
	{
		private var _applicationController:HivivaApplicationController;
		private var _appType:String;
		private var _splashBg:Image;
		private var _logo:Image;
		private var _hcpButton:Button;
		private var _patientButton:Button;

		private const SPLASH_TIMEOUT:uint						= 4000;

		public function HivivaSplashScreen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			drawSplashBackground();
			drawButtons();
		}

		override protected function initialize():void
		{
			super.initialize();

			initSplashBackground();
			initButtons();

			this._appType = applicationController.hivivaLocalStoreController.service.appDataVO._userAppType;
			if(this._appType == HivivaLocalStoreService.APP_FIRST_TIME_USE)
			{
				initButtonListeners();
			} else
			{
				initDefaultSplash();
			}
		}

		private function initSplashBackground():void
		{
			this._splashBg = new Image(HivivaAssets.SPLASH_SCREEN_BG);
			addChild(this._splashBg);

			this._logo = new Image(HivivaAssets.LOGO);
			addChild(this._logo);
		}

		private function drawSplashBackground():void
		{
			this._splashBg.width = this.actualWidth;
			this._splashBg.height = this.actualHeight;

			this._logo.width = this.actualWidth * 0.5;
			this._logo.scaleY = this._logo.scaleX;
			this._logo.x = (this.actualWidth * 0.5) - (this._logo.width * 0.5);
			this._logo.y = (this.actualHeight * 0.33) - (this._logo.height * 0.5);
		}

		private function initButtons():void
		{
			this._hcpButton = new Button();
			this._hcpButton.defaultSkin = new Image(HivivaAssets.SPLASH_BUTTON_HCP);
			applySplashButtonProperties(this._hcpButton);
			this._hcpButton.label = "I’m a healthcare \nprofessional \nor carer";

			this._patientButton = new Button();
			this._patientButton.defaultSkin = new Image(HivivaAssets.SPLASH_BUTTON_PATIENT);
			this._patientButton.label = "I am a patient";
			applySplashButtonProperties(this._patientButton);

			this._hcpButton.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			this._patientButton.horizontalAlign = Button.HORIZONTAL_ALIGN_RIGHT;

			this.addChild(this._hcpButton);
			this.addChild(this._patientButton);
		}

		private function drawButtons():void
		{
			this._hcpButton.validate();
			this._patientButton.validate();
			this._hcpButton.width = this._patientButton.width = this.actualWidth * 0.5;
			this._hcpButton.x = this.actualWidth * 0.5;
			this._hcpButton.y = this._patientButton.y = (this.actualHeight * 0.8) - (this._hcpButton.height * 0.5);
		}

		private function initButtonListeners():void
		{
			this._patientButton.addEventListener(Event.TRIGGERED , patientButtonHandler);
			this._hcpButton.addEventListener(Event.TRIGGERED , hcpButtonHandler);
		}

		private function removeButtonListeners():void
		{
			this._patientButton.removeEventListener(Event.TRIGGERED , patientButtonHandler);
			this._hcpButton.removeEventListener(Event.TRIGGERED , hcpButtonHandler);
		}

		private function applySplashButtonProperties(button:Button):void
		{
			button.name = HivivaTheme.NONE_THEMED;

			button.defaultLabelProperties.embedFonts = true;
			button.defaultLabelProperties.multiline = true;
			button.defaultLabelProperties.textFormat = new TextFormat("ExoBold", Math.round(22 * this.dpiScale), 0xFFFFFF);
			// offset y the height of the drop shadow (37px)
			button.labelOffsetY = -18.5 * this.dpiScale;
			button.defaultLabelProperties.width = 170 * this.dpiScale;

			button.paddingLeft = button.paddingRight = 40 * this.dpiScale;
			button.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
		}

		private function hcpButtonHandler(e:Event):void
		{
			//TODO move string values to Constants in a data file
			notifyLocalStoreController(HivivaLocalStoreService.USER_APP_TYPE_HCP);
			removeButtonListeners();
			fadeOutUnselected();
		}

		private function patientButtonHandler(e:Event):void
		{
			//TODO move string values to Constants in a data file
			notifyLocalStoreController(HivivaLocalStoreService.USER_APP_TYPE_PATIENT);
			removeButtonListeners();
			fadeOutUnselected();
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
			timer.start();

			this._patientButton.visible = false;
			this._hcpButton.visible = false;

			//fadeOutUnselected();
		}

		private function fadeOutUnselected():void
		{
			var fadeOutTime:Number = 1,
				buttonTween:Tween;

			if (this._appType == HivivaLocalStoreService.USER_APP_TYPE_HCP)
			{
				buttonTween = new Tween(this._patientButton, fadeOutTime, Transitions.EASE_OUT);
			}
			else if (this._appType == HivivaLocalStoreService.USER_APP_TYPE_PATIENT)
			{
				buttonTween = new Tween(this._hcpButton, fadeOutTime, Transitions.EASE_OUT);
				trace(this._appType);
			}

			buttonTween.animate("alpha", 0);
			Starling.juggler.add(buttonTween);
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
