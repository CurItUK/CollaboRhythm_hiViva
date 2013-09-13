package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaHeader;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.components.PasscodeFieldGenerator;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.PickerList;

	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;

	import starling.display.DisplayObject;

	import starling.events.Event;

	public class InchPasscodeSetup extends ValidationScreen
	{

		private var _backButton:Button;

		private var _passcodeInstruction1:Label;
		private var _enterPasscodeTitle:Label;

		private var _passcodeFieldGenerator1:PasscodeFieldGenerator;
		private var _passcodeFieldGenerator2:PasscodeFieldGenerator;





		private var _reEnterPasscodeTitle:Label;
		private var _passcodeRecoveryTitle:Label;
		private var _passcodeInstruction2:Label;
		private var _questionsTitle:Label;
		private var _questions:PickerList;
		private var _answerTitle:Label;
		private var _answerInput:TextInput;
		private var _passcodeInstruction3:Label;
		private var _enterBtn:Button;





		public function InchPasscodeSetup()
		{

		}

		override protected function initialize():void
		{
			super.initialize();
			this._header.title = "Set up passcode";
			initPasscodeSetup();

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}


		override protected function draw():void
		{
			super.draw();
			this._content.validate();
			this._contentHeight = this._content.height;



		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function initPasscodeSetup():void
		{
			this._passcodeInstruction1 = new Label();
			this._content.addChild(this._passcodeInstruction1);
			this._passcodeInstruction1.width = Constants.STAGE_WIDTH;
			this._passcodeInstruction1.text = "Set a 4-digit number as your passcode";
			this._passcodeInstruction1.validate();
			this._passcodeInstruction1.y = Constants.HEADER_HEIGHT + 30;
			this._passcodeInstruction1.x = 20;

			this._enterPasscodeTitle = new Label();
			this._enterPasscodeTitle.name = HivivaThemeConstants.BODY_CENTERED_LABEL
			this._content.addChild(this._enterPasscodeTitle);
			this._enterPasscodeTitle.width = this._innerWidth;
			this._enterPasscodeTitle.text = "Enter passcode";
			this._enterPasscodeTitle.validate();
			this._enterPasscodeTitle.y = this._passcodeInstruction1.y + this._passcodeInstruction1.height + 50;

			initSetupPasscodeInputs();

			this._reEnterPasscodeTitle = new Label();
			this._reEnterPasscodeTitle.name = HivivaThemeConstants.BODY_CENTERED_LABEL
			this._content.addChild(this._reEnterPasscodeTitle);
			this._reEnterPasscodeTitle.width = this._innerWidth;
			this._reEnterPasscodeTitle.text = "Re-enter passcode";
			this._reEnterPasscodeTitle.validate();
			this._reEnterPasscodeTitle.y = this._passcodeFieldGenerator1.y + this._passcodeFieldGenerator1.height + 20;

			initSetupPasscodeReInputs();

			this._passcodeRecoveryTitle = new Label();
			this._passcodeRecoveryTitle.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._content.addChild(this._passcodeRecoveryTitle);
			this._passcodeRecoveryTitle.validate();
			this._passcodeRecoveryTitle.text = "Passcode recovery";
			this._passcodeRecoveryTitle.width = Constants.STAGE_WIDTH;
			this._passcodeRecoveryTitle.y = this._passcodeFieldGenerator2.y + this._passcodeFieldGenerator2.height + 40;

			this._passcodeInstruction2 = new Label();
			this._content.addChild(this._passcodeInstruction2);
			this._passcodeInstruction2.width = this._innerWidth;
			this._passcodeInstruction2.text = "To enable passcode recovery please select a question and enter an answer.";
			this._passcodeInstruction2.validate();
			this._passcodeInstruction2.y = this._passcodeRecoveryTitle.y + this._passcodeRecoveryTitle.height + 20;

			this._questionsTitle = new Label();
			this._content.addChild(this._questionsTitle);
			this._questionsTitle.width = Constants.STAGE_WIDTH;
			this._questionsTitle.text = "Question";
			this._questionsTitle.y = this._passcodeInstruction2.y + this._passcodeInstruction2.height + 50;

			initQuestionsList();

			this._answerTitle = new Label();
			this._content.addChild(this._answerTitle);
			this._answerTitle.width = this._innerWidth;
			this._answerTitle.text = "Answer";
			this._answerTitle.validate();
			this._answerTitle.y = this._questions.y + this._questions.height + 40;

			this._answerInput = new TextInput();
			this._content.addChild(this._answerInput);

			this._answerInput.text = "Enter answer";
			this._answerInput.validate();
			this._answerInput.width = this._innerWidth;
			this._answerInput.y = this._answerTitle.y + this._answerTitle.height + 20;
			this._answerInput.validate();

			this._passcodeInstruction3 = new Label();
			this._content.addChild(this._passcodeInstruction3);
			this._passcodeInstruction3.width = Constants.STAGE_WIDTH;
			this._passcodeInstruction3.text = "You will need to recall this answer if you forget your passcode";
			this._passcodeInstruction3.y = this._answerInput.y + this._answerInput.height + 20;
			this._passcodeInstruction3.validate();

			this._enterBtn = new Button();
			this._enterBtn.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._enterBtn.label = "Enter";
			this._enterBtn.addEventListener(Event.TRIGGERED , enterBtnHandler);
			this._content.addChild(this._enterBtn);
			this._enterBtn.validate();
			this._enterBtn.y = this._passcodeInstruction3.y + this._passcodeInstruction3.height + 40;
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

		private function initQuestionsList():void
		{
			this._questions = new PickerList();
			this._questions.customButtonName = HivivaThemeConstants.BORDER_BUTTON;
			var passcodeQuestions:ListCollection = new ListCollection
			(
					[
						{text: "What was the name of your elementary / primary school?" },
						{text: "What is the name of the company of your first job?" },
						{text: "What is your preferred musical genre?" },
						{text: "What is your mother's middle name?" },
						{text: "What is the name of the company of your first job?" }
					]
			);

			this._questions.dataProvider = passcodeQuestions;
			this._questions.listProperties.@itemRendererProperties.labelField = "text";
			this._questions.labelField = "text";
			this._questions.prompt = "Select a question";
			this._questions.selectedIndex = -1;
			this._questions.addEventListener(starling.events.Event.CHANGE , questionsListSelectedHandler);
			this._content.addChild(this._questions);
			this._questions.width = this._innerWidth;
			this._questions.validate();
			this._questions.y = this._questionsTitle.y + this._questionsTitle.height + 30;
		}

		private function questionsListSelectedHandler(event:Event):void
		{

		}

		private function enterBtnHandler(event:Event):void
		{
			var formValidation:String = valdateContent();
			if (formValidation.length == 0)
			{
				savePasscode();
			}
			else
			{
				showFormValidation(formValidation);
			}
		}

		private function valdateContent():String
		{
			var validationArray:Array = [];



			if(this._passcodeFieldGenerator1.areFieldsEmpty() || this._passcodeFieldGenerator2.areFieldsEmpty()) validationArray.push("Please enter a passcode");
			if(this._passcodeFieldGenerator1.inputsToPasscode() != this._passcodeFieldGenerator2.inputsToPasscode()) validationArray.push("Passcodes do not match");

			if(this._answerInput.text == "Enter answer" || this._answerInput.text == "" || this._questions.selectedIndex == -1) validationArray.push("Please complete passcode recovery");


			return validationArray.join(",\n");

		}

		private function savePasscode():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.PASSCODE_SAVE_DETAILS_COMPLETE , passcodeSaveCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.savePasscodeDetails(this._passcodeFieldGenerator1.inputsToPasscode() , this._answerInput.text);
		}

		private function passcodeSaveCompleteHandler(event:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.PASSCODE_SAVE_DETAILS_COMPLETE , passcodeSaveCompleteHandler);
			showFormValidation("Passcode saved OK");
		}

	}
}