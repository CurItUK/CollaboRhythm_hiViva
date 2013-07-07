package collaboRhythm.hiviva.view.components
{

	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaStartup;

	import feathers.controls.Button;

	import starling.events.Event;

	public class EditMedicationCell extends MedicationCell
	{

		private var _delete:Button;
		private var _medicationId:String;

		public function EditMedicationCell()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._delete.validate();
			this._delete.x = this.actualWidth - (this._gap * 2) - this._delete.width;
			this._delete.y = (this.actualHeight * 0.5) - (this._delete.height * 0.5);

			this._genericNameLabel.width = this.actualWidth - this._pillImageBg.x - this._delete.width * 2 - this._gap;
		}

		override protected function initialize():void
		{
			super.initialize();

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
