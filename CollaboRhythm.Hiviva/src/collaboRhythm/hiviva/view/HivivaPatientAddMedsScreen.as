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
		private var _medicationXMLList:XMLList;

		public function HivivaPatientAddMedsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._searchButton.validate();
			this._searchButton.x = this.actualWidth - this._searchButton.width - 10;
			this._searchButton.y = 130;

			this._medicationSearchInput.validate();
			this._medicationSearchInput.width = this.actualWidth - this._searchButton.width - 40;
			this._medicationSearchInput.x = 10;
			this._medicationSearchInput.y = 135;

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
			medicationXMLList = e.data.medicationList as XMLList;

			if(this._medicationList != null)
			{
				this._medicationList.dataProvider = null;
				this.removeChild(this._medicationList);
				this._medicationList.dispose();
				this._medicationList = null;
			}

			this._medicationList = new List();
			this._medications = new ListCollection(medicationXMLList.name);
			this._medicationList.width = this.actualWidth;
			this._medicationList.y = this._header.height + 100;
			this._medicationList.dataProvider = this._medications;
			this._medicationList.itemRendererProperties.labelField = "text";
			this._medicationList.addEventListener(starling.events.Event.CHANGE , listSelectedHandler);

			this.addChild(this._medicationList);
			this._medicationList.validate();

			var useableScrollHeight:Number = this.actualHeight - this._header.height - (this._searchButton.height * 2) - 70;

			if(this._medicationList.height > useableScrollHeight)
			{
				this._medicationList.height = useableScrollHeight;
				this._medicationList.validate();
			}

		}

		private function listSelectedHandler(e:starling.events.Event):void
		{
			if(this._continueBtn == null)
			{
				this._continueBtn = new Button();
				this._continueBtn.label = "Continue";
				this._continueBtn.addEventListener(Event.TRIGGERED, continueBtnHandler);
				this.addChild(this._continueBtn);
				this._continueBtn.validate();
				this._continueBtn.y = this.actualHeight - this._continueBtn.height - 20;
				this._continueBtn.x = 10;
			}
		}

		private function continueBtnHandler(e:starling.events.Event):void
		{
			var selectedMedicine:XML = medicationXMLList[this._medicationList.selectedIndex];
			var screenParams:Object = {medicationResult:selectedMedicine , applicationController:applicationController};
			var screenNavigatorItem:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatientScheduleMedsScreen , null , screenParams);

			if(this.owner.getScreenIDs().indexOf(HivivaScreens.PATIENT_SCHEDULE_MEDICATION_SCREEN) == -1)
			{
				this.owner.addScreen(HivivaScreens.PATIENT_SCHEDULE_MEDICATION_SCREEN, screenNavigatorItem);
			}
			else
			{
				this.owner.removeScreen(HivivaScreens.PATIENT_SCHEDULE_MEDICATION_SCREEN);
				this.owner.addScreen(HivivaScreens.PATIENT_SCHEDULE_MEDICATION_SCREEN, screenNavigatorItem);
			}
			this.owner.showScreen(HivivaScreens.PATIENT_SCHEDULE_MEDICATION_SCREEN);
		}

		override public function dispose():void
		{
			super.dispose();
		}

		public function get medicationXMLList():XMLList
		{
			return _medicationXMLList;
		}

		public function set medicationXMLList(value:XMLList):void
		{
			_medicationXMLList = value;
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
