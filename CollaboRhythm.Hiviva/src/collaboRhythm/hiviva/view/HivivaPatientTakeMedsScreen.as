package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;

	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;


	public class HivivaPatientTakeMedsScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _applicationController:HivivaApplicationController;
		private var _medications:Array;

		public function HivivaPatientTakeMedsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;
			checkMedicationsExist();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Take Medication";
			addChild(this._header);
		}

		private function checkMedicationsExist():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE , medicationsLoadCompleteHandler );
			localStoreController.getMedicationList();
		}

		private function medicationsLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			trace("medicationsLoadCompleteHandler " + e.data.medications);
			this._medications = e.data.medications;
			localStoreController.removeEventListener(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE,	medicationsLoadCompleteHandler);
			if (this._medications != null)
			{
				populateMedications();
			}
			else
			{

			}
		}

		private function populateMedications():void
		{
			var medicationsLoop:uint = this._medications.length;
			for(var i:uint = 0 ; i < medicationsLoop ; i++)
			{

			}

			var medicationList:List = new List();
			medicationList.dataProvider = new ListCollection(this._medications);
			medicationList.itemRendererProperties.labelField = "medication_name";
			medicationList.y = this._header.height + 10;
			medicationList.width = this.actualWidth;

			this.addChild(medicationList);
			medicationList.validate();
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
