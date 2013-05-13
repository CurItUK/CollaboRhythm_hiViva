package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.model.MedicationScheduleTimeList;
	import collaboRhythm.shared.collaboration.model.SynchronizationService;
	import collaboRhythm.shared.model.Account;
	import collaboRhythm.shared.model.Record;
	import collaboRhythm.shared.model.healthRecord.CollaboRhythmCodedValue;
	import collaboRhythm.shared.model.healthRecord.document.MedicationOrder;
	import collaboRhythm.shared.model.services.ICurrentDateSource;
	import collaboRhythm.shared.model.services.WorkstationKernel;

	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PickerList;

	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.data.ListCollection;

	import flash.events.Event;

	import flash.net.URLLoader;

	import flash.net.URLRequest;

	import mx.collections.ArrayCollection;

	import starling.display.DisplayObject;

	import starling.events.Event;

	import starling.events.Event;

	public class HivivaPatientScheduleMedsScreen extends Screen
	{


		private var _header:HivivaHeader;
		private var _applicationController:HivivaApplicationController;
		private var _backButton:Button;
		private var _medicationResult:XML;

		private var _scheduleDoseList:PickerList;



		public function HivivaPatientScheduleMedsScreen()
		{



		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._scheduleDoseList.x = 10;
			this._scheduleDoseList.y = 130;
		}

		override protected function initialize():void
		{
			trace("Selected Medicine is " + medicationResult);
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Schedule Medicine";
			this.addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._scheduleDoseList = new PickerList();
			var schduleDoseAmounts:ListCollection = new ListCollection(
					[
						{text: "Once daily" , count:1},
						{text: "Twice daily" , count:2},
						{text: "Three daily", count:3}
					]);
			this._scheduleDoseList.dataProvider =schduleDoseAmounts;
			this._scheduleDoseList.listProperties.@itemRendererProperties.labelField = "text";
			this._scheduleDoseList.labelField = "text";
			this._scheduleDoseList.typicalItem = "Three daily  ";
			this._scheduleDoseList.addEventListener(starling.events.Event.CHANGE , doseListSelectedHandler);
			this.addChild(this._scheduleDoseList);
			initAvailableSchedules();
		}

		private function initAvailableSchedules():void
		{
			var loop:uint = this._scheduleDoseList.dataProvider.length;
			var times:ListCollection = MedicationScheduleTimeList.timeList();
			for(var i:uint = 0 ; i < loop ; i++)
			{
				var timeList:PickerList = new PickerList();
				timeList.dataProvider = times;
				this.addChild(timeList);
			}
		}

		private function doseListSelectedHandler(e:starling.events.Event):void
		{
			var scheduleItemsCount:uint = this._scheduleDoseList.selectedItem.count;
			trace(scheduleItemsCount);
		}

		private function backBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_ADD_MEDICATION_SCREEN);
		}

		public function get localStoreController():HivivaLocalStoreController
		{
			return applicationController.hivivaLocalStoreController;
		}

		public function get medicationResult():XML
		{
			return this._medicationResult;
		}

		public function set medicationResult(value:XML):void
		{
			this._medicationResult = value;
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
