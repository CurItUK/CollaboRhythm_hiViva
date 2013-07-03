package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.*;

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.model.MedicationScheduleTimeList;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.components.MedicationCell;
	import collaboRhythm.hiviva.view.media.Assets;
	import collaboRhythm.hiviva.view.screens.shared.BaseScreen;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import feathers.text.BitmapFontTextFormat;

	import flash.text.TextFormatAlign;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;

	public class HivivaPatientScheduleMedsScreen extends BaseScreen
	{
		private var _backButton:Button;
		private var _saveToProfileBtn:BoxedButtons;
		private var _medicationResult:XML;
		private var _seperator:Image;
		private var _medicationLabel:MedicationCell;
//		private var _medicationLabel:List;
		private var _takeLabel:Label;


		private var _scheduleDoseList:PickerList;
		private var _timeListItems:Array = [];
		private var _tabletListItems:Array = [];



		public function HivivaPatientScheduleMedsScreen()
		{
		}

		override protected function draw():void
		{
			super.draw();

			this._componentGap = (this.actualHeight * 0.01) * this.dpiScale;
			this._content.width = this.actualWidth;
			this._content.validate();

			initChosenMedicationInfo();
			initAvailableSchedules();
		}

		override protected function initialize():void
		{
			trace("Selected Medicine is " + medicationResult);
			super.initialize();

			this._header.title = "Schedule Medicine";

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

		}

		private function initChosenMedicationInfo():void
		{
			this._medicationLabel = new MedicationCell();
			this._medicationLabel.scale = this.dpiScale;
			this._medicationLabel.brandName = HivivaModifier.getBrandName(this._medicationResult.name);
			this._medicationLabel.genericName = HivivaModifier.getGenericName(this._medicationResult.name);
			this._medicationLabel.width = this._content.width;
			this._content.addChild(this._medicationLabel);
			this._medicationLabel.validate();

		/*
			this._medicationLabel = new List();
			this._medicationLabel.dataProvider = new ListCollection(medicationResult.name);
			this._medicationLabel.itemRendererProperties.labelFunction = labelFunction;
			this._medicationLabel.isSelectable = false;
			this._content.addChild(this._medicationLabel);
			this._medicationLabel.width = this.actualWidth;
			this._medicationLabel.validate();
*/
			this._seperator = new Image(Main.assets.getTexture("header_line"));
			this._content.addChild(this._seperator);
			this._seperator.width = this.actualWidth;
			this._seperator.y = this._medicationLabel.y + this._medicationLabel.height;

			this._scheduleDoseList = new PickerList();
			this._scheduleDoseList.customButtonName = "border-button";
			var schduleDoseAmounts:ListCollection = new ListCollection
			(
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
			this._content.addChild(this._scheduleDoseList);
			this._scheduleDoseList.validate();
			this._scheduleDoseList.x = this._horizontalPadding;
			this._scheduleDoseList.y = this._seperator.y + (this._componentGap * 3);

			this._takeLabel = new Label();
			this._takeLabel.name = HivivaThemeConstants.INPUT_LABEL_LEFT;
			this._takeLabel.text = "Take";
			this._content.addChild(this._takeLabel);
			this._takeLabel.textRendererProperties.textFormat.size = 24 * this.dpiScale;
			this._takeLabel.textRendererProperties.textFormat.align = TextFormatAlign.CENTER;
			this._takeLabel.validate();
			this._takeLabel.y = this._scheduleDoseList.y + this._scheduleDoseList.height + this._componentGap;
			this._takeLabel.x = this._horizontalPadding;
			this._takeLabel.width = this._scheduleDoseList.width;
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
				timeList.customButtonName = "border-button";
				timeList.dataProvider = times;
				timeList.listProperties.@itemRendererProperties.labelField = "text";
				timeList.labelField = "text";
				timeList.typicalItem = "Select time  ";
				timeList.prompt = "Select time";
				timeList.selectedIndex = -1;
				timeList.name = "tileList" + i;
				timeList.addEventListener(starling.events.Event.CHANGE , timeListTabletListChangeHandler);
				this._content.addChild(timeList);
				timeList.validate();
				timeList.x = this._horizontalPadding;
				if(i == 0 )
				{
					timeList.y = this._takeLabel.y + this._takeLabel.height + this._componentGap;
				}
				else
				{
					var prevListItem:PickerList = this._content.getChildByName("tileList" + (i-1)) as PickerList;
					var andLabel:Label = new Label();
					andLabel.text = "and";
					this._content.addChild(andLabel);
					andLabel.textRendererProperties.textFormat =
							new BitmapFontTextFormat(TextField.getBitmapFont("normal-white-regular"), 24 * this.dpiScale, HivivaThemeConstants.MEDIUM_FONT_COLOUR,TextFormatAlign.CENTER);
					andLabel.validate();
					andLabel.width = prevListItem.width;
					andLabel.x = this._horizontalPadding;
					andLabel.y = prevListItem.y + prevListItem.height + this._componentGap;
					timeList.y = andLabel.y + andLabel.height + this._componentGap;
				}
				_timeListItems.push(timeList);

				//tabletList drop down to select the amount of tablets to be taken on that time slot
				var tabletList:PickerList = new PickerList();
				tabletList.customButtonName = "border-button";
				tabletList.dataProvider = tablets;
				tabletList.listProperties.@itemRendererProperties.labelField = "text";
				tabletList.labelField = "text";
				tabletList.typicalItem = "Select tablet amount ";
				tabletList.prompt = "Select tablet amount";
				tabletList.selectedIndex = -1;
				tabletList.name = "tabletList" + i;
				tabletList.addEventListener(starling.events.Event.CHANGE , timeListTabletListChangeHandler);
				this._content.addChild(tabletList);
				tabletList.validate();
				tabletList.y = timeList.y;
				tabletList.x = this._innerWidth - tabletList.width;
				_tabletListItems.push(tabletList);
			}
		}

		private function timeListTabletListChangeHandler(e:starling.events.Event = null):void
		{
			//TODO create constant for screen edge padding's.

			if(this._saveToProfileBtn != null)
			{
				this._content.removeChild(this._saveToProfileBtn);
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

				this._saveToProfileBtn = new BoxedButtons();
				this._saveToProfileBtn.scale = this.dpiScale;
				this._saveToProfileBtn.labels = ["Add to my profile"];
				this._saveToProfileBtn.addEventListener(starling.events.Event.TRIGGERED, saveProfileBtnHandler);
				this.addChild(this._saveToProfileBtn);
				this._saveToProfileBtn.x = this._horizontalPadding;
				this._saveToProfileBtn.width = this._innerWidth;
				this._saveToProfileBtn.validate();
				this._saveToProfileBtn.y = this._content.y + this._content.height - this._saveToProfileBtn.height - this._verticalPadding;
				this._content.height = this._contentHeight - this._verticalPadding - this._saveToProfileBtn.height - this._componentGap;
				this._content.validate();
			}
		}

		private function saveProfileBtnHandler(e:starling.events.Event):void
		{
			//medicationTimes time as medication should be taken
			//medicationTablets amount of tablets to be taken at medication time
			var medicationScheduleData:Array = [];
			var loop:int = _timeListItems.length;
			for(var i:uint = 0 ; i < loop ; i++)
			{
				var medicationObject:Object = {time:_timeListItems[i].selectedItem.time , count:_tabletListItems[i].selectedItem.count};
				medicationScheduleData.push(medicationObject);

			}
			medicationScheduleData.sortOn("time" , Array.NUMERIC);

			var schedule:String = "";
			for(var j:int = 0 ; j<loop ; j++)
			{
				schedule +=  "count=" + medicationScheduleData[j].count + "|time=" + medicationScheduleData[j].time + ";";
			}
			schedule = schedule.slice(0,-1);

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.ADD_MEDICATION_COMPLETE , addMedicationCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addUserMedication(medicationResult.name , schedule);
		}

		private function addMedicationCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.ADD_MEDICATION_COMPLETE , addMedicationCompleteHandler);
			clearDownListArrayObect();
			this._owner.showScreen(HivivaScreens.PATIENT_EDIT_MEDICATION_SCREEN);

		}

		private function clearDownListArrayObect():void
		{
			if (this._saveToProfileBtn != null)
			{
				this._content.removeChild(this._saveToProfileBtn);
				this._saveToProfileBtn = null;
			}

			while (_timeListItems.length > 0)
			{
				this._content.removeChild(_timeListItems[0]);
				_timeListItems[0].removeEventListener(starling.events.Event.CHANGE, timeListTabletListChangeHandler);
				_timeListItems[0].dataProvider = null;
				_timeListItems[0].dispose();
				_timeListItems[0] = null;
				_timeListItems.shift();

				this._content.removeChild(_tabletListItems[0]);
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

		public function get medicationResult():XML
		{
			return this._medicationResult;
		}

		public function set medicationResult(value:XML):void
		{
			this._medicationResult = value;
		}
	}
}
