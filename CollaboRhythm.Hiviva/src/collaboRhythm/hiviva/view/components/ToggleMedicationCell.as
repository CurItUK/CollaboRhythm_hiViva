package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.FeathersScreenEvent;

	import feathers.controls.Radio;
	import feathers.controls.Label;

	import starling.events.Event;

	public class ToggleMedicationCell extends MedicationCell
	{
//		private var _doseDetailsLabel:Label;
//		private var _doseDetails:String;
		private var _radio:Radio;
//		private var _isChanged:Boolean;
		private var _medicationId:int;

		public function ToggleMedicationCell(theme:String = MedicationCell.WHITE_THEME)
		{
			super(theme);
		}

		override protected function draw():void
		{
			super.draw();

			this._radio.validate();

			var labelWidthMinus:Number = this._radio.width + (this._gap * 2);

			this._radio.x = this.actualWidth - labelWidthMinus;

			this._brandNameLabel.width = this.actualWidth - this._brandNameLabel.x - labelWidthMinus - this._gap;
			this._genericNameLabel.width = this._brandNameLabel.width;

			positionGenericLabel();

			setSizeInternal(this.actualWidth, this._genericNameLabel.y + this._genericNameLabel.height + this._gap, true);

			this._radio.y = (this.actualHeight * 0.5) - (this._radio.height * 0.5);
		}

		override protected function initialize():void
		{
			super.initialize();

			this._radio = new Radio();
			this._radio.addEventListener(Event.TRIGGERED, radioTriggerHandler);
			this.addChild(this._radio);
		}

		private function radioTriggerHandler(e:Event):void
		{
			var fsEvt:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.MEDICATION_RADIO_TRIGGERED);
			fsEvt.evtData = {activeId:_medicationId};
			dispatchEvent(fsEvt);
		}

/*
		public function get doseDetails():String
		{
			return _doseDetails;
		}

		public function set doseDetails(value:String):void
		{
			_doseDetails = value;
		}
*/

		/*public function get isChanged():Boolean
		{
			return _isChanged;
		}

		public function set isChanged(value:Boolean):void
		{
			_isChanged = value;
		}*/

		public function get radio():Radio
		{
			return _radio;
		}

		public function set radio(value:Radio):void
		{
			_radio = value;
		}

		public function get medicationId():int
		{
			return _medicationId;
		}

		public function set medicationId(value:int):void
		{
			_medicationId = value;
		}
	}
}
