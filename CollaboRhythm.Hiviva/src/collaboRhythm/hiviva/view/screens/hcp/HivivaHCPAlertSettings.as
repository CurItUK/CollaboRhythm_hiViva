package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.*;
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaHCPAlertSettings extends Screen
	{
		private var _header:HivivaHeader;
		private var _instructionsLabel:Label;
		private var _requestsCheck:Check;
		private var _adherenceCheck:Check;
		private var _adherenceLabelInput:LabelAndInput;
		private var _tolerabilityCheck:Check;
		private var _tolerabilityLabelInput:LabelAndInput;
		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _backButton:Button;

		private const PADDING:Number = 32;

		public function HivivaHCPAlertSettings()
		{

		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;

			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._instructionsLabel.y = this._header.y + this._header.height;
			this._instructionsLabel.x = scaledPadding;

			this._instructionsLabel.width = this.actualWidth - (scaledPadding * 2);
			this._instructionsLabel.y = this._header.height;
			this._instructionsLabel.x = scaledPadding;
			this._instructionsLabel.validate();

			this._requestsCheck.width = this._instructionsLabel.width;
			this._requestsCheck.x = scaledPadding;
			this._requestsCheck.y = this._instructionsLabel.y + this._instructionsLabel.height + scaledPadding;
			this._requestsCheck.validate();

			this._adherenceCheck.width = this._instructionsLabel.width * 0.5;
			this._adherenceCheck.x = scaledPadding;
			this._adherenceCheck.y = this._requestsCheck.y + this._requestsCheck.height + scaledPadding;
			this._adherenceCheck.validate();

			this._adherenceLabelInput.width = this._adherenceCheck.width;
			this._adherenceLabelInput._labelLeft.text = ">";
			this._adherenceLabelInput._labelRight.text = "%";
			this._adherenceLabelInput.validate();
			this._adherenceLabelInput._input.x += this._adherenceLabelInput._labelLeft.width;
			this._adherenceLabelInput._input.width = this._adherenceCheck.width * 0.3;
			this._adherenceLabelInput.validate();
			this._adherenceLabelInput.y = this._adherenceCheck.y +
					(this._adherenceCheck.height * 0.5) - (this._adherenceLabelInput.height * 0.5);
			this._adherenceLabelInput.x = this._adherenceCheck.x + this._adherenceCheck.width;

			this._tolerabilityCheck.width = this._instructionsLabel.width * 0.5;
			this._tolerabilityCheck.x = scaledPadding;
			this._tolerabilityCheck.y = this._adherenceCheck.y + this._adherenceCheck.height + scaledPadding;
			this._tolerabilityCheck.validate();

			this._tolerabilityLabelInput.width = this._tolerabilityCheck.width;
			this._tolerabilityLabelInput._labelLeft.text = ">";
			this._tolerabilityLabelInput._labelRight.text = "%";
			this._tolerabilityLabelInput.validate();
			this._tolerabilityLabelInput._input.x += this._tolerabilityLabelInput._labelLeft.width;
			this._tolerabilityLabelInput._input.width = this._tolerabilityCheck.width * 0.3;
			this._tolerabilityLabelInput.validate();
			this._tolerabilityLabelInput.y = this._tolerabilityCheck.y +
					(this._tolerabilityCheck.height * 0.5) - (this._tolerabilityLabelInput.height * 0.5);
			this._tolerabilityLabelInput.x = this._tolerabilityCheck.x + this._tolerabilityCheck.width;

			this._submitButton.validate();
			this._cancelButton.validate();
			this._backButton.validate();

			this._cancelButton.y = this._submitButton.y = this._tolerabilityCheck.y + this._tolerabilityCheck.height;
			this._cancelButton.x = scaledPadding;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + scaledPadding;

			populateOldData();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Alerts";
			this.addChild(this._header);

			this._instructionsLabel = new Label();
			this._instructionsLabel.text = "<FONT FACE='ExoBold'>Alert me for:</FONT>";
			addChild(this._instructionsLabel);

			this._requestsCheck = new Check();
			this._requestsCheck.isSelected = false;
			this._requestsCheck.label = "New connection requests";
			addChild(this._requestsCheck);

			this._adherenceCheck = new Check();
			this._adherenceCheck.isSelected = false;
			this._adherenceCheck.label = "Adherence";
			addChild(this._adherenceCheck);

			this._adherenceLabelInput = new LabelAndInput();
			this._adherenceLabelInput.scale = this.dpiScale;
			this._adherenceLabelInput.labelStructure = "leftAndRight";
			addChild(this._adherenceLabelInput);

			this._tolerabilityCheck = new Check();
			this._tolerabilityCheck.isSelected = false;
			this._tolerabilityCheck.label = "Tolerability";
			addChild(this._tolerabilityCheck);

			this._tolerabilityLabelInput = new LabelAndInput();
			this._tolerabilityLabelInput.scale = this.dpiScale;
			this._tolerabilityLabelInput.labelStructure = "leftAndRight";
			addChild(this._tolerabilityLabelInput);

			this._cancelButton = new Button();
			this._cancelButton.label = "Cancel";
			this._cancelButton.addEventListener(Event.TRIGGERED, cancelButtonClick);
			addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.label = "Save";
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}

		private function cancelButtonClick(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function submitButtonClick(e:Event):void
		{
			// TODO: validate
			// TODO: write data to sql
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

		private function populateOldData():void
		{
			// TODO: get data from sql
		}
	}
}
