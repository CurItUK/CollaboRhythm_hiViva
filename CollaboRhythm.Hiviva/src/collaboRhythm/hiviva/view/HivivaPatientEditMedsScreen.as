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
	import feathers.controls.List;

	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;

	import flash.events.Event;

	import flash.net.URLLoader;

	import flash.net.URLRequest;

	import mx.collections.ArrayCollection;

	import starling.events.Event;

	import starling.events.Event;

	public class HivivaPatientEditMedsScreen extends Screen
	{

		private static const RXNORM_BASE_URI:String = "http://rxnav.nlm.nih.gov/REST/";
		private static const RXNORM_DRUGS_API:String = "drugs?name=";

		private var _header:HivivaHeader;
		private var _applicationController:HivivaApplicationController;

		private var _medicationSearchInput:TextInput;
		private var _searchButton:Button;

		private var _medicationList:List;
		private var _medicationListCollection:ListCollection;







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
			this._searchButton.y = 100;

			this._medicationSearchInput.validate();
			this._medicationSearchInput.x = this._searchButton.x + this._searchButton.width + 10;
			this._medicationSearchInput.y = 100;

			this._medicationList.y = 200;
			this._medicationList.width = this.actualWidth;


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
			this._searchButton.addEventListener(starling.events.Event.TRIGGERED, searchMedicationHandler);
			addChild(this._searchButton);

			this._medicationList = new List();


		}

		private function searchMedicationHandler():void
		{
			var urlRequest:URLRequest = new URLRequest(RXNORM_BASE_URI + RXNORM_DRUGS_API + this._medicationSearchInput.text);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(flash.events.Event.COMPLETE, queryDrugName_completeHandler);
			urlLoader.load(urlRequest);
		}

		private function queryDrugName_completeHandler(e:flash.events.Event):void
		{
			var xmlResponse:XML = new XML(e.target.data);
			var conceptXMList:XMLList = xmlResponse.drugGroup.conceptGroup.conceptProperties;

			this._medicationListCollection = new ListCollection(conceptXMList.name);
			this._medicationList.dataProvider = this._medicationListCollection;
			this._medicationList.itemRendererProperties.labelField = "text";
			this.addChild(this._medicationList);
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
