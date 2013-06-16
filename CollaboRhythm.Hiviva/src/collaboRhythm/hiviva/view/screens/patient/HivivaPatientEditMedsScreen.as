package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.view.*;

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.components.EditMedicationCell;
	import collaboRhythm.hiviva.view.components.MedicationCell;
	import collaboRhythm.hiviva.view.media.Assets;
	import collaboRhythm.hiviva.view.screens.shared.BaseScreen;

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
	import starling.display.Image;
	import starling.display.Sprite;

	import starling.events.Event;

	public class HivivaPatientEditMedsScreen extends BaseScreen
	{
		private var _backButton:Button;
		private var _snakeyThing:Image;
		private var _addMedBtnBordered:Button;
		private var _addMedBtnBoxed:BoxedButtons;
		private var _saveAndContinueBoxed:BoxedButtons;
		private var _seperator:Image;
		private var _medications:Array;
		private var _medsExist:Boolean;
		private var _editMedsCells:Vector.<EditMedicationCell>;

		public function HivivaPatientEditMedsScreen()
		{
		}

		override protected function draw():void
		{
			super.draw();
		}

		override protected function preValidateContent():void
		{
			if(this._medsExist)
			{
				this._saveAndContinueBoxed.width = this.actualWidth - (this._horizontalPadding * 2);
				this._saveAndContinueBoxed.x = this._horizontalPadding;
				this._saveAndContinueBoxed.validate();
				this._saveAndContinueBoxed.y = this.actualHeight - this._saveAndContinueBoxed.height - this._verticalPadding;

//				this._customHeight = this._saveAndContinueBoxed.y - this._componentGap;

				drawMedications();
			}
			else
			{
				this._snakeyThing.width = this.actualWidth * 0.5;
				this._snakeyThing.scaleY = this._snakeyThing.scaleX;

				this._addMedBtnBoxed.width = this.actualWidth - (this._horizontalPadding * 2);
			}

			this._content.width = this.actualWidth;

			this._contentLayout.paddingLeft = this._contentLayout.paddingRight = 0;
			this._contentLayout.paddingTop = this._contentLayout.paddingBottom = 0;
			this._contentLayout.gap = 0;
		}

		override protected function postValidateContent():void
		{
			if(this._medsExist)
			{
				this._seperator.width = this.actualWidth;

				this._addMedBtnBordered.x = this._horizontalPadding;
				this._addMedBtnBordered.y = this._seperator.y + this._componentGap;
			}
			else
			{
				this._snakeyThing.x = (this.actualWidth * 0.5) - (this._snakeyThing.width * 0.5);
				this._snakeyThing.y = (this._content.height * 0.5) - ((this._snakeyThing.height + this._componentGap + this._addMedBtnBoxed.height) * 0.5);
				this._addMedBtnBoxed.y = this._snakeyThing.y + this._snakeyThing.height + this._componentGap;
				this._addMedBtnBoxed.x = this._horizontalPadding;
			}
		}

		override protected function initialize():void
		{
			super.initialize();

			checkMedicationsExist();

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}

		private function backBtnHandler(e:Event):void
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
			this._medsExist = this._medications != null;
			if (this._medsExist)
			{
				initializeShowMedications();
			}
			else
			{
				initializeEnterRegimen()
			}
		}

		private function initializeEnterRegimen():void
		{
			this._header.title = "Enter your regimen";

			this._snakeyThing = new Image(Assets.getTexture(HivivaAssets.SNAKEY_THING));
			this._content.addChild(this._snakeyThing);

			this._addMedBtnBoxed = new BoxedButtons();
			this._addMedBtnBoxed.addEventListener(Event.TRIGGERED, addMedBtnHandler);
			this._addMedBtnBoxed.scale = this.dpiScale;
			this._addMedBtnBoxed.labels = ["ADD A MEDICINE"];
			this._content.addChild(this._addMedBtnBoxed);

			draw();
		}

		private function initializeShowMedications():void
		{
			this._header.title = "Your daily medicines";

			this._editMedsCells = new <EditMedicationCell>[];
			var medicationsLoop:uint = this._medications.length,
				editMedicationCell:EditMedicationCell;
			for (var i:uint = 0; i < medicationsLoop; i++)
			{
				editMedicationCell = new EditMedicationCell();
				editMedicationCell.addEventListener(Event.REMOVED_FROM_STAGE, editMedicationCellRemoved);
				editMedicationCell.medicationId = int(this._medications[i].id);
				editMedicationCell.scale = this.dpiScale;
				editMedicationCell.brandName = HivivaModifier.getBrandName(this._medications[i].medication_name);
				editMedicationCell.genericName = HivivaModifier.getGenericName(this._medications[i].medication_name);
				this._content.addChild(editMedicationCell);
				this._editMedsCells.push(editMedicationCell);
			}

			this._seperator = new Image(Main.assets.getTexture("header_line"));
			this._content.addChild(this._seperator);

			this._addMedBtnBordered = new Button();
			this._addMedBtnBordered.name = "border-button";
			this._addMedBtnBordered.label = "Add a medicine";
			this._addMedBtnBordered.addEventListener(Event.TRIGGERED, addMedBtnHandler);
			this._content.addChild(this._addMedBtnBordered);

			this._saveAndContinueBoxed = new BoxedButtons();
			this._saveAndContinueBoxed.addEventListener(Event.TRIGGERED, backBtnHandler);
			this._saveAndContinueBoxed.scale = this.dpiScale;
			this._saveAndContinueBoxed.labels = ["Save and continue"];
			this.addChild(this._saveAndContinueBoxed);

			draw();
		}

		private function drawMedications():void
		{
			var medicationsLoop:uint = this._editMedsCells.length,
				editMedicationCell:EditMedicationCell;
			for (var i:uint = 0; i < medicationsLoop; i++)
			{
				editMedicationCell = this._editMedsCells[i];
				editMedicationCell.width = this.actualWidth;
				editMedicationCell.validate();
			}
		}

		private function editMedicationCellRemoved(e:Event):void
		{
			var currEditMedicationCell:EditMedicationCell = e.target as EditMedicationCell;
			currEditMedicationCell.removeEventListener(Event.REMOVED_FROM_STAGE, editMedicationCellRemoved);
			trace("medication cell removed");

			this._content.layout = this._contentLayout;
			draw();
		}

		private function addMedBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_ADD_MEDICATION_SCREEN);
		}
	}
}
