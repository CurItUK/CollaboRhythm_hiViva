package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.model.vo.UserAuthenticationVO;
	import collaboRhythm.hiviva.view.HivivaHeader;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.components.PreloaderSpinner;

	import feathers.controls.Button;

	import feathers.controls.Screen;

	import starling.display.DisplayObject;

	import starling.events.Event;

	public class InchPasscodeLock extends Screen
	{
		private var _header:HivivaHeader;
		private var _backButton:Button;

		private var _enableDisablePasscodeBtn:Button;
		private var _changePassCodeBtn:Button;
		private var _passcodeEnabled:Boolean;
		private var _userAuthenticationVO:UserAuthenticationVO;


		public function InchPasscodeLock()
		{
			this._userAuthenticationVO = HivivaStartup.hivivaAppController.hivivaLocalStoreController.service.userAuthenticationVO;
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Passcode lock";
			addChild(this._header);


			initPasscode();
		}



		override protected function draw():void
		{
			super.draw();
			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function initPasscode():void
		{
			this._passcodeEnabled = HivivaStartup.hivivaAppController.hivivaLocalStoreController.service.userAuthenticationVO.enabled;

			this._enableDisablePasscodeBtn = new Button();
			this._enableDisablePasscodeBtn.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._enableDisablePasscodeBtn.addEventListener(Event.TRIGGERED , enableDisableBtnHandler);
			this.addChild(this._enableDisablePasscodeBtn);
			this._enableDisablePasscodeBtn.validate();
			this._enableDisablePasscodeBtn.width = Constants.STAGE_WIDTH * 0.8;
			this._enableDisablePasscodeBtn.y = 100;
			this._enableDisablePasscodeBtn.x = Constants.STAGE_WIDTH/2 - this._enableDisablePasscodeBtn.width/2;

			this._changePassCodeBtn = new Button();
			this._changePassCodeBtn.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._changePassCodeBtn.addEventListener(Event.TRIGGERED , changePasscodeBtnHandler);
			this.addChild(this._changePassCodeBtn);
			this._changePassCodeBtn.label = "Change passcode";
			this._changePassCodeBtn.validate();


			this._changePassCodeBtn.width = Constants.STAGE_WIDTH * 0.8;
			this._changePassCodeBtn.y = this._enableDisablePasscodeBtn.y + this._enableDisablePasscodeBtn.height + 30;
			this._changePassCodeBtn.x = Constants.STAGE_WIDTH/2 - this._changePassCodeBtn.width/2;

			enableDisablePasscodeBtn();

		}

		private function changePasscodeBtnHandler(event:Event):void
		{

			this.owner.showScreen(HivivaScreens.PATIENT_PASSCODE_CHANGE_CONFIRM_SCREEN);

		}

		private function enableDisableBtnHandler(event:Event):void
		{
			if(!this._userAuthenticationVO.enabled)
			{
				this.owner.showScreen(HivivaScreens.PATIENT_PASSCODE_SETUP_SCREEN);
			} else
			{
				disablePasscode();
			}
		}

		private function disablePasscode():void
		{
			trace("disablePasscode")  ;
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.PASSCODE_SAVE_DETAILS_COMPLETE , passcodeDisableCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.disablePasscodeDetails();

		}

		private function passcodeDisableCompleteHandler(event:LocalDataStoreEvent):void
		{
			trace("passcodeDisableCompleteHandler")   ;
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.PASSCODE_SAVE_DETAILS_COMPLETE , passcodeDisableCompleteHandler);
			this._userAuthenticationVO.enabled = false;
			enableDisablePasscodeBtn()

		}


		private function enableDisablePasscodeBtn():void
		{
			if(this._userAuthenticationVO.enabled)
			{
				this._enableDisablePasscodeBtn.label = "Turn passcode lock Off";
				this._changePassCodeBtn.isEnabled = true;
			}
			else
			{
				this._enableDisablePasscodeBtn.label = "Turn passcode lock On";
				this._changePassCodeBtn.alpha = 0.3;
				this._changePassCodeBtn.isEnabled = false;
			}
		}




	}
}
