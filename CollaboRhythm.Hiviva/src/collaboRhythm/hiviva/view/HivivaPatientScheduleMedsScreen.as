package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.model.MedicationScheduleTimeList;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaPatientScheduleMedsScreen extends Screen
	{


		private var _header:HivivaHeader;
		private var _applicationController:HivivaApplicationController;
		private var _backButton:Button;
		private var _saveToProfileBtn:Button;
		private var _medicationResult:XML;

		private var _medicationLable:Label;
		private var _takeLable:Label;


		private var _scheduleDoseList:PickerList;
		private var _timeListItems:Array = [];
		private var _tabletListItems:Array = [];



		public function HivivaPatientScheduleMedsScreen()
		{
		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._scheduleDoseList.x = 10;

			initChosenMedicationInfo();
			initAvailableSchedules();
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

		}

		private function initChosenMedicationInfo():void
		{
			this._medicationLable = new Label();
			this._medicationLable.text = medicationResult.name;
			this.addChild(this._medicationLable);
			this._medicationLable.validate()
			this._medicationLable.x = 10;
			this._medicationLable.y = this._header.height + 10;
			this._medicationLable.width = this.actualWidth - 10;

			this._scheduleDoseList.y = this._medicationLable.y + this._medicationLable.height + 50;
			this._scheduleDoseList.validate();

			this._takeLable = new Label();
			this._takeLable.text = "Take ";
			this.addChild(this._takeLable);
			this._takeLable.validate();
			this._takeLable.y = this._scheduleDoseList.y + this._scheduleDoseList.height + 40;
			this._takeLable.x = 10;

		}

		private function initAvailableSchedules():void
		{
			clearDownListArrayObect();

			var loop:uint = this._scheduleDoseList.selectedItem.count;
			var times:ListCollection = MedicationScheduleTimeList.timeList();
			var tablets:ListCollection = MedicationScheduleTimeList.tabletList();
			for(var i:uint = 0 ; i < loop ; i++)
			{
				//timeList drop down to select time medication should be taken
				var timeList:PickerList = new PickerList();
				timeList.dataProvider = times;
				timeList.listProperties.@itemRendererProperties.labelField = "text";
				timeList.labelField = "text";
				timeList.typicalItem = "Select time  ";
				timeList.prompt = "Select time";
				timeList.selectedIndex = -1;
				timeList.name = "tileList" + i;
				timeList.addEventListener(starling.events.Event.CHANGE , timeListTabletListChangeHandler);
				this.addChild(timeList);
				timeList.validate();
				timeList.x = 10;
				if(i == 0 )
				{
					timeList.y = this._takeLable.y + this._takeLable.height + 30;
				} else
				{
					var andLabel:Label = new Label();
					andLabel.text = "and  ";
					andLabel.name = "centered-label";
					this.addChild(andLabel);
					andLabel.validate();
					andLabel.width = PickerList(this.getChildByName("tileList" + (i-1))).width;
					trace(andLabel.width);
					andLabel.x = 10;
					andLabel.y = PickerList(this.getChildByName("tileList" + (i-1))).y + PickerList(this.getChildByName("tileList" + (i-1))).height + 20;
					timeList.y = PickerList(this.getChildByName("tileList" + (i-1))).y + PickerList(this.getChildByName("tileList" + (i-1))).height + 60;
				}
				_timeListItems.push(timeList);

				//tabletList drop down to select the amount of tablets to be taken on that time slot
				var tabletList:PickerList = new PickerList();
				tabletList.dataProvider = tablets;
				tabletList.listProperties.@itemRendererProperties.labelField = "text";
				tabletList.labelField = "text";
				tabletList.typicalItem = "Select tablet amount ";
				tabletList.prompt = "Select tablet amount";
				tabletList.selectedIndex = -1;
				tabletList.name = "tabletList" + i;
				tabletList.addEventListener(starling.events.Event.CHANGE , timeListTabletListChangeHandler);
				this.addChild(tabletList);
				tabletList.validate();
				tabletList.y = timeList.y;
				tabletList.x = this.actualWidth - tabletList.width - 10;
				_tabletListItems.push(tabletList);
			}
		}

		private function timeListTabletListChangeHandler(e:starling.events.Event = null):void
		{
			//TODO create constant for screen edge padding's.

			if(this._saveToProfileBtn != null)
			{
				this.removeChild(this._saveToProfileBtn);
				this._saveToProfileBtn = null;
			}

			var loop:uint = _timeListItems.length;
			var itemsValidated:uint = 0;
			for(var i:uint = 0 ; i<loop ; i++)
			{
				if(_timeListItems[i].selectedIndex != -1 && _tabletListItems[i].selectedIndex != -1)
				{
					itemsValidated++;
				}
			}

			if(itemsValidated == _timeListItems.length)
			{
				this._saveToProfileBtn = new Button();
				this._saveToProfileBtn.label = "Save to profile";
				this._saveToProfileBtn.addEventListener(starling.events.Event.TRIGGERED, saveProfileBtnHandler);
				this.addChild(this._saveToProfileBtn);
				this._saveToProfileBtn.validate();
				this._saveToProfileBtn.x = 10;
				this._saveToProfileBtn.y = this.actualHeight - this._saveToProfileBtn.height - 20;
			}
		}

		private function saveProfileBtnHandler(e:starling.events.Event):void
		{
			//medicationTimes time as medication should be taken
			//medicationTablets amount of tablets to be taken at medication time
			var medicationScheduleData:Array = [];
			var loop:uint = _timeListItems.length;
			for(var i:uint = 0 ; i < loop ; i++)
			{
				var medicationObject:Object = {time:_timeListItems[i].selectedItem.time , count:_tabletListItems[i].selectedItem.count};
				medicationScheduleData.push(medicationObject);
			}
			medicationScheduleData.sortOn("time" , Array.NUMERIC);
			localStoreController.addEventListener(LocalDataStoreEvent.MEDICATIONS_SAVE_COMPLETE , medicationSaveCompleteHandler);
			localStoreController.setMedicationList(medicationScheduleData , medicationResult.name);
		}

		private function medicationSaveCompleteHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.MEDICATIONS_SAVE_COMPLETE , medicationSaveCompleteHandler);
			clearDownListArrayObect();
			this._owner.showScreen(HivivaScreens.PATIENT_EDIT_MEDICATION_SCREEN);
		}

		private function clearDownListArrayObect():void
		{
			if (this._saveToProfileBtn != null)
			{
				this.removeChild(this._saveToProfileBtn);
				this._saveToProfileBtn = null;
			}

			while (_timeListItems.length > 0)
			{
				this.removeChild(_timeListItems[0]);
				_timeListItems[0].removeEventListener(starling.events.Event.CHANGE, timeListTabletListChangeHandler);
				_timeListItems[0].dataProvider = null;
				_timeListItems[0].dispose();
				_timeListItems[0] = null;
				_timeListItems.shift();

				this.removeChild(_tabletListItems[0]);
				_tabletListItems[0].removeEventListener(starling.events.Event.CHANGE, timeListTabletListChangeHandler);
				_tabletListItems[0].dataProvider = null;
				_tabletListItems[0].dispose();
				_tabletListItems[0] = null;
				_tabletListItems.shift();
			}
		}

		private function doseListSelectedHandler(e:starling.events.Event):void
		{
			initAvailableSchedules();
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
