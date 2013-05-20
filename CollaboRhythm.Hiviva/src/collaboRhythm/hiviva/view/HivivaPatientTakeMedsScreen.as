package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.utils.MedicationNameModifier;
	import collaboRhythm.hiviva.utils.MedicationNameModifier;
	import collaboRhythm.hiviva.view.components.MedicationCell;
	import collaboRhythm.hiviva.view.components.TakeMedicationCell;

	import feathers.controls.Button;

	import feathers.controls.Check;

	import feathers.controls.Label;

	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Slider;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;

	import starling.events.Event;


	public class HivivaPatientTakeMedsScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _feelingQuestion:Label;
		private var _feelingSlider:Slider;
		private var _submitButton:Button;
		private var _applicationController:HivivaApplicationController;
		private var _medicationSchedule:Array;
		private var _latestAdherenceData:Object;
		private var _takeMedicationCellHolder:ScrollContainer;
		private var _footerHeight:Number;

		private const PADDING:Number = 20;

		public function HivivaPatientTakeMedsScreen()
		{

		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;

			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._feelingQuestion.validate();
			this._feelingQuestion.width = this.actualWidth - (scaledPadding * 2);
			this._feelingQuestion.x = scaledPadding;
			this._feelingQuestion.y = this._header.y + this._header.height;

			this._feelingSlider.validate();
			this._feelingSlider.width = this._feelingQuestion.width;
			this._feelingSlider.x = this._feelingQuestion.x;
			this._feelingSlider.y = this._feelingQuestion.y + this._feelingQuestion.height;

			this._submitButton.validate();
			this._submitButton.x = scaledPadding;
			this._submitButton.y = this.actualHeight - this._footerHeight - scaledPadding - this._submitButton.height;

			checkMedicationScheduleExist();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Take Medication";
			addChild(this._header);

			this._feelingQuestion = new Label();
			this._feelingQuestion.text = "<font face='ExoBold'>How am I feeling on my meds today?</font>";
			addChild(this._feelingQuestion);

			this._feelingSlider = new Slider();
			this._feelingSlider.minimum = 0;
			this._feelingSlider.maximum = 100;
			this._feelingSlider.value = 50;
			this._feelingSlider.step = 1;
			this._feelingSlider.page = 10;
			this._feelingSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._feelingSlider.liveDragging = false;
			this.addChild(this._feelingSlider);
			// to check value on submit this._feelingSlider.value;

			this._takeMedicationCellHolder = new ScrollContainer();

			this._submitButton = new Button();
			this._submitButton.visible = false;
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonHandler);
			this._submitButton.label = "Save";
			addChild(this._submitButton);
		}

		private function submitButtonHandler(e:Event):void
		{
			// submit changed data only
			var medicationsLoop:uint = this._medicationSchedule.length,
				takeMedicationCell:TakeMedicationCell,
				data:Array = [],
				today:String = MedicationNameModifier.getSQLStringFromDate(new Date());
			for (var i:uint = 0; i < medicationsLoop; i++)
			{
				takeMedicationCell = this._takeMedicationCellHolder.getChildAt(i) as TakeMedicationCell;
				if(takeMedicationCell.checkBox.isSelected)
				{
					data.push("id:" + takeMedicationCell.medicationScheduleId + ";" + "feeling:" + this._feelingSlider.value)
				}
			}
			if (data.length > 0)
			{
				localStoreController.addEventListener(LocalDataStoreEvent.ADHERENCE_SAVE_COMPLETE, adherenceSaveCompleteHandler);
				localStoreController.setAdherence({date:today, data:data});
			}
		}

		private function adherenceSaveCompleteHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.ADHERENCE_SAVE_COMPLETE, adherenceSaveCompleteHandler);
			trace("data saved");
		}

		private function checkMedicationScheduleExist():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE, medicationsScheduleLoadCompleteHandler);
			localStoreController.getMedicationsSchedule();
		}

		private function medicationsScheduleLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			trace("medicationsLoadCompleteHandler " + e.data.medicationSchedule);
			this._medicationSchedule = e.data.medicationSchedule;
			localStoreController.removeEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE, medicationsScheduleLoadCompleteHandler);
			if (this._medicationSchedule != null)
			{
				populateMedications();

				localStoreController.addEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE, adherenceLoadCompleteHandler);
				localStoreController.getAdherence();
			}
			else
			{
				//TODO display message / button link to add medications if empty

			}
		}

		private function populateMedications():void
		{
			this.addChild(this._takeMedicationCellHolder);


			var medicationsLoop:uint = this._medicationSchedule.length;
			for (var i:uint = 0; i < medicationsLoop; i++)
			{
				var takeMedicationCell:TakeMedicationCell = new TakeMedicationCell();
				takeMedicationCell.medicationScheduleId = this._medicationSchedule[i].id;
				takeMedicationCell.scale = this.dpiScale;
				takeMedicationCell.brandName = MedicationNameModifier.getBrandName(this._medicationSchedule[i].medication_name);
				takeMedicationCell.genericName = MedicationNameModifier.getGenericName(this._medicationSchedule[i].medication_name);
				takeMedicationCell.doseDetails = MedicationNameModifier.getNeatTabletText(this._medicationSchedule[i].tablet_count) + " " + MedicationNameModifier.getNeatTime(this._medicationSchedule[i].time);
				takeMedicationCell.width = this.actualWidth;
				this._takeMedicationCellHolder.addChild(takeMedicationCell);
				takeMedicationCell.checkBox.addEventListener(Event.TRIGGERED, medCellChangeHandler);
			}
			drawResults();

		}

		private function medCellChangeHandler(e:Event):void
		{
			if (!this._submitButton.visible)
			{
				this._submitButton.visible = true;
				this._submitButton.validate();
			}
		}

		private function drawResults():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var maxHeight:Number = this.actualHeight - (this._feelingSlider.y + this._feelingSlider.height) - this._submitButton.height - this._footerHeight - (scaledPadding * 3);
			this._takeMedicationCellHolder.y = this._feelingSlider.y + this._feelingSlider.height + scaledPadding;
			this._takeMedicationCellHolder.width = this.actualWidth;
			this._takeMedicationCellHolder.height = maxHeight;

			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = scaledPadding;
			this._takeMedicationCellHolder.layout = layout;
			this._takeMedicationCellHolder.validate();
		}

		private function adherenceLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			trace("adherenceLoadCompleteHandler " + e.data.adherence);
			localStoreController.removeEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE, adherenceLoadCompleteHandler);

			var allAdherenceData:Array = e.data.adherence;
			if (allAdherenceData != null)
			{
				this._latestAdherenceData = allAdherenceData[allAdherenceData.length - 1];
				populateCurrentAdherence();
			}
		}

		private function populateCurrentAdherence():void
		{
			var today:Date = new Date(),
				latestAdherenceDate:Date = MedicationNameModifier.getAS3DatefromString(this._latestAdherenceData.date),
				dayDiff:Number = MedicationNameModifier.getDaysDiff(today, latestAdherenceDate),
				latestAdherenceData:Array = String(this._latestAdherenceData.data).split(","),
				rawIdData:String,
				medicationId:int,
				feeling:Number,
				takeMedicationCell:TakeMedicationCell;
			// latestAdherence.date
			// latestAdherence.data[i].medication_id
			// latestAdherence.data[i].feeling
			// its the same day since the last adherence update so select taken medicines
			if (dayDiff == 0)
			{
				for (var i:int = 0; i < latestAdherenceData.length; i++)
				{
					rawIdData = String(latestAdherenceData[i]).split(";")[0];
					medicationId = int(rawIdData.split(":")[1]);
					//feeling = latestAdherenceData[i].feeling;

					var medicationsLoop:uint = this._medicationSchedule.length;
					for (var j:uint = 0; j < medicationsLoop; j++)
					{
						takeMedicationCell = this._takeMedicationCellHolder.getChildAt(j) as TakeMedicationCell;
						if(takeMedicationCell.medicationScheduleId == medicationId)
						{
							takeMedicationCell.checkBox.isSelected = true;
							takeMedicationCell.validate();
						}
					}
				}
			}
		}
/*
		private function isMedicineMarkedAsTakenInDatabase(medCell:TakeMedicationCell):Boolean
		{
			var isIt:Boolean = false,
				latestAdherenceData:Array = this._latestAdherenceData.data,
				data:Array,
				selectedMedIdInDatabase:int;
			for (var i:int = 0; i < latestAdherenceData.length; i++)
			{
				data = String(latestAdherenceData[i].data).split(',');
				for (var j:int = 0; j < data.length; j++)
				{
					selectedMedIdInDatabase = int(data[j]);
					if(medCell.medicationScheduleId == selectedMedIdInDatabase)
					{
						isIt = true;
						break;
					}
				}
				if (isIt) break;
			}

			return isIt;
		}
*/

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

		public function get footerHeight():Number
		{
			return _footerHeight;
		}

		public function set footerHeight(value:Number):void
		{
			_footerHeight = value;
		}
	}
}
