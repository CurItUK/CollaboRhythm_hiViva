package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.*;

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


	public class HivivaHCPDisplaySettings extends Screen
	{
		private var _header:HivivaHeader;
		private var _content:ScrollContainer;
		private var _contentLayout:VerticalLayout;
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

		private var _customHeight:Number = 0;

		public function HivivaHCPDisplaySettings()
		{

		}

		override protected function draw():void
		{
			super.draw();

			var horizontalPadding:Number = this.actualWidth * 0.04;
			var verticalPadding:Number = this.actualHeight * 0.02;
			var contentHeight:Number;

			this._header.paddingLeft = this._header.paddingRight = horizontalPadding;
			this._header.paddingTop = verticalPadding;
			this._header.width = this.actualWidth - (horizontalPadding * 2);
			this._header.height = (110 * this.dpiScale) - verticalPadding;
			this._header.validate();

			contentHeight = this._customHeight > 0 ? this._customHeight : this.actualHeight;
			contentHeight -= (this._header.y + this._header.height);

			this._content.y = this._header.y + this._header.height;
			this._content.width = this.actualWidth - (horizontalPadding * 2);
			this._content.height = contentHeight - verticalPadding;

			this._contentLayout.paddingLeft = this._contentLayout.paddingRight = horizontalPadding;
			this._contentLayout.paddingTop = this._contentLayout.paddingBottom = verticalPadding;
			this._contentLayout.gap = verticalPadding;

			this._orderInstructionsLabel.width = this._content.width;
			this._fromInstructionsLabel.width = this._content.width;

			this._content.validate();

			this._submitButton.y = this._cancelButton.y;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + horizontalPadding;

			populateOldData();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Display settings";
			this.addChild(this._header);

			this._content = new ScrollContainer();
			this._content.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			this._content.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			addChild(this._content);

			this._contentLayout = new VerticalLayout();
			this._content.layout = this._contentLayout;

			this._orderInstructionsLabel = new Label();
			this._orderInstructionsLabel.text = "<FONT FACE='ExoBold'>Home page</FONT><br />Order my patients by:";
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
			this._content.addChild(this._fromPickerList);

			this._cancelButton = new Button();
			this._cancelButton.label = "Cancel";
			this._cancelButton.addEventListener(Event.TRIGGERED, cancelButtonClick);
			this._content.addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.label = "Save";
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			this._content.addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}


		private function cancelButtonClick(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
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

		public function get customHeight():Number
		{
			return _customHeight;
		}

		public function set customHeight(value:Number):void
		{
			_customHeight = value;
		}
	}
}
