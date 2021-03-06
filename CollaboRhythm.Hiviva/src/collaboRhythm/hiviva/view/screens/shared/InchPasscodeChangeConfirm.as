
package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.model.vo.UserAuthenticationVO;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.components.PasscodeFieldGenerator;

	import feathers.controls.Button;
	import feathers.controls.Label;

	import starling.display.DisplayObject;

	import starling.events.Event;

	public class InchPasscodeChangeConfirm extends ValidationScreen
	{
		private var _backButton:Button;
		private var _passcodeInstruction1:Label;
		private var _enterPasscodeTitle:Label;
		private var _passcodeFieldGenerator1:PasscodeFieldGenerator;
		private var _passcodeFieldGenerator2:PasscodeFieldGenerator;
		private var _reEnterPasscodeTitle:Label;
		private var _enterBtn:Button;
		private var _userAuthenticationVO:UserAuthenticationVO;
		private var _cancelAndSave:BoxedButtons;


		public function InchPasscodeChangeConfirm()
		{
			this._userAuthenticationVO = HivivaStartup.hivivaAppController.hivivaLocalStoreController.service.userAuthenticationVO;
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header.title = "Change passcode";

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

		override protected function preValidateContent():void
		{
			super.preValidateContent();
			this._cancelAndSave.width = this._innerWidth;

		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PASSCODE_LOCK_SCREEN);
		}

		private function initPasswordUpdate():void
		{
			this._enterPasscodeTitle = new Label();
			this._enterPasscodeTitle.name = HivivaThemeConstants.BODY_CENTERED_LABEL
			this._content.addChild(this._enterPasscodeTitle);
			this._enterPasscodeTitle.width = this._innerWidth;
			this._enterPasscodeTitle.text = "Enter your old passcode";
			this._enterPasscodeTitle.validate();

			initSetupPasscodeInputs();

			this._cancelAndSave = new BoxedButtons();
			this._cancelAndSave.addEventListener(Event.TRIGGERED, cancelAndSaveHandler);
			this._cancelAndSave.scale = this.dpiScale;
			this._cancelAndSave.labels = ["Cancel", "Save"];
			this._content.addChild(this._cancelAndSave);

			this._cancelAndSave.width = this._innerWidth;
			this._cancelAndSave.validate();
			this._cancelAndSave.y = this.actualHeight - this._cancelAndSave.height - 50;

		}

		private function cancelAndSaveHandler(e:Event):void
		{
			var button:String = e.data.button;
			switch(button)
			{
				case "Cancel" :
					this.owner.showScreen(HivivaScreens.PASSCODE_LOCK_SCREEN);
					break;
				case "Save" :
					var formValidation:String = validateContent();
					if (formValidation.length == 0)
					{
						allowChangePasscode();
					}
					else
					{
						showFormValidation(formValidation);
					}
					break;
			}
		}


		private function initSetupPasscodeInputs():void
		{
			this._passcodeFieldGenerator1 = new PasscodeFieldGenerator();
			this._passcodeFieldGenerator1.setSize(Constants.STAGE_WIDTH , 70);
			this._content.addChild(this._passcodeFieldGenerator1);
			this._passcodeFieldGenerator1.width = Constants.STAGE_WIDTH;
			this._passcodeFieldGenerator1.y = this._enterPasscodeTitle.y + this._enterPasscodeTitle.height + 20;
		}

		private function enterBtnHandler(event:Event):void
		{
			var formValidation:String = validateContent();
			if (formValidation.length == 0)
			{
				allowChangePasscode();
			}
			else
			{
				showFormValidation(formValidation);
			}
		}

		private function allowChangePasscode():void
		{
			this.owner.showScreen(HivivaScreens.PASSCODE_CHANGE_SCREEN);
		}

		private function validateContent():String
		{
			var validationArray:Array = [];

			if(this._passcodeFieldGenerator1.inputsToPasscode() != this._userAuthenticationVO.passcode) validationArray.push("Incorrect passcode");

			return validationArray.join(",\n");
		}


	}
}
