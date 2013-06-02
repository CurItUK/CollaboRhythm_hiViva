package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.view.*;

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.components.EditMedicationCell;
	import collaboRhythm.hiviva.view.components.MedicationCell;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;

	import starling.display.DisplayObject;
	import starling.display.Sprite;

	import starling.events.Event;

	public class HivivaPatientEditMedsScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _applicationController:HivivaApplicationController;
		private var _backButton:Button;
		private var _addMedBtn:Button;
		private var _medications:Array;
		private var _takeMedicationCellHolder:ScrollContainer;

		private const PADDING:Number = 20;


		public function HivivaPatientEditMedsScreen()
		{
			HivivaAssets
		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._addMedBtn.validate();
			this._addMedBtn.y = this.actualHeight - this._addMedBtn.height - 20;
			this._addMedBtn.x = 20;


			checkMedicationsExist();
		}

		override protected function initialize():void
		{

			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Enter your Regimen";
			this.addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._addMedBtn = new Button();
			this._addMedBtn.label = "Add a medicine";
			this._addMedBtn.addEventListener(starling.events.Event.TRIGGERED, addMedBtnHandler);
			this.addChild(this._addMedBtn);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._takeMedicationCellHolder = new ScrollContainer();
		}

		private function backBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function checkMedicationsExist():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE, medicationsLoadCompleteHandler);
			localStoreController.getMedicationList();
		}

		private function medicationsLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			trace("medicationsLoadCompleteHandler " + e.data.medications);
			this._medications = e.data.medications;
			localStoreController.removeEventListener(LocalDataStoreEvent.MEDICATIONS_LOAD_COMPLETE,	medicationsLoadCompleteHandler);
			if (this._medications != null)
			{
				populateMedications();
			}
		}

		private function populateMedications():void
		{
			this.addChild(this._takeMedicationCellHolder);


			var medicationsLoop:uint = this._medications.length;
			for (var i:uint = 0; i < medicationsLoop; i++)
			{
				var editMedicationCell:EditMedicationCell = new EditMedicationCell();
				editMedicationCell.applicationController = _applicationController;
				editMedicationCell.medicationId = int(this._medications[i].id);
				editMedicationCell.scale = this.dpiScale;
				editMedicationCell.brandName = HivivaModifier.getBrandName(this._medications[i].medication_name);
				editMedicationCell.genericName = HivivaModifier.getGenericName(this._medications[i].medication_name);
				editMedicationCell.width = this.actualWidth;
				this._takeMedicationCellHolder.addChild(editMedicationCell);
				editMedicationCell.addEventListener(Event.REMOVED_FROM_STAGE, editMedicationCellRemoved);
			}
			drawResults();

		}

		private function editMedicationCellRemoved(e:Event):void
		{
			var editMedicationCell:EditMedicationCell = e.target as EditMedicationCell;
			editMedicationCell.removeEventListener(Event.REMOVED_FROM_STAGE, editMedicationCellRemoved);
			trace("medication cell removed");
			this._takeMedicationCellHolder.validate();
		}

		private function drawResults():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var maxHeight:Number = this.actualHeight - this._header.height - (scaledPadding * 2) - this._addMedBtn.height - 30;
			this._takeMedicationCellHolder.y = this._header.height + 20;
			this._takeMedicationCellHolder.height = maxHeight;
			this._takeMedicationCellHolder.width = this.actualWidth;

			this._takeMedicationCellHolder.validate();

			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = scaledPadding;
			this._takeMedicationCellHolder.layout = layout;
			this._takeMedicationCellHolder.validate();


		}

		private function addMedBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_ADD_MEDICATION_SCREEN);
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
