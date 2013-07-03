package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;

	import feathers.controls.Label;
	import feathers.controls.PickerList;
	import feathers.controls.Radio;


	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaHCPDisplaySettings extends ValidationScreen
	{
		private var _orderInstructionsLabel:Label;
		private var _orderTypeGroup:ToggleGroup;
		private var _adherenceRadio:Radio;
		private var _tolerabilityRadio:Radio;
		private var _orderByGroup:ToggleGroup;
		private var _ascendingRadio:Radio;
		private var _descendingRadio:Radio;
		private var _fromInstructionsLabel:Label;
		private var _fromPickerList:PickerList;
		private var _scheduleDoseAmounts:ListCollection;

		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _backButton:Button;

		public function HivivaHCPDisplaySettings()
		{

		}

		override protected function draw():void
		{
			super.draw();
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();

			this._orderInstructionsLabel.width = this._content.width;
			this._fromInstructionsLabel.width = this._content.width;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();

			this._submitButton.y = this._cancelButton.y;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + this._componentGap;
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Display settings";

			this._orderInstructionsLabel = new Label();
			this._orderInstructionsLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._orderInstructionsLabel.text = "Home page\nOrder my patients by:";
			this._content.addChild(this._orderInstructionsLabel);

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
			this._fromInstructionsLabel.text = "Show patient data from:";
			this._content.addChild(this._fromInstructionsLabel);

			this._fromPickerList = new PickerList();
			this._scheduleDoseAmounts = new ListCollection(
					[
						{text: "Last week"},
						{text: "Last month"},
						{text: "All time"}
					]);
			this._fromPickerList.dataProvider = this._scheduleDoseAmounts;
			this._fromPickerList.listProperties.@itemRendererProperties.labelField = "text";
			this._fromPickerList.labelField = "text";
			this._fromPickerList.typicalItem = "Last month  ";
//			this._fromPickerList.addEventListener(Event.CHANGE , doseListSelectedHandler);
			this._content.addChild(this._fromPickerList);

			this._cancelButton = new Button();
			this._cancelButton.label = "Cancel";
			this._cancelButton.addEventListener(starling.events.Event.TRIGGERED, cancelButtonClick);
			this._content.addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.label = "Save";
			this._submitButton.addEventListener(starling.events.Event.TRIGGERED, submitButtonClick);
			this._content.addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			populateOldData();
		}


		private function cancelButtonClick(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

		private function submitButtonClick(e:Event):void
		{
			// TODO: validate

			var displaySettings:Object = {};
			displaySettings.stat_type = Radio(this._orderTypeGroup.selectedItem).label;
			displaySettings.direction = Radio(this._orderByGroup.selectedItem).label;
			displaySettings.from_date = this._fromPickerList.selectedItem.text;

			localStoreController.addEventListener(LocalDataStoreEvent.HCP_DISPLAY_SETTINGS_SAVE_COMPLETE, setHcpDisplaySettingsHandler);
			localStoreController.setHcpDisplaySettings(displaySettings);
		}

		private function setHcpDisplaySettingsHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.HCP_DISPLAY_SETTINGS_SAVE_COMPLETE, setHcpDisplaySettingsHandler);
			showFormValidation("Your display settings have been saved...");
		}

		private function backBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

		private function populateOldData():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.HCP_DISPLAY_SETTINGS_LOAD_COMPLETE, getHcpDisplaySettingsHandler);
			localStoreController.getHcpDisplaySettings();
		}

		private function getHcpDisplaySettingsHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.HCP_DISPLAY_SETTINGS_LOAD_COMPLETE, getHcpDisplaySettingsHandler);

			var settings:Array = e.data.settings;
			var loopLength:int = this._scheduleDoseAmounts.length;

			try
			{
				if(settings != null)
				{
					switch(settings[0].stat_type)
					{
						case "Adherence" :
							this._adherenceRadio.isSelected = true;
							break;
						case "Tolerability" :
							this._tolerabilityRadio.isSelected = true;
							break;
					}

					switch(settings[0].direction)
					{
						case "Ascending" :
							this._ascendingRadio.isSelected = true;
							break;
						case "Descending" :
							this._descendingRadio.isSelected = true;
							break;
					}

					for (var i:int = 0; i < loopLength; i++)
					{
						if(this._scheduleDoseAmounts.data[i].text == settings[0].from_date)
						{
							this._fromPickerList.selectedIndex = i;
							break;
						}
					}
				}
			}
			catch(e:Error)
			{

			}
		}
	}
}
