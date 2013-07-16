package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;

	import feathers.controls.Check;
	import feathers.controls.Label;

	import starling.events.Event;

	public class SelectMedicationCell extends MedicationCell
	{
		private var _doseDetailsLabel:Label;
		private var _doseDetails:String;
		private var _checkBox:Check;
		private var _isChanged:Boolean;
		private var _medicationScheduleId:int;
		private var _medicationGuid:String;

		public function SelectMedicationCell()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._doseDetailsLabel.x = this._pillImageBg.x + this._pillImageBg.width + this._gap;
			this._doseDetailsLabel.width = this.actualWidth - this._doseDetailsLabel.x;

			this._checkBox.validate();

			var labelWidthMinus:Number = this._checkBox.width + (this._gap * 2);

			this._checkBox.x = this.actualWidth - labelWidthMinus;

			this._brandNameLabel.width = this.actualWidth - this._brandNameLabel.x - labelWidthMinus - this._gap;
			this._genericNameLabel.width = this._doseDetailsLabel.width = this._brandNameLabel.width;

			positionGenericLabel();

			this._doseDetailsLabel.y = this._genericNameLabel.y + this._genericNameLabel.height;
			this._doseDetailsLabel.validate();

			setSizeInternal(this.actualWidth, this._doseDetailsLabel.y + this._doseDetailsLabel.height + this._gap, false);

			this._checkBox.y = (this.actualHeight * 0.5) - (this._checkBox.height * 0.5);
		}

		override protected function initialize():void
		{
			super.initialize();

			this._doseDetailsLabel = new Label();
			this._doseDetailsLabel.name = HivivaThemeConstants.CELL_SMALL_BOLD_LABEL;
			this._doseDetailsLabel.text = this._doseDetails;
			this.addChild(this._doseDetailsLabel);

			this._checkBox = new Check();
			this._checkBox.padding = 0;
			this.addChild(this._checkBox);

			this._isChanged = false;
		}

		public function get doseDetails():String
		{
			return _doseDetails;
		}

		public function set doseDetails(value:String):void
		{
			_doseDetails = value;
		}

		public function get isChanged():Boolean
		{
			return _isChanged;
		}

		public function set isChanged(value:Boolean):void
		{
			_isChanged = value;
		}

		public function get checkBox():Check
		{
			return _checkBox;
		}

		public function set checkBox(value:Check):void
		{
			_checkBox = value;
		}


		public function get medicationScheduleId():int
		{
			return _medicationScheduleId;
		}

		public function set medicationScheduleId(value:int):void
		{
			_medicationScheduleId = value;
		}

		public function get medicationGuid():String
		{
			return this._medicationGuid;
		}

		public function set medicationGuid(value:String):void
		{
			this._medicationGuid = value;
		}
	}
}
