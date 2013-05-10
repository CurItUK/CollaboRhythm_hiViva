package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.global.RXNORMEvent;
	import collaboRhythm.hiviva.utils.RXNORM_DrugSearch;
	import collaboRhythm.shared.collaboration.model.SynchronizationService;
	import collaboRhythm.shared.model.Account;
	import collaboRhythm.shared.model.Record;
	import collaboRhythm.shared.model.healthRecord.CollaboRhythmCodedValue;
	import collaboRhythm.shared.model.healthRecord.document.MedicationOrder;
	import collaboRhythm.shared.model.services.ICurrentDateSource;
	import collaboRhythm.shared.model.services.WorkstationKernel;

	import feathers.controls.Button;
	import feathers.controls.List;

	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;

	import flash.events.Event;

	import flash.net.URLLoader;

	import flash.net.URLRequest;

	import mx.collections.ArrayCollection;

	import starling.display.DisplayObject;

	import starling.events.Event;

	import starling.events.Event;

	public class HivivaPatientAddMedsScreen extends Screen
	{

		private var _header:HivivaHeader;
		private var _applicationController:HivivaApplicationController;
		private var _backButton:Button;
		private var _medicationSearchInput:TextInput;
		private var _searchButton:Button;

		public function HivivaPatientAddMedsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._searchButton.validate();
			this._searchButton.x = 10;
			this._searchButton.y = 100;

			this._medicationSearchInput.validate();
			this._medicationSearchInput.x = this._searchButton.x + this._searchButton.width + 10;
			this._medicationSearchInput.y = 100;

		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Add a medicine";
			this.addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._searchButton = new Button();
			this._searchButton.label = "Search";
			this._searchButton.addEventListener(starling.events.Event.TRIGGERED, searchBtnHandler);
			this.addChild(this._searchButton);

			this._medicationSearchInput = new TextInput();
			this.addChild(this._medicationSearchInput);
		}

		private function backBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_EDIT_MEDICATION_SCREEN);
		}

		private function searchBtnHandler(e:starling.events.Event):void
		{
			var drugSearch:RXNORM_DrugSearch = new RXNORM_DrugSearch();
			drugSearch.addEventListener(RXNORMEvent.DATA_LOAD_COMPLETE , drugSearchLoadHandler);
			drugSearch.findDrug(this._medicationSearchInput.text);

		}

		private function drugSearchLoadHandler(e:RXNORMEvent):void
		{
			trace(e.data.medicationList)



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
