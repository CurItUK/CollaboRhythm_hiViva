package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Button;

	import feathers.controls.Label;
	import feathers.controls.PickerList;
	import feathers.controls.Radio;


	import feathers.controls.Screen;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaHCPDisplaySettings extends Screen
	{
		private var _header:HivivaHeader;
		private var _orderInstructionsLabel:Label;
		private var _orderTypeGroup:ToggleGroup;
		private var _adherenceRadio:Radio;
		private var _tolerabilityRadio:Radio;
		private var _orderByGroup:ToggleGroup;
		private var _ascendingRadio:Radio;
		private var _descendingRadio:Radio;
		private var _fromInstructionsLabel:Label;
		private var _fromPickerList:PickerList;

		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _backButton:Button;

		private const PADDING:Number = 32;

		public function HivivaHCPDisplaySettings()
		{

		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;

			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._orderInstructionsLabel.y = this._header.y + this._header.height;
			this._orderInstructionsLabel.x = scaledPadding;
			this._orderInstructionsLabel.width = this.actualWidth - (scaledPadding * 2);
			this._orderInstructionsLabel.validate();

			this._adherenceRadio.y = this._orderInstructionsLabel.y + this._orderInstructionsLabel.height + scaledPadding;
			this._adherenceRadio.x = scaledPadding;
			this._adherenceRadio.width = this.actualWidth - (scaledPadding * 2);
			this._adherenceRadio.validate();

			this._tolerabilityRadio.y = this._adherenceRadio.y + this._adherenceRadio.height + scaledPadding;
			this._tolerabilityRadio.x = scaledPadding;
			this._tolerabilityRadio.width = this.actualWidth - (scaledPadding * 2);
			this._tolerabilityRadio.validate();

			this._ascendingRadio.y = this._tolerabilityRadio.y + this._tolerabilityRadio.height + scaledPadding;
			this._ascendingRadio.x = scaledPadding;
			this._ascendingRadio.width = this.actualWidth - (scaledPadding * 2);
			this._ascendingRadio.validate();

			this._descendingRadio.y = this._ascendingRadio.y + this._ascendingRadio.height + scaledPadding;
			this._descendingRadio.x = scaledPadding;
			this._descendingRadio.width = this.actualWidth - (scaledPadding * 2);
			this._descendingRadio.validate();

			this._fromInstructionsLabel.y = this._descendingRadio.y + this._descendingRadio.height + scaledPadding;
			this._fromInstructionsLabel.x = scaledPadding;
			this._fromInstructionsLabel.width = this.actualWidth - (scaledPadding * 2);
			this._fromInstructionsLabel.validate();

			this._fromPickerList.y = this._fromInstructionsLabel.y + this._fromInstructionsLabel.height + scaledPadding;
			this._fromPickerList.x = scaledPadding;
			this._fromPickerList.validate();

			this._submitButton.validate();
			this._cancelButton.validate();
			this._backButton.validate();

			this._cancelButton.y = this._submitButton.y = this._fromPickerList.y + this._fromPickerList.height + scaledPadding;
			this._cancelButton.x = scaledPadding;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + scaledPadding;

			populateOldData();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Display settings";
			this.addChild(this._header);

			this._orderInstructionsLabel = new Label();
			this._orderInstructionsLabel.text = "<FONT FACE='ExoBold'>Home page</FONT><br />Order my patients by:";
			addChild(this._orderInstructionsLabel);

			this._orderTypeGroup = new ToggleGroup();

			this._adherenceRadio = new Radio();
			this._adherenceRadio.label = "Adherence";
			this._orderTypeGroup.addItem(this._adherenceRadio);
			addChild(this._adherenceRadio);

			this._tolerabilityRadio = new Radio();
			this._tolerabilityRadio.label = "Tolerability";
			this._orderTypeGroup.addItem(this._tolerabilityRadio);
			addChild(this._tolerabilityRadio);

			this._orderByGroup = new ToggleGroup();

			this._ascendingRadio = new Radio();
			this._ascendingRadio.label = "Ascending";
			this._orderByGroup.addItem(this._ascendingRadio);
			addChild(this._ascendingRadio);

			this._descendingRadio = new Radio();
			this._descendingRadio.label = "Descending";
			this._orderByGroup.addItem(this._descendingRadio);
			addChild(this._descendingRadio);

			this._fromInstructionsLabel = new Label();
			this._fromInstructionsLabel.text = "Show patient data from:";
			addChild(this._fromInstructionsLabel);

			this._fromPickerList = new PickerList();
			var scheduleDoseAmounts:ListCollection = new ListCollection(
					[
						{text: "Last week"},
						{text: "Last month"},
						{text: "All time"}
					]);
			this._fromPickerList.dataProvider = scheduleDoseAmounts;
			this._fromPickerList.listProperties.@itemRendererProperties.labelField = "text";
			this._fromPickerList.labelField = "text";
			this._fromPickerList.typicalItem = "Last month  ";
//			this._fromPickerList.addEventListener(Event.CHANGE , doseListSelectedHandler);
			this.addChild(this._fromPickerList);

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
