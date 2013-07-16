package collaboRhythm.hiviva.view.components
{

	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaStartup;

	import feathers.controls.Button;
	import feathers.controls.Label;

	import starling.events.Event;

	public class EditMedicationCell extends MedicationCell
	{
		private var _doseDetailsLabel:Label;
		private var _doseDetails:String;
		private var _delete:Button;
		private var _medicationId:String;

		public function EditMedicationCell()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._doseDetailsLabel.x = this._pillImageBg.x + this._pillImageBg.width + this._gap;
			this._doseDetailsLabel.width = this.actualWidth - this._doseDetailsLabel.x;

			this._delete.validate();

			var labelWidthMinus:Number = this._delete.width + (this._gap * 2);

			this._delete.x = this.actualWidth - labelWidthMinus;

			this._brandNameLabel.width = this.actualWidth - this._brandNameLabel.x - labelWidthMinus - this._gap;
			this._genericNameLabel.width = this._doseDetailsLabel.width = this._brandNameLabel.width;

			positionGenericLabel();

			this._doseDetailsLabel.y = this._genericNameLabel.y + this._genericNameLabel.height;
			this._doseDetailsLabel.validate();

			setSizeInternal(this.actualWidth, this._doseDetailsLabel.y + this._doseDetailsLabel.height + this._gap, false);

			this._delete.y = (this.actualHeight * 0.5) - (this._delete.height * 0.5);
		}

		override protected function initialize():void
		{
			super.initialize();

			this._doseDetailsLabel = new Label();
			this._doseDetailsLabel.name = HivivaThemeConstants.CELL_SMALL_BOLD_LABEL;
			this._doseDetailsLabel.text = this._doseDetails;
			this.addChild(this._doseDetailsLabel);

			this._delete = new Button();
			this._delete.name = "delete-cell-button";
			this._delete.addEventListener(Event.TRIGGERED, deleteData);
			addChild(this._delete);
		}

		private function deleteData(e:Event):void
		{
			this._delete.removeEventListener(Event.TRIGGERED, deleteData);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.DELETE_PATIENT_MEDICATION_COMPLETE , deleteMedicationCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.deleteMedication(medicationId);
		}

		private function deleteMedicationCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.DELETE_PATIENT_MEDICATION_COMPLETE , deleteMedicationCompleteHandler);
			trace("medication with id:" + _medicationId + " deleted.");
			this.removeFromParent(true);
		}

		public function get doseDetails():String
		{
			return _doseDetails;
		}

		public function set doseDetails(value:String):void
		{
			_doseDetails = value;
		}

		public function get medicationId():String
		{
			return _medicationId;
		}

		public function set medicationId(value:String):void
		{
			_medicationId = value;
		}
	}
}
