package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.Constants;

	import feathers.controls.TextInput;
	import feathers.core.FeathersControl;

	import flash.text.SoftKeyboardType;

	import flashx.textLayout.formats.TextAlign;

	public class PasscodeFieldGenerator extends FeathersControl
	{
		private var _passwordInput:TextInput;

		public function PasscodeFieldGenerator()
		{

		}

		override protected function initialize():void
		{
			super.initialize();
		}

		override protected function draw():void
		{
			super.draw();
			initInputFields();
		}

		private function initInputFields():void
		{

			this._passwordInput = new TextInput();
			this._passwordInput.textEditorProperties.displayAsPassword = true;
			this._passwordInput.textEditorProperties.maxChars = 4;
			this._passwordInput.textEditorProperties.restrict = "0-9";
			this._passwordInput.textEditorProperties.softKeyboardType = SoftKeyboardType.NUMBER;
			this._passwordInput.textEditorProperties.textAlign = TextAlign.CENTER;
			addChild(this._passwordInput);
			this._passwordInput.width = Constants.STAGE_WIDTH * 0.5;
			this._passwordInput.validate();
			this._passwordInput.x = (Constants.STAGE_WIDTH * 0.5) - (this._passwordInput.width * 0.5);
		}

		public function areFieldsEmpty():Boolean
		{
			var validate:Boolean = false;
			if(this._passwordInput.text == "")
			{
				validate = true;
			}
			return validate;
		}

		public function inputsToPasscode():String
		{
			return this._passwordInput.text;
		}
	}
}
