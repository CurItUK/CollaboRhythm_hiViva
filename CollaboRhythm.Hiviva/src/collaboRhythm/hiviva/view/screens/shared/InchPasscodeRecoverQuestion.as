package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.model.vo.UserAuthenticationVO;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.components.BoxedButtons;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;

	import starling.display.DisplayObject;

	import starling.events.Event;

	public class InchPasscodeRecoverQuestion extends ValidationScreen
	{
		private var _backButton:Button;
		private var _questionsTitle:Label;
		private var _answerTitle:Label;
		private var _question:Label;
		private var _answerInput:TextInput;
		private var _userAuthenticationVO:UserAuthenticationVO;
		private var _enterBtn:Button;
		private var _cancelAndSave:BoxedButtons;

		private var questions:Array =
			[
				 "What was the name of your elementary / primary school?",
				 "What is the name of the company of your first job?",
				 "What is your preferred musical genre?",
				 "What is your mother's middle name?",
				 "What is the name of the company of your first job?"
			]  ;

		public function InchPasscodeRecoverQuestion()
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

			initPasswordRecovery();
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
			this.owner.showScreen(HivivaScreens.SPLASH_SCREEN);
		}

		private function initPasswordRecovery():void
		{
			this._questionsTitle = new Label();
			this._questionsTitle.name = HivivaThemeConstants.BODY_BOLD_WHITE_LABEL;
			this._content.addChild(this._questionsTitle);
			this._questionsTitle.width = Constants.STAGE_WIDTH;
			this._questionsTitle.text = "Question";
			this._questionsTitle.validate();

			this._question = new Label();
			this._content.addChild(this._question);
			this._question.width = Constants.STAGE_WIDTH;
			this._question.text = questions[this._userAuthenticationVO.questionId];
			this._question.validate();
			this._question.y = this._questionsTitle.y + this._questionsTitle.height + 20;
			this._question.x = 20;

			this._answerTitle = new Label();
			this._answerTitle.name = HivivaThemeConstants.BODY_BOLD_WHITE_LABEL;
			this._content.addChild(this._answerTitle);
			this._answerTitle.width = Constants.STAGE_WIDTH;
			this._answerTitle.text = "Answer";
			this._answerTitle.validate();
			this._answerTitle.y =    this._question.y + this._question.height + 50;

			this._answerInput = new TextInput();
			this._content.addChild(this._answerInput);
			this._answerInput.text = "Enter answer"
			this._answerInput.addEventListener(FeathersEventType.FOCUS_IN , onEnterInputHandler);
			this._answerInput.validate();
			this._answerInput.width = this._innerWidth;
			this._answerInput.y = this._answerTitle.y + this._answerTitle.height + 20;
			this._answerInput.validate();

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
					this.owner.showScreen(HivivaScreens.SPLASH_SCREEN);
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


		private function onEnterInputHandler(event:Event):void
		{
			this._answerInput.removeEventListener(FeathersEventType.FOCUS_IN , onEnterInputHandler);
			this._answerInput.text = "";
		}

		private function allowChangePasscode():void
		{
			this.owner.showScreen(HivivaScreens.PASSCODE_RECOVER_UPDATE_SCREEN);
		}

		private function validateContent():String
		{
			var validationArray:Array = [];
			if(answerCheckSearch(this._answerInput.text)) validationArray.push("Incorrect answer");

			return validationArray.join(",\n");
		}

		private function answerCheckSearch(answer:String):Boolean
		{
			var answerIncorrect:Boolean = false;
			trace(answer.search(this._userAuthenticationVO.answer))
			if(answer.toLocaleLowerCase().search(this._userAuthenticationVO.answer.toLocaleLowerCase()) == -1)
			{

				answerIncorrect = true;
			}

			return answerIncorrect;
		}
	}
}
