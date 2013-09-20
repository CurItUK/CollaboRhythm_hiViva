package collaboRhythm.hiviva.view.screens.hcp
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
 	import feathers.controls.Label;
	import feathers.controls.PickerList;
	import feathers.controls.Radio;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaHCPDisplaySettings extends ValidationScreen
	{
		private var _subHeaderLabel:Label;
		private var _instructionsLabel:Label;
		private var _orderTypeGroup:ToggleGroup;
		private var _adherenceRadio:Radio;
		private var _tolerabilityRadio:Radio;
		private var _orderByGroup:ToggleGroup;
		private var _ascendingRadio:Radio;
		private var _descendingRadio:Radio;
		private var _fromInstructionsLabel:Label;
		private var _fromPickerList:PickerList;
		private var _scheduleDoseAmounts:ListCollection;
		private var _cancelAndSave:BoxedButtons;
		private var _backButton:Button;

		public function HivivaHCPDisplaySettings()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._ascendingRadio.y = this._adherenceRadio.y;
			this._ascendingRadio.x = this._innerWidth * 0.5;

			this._descendingRadio.y = this._tolerabilityRadio.y;
			this._descendingRadio.x = this._innerWidth * 0.5;

			this._fromInstructionsLabel.y = this._descendingRadio.y + this._descendingRadio.height + this._componentGap;
			this._fromPickerList.y = this._fromInstructionsLabel.y + this._fromInstructionsLabel.height + this._componentGap;

			this._content.height = this._cancelAndSave.y - this._content.y - this._componentGap;
			this._content.validate();
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();

			this._subHeaderLabel.width = this._innerWidth;
			this._instructionsLabel.width = this._innerWidth;
			this._fromInstructionsLabel.width = this._innerWidth;

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

			this._header.title = "Display settings";

			this._subHeaderLabel = new Label();
			this._subHeaderLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._subHeaderLabel.text = "Home page";
			this._content.addChild(this._subHeaderLabel);

			this._instructionsLabel = new Label();
			this._instructionsLabel.name = HivivaThemeConstants.BODY_BOLD_WHITE_LABEL;
			this._instructionsLabel.text = "Order my patients by:";
			this._content.addChild(this._instructionsLabel);

			this._orderTypeGroup = new ToggleGroup();

			this._adherenceRadio = new Radio();
			this._adherenceRadio.label = "Adherence";
			this._orderTypeGroup.addItem(this._adherenceRadio);
			this._content.addChild(this._adherenceRadio);

			this._tolerabilityRadio = new Radio();
			this._tolerabilityRadio.label = "Tolerability";
			this._orderTypeGroup.addItem(this._tolerabilityRadio);
			this._content.addChild(this._tolerabilityRadio);

			this._orderByGroup = new ToggleGroup();

			this._ascendingRadio = new Radio();
			this._ascendingRadio.label = "Ascending";
			this._orderByGroup.addItem(this._ascendingRadio);
			this._content.addChild(this._ascendingRadio);

			this._descendingRadio = new Radio();
			this._descendingRadio.label = "Descending";
			this._orderByGroup.addItem(this._descendingRadio);
			this._content.addChild(this._descendingRadio);

			this._fromInstructionsLabel = new Label();
			this._fromInstructionsLabel.name = HivivaThemeConstants.BODY_BOLD_WHITE_LABEL;
			this._fromInstructionsLabel.text = "Show patient data from:";
			this._content.addChild(this._fromInstructionsLabel);

			this._fromPickerList = new PickerList();
			this._scheduleDoseAmounts = new ListCollection(
					[
						{text: "Last week" , weekData:1},
						{text: "Last month" , weekData:4},
						{text: "All time" , weekData:-1}
					]);
			this._fromPickerList.dataProvider = this._scheduleDoseAmounts;
			this._fromPickerList.listProperties.@itemRendererProperties.labelField = "text";
			this._fromPickerList.labelField = "text";
			this._fromPickerList.typicalItem = "Last month  ";
//			this._fromPickerList.addEventListener(Event.CHANGE , doseListSelectedHandler);
			this._content.addChild(this._fromPickerList);

			this._cancelAndSave = new BoxedButtons();
			this._cancelAndSave.labels = ["Cancel","Save"];
			this._cancelAndSave.addEventListener(starling.events.Event.TRIGGERED, cancelAndSaveHandler);
			addChild(this._cancelAndSave);

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			getUserDisplaySettings();
		}

		private function getUserDisplaySettings():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_DISPLAY_SETTINGS_COMPLETE , getDisplaySettingsCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getUserDisplaySettings();
		}

		private function getDisplaySettingsCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_DISPLAY_SETTINGS_COMPLETE , getDisplaySettingsCompleteHandler);


			var displaySettings:XMLList = e.data.xmlResponse.Attributes.DCUserAttribute;

			if(displaySettings.children().length() > 0)
			{
				if(displaySettings[0].Enabled == "true")
				{
					this._adherenceRadio.isSelected = true;
					if(displaySettings[0].Value == "Descending")
					{
						this._descendingRadio.isSelected = true;
					}
				}
				else
				{
					this._tolerabilityRadio.isSelected = true;
					if(displaySettings[1].Value == "Descending")
					{
						this._descendingRadio.isSelected = true;
					}
				}


				switch(String(displaySettings[2].Value))
				{
					case "1" :
						this._fromPickerList.selectedIndex = 0;
						break;

					case "4":
						this._fromPickerList.selectedIndex = 1;
						break;

					case "-1" :
						this._fromPickerList.selectedIndex = 2;
						break;
				}

			}
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
					saveDisplaySettings();
					break;
			}
		}

		private function saveDisplaySettings():void
		{

			var settings:XML =
					<DCUserSettings>
						<UserGuid>{HivivaStartup.userVO.guid}</UserGuid>
						<Attributes>
							<DCUserAttribute>
								<UserAttributeId>1</UserAttributeId>
								<Value>{Radio(this._orderByGroup.selectedItem).label}</Value>
								<Enabled>{this._adherenceRadio.isSelected ? 1 : 0}</Enabled>
							</DCUserAttribute>
							<DCUserAttribute>
								<UserAttributeId>2</UserAttributeId>
								<Value>{Radio(this._orderByGroup.selectedItem).label}</Value>
								<Enabled>{this._tolerabilityRadio.isSelected ? 1 : 0}</Enabled>
							</DCUserAttribute>
							<DCUserAttribute>
								<UserAttributeId>3</UserAttributeId>
								<Value>{this._fromPickerList.selectedItem.weekData}</Value>
								<Enabled>1</Enabled>
							</DCUserAttribute>
						</Attributes>
					</DCUserSettings>

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.ADD_DISPLAY_SETTINGS_COMPLETE, addDisplaySettingsCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addUserDisplaySettings(settings);
		}

		private function addDisplaySettingsCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.ADD_DISPLAY_SETTINGS_COMPLETE , addDisplaySettingsCompleteHandler);
			showFormValidation("Your display settings have been updated...");

//			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_WITH_SUMMARY_COMPLETE, getApprovedConnectionsWithSummaryHandler);
//			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getApprovedConnectionsWithSummary();
		}

		/*private function getApprovedConnectionsWithSummaryHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_WITH_SUMMARY_COMPLETE, getApprovedConnectionsWithSummaryHandler);
		}*/

		private function backBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

	}
}


