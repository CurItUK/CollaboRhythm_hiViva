package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.core.FeathersControl;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaHCPAlertSettings extends ValidationScreen
	{
		private var _instructionsLabel:Label;
		private var _requestsCheck:Check;

		private var _adherenceRow:FeathersControl;
		private var _adherenceCheck:Check;
		private var _adherenceLabelInput:LabelAndInput;

		private var _tolerabilityRow:FeathersControl;
		private var _tolerabilityCheck:Check;
		private var _tolerabilityLabelInput:LabelAndInput;

		private var _cancelAndSave:BoxedButtons;
		private var _backButton:Button;

		public function HivivaHCPAlertSettings()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._content.height = this._cancelAndSave.y - this._content.y - this._componentGap;
			this._content.validate();
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();

			this._instructionsLabel.width = this._innerWidth;

			drawAdherenceRow();
			drawTolerabilityRow();

			this._cancelAndSave.width = this._innerWidth;
			this._cancelAndSave.validate();
			this._cancelAndSave.x = Constants.PADDING_LEFT;
			this._cancelAndSave.y = Constants.STAGE_HEIGHT - Constants.PADDING_BOTTOM - this._cancelAndSave.height;
		}
/*

		override protected function postValidateContent():void
		{
			super.postValidateContent();
		}
*/

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Alerts";

			this._instructionsLabel = new Label();
			this._instructionsLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._instructionsLabel.text = "Alert me for:";
			this._content.addChild(this._instructionsLabel);

			this._requestsCheck = new Check();
			this._requestsCheck.isSelected = false;
			this._requestsCheck.label = "New connection requests";
			this._content.addChild(this._requestsCheck);

			initializeAdherenceRow();
			initializeTolerabilityRow();

			this._cancelAndSave = new BoxedButtons();
			this._cancelAndSave.labels = ["Cancel","Save"];
			this._cancelAndSave.addEventListener(starling.events.Event.TRIGGERED, cancelAndSaveHandler);
			addChild(this._cancelAndSave);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			populateOldData();
		}

		private function cancelAndSaveHandler(e:starling.events.Event):void
		{
			var button:String = e.data.button;

			switch(button)
			{
				case "Cancel" :
					this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
					break;
				case "Save" :
					// TODO: validate if user has ticked a box but not filled the corresponding input

					var alertSettings:Object = {};
					alertSettings.requests = this._requestsCheck.isSelected ? 1 : -1;
					alertSettings.adherence = this._adherenceCheck.isSelected ? this._adherenceLabelInput._input.text : "";
					alertSettings.tolerability = this._tolerabilityCheck.isSelected ? this._tolerabilityLabelInput._input.text : "";

					localStoreController.addEventListener(LocalDataStoreEvent.HCP_ALERT_SETTINGS_SAVE_COMPLETE, setHcpAlertSettingsHandler);
					localStoreController.setHcpAlertSettings(alertSettings);
					break;
			}
		}

		private function initializeAdherenceRow():void
		{
			this._adherenceRow = new FeathersControl();
			this._content.addChild(this._adherenceRow);

			this._adherenceCheck = new Check();
			this._adherenceCheck.label = "Adherence <";
			this._adherenceCheck.isSelected = false;
			this._adherenceRow.addChild(this._adherenceCheck);

			this._adherenceLabelInput = new LabelAndInput();
			this._adherenceLabelInput.scale = this.dpiScale;
			this._adherenceLabelInput.labelStructure = "right";
			this._adherenceRow.addChild(this._adherenceLabelInput);
			this._adherenceLabelInput._labelRight.text = "%";
		}

		private function drawAdherenceRow():void
		{
			this._adherenceCheck.validate();

			var usableWidth:Number = (this._innerWidth - this._adherenceCheck.width) * 0.8;

			this._adherenceLabelInput.width = usableWidth;
			this._adherenceLabelInput._input.width = usableWidth * 0.75;
			this._adherenceLabelInput.validate();

			this._adherenceLabelInput.x = this._innerWidth * 0.4;
			this._adherenceCheck.y = (this._adherenceLabelInput.height * 0.5) - (this._adherenceCheck.height * 0.5);

			this._adherenceRow.height = this._adherenceLabelInput.height;
		}

		private function initializeTolerabilityRow():void
		{
			this._tolerabilityRow = new FeathersControl();
			this._content.addChild(this._tolerabilityRow);

			this._tolerabilityCheck = new Check();
			this._tolerabilityCheck.label = "Tolerability <";
			this._tolerabilityCheck.isSelected = false;
			this._tolerabilityRow.addChild(this._tolerabilityCheck);

			this._tolerabilityLabelInput = new LabelAndInput();
			this._tolerabilityLabelInput.scale = this.dpiScale;
			this._tolerabilityLabelInput.labelStructure = "right";
			this._tolerabilityRow.addChild(this._tolerabilityLabelInput);
			this._tolerabilityLabelInput._labelRight.text = "%";
		}

		private function drawTolerabilityRow():void
		{
			this._tolerabilityCheck.validate();

			var usableWidth:Number = (this._innerWidth - this._tolerabilityCheck.width) * 0.8;

			this._tolerabilityLabelInput.width = usableWidth;
			this._tolerabilityLabelInput._input.width = usableWidth * 0.75;
			this._tolerabilityLabelInput.validate();

			this._tolerabilityLabelInput.x = this._innerWidth * 0.4;
			this._tolerabilityCheck.y = (this._tolerabilityLabelInput.height * 0.5) - (this._tolerabilityCheck.height * 0.5);

			this._tolerabilityRow.height = this._tolerabilityLabelInput.height;
		}

		private function cancelButtonClick(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

		private function submitButtonClick(e:starling.events.Event):void
		{
			// TODO: validate if user has ticked a box but not filled the corresponding input

			var alertSettings:Object = {};
			alertSettings.requests = this._requestsCheck.isSelected ? 1 : -1;
			alertSettings.adherence = this._adherenceCheck.isSelected ? this._adherenceLabelInput._input.text : "";
			alertSettings.tolerability = this._tolerabilityCheck.isSelected ? this._tolerabilityLabelInput._input.text : "";

			localStoreController.addEventListener(LocalDataStoreEvent.HCP_ALERT_SETTINGS_SAVE_COMPLETE, setHcpAlertSettingsHandler);
			localStoreController.setHcpAlertSettings(alertSettings);
		}

		private function setHcpAlertSettingsHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.HCP_ALERT_SETTINGS_SAVE_COMPLETE, setHcpAlertSettingsHandler);
			showFormValidation("Your alert settings have been saved...");
		}

		private function backBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

		private function populateOldData():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.HCP_ALERT_SETTINGS_LOAD_COMPLETE, getHcpAlertSettingsHandler);
			localStoreController.getHcpAlertSettings();
		}

		private function getHcpAlertSettingsHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.HCP_ALERT_SETTINGS_LOAD_COMPLETE, getHcpAlertSettingsHandler);

			var settings:Array = e.data.settings;

			try
			{
				if(settings != null)
				{
					this._requestsCheck.isSelected = settings[0].requests == "1";
					if(settings[0].adherence.length > 0)
					{
						this._adherenceCheck.isSelected = true;
						this._adherenceLabelInput._input.text = settings[0].adherence;
					}
					if(settings[0].tolerability.length > 0)
					{
						this._tolerabilityCheck.isSelected = true;
						this._tolerabilityLabelInput._input.text = settings[0].tolerability;
					}
				}
			}
			catch(e:Error)
			{

			}
		}
	}
}
