package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Screen;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import starling.display.Image;
	import starling.events.Event;

	public class HivivaSplashScreen extends Screen
	{
		//private var _appType:String;
		private var _splashBg:Image;
		private var _logo:Image;
		private var _footer:Label;
		private var _termsButton:Button;
		private var _privacyButton:Button;
		private var _hcpButton:Button;
		private var _patientButton:Button;
		private var _userType:String;
		private var _preCloseDownCount:int = 0;

		private var _starlingMain:Main;

		private const SPLASH_TIMEOUT:uint						= 2000;

		public function HivivaSplashScreen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			drawSplashBackground();
			if(this._hcpButton != null)
			{
				drawButtons();
			}
		}

		override protected function initialize():void
		{
			super.initialize();

			initSplashBackground();
			//this._appType = HivivaStartup.hivivaAppController.hivivaLocalStoreController.service.appDataVO._userAppType;
			if(HivivaStartup.userVO.type == Constants.APP_FIRST_TIME_USE)
			{
				initButtons();
			}
			else
			{
				initDefaultSplash();
			}
		}

		private function initSplashBackground():void
		{
			this._splashBg = new Image(Main.assets.getTexture("splash_bg"));
			this._splashBg.touchable = false;
			addChild(this._splashBg);

			this._logo = new Image(Main.assets.getTexture("logo"));
			this._logo.touchable = false;
			addChild(this._logo);

			this._footer = new Label();
			this._footer.name = HivivaThemeConstants.SPLASH_FOOTER_LABEL;
			this._footer.text = "An extension of MIT's CollaboRhythm project";
			this._footer.alpha = 0.56;
			this._footer.touchable = false;
			addChild(this._footer);

			this._termsButton = new Button();
			this._termsButton.label = "Terms of Use";
			addChild(this._termsButton);

			this._privacyButton = new Button();
			this._privacyButton.label = "Privacy Policy";
			addChild(this._privacyButton);
		}

		private function drawSplashBackground():void
		{
			var padding:Number = 15;

			this._splashBg.width = this.actualWidth;
			this._splashBg.height = this.actualHeight;

			this._logo.width = this.actualWidth * 0.5;
			this._logo.scaleY = this._logo.scaleX;
			this._logo.x = (this.actualWidth * 0.5) - (this._logo.width * 0.5);
			this._logo.y = (this.actualHeight * 0.33) - (this._logo.height * 0.5);

			this._termsButton.validate();
			this._privacyButton.validate();
			this._footer.validate();

			this._termsButton.y = this._privacyButton.y = this.actualHeight - padding - this._termsButton.height;
			this._termsButton.x = this.actualWidth * 0.5;
			this._termsButton.x -= (this._termsButton.width + this._privacyButton.width + padding) * 0.5;
			this._privacyButton.x = this._termsButton.x + this._termsButton.width + padding;

			this._footer.width = this.actualWidth;
			this._footer.y = this._termsButton.y - padding - this._footer.height;
		}

		private function initButtons():void
		{
			this._hcpButton = new Button();
			this._hcpButton.name = "splash-hcp-button";
			this._hcpButton.label = "I’m a healthcare \nprofessional \nor carer";
			this._hcpButton.addEventListener(Event.TRIGGERED , hcpButtonHandler);

			this._patientButton = new Button();
			this._patientButton.name = "splash-patient-button";
			this._patientButton.label = "I am a patient";
			this._patientButton.addEventListener(Event.TRIGGERED , patientButtonHandler);

			this.addChild(this._hcpButton);
			this.addChild(this._patientButton);
		}

		private function drawButtons():void
		{
			this._hcpButton.validate();
			this._patientButton.validate();
			this._hcpButton.width = this._patientButton.width = this.actualWidth * 0.5;
			this._hcpButton.x = this.actualWidth * 0.5;
			this._hcpButton.y = this._patientButton.y = this._footer.y - this._hcpButton.height;
		}

		private function hcpButtonHandler(e:Event):void
		{
			createUser(Constants.APP_TYPE_HCP);
		}

		private function patientButtonHandler(e:Event):void
		{
			createUser(Constants.APP_TYPE_PATIENT);
		}

		private function createUser(type:String):void
		{
			this._userType = type;
			var userTypeInt:int = type == Constants.APP_TYPE_HCP ? 1 : 0;

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.CREATE_USER_COMPLETE , createUserCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.createUser(String(userTypeInt));
		}

		private function createUserCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.CREATE_USER_COMPLETE , createUserCompleteHandler);
			trace("initSplashBackground user created " + e.data.appid);

			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.APP_ID_SAVE_COMPLETE , appIdGuidSaveHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.setTypeAppIdGuid(e.data.appid , e.data.guid , this._userType);
		}

		private function appIdGuidSaveHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.APP_ID_SAVE_COMPLETE , appIdGuidSaveHandler);
			HivivaStartup.userVO.type = this._userType;
			closeDownScreen();
		}

		private function initDefaultSplash():void
		{
			var timer:Timer = new Timer(SPLASH_TIMEOUT , 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer.start();
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
			getServerDate();
			getPatientDailyAdherenceIfUserIsPatient();
		}

		private function getServerDate():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_SERVER_DATE_COMPLETE,
					getServerDateComplete);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getServerDate();
		}

		private function getPatientDailyAdherenceIfUserIsPatient():void
		{
			if (HivivaStartup.userVO.type == Constants.APP_TYPE_PATIENT)
			{
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE,
						getPatientMedicationListComplete);
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatientMedicationList();
			}
			else
			{
				this._preCloseDownCount++;
			}
		}

		private function getServerDateComplete(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_SERVER_DATE_COMPLETE,
					getServerDateComplete);

			if(e.data.xmlResponse.children().length() > 0)
			{
				updateServerDate(e.data.xmlResponse);
			}

			this._preCloseDownCount++;
			checkToClose();
		}

		private function getPatientMedicationListComplete(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);

			if(e.data.xmlResponse.children().length() > 0)
			{
				updateUserDailyAdherence(e.data.xmlResponse);
			}
			this._preCloseDownCount++;
			checkToClose();
		}

		private function updateServerDate(dateData:String):void
		{
			// TODO : need to include xml schema in xmlResponse
			var datStr:String = dateData;
			HivivaStartup.userVO.serverDate = HivivaModifier.getDateFromIsoString(datStr);
			trace("userVO.serverDate " + dateData);
		}

		private function updateUserDailyAdherence(medicationData:XML):void
		{
			HivivaStartup.patientAdherenceVO.percentage = HivivaModifier.calculateDailyAdherence(medicationData.DCUserMedication.Schedule.DCMedicationSchedule);
			trace("patientAdherenceVO " + HivivaStartup.patientAdherenceVO.percentage);
		}

		private function checkToClose():void
		{
			if(this._preCloseDownCount == 2) this.dispatchEventWith("complete");
		}

		override public function dispose():void
		{
			trace("HivivaSplashScreen dispose called");
			Main.assets.removeTexture("splash_bg");
			Main.assets.removeTexture("logo");
			Main.assets.removeTexture("splash_button_01");
			Main.assets.removeTexture("splash_button_02");
			super.dispose();
		}

	}
}
