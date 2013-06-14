package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;

	import feathers.controls.Button;

	import starling.events.Event;

	public class EditMedicationCell extends MedicationCell
	{
		private var _applicationController:HivivaApplicationController;
		private var _edit:Button;
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
			this._delete.x = this.actualWidth - this._gap - this._delete.width;
			this._delete.y = (this.actualHeight * 0.5) - (this._delete.height * 0.5);


			this._genericNameLabel.width = this.actualWidth - this._pillImageBg.x - this._delete.width *2 - this._gap;
/*

			this._edit.validate();
			this._edit.x = this._delete.x - this._edit.width;
			this._edit.y = (this.actualHeight * 0.5) - (this._edit.height * 0.5);
*/

		}

		override protected function initialize():void
		{
			super.initialize();
/*

			this._edit = new Button();
			this._edit.name = "edit-cell-button";
			this._edit.addEventListener(Event.TRIGGERED, editData);
			addChild(this._edit);
*/

			this._delete = new Button();
			this._delete.name = "delete-cell-button";
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

/*
		private function editData(e:Event):void
		{
			// dispatch even with relevant date to call edit in parent
		}
*/

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
