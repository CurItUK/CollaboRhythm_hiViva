package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.utils.MedicationNameModifier;
	import collaboRhythm.hiviva.view.components.MedicationCell;
	import collaboRhythm.hiviva.view.components.TakeMedicationCell;

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
		private var _applicationController:HivivaApplicationController;
		private var _medicationSchedule:Array;
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
		}

		private function checkMedicationScheduleExist():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE, medicationsScheduleLoadCompleteHandler);
			localStoreController.getMedicationsSchedule();
		}

		private function medicationsScheduleLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			trace("medicationsLoadCompleteHandler " + e.data.medicationsSchedule);
			this._medicationSchedule = e.data.medicationSchedule;
			localStoreController.removeEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE, medicationsScheduleLoadCompleteHandler);
			if (this._medicationSchedule != null)
			{
				populateMedications();
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
				takeMedicationCell.addEventListener(Event.CHANGE, takeMedicationCellChangeHandler);
				takeMedicationCell.scale = this.dpiScale;
				takeMedicationCell.brandName = MedicationNameModifier.getBrandName(this._medicationSchedule[i].medication_name);
				takeMedicationCell.genericName = MedicationNameModifier.getGenericName(this._medicationSchedule[i].medication_name);
				takeMedicationCell.doseDetails = MedicationNameModifier.getNeatTabletText(this._medicationSchedule[i].tablet_count) + " " + MedicationNameModifier.getNeatTime(this._medicationSchedule[i].time);
				takeMedicationCell.width = this.actualWidth;
				this._takeMedicationCellHolder.addChild(takeMedicationCell);
			}
			drawResults();

		}

		private function takeMedicationCellChangeHandler(e:Event):void
		{
			// TODO: change check  button to 2 radio buttons 'x' and 'tick'
		}

		private function drawResults():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var maxHeight:Number = this.actualHeight - (this._feelingSlider.y + this._feelingSlider.height) - this._footerHeight - (scaledPadding * 2);
			this._takeMedicationCellHolder.y = this._feelingSlider.y + this._feelingSlider.height + scaledPadding;
			this._takeMedicationCellHolder.width = this.actualWidth;
			this._takeMedicationCellHolder.height = maxHeight;

			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = scaledPadding;
			this._takeMedicationCellHolder.layout = layout;
			this._takeMedicationCellHolder.validate();
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
