package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.shared.collaboration.model.SynchronizationService;
	import collaboRhythm.shared.model.Account;
	import collaboRhythm.shared.model.Record;
	import collaboRhythm.shared.model.healthRecord.CollaboRhythmCodedValue;
	import collaboRhythm.shared.model.healthRecord.document.MedicationOrder;
	import collaboRhythm.shared.model.services.ICurrentDateSource;
	import collaboRhythm.shared.model.services.WorkstationKernel;

	import feathers.controls.Button;

	import feathers.controls.Screen;
	import feathers.controls.TextInput;

	import mx.collections.ArrayCollection;

	import starling.events.Event;

	public class HivivaPatientEditMedsScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _applicationController:HivivaApplicationController;

		private var _medicationSearchInput:TextInput;
		private var _searchButton:Button;





		public function HivivaPatientEditMedsScreen()
		{



		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._searchButton.label = "Search";
			this._searchButton.validate();
			this._searchButton.x = 10;
			this._searchButton.y = 200;

			this._medicationSearchInput.validate();
			this._medicationSearchInput.x = this._searchButton.x + this._searchButton.width + 10;
			this._medicationSearchInput.y = 200;


		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Daily medicines";
			this.addChild(this._header);

			this._medicationSearchInput = new TextInput();
			this.addChild(this._medicationSearchInput);


			this._searchButton = new Button();
			this._searchButton.addEventListener(Event.TRIGGERED, searchMedicationHandler);
			addChild(this._searchButton);



			initMedicationOrder();
		}

		private function searchMedicationHandler(e:Event):void
		{

		}

		private function initMedicationOrder():void
		{
			applicationController.createSession();







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
