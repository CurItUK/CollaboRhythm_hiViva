package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.utils.MedicationNameModifier;
	import collaboRhythm.hiviva.view.components.TakeMedicationCell;

	import feathers.controls.Check;

	import feathers.controls.Label;

	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;


	public class HivivaPatientTakeMedsScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _applicationController:HivivaApplicationController;
		private var _medications:Array;
		private var _takeMedicationCellHolder:ScrollContainer;

		private const PADDING:Number = 20;

		public function HivivaPatientTakeMedsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;
			checkMedicationsExist();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Take Medication";
			addChild(this._header);

			this._takeMedicationCellHolder = new ScrollContainer();
		}

		private function checkMedicationsExist():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE,
					medicationsLoadCompleteHandler);
			localStoreController.getMedicationList();
		}

		private function medicationsLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			trace("medicationsLoadCompleteHandler " + e.data.medications);
			this._medications = e.data.medications;
			localStoreController.removeEventListener(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE,
					medicationsLoadCompleteHandler);
			if (this._medications != null)
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


			var medicationsLoop:uint = this._medications.length;
			for (var i:uint = 0; i < medicationsLoop; i++)
			{
				var takeMedicationCell:TakeMedicationCell = new TakeMedicationCell();
				takeMedicationCell.scale = this.dpiScale;
				takeMedicationCell.brandName = MedicationNameModifier.getBrandName(this._medications[i].medication_name);
				takeMedicationCell.genericName = MedicationNameModifier.getGenericName(this._medications[i].medication_name);
				takeMedicationCell.width = this.actualWidth;
				this._takeMedicationCellHolder.addChild(takeMedicationCell);
			}
			drawResults();

		}

		private function drawResults():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var maxHeight:Number = this.actualHeight - (this._header.height + 20) + scaledPadding;
			this._takeMedicationCellHolder.y = this._header.height + 20;
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
	}
}
