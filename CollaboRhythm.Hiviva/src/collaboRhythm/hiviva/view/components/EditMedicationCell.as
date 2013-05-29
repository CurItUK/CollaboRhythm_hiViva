package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;

	import feathers.controls.Button;

	import starling.events.Event;

	public class EditMedicationCell extends MedicationCell
	{
		private var _applicationController:HivivaApplicationController;
		private var _delete:Button;
		private var _medicationId:int;

		public function EditMedicationCell()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._delete.validate();
			this._delete.x = this._bg.x + this._bg.width - this._gap - this._delete.width;
			this._delete.y = this._bg.y + (this._bg.height * 0.5) - (this._delete.height * 0.5);
		}

		override protected function initialize():void
		{
			super.initialize();

			this._delete = new Button();
			this._delete.label = "X";
			this._delete.addEventListener(Event.TRIGGERED, deleteData);
			addChild(this._delete);
		}

		private function deleteData(e:Event):void
		{
			this._delete.removeEventListener(Event.TRIGGERED, deleteData);

			localStoreController.addEventListener(LocalDataStoreEvent.MEDICATIONS_DELETE_COMPLETE, deleteMedicationCompleteHandler);
			localStoreController.deleteMedication(this._medicationId);
		}

		private function deleteMedicationCompleteHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.MEDICATIONS_DELETE_COMPLETE , deleteMedicationCompleteHandler);
			trace("medication with id:" + _medicationId + " deleted.");
			this.removeFromParent(true);
		}

		public function get medicationId():int
		{
			return _medicationId;
		}

		public function set medicationId(value:int):void
		{
			_medicationId = value;
		}

		public function get localStoreController():HivivaLocalStoreController
		{
			return applicationController.hivivaLocalStoreController;
		}

		public function get applicationController():HivivaApplicationController
		{
			return _applicationController;
		}

		public function set applicationController(value:HivivaApplicationController):void
		{
			_applicationController = value;
		}
	}
}
