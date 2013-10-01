package collaboRhythm.hiviva.view.screens.hcp
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.LabelAndInput;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.core.FeathersControl;

	import flash.text.SoftKeyboardType;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class HivivaHCPAlertSettings extends ValidationScreen
	{
		private var _instructionsLabel:Label;
		private var _requestsCheck:Check;

		private var _lessThanTexture:Texture;

		private var _adherenceRow:FeathersControl;
		private var _adherenceCheck:Check;
		private var _adherenceLessThan:Image;
		private var _adherenceLabelInput:LabelAndInput;

		private var _tolerabilityRow:FeathersControl;
		private var _tolerabilityCheck:Check;
		private var _tolerabilityLessThan:Image;
		private var _tolerabilityLabelInput:LabelAndInput;

		private var _cancelAndSave:BoxedButtons;
		private var _backButton:Button;

		private var _parentScreen:String;

		public function HivivaHCPAlertSettings()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._content.height = this._cancelAndSave.y - this._content.y - this._componentGap;
			this._content.validate();


			this._adherenceRow.x =
			this._tolerabilityRow.x = Constants.PADDING_LEFT * 4;

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

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Alerts";

			this._instructionsLabel = new Label();
			this._instructionsLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._instructionsLabel.text = "Alert me for:";
			this._content.addChild(this._instructionsLabel);

			this._requestsCheck = new Check();
			this._requestsCheck.isSelected = true;
			this._requestsCheck.label = "New connection requests";
			this._content.addChild(this._requestsCheck);
			this._requestsCheck.visible = false;

			this._lessThanTexture = Main.assets.getTexture('v2_icon_lessthan');
			initializeAdherenceRow();
			initializeTolerabilityRow();

			this._cancelAndSave = new BoxedButtons();
			this._cancelAndSave.labels = ["Cancel","Save"];
			this._cancelAndSave.addEventListener(Event.TRIGGERED, cancelAndSaveHandler);
			addChild(this._cancelAndSave);

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			getUserDisplaySettings();
		}


		private function initializeAdherenceRow():void
		{
			this._adherenceRow = new FeathersControl();
			this._content.addChild(this._adherenceRow);

			this._adherenceLessThan = new Image(this._lessThanTexture);
			this._adherenceRow.addChild(this._adherenceLessThan);

			this._adherenceLabelInput = new LabelAndInput();
			this._adherenceLabelInput.scale = this.dpiScale;
			this._adherenceLabelInput.labelStructure = "right";
			this._adherenceRow.addChild(this._adherenceLabelInput);
			this._adherenceLabelInput._labelRight.text = "%";

			this._adherenceLabelInput._input.textEditorProperties.maxChars = 3;
			this._adherenceLabelInput._input.textEditorProperties.restrict = "0-9";
			this._adherenceLabelInput._input.textEditorProperties.softKeyboardType = SoftKeyboardType.NUMBER;

			this._adherenceCheck = new Check();
			this._adherenceCheck.addEventListener(Event.CHANGE, toggleAdherenceInput);
			this._adherenceCheck.label = "Adherence";
			this._adherenceCheck.isSelected = true;
			this._adherenceRow.addChild(this._adherenceCheck);
		}

		private function toggleAdherenceInput(e:Event):void
		{
			if(this._adherenceCheck.isSelected) this._adherenceLabelInput._input.text = "";
			this._adherenceLabelInput.visible = this._adherenceLessThan.visible = this._adherenceCheck.isSelected;
		}

		private function drawAdherenceRow():void
		{
			this._adherenceCheck.validate();

			var usableWidth:Number = (this._innerWidth - this._adherenceCheck.width - this._adherenceLessThan.width) * 0.8;

			this._adherenceLabelInput.width = usableWidth * 0.6;
			this._adherenceLabelInput._input.width = usableWidth * 0.5;
			this._adherenceLabelInput.validate();

			this._adherenceLessThan.height = this._adherenceCheck.height;
			this._adherenceLessThan.scaleX = this._adherenceLessThan.scaleY;
			this._adherenceLessThan.x = this._innerWidth * 0.35;

			this._adherenceLabelInput.x = this._innerWidth * 0.45;
			this._adherenceCheck.y = (this._adherenceLabelInput.height * 0.5) - (this._adherenceCheck.height * 0.5);

			this._adherenceLessThan.y = (this._adherenceLabelInput.height * 0.5) - (this._adherenceLessThan.height * 0.5);

			this._adherenceRow.height = this._adherenceLabelInput.height;
		}

		private function initializeTolerabilityRow():void
		{
			this._tolerabilityRow = new FeathersControl();
			this._content.addChild(this._tolerabilityRow);

			this._tolerabilityLessThan = new Image(this._lessThanTexture);
			this._tolerabilityRow.addChild(this._tolerabilityLessThan);

			this._tolerabilityLabelInput = new LabelAndInput();
			this._tolerabilityLabelInput.scale = this.dpiScale;
			this._tolerabilityLabelInput.labelStructure = "right";
			this._tolerabilityRow.addChild(this._tolerabilityLabelInput);
			this._tolerabilityLabelInput._labelRight.text = "%";

			this._tolerabilityLabelInput._input.textEditorProperties.maxChars = 3;
			this._tolerabilityLabelInput._input.textEditorProperties.restrict = "0-9";
			this._tolerabilityLabelInput._input.textEditorProperties.softKeyboardType = SoftKeyboardType.NUMBER;

			this._tolerabilityCheck = new Check();
			this._tolerabilityCheck.addEventListener(Event.CHANGE, toggleTolerabilityInput);
			this._tolerabilityCheck.label = "Tolerability";
			this._tolerabilityCheck.isSelected = true;
			this._tolerabilityRow.addChild(this._tolerabilityCheck);
		}

		private function toggleTolerabilityInput(e:Event):void
		{
			if(this._tolerabilityCheck.isSelected) this._tolerabilityLabelInput._input.text = "";
			this._tolerabilityLabelInput.visible = this._tolerabilityLessThan.visible = this._tolerabilityCheck.isSelected;
		}

		private function drawTolerabilityRow():void
		{
			this._tolerabilityCheck.validate();

			var usableWidth:Number = (this._innerWidth - this._tolerabilityCheck.width - this._tolerabilityLessThan.width) * 0.8;

			this._tolerabilityLabelInput.width = usableWidth * 0.6;
			this._tolerabilityLabelInput._input.width = usableWidth * 0.5;
			this._tolerabilityLabelInput.validate();

			this._tolerabilityLessThan.height = this._tolerabilityCheck.height;
			this._tolerabilityLessThan.scaleX = this._tolerabilityLessThan.scaleY;
			this._tolerabilityLessThan.x = this._innerWidth * 0.35;

			this._tolerabilityLabelInput.x = this._innerWidth * 0.45;
			this._tolerabilityCheck.y = (this._tolerabilityLabelInput.height * 0.5) - (this._tolerabilityCheck.height * 0.5);

			this._tolerabilityLessThan.y = (this._tolerabilityLabelInput.height * 0.5) - (this._tolerabilityLessThan.height * 0.5);

			this._tolerabilityRow.height = this._tolerabilityLabelInput.height;
		}

		private function cancelAndSaveHandler(e:Event):void
		{
			var button:String = e.data.button;

			switch(button)
			{
				case "Cancel" :
					backBtnHandler();
					break;

				case "Save" :
					saveAlertSettings();
					break;
			}
		}

		private function saveAlertSettings():void
		{
			var formValidation:String = alertSettingsCheck();
			if(formValidation.length == 0)
			{
				var settings:XML =
						<DCUserAlerts>
							<UserGuid>{HivivaStartup.userVO.guid}</UserGuid>
							<Alerts>
								<DCUserAlert>
									<UserAlertId>1</UserAlertId>
									<Value>-1</Value>
									<Enabled>1</Enabled>
								</DCUserAlert>
								<DCUserAlert>
									<UserAlertId>2</UserAlertId>
									<Value>{_adherenceCheck.isSelected ? this._adherenceLabelInput._input.text : "-1"}</Value>
									<Enabled>{_adherenceCheck.isSelected ? 1 : 0}</Enabled>
								</DCUserAlert>
								<DCUserAlert>
									<UserAlertId>3</UserAlertId>
									<Value>{_tolerabilityCheck.isSelected ? this._tolerabilityLabelInput._input.text : "-1"}</Value>
									<Enabled>{_tolerabilityCheck.isSelected ? 1 : 0}</Enabled>
								</DCUserAlert>
							</Alerts>
						</DCUserAlerts>;

				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.ADD_ALERT_SETTINGS_COMPLETE, addAlertSettingsCompleteHandler);
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addUserAlertSettings(settings);
			}
			else
			{
				showFormValidation(formValidation);
			}
		}

		private function alertSettingsCheck():String
		{
			var validationArray:Array = [];

			if(_adherenceCheck.isSelected)
			{
				if(this._adherenceLabelInput._input.text.length == 0 || Number(this._adherenceLabelInput._input.text) > 100 || Number(this._adherenceLabelInput._input.text) < 0)
				{
					validationArray.push("Please enter valid percentage for adherence");
				}
			}

			if(_tolerabilityCheck.isSelected)
			{
				if(this._tolerabilityLabelInput._input.text.length == 0 || Number(this._tolerabilityLabelInput._input.text) > 100 || Number(this._tolerabilityLabelInput._input.text) < 0)
				{
					validationArray.push("Please enter valid percentage for tolerability");
				}
			}
			return validationArray.join("\n");
		}

		private function addAlertSettingsCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.ADD_ALERT_SETTINGS_COMPLETE, addAlertSettingsCompleteHandler);
			showFormValidation("Your alert settings have been saved");
		}

		private function backBtnHandler(e:Event = null):void
		{
			if(_parentScreen != null)
			{
				this.owner.showScreen(_parentScreen);
			}
			else
			{
				this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
			}
		}

		private function getUserDisplaySettings():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_ALERT_SETTINGS_COMPLETE, getAlertSettingsCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getUserAlertSettings();
		}

		private function getAlertSettingsCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_ALERT_SETTINGS_COMPLETE, getAlertSettingsCompleteHandler);

			trace(e.data.xmlResponse);

			var settings:XML = e.data.xmlResponse;

			this._requestsCheck.isSelected = Boolean(settings.Alerts.DCUserAlert[0].Enabled == "true");
			this._adherenceCheck.isSelected = Boolean(settings.Alerts.DCUserAlert[1].Enabled == "true");
			this._adherenceLabelInput._input.text = String(settings.Alerts.DCUserAlert[1].Value);
			this._tolerabilityCheck.isSelected = Boolean(settings.Alerts.DCUserAlert[2].Enabled == "true");
			this._tolerabilityLabelInput._input.text = String(settings.Alerts.DCUserAlert[2].Value);


 		}

		public function get parentScreen():String
		{
			return _parentScreen;
		}

		public function set parentScreen(value:String):void
		{
			_parentScreen = value;
		}

		override public function dispose():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.ADD_ALERT_SETTINGS_COMPLETE, addAlertSettingsCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_ALERT_SETTINGS_COMPLETE, getAlertSettingsCompleteHandler);
			super.dispose();
		}
	}
}
