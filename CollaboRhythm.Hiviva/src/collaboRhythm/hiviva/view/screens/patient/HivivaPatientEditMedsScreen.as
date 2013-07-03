package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
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
	import feathers.controls.Scroller;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;

	import starling.events.Event;

	public class HivivaPatientEditMedsScreen extends Screen
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

		protected var _header:HivivaHeader;
		protected var _content:ScrollContainer;
		protected var _contentLayout:VerticalLayout;
		protected var _horizontalPadding:Number;
		protected var _verticalPadding:Number;
		protected var _componentGap:Number;

		protected var _customHeight:Number = 0;
		protected var _contentHeight:Number;

		public function HivivaPatientEditMedsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.title = " ";
			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			this._horizontalPadding = (this.actualWidth * 0.04) * this.dpiScale;
			this._verticalPadding = (this.actualHeight * 0.02) * this.dpiScale;
			this._componentGap = (this.actualHeight * 0.04) * this.dpiScale;

			this._contentLayout = new VerticalLayout();
			this._contentLayout.paddingLeft = this._contentLayout.paddingRight = this._horizontalPadding;
			this._contentLayout.paddingTop = this._contentLayout.paddingBottom = this._verticalPadding;
			this._contentLayout.gap = this._componentGap;
			this._content.layout = this._contentLayout;

			checkMedicationsExist();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.scale = this.dpiScale;
			addChild(this._header);

			this._content = new ScrollContainer();
			this._content.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			addChild(this._content);



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
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatientMedicationList();
		}

		private function getPatientMedicationListComplete(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			trace("medicationsLoadCompleteHandler " + e.data.xmlResponse);

			var medicationsXML:XMLList = e.data.xmlResponse.DCUserMedication;

			trace(medicationsXML.length());

			if(medicationsXML.length() >0)
			{
				this._medications = [];
				var medLoop:int = medicationsXML.length();
				for(var i:int = 0 ; i < medLoop ; i++)
				{
					var medObj:Object = {medication_name:medicationsXML[i].MedicationName , id: medicationsXML[i].MedicationID};
					this._medications.push(medObj);
				}
				initializeShowMedications();
			}
			else
			{
				initializeEnterRegimen();
			}
		}

		private function initializeShowMedications():void
		{
			this._header.title = "Your daily medicines";
			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			this._editMedsCells = new <EditMedicationCell>[];
			var medicationsLoop:uint = this._medications.length;
			var editMedicationCell:EditMedicationCell;

			for (var i:uint = 0; i < medicationsLoop; i++)
			{
				editMedicationCell = new EditMedicationCell();
				editMedicationCell.addEventListener(Event.REMOVED_FROM_STAGE, editMedicationCellRemoved);
				editMedicationCell.medicationId = int(this._medications[i].id);
				editMedicationCell.scale = this.dpiScale;
				editMedicationCell.brandName = HivivaModifier.getBrandName(this._medications[i].medication_name);
				editMedicationCell.genericName = HivivaModifier.getGenericName(this._medications[i].medication_name);
				editMedicationCell.width = this._content.width;
				this._content.addChild(editMedicationCell);
				this._editMedsCells.push(editMedicationCell);
			}

			this._seperator = new Image(Main.assets.getTexture("header_line"));
			this._content.addChild(this._seperator);

			this._addMedBtnBordered = new Button();
			this._addMedBtnBordered.name = HivivaThemeConstants.BORDER_BUTTON;
			this._addMedBtnBordered.label = "Add a medicine";
			this._addMedBtnBordered.addEventListener(Event.TRIGGERED, addMedBtnHandler);
			this._content.addChild(this._addMedBtnBordered);

			this._saveAndContinueBoxed = new BoxedButtons();
			this._saveAndContinueBoxed.addEventListener(Event.TRIGGERED, backBtnHandler);
			this._saveAndContinueBoxed.scale = this.dpiScale;
			this._saveAndContinueBoxed.labels = ["Save and continue"];
			this.addChild(this._saveAndContinueBoxed);

			//previous draw

			this._horizontalPadding = (this.actualWidth * 0.04) * this.dpiScale;
			this._verticalPadding = (this.actualHeight * 0.02) * this.dpiScale;
			this._componentGap = (this.actualHeight * 0.04) * this.dpiScale;

			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			this._contentHeight = this._customHeight > 0 ? this._customHeight : this.actualHeight;
			this._contentHeight -= (this._header.y + this._header.height);

			this._content.y = this._header.y + this._header.height;
			this._content.width = this.actualWidth - this._horizontalPadding;
			this._content.height = this._contentHeight - this._verticalPadding;

			this._contentLayout.paddingLeft = this._contentLayout.paddingRight = this._horizontalPadding;
			this._contentLayout.paddingTop = this._contentLayout.paddingBottom = this._verticalPadding;
			this._contentLayout.gap = this._componentGap;

			//previous pre-validate

			this._saveAndContinueBoxed.width = this.actualWidth - (this._horizontalPadding * 2);
			this._saveAndContinueBoxed.x = this._horizontalPadding;
			this._saveAndContinueBoxed.validate();
			this._saveAndContinueBoxed.y = this.actualHeight - this._saveAndContinueBoxed.height - this._verticalPadding;

			drawMedications();

			this._content.width = this.actualWidth;

			this._contentLayout.paddingLeft = this._contentLayout.paddingRight = 0;
			this._contentLayout.paddingTop = this._contentLayout.paddingBottom = 0;
			this._contentLayout.gap = 0;

			this._content.validate();

			//previous post-validate

			this._seperator.width = this.actualWidth;

			this._addMedBtnBordered.x = this._horizontalPadding;
			this._addMedBtnBordered.y = this._seperator.y + this._componentGap;
		}

		private function drawMedications():void
		{
			var medicationsLoop:uint = this._editMedsCells.length;
			var editMedicationCell:EditMedicationCell;
			for (var i:uint = 0; i < medicationsLoop; i++)
			{
				editMedicationCell = this._editMedsCells[i];
				editMedicationCell.width = this.actualWidth;
				editMedicationCell.validate();
			}
		}

		private function initializeEnterRegimen():void
		{
			this._header.title = "Enter your regimen";
			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			this._contentHeight = this._customHeight > 0 ? this._customHeight : this.actualHeight;
			this._contentHeight -= (this._header.y + this._header.height);

			trace("this._contentHeight " + this._contentHeight);

			this._content.y = this._header.y + this._header.height;
			this._content.width = this.actualWidth - this._horizontalPadding;
			this._content.height = this._contentHeight - this._verticalPadding;


			this._snakeyThing = new Image(Assets.getTexture(HivivaAssets.SNAKEY_THING));
			this._content.addChild(this._snakeyThing);

			this._snakeyThing.width = this.actualWidth * 0.5;
			this._snakeyThing.scaleY = this._snakeyThing.scaleX;

			this._addMedBtnBoxed = new BoxedButtons();
			this._addMedBtnBoxed.addEventListener(Event.TRIGGERED, addMedBtnHandler);
			this._addMedBtnBoxed.scale = this.dpiScale;
			this._addMedBtnBoxed.labels = ["ADD A MEDICINE"];
			this._content.addChild(this._addMedBtnBoxed);

			this._addMedBtnBoxed.width = this.actualWidth - (this._horizontalPadding * 2);

			this._content.validate();

			this._snakeyThing.x = (this.actualWidth * 0.5) - (this._snakeyThing.width * 0.5);
			this._snakeyThing.y = (this._content.height * 0.5) - ((this._snakeyThing.height + this._componentGap + this._addMedBtnBoxed.height) * 0.5);

			this._addMedBtnBoxed.y = this._snakeyThing.y + this._snakeyThing.height + this._componentGap;
			this._addMedBtnBoxed.x = this._horizontalPadding;
		}

		private function editMedicationCellRemoved(e:Event):void
		{
			var currEditMedicationCell:EditMedicationCell = e.target as EditMedicationCell;
			currEditMedicationCell.removeEventListener(Event.REMOVED_FROM_STAGE, editMedicationCellRemoved);
			trace("medication cell removed");

			this._content.layout = this._contentLayout;

			this._horizontalPadding = (this.actualWidth * 0.04) * this.dpiScale;
			this._verticalPadding = (this.actualHeight * 0.02) * this.dpiScale;
			this._componentGap = (this.actualHeight * 0.04) * this.dpiScale;

			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			this._contentHeight = this._customHeight > 0 ? this._customHeight : this.actualHeight;
			this._contentHeight -= (this._header.y + this._header.height);

			this._content.y = this._header.y + this._header.height;
			this._content.width = this.actualWidth - this._horizontalPadding;
			this._content.height = this._contentHeight - this._verticalPadding;

			this._contentLayout.paddingLeft = this._contentLayout.paddingRight = this._horizontalPadding;
			this._contentLayout.paddingTop = this._contentLayout.paddingBottom = this._verticalPadding;
			this._contentLayout.gap = this._componentGap;

			//previous pre-validate

			this._saveAndContinueBoxed.width = this.actualWidth - (this._horizontalPadding * 2);
			this._saveAndContinueBoxed.x = this._horizontalPadding;
			this._saveAndContinueBoxed.validate();
			this._saveAndContinueBoxed.y = this.actualHeight - this._saveAndContinueBoxed.height - this._verticalPadding;

			drawMedications();

			this._content.width = this.actualWidth;

			this._contentLayout.paddingLeft = this._contentLayout.paddingRight = 0;
			this._contentLayout.paddingTop = this._contentLayout.paddingBottom = 0;
			this._contentLayout.gap = 0;

			this._content.validate();

			//previous post-validate

			this._seperator.width = this.actualWidth;

			this._addMedBtnBordered.x = this._horizontalPadding;
			this._addMedBtnBordered.y = this._seperator.y + this._componentGap;

		}

		private function addMedBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_ADD_MEDICATION_SCREEN);
		}
	}
}
