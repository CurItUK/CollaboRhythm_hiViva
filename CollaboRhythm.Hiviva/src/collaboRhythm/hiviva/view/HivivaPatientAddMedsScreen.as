package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.RXNORMEvent;
	import collaboRhythm.hiviva.utils.RXNORM_DrugSearch;

	import feathers.controls.Button;
	import feathers.controls.List;

	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;
	import starling.display.DisplayObject;

	import starling.events.Event;

	public class HivivaPatientAddMedsScreen extends Screen
	{

		private var _header:HivivaHeader;
		private var _applicationController:HivivaApplicationController;
		private var _backButton:Button;
		private var _medicationSearchInput:TextInput;
		private var _searchButton:Button;
		private var _continueBtn:Button;
		private var _medicationList:List;
		private var _medications:ListCollection;

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
			trace(e.data.medicationList);

			this._medicationList = new List();
			this._medications = new ListCollection(e.data.medicationList);
			this._medicationList.width = this.actualWidth;
			//this._medicationList.height = this.actualHeight - this._header.height - 20;
			this._medicationList.y = this._header.height + 100;
			this._medicationList.dataProvider = this._medications;
			this._medicationList.itemRendererProperties.labelField = "text";

			this.addChild(this._medicationList);

			this._medicationList.validate();

			trace("this._medicationList.height " + this._medicationList.height);
			trace("this.actualHeight " + this.actualHeight);

			this._medicationList.addEventListener(starling.events.Event.CHANGE , listSelectedHandler);

		}

		private function listSelectedHandler(e:starling.events.Event):void
		{
			this._continueBtn = new Button();
			this._continueBtn.label = "Continue";
			this._continueBtn.addEventListener(Event.TRIGGERED, continueBtnHandler);
			this.addChild(this._continueBtn);
			this._continueBtn.validate();
			this._continueBtn.y = this.actualHeight - this._continueBtn.height - 20;
			this._continueBtn.x = 30;
		}

		private function continueBtnHandler(e:starling.events.Event):void
		{
			var screenParams:Object = {medicationResult:this._medicationList.selectedItem.text , applicationController:applicationController};
			var screenNavigatorItem:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatientScheduleMedsScreen , null , screenParams);
			this.owner.addScreen(HivivaScreens.PATIENT_SCHEDULE_MEDICATION_SCREEN, screenNavigatorItem);
			this.owner.showScreen(HivivaScreens.PATIENT_SCHEDULE_MEDICATION_SCREEN);
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
