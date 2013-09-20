
package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.model.vo.UserAuthenticationVO;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.components.PasscodeFieldGenerator;

	import feathers.controls.Button;
	import feathers.controls.Label;

	import starling.display.DisplayObject;

	import starling.events.Event;

	public class InchPasscodeChange extends ValidationScreen
	{
		private var _backButton:Button;
		private var _passcodeInstruction1:Label;
		private var _enterPasscodeTitle:Label;
		private var _passcodeFieldGenerator1:PasscodeFieldGenerator;
		private var _passcodeFieldGenerator2:PasscodeFieldGenerator;
		private var _reEnterPasscodeTitle:Label;
		private var _enterBtn:Button;
		private var _userAuthenticationVO:UserAuthenticationVO;


		public function InchPasscodeChange()
		{
			this._userAuthenticationVO = HivivaStartup.hivivaAppController.hivivaLocalStoreController.service.userAuthenticationVO;
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header.title = "Fogotten your passcode?";

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			initPasswordUpdate();
		}

		override protected function draw():void
		{
			super.draw();
			this._content.validate();
			this._contentHeight = this._content.height;
		}

		private function backBtnHandler(e:Event):void
		{
			var userType:String = HivivaStartup.hivivaAppController.hivivaLocalStoreController.service.userVO.type;
			if(userType == "HCP")
			{
				this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
			}
			else
			{
				this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
			}

		}

		private function initPasswordUpdate():void
		{
			this._enterPasscodeTitle = new Label();
			this._enterPasscodeTitle.name = HivivaThemeConstants.BODY_CENTERED_LABEL
			this._content.addChild(this._enterPasscodeTitle);
			this._enterPasscodeTitle.width = this._innerWidth;
			this._enterPasscodeTitle.text = "Enter passcode";
			this._enterPasscodeTitle.validate();

			initSetupPasscodeInputs();

			this._reEnterPasscodeTitle = new Label();
			this._reEnterPasscodeTitle.name = HivivaThemeConstants.BODY_CENTERED_LABEL
			this._content.addChild(this._reEnterPasscodeTitle);
			this._reEnterPasscodeTitle.width = this._innerWidth;
			this._reEnterPasscodeTitle.text = "Re-enter passcode";
			this._reEnterPasscodeTitle.validate();
			this._reEnterPasscodeTitle.y = this._passcodeFieldGenerator1.y + this._passcodeFieldGenerator1.height + 20;

			initSetupPasscodeReInputs();

			this._enterBtn = new Button();
			this._enterBtn.name = HivivaThemeConstants.BODY_BOLD_WHITE_LABEL;
			this._enterBtn.label = "Enter";
			this._enterBtn.addEventListener(Event.TRIGGERED , enterBtnHandler);
			this._content.addChild(this._enterBtn);
			this._enterBtn.validate();
			this._enterBtn.y = this.actualHeight - this._enterBtn.height - 50;
		}

		private function initSetupPasscodeInputs():void
		{
			this._passcodeFieldGenerator1 = new PasscodeFieldGenerator();
			this._passcodeFieldGenerator1.setSize(Constants.STAGE_WIDTH , 70);
			this._content.addChild(this._passcodeFieldGenerator1);
			this._passcodeFieldGenerator1.width = Constants.STAGE_WIDTH;
			this._passcodeFieldGenerator1.y = this._enterPasscodeTitle.y + this._enterPasscodeTitle.height + 20;
		}

		private function initSetupPasscodeReInputs():void
		{
			this._passcodeFieldGenerator2 = new PasscodeFieldGenerator();
			this._passcodeFieldGenerator2.setSize(Constants.STAGE_WIDTH , 70);
			this._content.addChild(this._passcodeFieldGenerator2);
			this._passcodeFieldGenerator2.width = Constants.STAGE_WIDTH;
			this._passcodeFieldGenerator2.y = this._reEnterPasscodeTitle.y + this._reEnterPasscodeTitle.height + 20;
		}

		private function enterBtnHandler(event:Event):void
		{
			var formValidation:String = validateContent();
			if (formValidation.length == 0)
			{
				savePasscode();
			}
			else
			{
				showFormValidation(formValidation);
			}
		}

		private function validateContent():String
		{
			var validationArray:Array = [];

			if(this._passcodeFieldGenerator1.areFieldsEmpty() || this._passcodeFieldGenerator2.areFieldsEmpty()) validationArray.push("Please enter a passcode");
			if(this._passcodeFieldGenerator1.inputsToPasscode() != this._passcodeFieldGenerator2.inputsToPasscode()) validationArray.push("Passcodes do not match");

			return validationArray.join(",\n");
		}

		private function savePasscode():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.PASSCODE_SAVE_DETAILS_COMPLETE , passcodeSaveCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.updatePasscodeDetails(this._passcodeFieldGenerator1.inputsToPasscode() );
		}

		private function passcodeSaveCompleteHandler(event:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.PASSCODE_SAVE_DETAILS_COMPLETE , passcodeSaveCompleteHandler);
			this._userAuthenticationVO.passcode = this._passcodeFieldGenerator1.inputsToPasscode();
			showFormValidation("Passcode saved OK");
		}


	}
}
