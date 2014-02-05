package collaboRhythm.hiviva.view.screens.patient
{

	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RXNORMEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.utils.RXNORM_DrugSearch;
	import collaboRhythm.hiviva.view.components.MedicationCell;
	import collaboRhythm.hiviva.view.components.PreloaderSpinner;
	import collaboRhythm.hiviva.view.components.SelectMedicationCell;
	import collaboRhythm.hiviva.view.components.ToggleMedicationCell;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.List;
	import feathers.controls.Radio;

	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;

	import flash.text.TextFormat;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;

	import starling.events.Event;
	import starling.textures.Texture;

	public class HivivaPatientAddMedsScreen extends ValidationScreen
	{
		private var _backButton:Button;
		private var _medicationSearchInput:TextInput;
		private var _searchButton:Button;
		private var _continueBtn:Button;
		private var _medicationContainer:ScrollContainer;
		private var _medicationXMLList:XMLList;
		private var _selectedMedicationId:int;
		private var _preloader:PreloaderSpinner;

		public function HivivaPatientAddMedsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();
			this._searchButton.width = this._innerWidth * 0.3;
			this._searchButton.validate();
			this._medicationSearchInput.width = this._innerWidth * 0.65;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();

			this._searchButton.y = this._medicationSearchInput.y + (this._medicationSearchInput.height * 0.5) - (this._searchButton.height * 0.5);
			this._searchButton.x = this._medicationSearchInput.width + this._componentGap;

			this._continueBtn.width = this._innerWidth * 0.3;
			this._continueBtn.validate();
			this._continueBtn.y = this.actualHeight - this._continueBtn.height - this._verticalPadding;
			this._continueBtn.x = this._horizontalPadding;
			// scroll not needed for this screen
			killContentScroll();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Add a medicine";

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._medicationSearchInput = new TextInput();
			this._content.addChild(this._medicationSearchInput);

			this._searchButton = new Button();
			this._searchButton.label = "SEARCH";
			this._searchButton.addEventListener(starling.events.Event.TRIGGERED, searchBtnHandler);
			this._content.addChild(this._searchButton);

			this._continueBtn = new Button();
			this._continueBtn.name = HivivaThemeConstants.BORDER_BUTTON;
			this._continueBtn.label = "Continue";
			this._continueBtn.visible = false;
			this._continueBtn.addEventListener(Event.TRIGGERED, continueBtnHandler);
			this.addChild(this._continueBtn);
		}

		private function backBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_EDIT_MEDICATION_SCREEN);
		}

		private function searchBtnHandler(e:starling.events.Event):void
		{
			var formValidation:String = patientAddMedsSearchCheck();
			if(formValidation.length == 0)
			{
				initPreloader();
				var drugSearch:RXNORM_DrugSearch = new RXNORM_DrugSearch();
				drugSearch.addEventListener(RXNORMEvent.DATA_LOAD_COMPLETE , drugSearchLoadHandler);
				drugSearch.findDrug(this._medicationSearchInput.text);
			}
			else
			{
				showFormValidation(formValidation);
			}
		}

		private function patientAddMedsSearchCheck():String
		{
			var validString:String = "";

			if(this._medicationSearchInput.text.length == 0) validString += "Please enter a medicine name";

			return validString;
		}

		private function drugSearchLoadHandler(e:RXNORMEvent):void
		{
			removePreloder();
			medicationXMLList = e.data.medicationList as XMLList;
			if(medicationXMLList.length() == 0)
			{
				showFormValidation("No medicines were found");
			}
			else
			{
//				hideFormValidation();

				if(this._medicationContainer != null)
				{
					this._medicationContainer.removeChildren(0,-1,true);
					this.removeChild(this._medicationContainer);
					this._medicationContainer = null;
				}

				this._medicationContainer = new ScrollContainer();

				this._medicationContainer.width = this.actualWidth;
				this._medicationContainer.y = this._content.y + this._medicationSearchInput.y + this._medicationSearchInput.height + this._componentGap;
				this._medicationContainer.layout = new VerticalLayout();
				this.addChild(this._medicationContainer);

				populateMedications();
			}
		}

		private function populateMedications():void
		{
			var medicationsLoop:uint = this._medicationXMLList.length();
			for (var i:uint = 0; i < medicationsLoop; i++)
			{
				var foundMedication:ToggleMedicationCell = new ToggleMedicationCell(MedicationCell.WHITE_THEME_LITE);
				foundMedication.addEventListener(FeathersScreenEvent.MEDICATION_RADIO_TRIGGERED, medicationRadioTriggerHandler);
				foundMedication.scale = this.dpiScale;
				foundMedication.medicationId = i;
				foundMedication.brandName = HivivaModifier.getBrandName(this._medicationXMLList[i].name);
				foundMedication.genericName = HivivaModifier.getGenericName(this._medicationXMLList[i].name);
				foundMedication.width = this._medicationContainer.width;
				this._medicationContainer.addChild(foundMedication);
			}
			// select first result
			ToggleMedicationCell(this._medicationContainer.getChildAt(0)).radio.isSelected = true;
			this._selectedMedicationId = 0;
			this._medicationContainer.validate();

//			if(this._continueBtn == null) addContinueButton();
			this._continueBtn.visible = true;

			var usableScrollHeight:Number = this.actualHeight - this._medicationContainer.y -
										this._verticalPadding - this._continueBtn.height - this._componentGap;

			if(this._medicationContainer.height > usableScrollHeight)
			{
				this._medicationContainer.height = usableScrollHeight;
			}
			this._medicationContainer.validate();
		}

		protected function addContinueButton():void
		{
			this._continueBtn = new Button();
			this._continueBtn.label = "Continue";
			this._continueBtn.addEventListener(Event.TRIGGERED, continueBtnHandler);
			this.addChild(this._continueBtn);
			this._continueBtn.width = this._innerWidth * 0.3;
			this._continueBtn.validate();
			this._continueBtn.y = this.actualHeight - this._continueBtn.height - this._verticalPadding;
			this._continueBtn.x = this._horizontalPadding;
		}

		private function medicationRadioTriggerHandler(e:FeathersScreenEvent):void
		{
			this._selectedMedicationId = e.evtData.activeId;
		}

		private function continueBtnHandler(e:starling.events.Event):void
		{
			var selectedMedicine:XML = medicationXMLList[this._selectedMedicationId];
			var screenParams:Object = {medicationResult:selectedMedicine};
			var screenNavigatorItem:ScreenNavigatorItem = new ScreenNavigatorItem(HivivaPatientScheduleMedsScreen , null , screenParams);

			if(this.owner.getScreenIDs().indexOf(HivivaScreens.PATIENT_SCHEDULE_MEDICATION_SCREEN) == -1)
			{
				this.owner.addScreen(HivivaScreens.PATIENT_SCHEDULE_MEDICATION_SCREEN, screenNavigatorItem);
			}
			else
			{
				this.owner.removeScreen(HivivaScreens.PATIENT_SCHEDULE_MEDICATION_SCREEN);
				this.owner.addScreen(HivivaScreens.PATIENT_SCHEDULE_MEDICATION_SCREEN, screenNavigatorItem);
			}
			this.owner.showScreen(HivivaScreens.PATIENT_SCHEDULE_MEDICATION_SCREEN);
		}

		private function initPreloader():void
		{
			this._preloader = new PreloaderSpinner();
			this.addChild(this._preloader) ;
			this._preloader.y = this.actualHeight/2 - this._preloader.height/2;
			this._preloader.x = this.actualWidth/2 - this._preloader.width/2;
		}

		private function removePreloder():void
		{
			this._preloader.disposePreloader();
			this.removeChild(this._preloader);
		}

		override public function dispose():void
		{
			super.dispose();
		}

		public function get medicationXMLList():XMLList
		{
			return _medicationXMLList;
		}

		public function set medicationXMLList(value:XMLList):void
		{
			_medicationXMLList = value;
		}
	}
}
