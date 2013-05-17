package collaboRhythm.hiviva.view.components
{
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.Radio;
	import feathers.core.ToggleGroup;

	import starling.events.Event;

	public class TakeMedicationCell extends MedicationCell
	{
		private var _doseDetailsLabel:Label;
		private var _doseDetails:String;
		private var _yesNoRadioGroup:ToggleGroup;
		private var _yesRadio:Radio;
		private var _noRadio:Radio;

		public function TakeMedicationCell()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._doseDetailsLabel.x = this._pillImageBg.x + this._pillImageBg.width + this._gap;
			this._doseDetailsLabel.y = this._genericNameLabel.y + this._genericNameLabel.height;
			this._doseDetailsLabel.width = this._bg.width - this._pillImageBg.x;

			this._yesRadio.validate();
			this._noRadio.validate();

			this._yesRadio.x = (this._bg.x + this._bg.width) - this._gap - (this._noRadio.width + this._yesRadio.width);
			this._yesRadio.y = (this._bg.height * 0.5) - (this._yesRadio.height * 0.5);
			this._noRadio.x = this._yesRadio.x + this._yesRadio.width;
			this._noRadio.y = this._yesRadio.y;
		}

		override protected function initialize():void
		{
			super.initialize();

			this._doseDetailsLabel = new Label();
			this._doseDetailsLabel.text = this._doseDetails;
			this.addChild(this._doseDetailsLabel);

			this._yesNoRadioGroup = new ToggleGroup();
			//this._yesNoRadioGroup.addEventListener(Event.CHANGE,);

			this._yesRadio = new Radio();
			this._yesRadio.label = "Yes";
			this._yesNoRadioGroup.addItem(this._yesRadio);
			this.addChild(this._yesRadio);

			this._noRadio = new Radio();
			this._noRadio.label = "No";
			this._yesNoRadioGroup.addItem(this._noRadio);
			this.addChild(this._noRadio);
		}

		public function get doseDetails():String
		{
			return _doseDetails;
		}

		public function set doseDetails(value:String):void
		{
			_doseDetails = value;
		}
	}
}
