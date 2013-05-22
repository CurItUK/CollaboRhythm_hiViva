package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.view.*;

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.utils.HivivaModifier;
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

	import starling.display.Image;

	import starling.events.Event;


	public class HivivaPatientTakeMedsScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _feelingQuestion:Label;
		private var _feelingSlider:Slider;
		private var _feelingSliderLeftLabel:Label;
		private var _feelingSliderCenterLabel:Label;
		private var _feelingSliderRightLabel:Label;
		private var _feelingSliderLeftImage:Image;
		private var _feelingSliderRightImage:Image;
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
			this._feelingQuestion.width = this.actualWidth - (scaledPadding * 10);
			this._feelingQuestion.x = scaledPadding * 5;
			this._feelingQuestion.y = this._header.y + this._header.height;

			this._feelingSlider.validate();
			this._feelingSlider.width = this._feelingQuestion.width + (scaledPadding * 3);
			this._feelingSlider.x = this._feelingQuestion.x - (scaledPadding * 1.5);
			this._feelingSlider.y = this._feelingQuestion.y + this._feelingQuestion.height;

			this._feelingSliderLeftImage.y = this._feelingSliderRightImage.y = this._feelingSlider.y + (this._feelingSlider.height * 0.5)

			this._feelingSliderLeftImage.x = this._feelingSlider.x - this._feelingSliderLeftImage.width;
			this._feelingSliderLeftImage.y -= this._feelingSliderLeftImage.height * 0.5;

			this._feelingSliderRightImage.x = this._feelingSlider.x + this._feelingSlider.width;
			this._feelingSliderRightImage.y -= this._feelingSliderRightImage.height * 0.5;

			this._feelingSliderLeftLabel.validate();
			this._feelingSliderLeftLabel.y = this._feelingSlider.y + this._feelingSlider.height;
			this._feelingSliderLeftLabel.x = this._feelingSliderLeftImage.x + (this._feelingSliderLeftImage.width * 0.5) - (this._feelingSliderLeftLabel.width * 0.5);

			this._feelingSliderCenterLabel.validate();
			this._feelingSliderCenterLabel.y = this._feelingSlider.y + this._feelingSlider.height;
			this._feelingSliderCenterLabel.x = this._feelingSlider.x + (this._feelingSlider.width * 0.5) - (this._feelingSliderCenterLabel.width * 0.5);

			this._feelingSliderRightLabel.validate();
			this._feelingSliderRightLabel.y = this._feelingSlider.y + this._feelingSlider.height;
			this._feelingSliderRightLabel.x = this._feelingSliderRightImage.x + (this._feelingSliderRightImage.width * 0.5) - (this._feelingSliderRightLabel.width * 0.5);

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
			this._feelingSlider.name = "feeling-slider";
			this._feelingSlider.customThumbName = "feeling-slider";
			this._feelingSlider.minimum = 0;
			this._feelingSlider.maximum = 100;
			this._feelingSlider.value = 50;
			this._feelingSlider.step = 1;
			this._feelingSlider.page = 10;
			this._feelingSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._feelingSlider.liveDragging = false;
			this.addChild(this._feelingSlider);

			this._feelingSliderLeftImage = new Image(HivivaAssets.FEELING_SLIDER_CLOUD);
			addChild(this._feelingSliderLeftImage);

			this._feelingSliderRightImage = new Image(HivivaAssets.FEELING_SLIDER_SUN);
			addChild(this._feelingSliderRightImage);

			this._feelingSliderLeftLabel = new Label();
			this._feelingSliderLeftLabel.name = "feeling-slider-label";
			this._feelingSliderLeftLabel.text = "AWFUL";
			addChild(this._feelingSliderLeftLabel);

			this._feelingSliderCenterLabel = new Label();
			this._feelingSliderCenterLabel.name = "feeling-slider-label";
			this._feelingSliderCenterLabel.text = "OK";
			addChild(this._feelingSliderCenterLabel);

			this._feelingSliderRightLabel = new Label();
			this._feelingSliderRightLabel.name = "feeling-slider-label";
			this._feelingSliderRightLabel.text = "AWESOME";
			addChild(this._feelingSliderRightLabel);

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
				today:String = HivivaModifier.getSQLStringFromDate(new Date());
			for (var i:uint = 0; i < medicationsLoop; i++)
			{
				takeMedicationCell = this._takeMedicationCellHolder.getChildAt(i) as TakeMedicationCell;
				if(takeMedicationCell.checkBox.isSelected)
				{
					data.push("id:" + takeMedicationCell.medicationScheduleId + ";" + "feeling:" + this._feelingSlider.value)
				}
			}

			var adherencePer:Number = (data.length / medicationsLoop) * 100;

			if (data.length > 0)
			{
				localStoreController.addEventListener(LocalDataStoreEvent.ADHERENCE_SAVE_COMPLETE, adherenceSaveCompleteHandler);
				localStoreController.setAdherence({date:today, data:data, adherence_percentage:adherencePer});
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
				takeMedicationCell.brandName = HivivaModifier.getBrandName(this._medicationSchedule[i].medication_name);
				takeMedicationCell.genericName = HivivaModifier.getGenericName(this._medicationSchedule[i].medication_name);
				takeMedicationCell.doseDetails = HivivaModifier.getNeatTabletText(this._medicationSchedule[i].tablet_count) + " " + HivivaModifier.getNeatTime(this._medicationSchedule[i].time);
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
			var maxHeight:Number = this.actualHeight - (this._feelingSliderRightLabel.y + this._feelingSliderRightLabel.height) - this._submitButton.height - this._footerHeight - (scaledPadding * 3);
			this._takeMedicationCellHolder.y = this._feelingSliderRightLabel.y + this._feelingSliderRightLabel.height + scaledPadding;
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
				latestAdherenceDate:Date = HivivaModifier.getAS3DatefromString(this._latestAdherenceData.date),
				dayDiff:Number = HivivaModifier.getDaysDiff(today, latestAdherenceDate),
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
