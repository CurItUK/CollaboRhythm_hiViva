package collaboRhythm.hiviva.view.screens.patient
{

	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.RXNORMEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.utils.RXNORM_DrugSearch;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.List;
	import feathers.controls.Radio;

	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;

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
		private var _medicationList:List;
		private var _medications:ListCollection;
		private var _medicationXMLList:XMLList;
		private var _ListToggleGroup:ToggleGroup;

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
			// scroll not needed for this screen
			killContentScroll();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Add a medicine";

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._medicationSearchInput = new TextInput();
			this._content.addChild(this._medicationSearchInput);

			this._searchButton = new Button();
			this._searchButton.label = "SEARCH";
			this._searchButton.addEventListener(starling.events.Event.TRIGGERED, searchBtnHandler);
			this._content.addChild(this._searchButton);
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
			medicationXMLList = e.data.medicationList as XMLList;
			if(medicationXMLList.length() == 0)
			{
				showFormValidation("No medicines were found");
			}
			else
			{
				hideFormValidation();

				if(this._medicationList != null)
				{
					this._medicationList.dataProvider = null;
					this.removeChild(this._medicationList);
					this._medicationList.dispose();
					this._medicationList = null;
				}

				this._medications = new ListCollection(medicationXMLList.name);

				this._ListToggleGroup = new ToggleGroup();

				this._medicationList = new List();
				this._medicationList.width = this.actualWidth;
				this._medicationList.y = this._content.y + this._medicationSearchInput.y + this._medicationSearchInput.height + this._componentGap;
				this._medicationList.dataProvider = this._medications;
				this._medicationList.itemRendererProperties.labelName = "lighter-color-label";
				this._medicationList.itemRendererProperties.labelFunction = labelFunction;
				this._medicationList.itemRendererProperties.accessoryFunction = accessoryFunction;
				this._medicationList.isSelectable = false;
				//this._medicationList.addEventListener(starling.events.Event.CHANGE , listSelectedHandler);

				this.addChild(this._medicationList);
				this._medicationList.validate();

				var usableScrollHeight:Number = this.actualHeight - this._medicationList.y - this._verticalPadding;

				if(this._medicationList.height > usableScrollHeight)
				{
					this._medicationList.height = usableScrollHeight;
					this._medicationList.validate();
				}
			}
		}

		private function labelFunction( item:Object ):String
		{
			var itemXML:XML = item as XML;
			var str:String = "<font face='ExoBold'>" + HivivaModifier.getBrandName(itemXML.toString()) + "</font> <br/>" +
								HivivaModifier.getGenericName(itemXML.toString());

			return str;
		}

		private function accessoryFunction( item:Object ):DisplayObject
		{
			var radio:Radio = new Radio();
			radio.addEventListener(Event.TRIGGERED, listSelectedHandler);
			this._ListToggleGroup.addItem(radio);

			return radio;
		}

		private function listSelectedHandler(e:starling.events.Event):void
		{
			if(this._continueBtn == null)
			{
				this._continueBtn = new Button();
				this._continueBtn.label = "Continue";
				this._continueBtn.addEventListener(Event.TRIGGERED, continueBtnHandler);
				this.addChild(this._continueBtn);
				this._continueBtn.validate();
				this._continueBtn.y = this.actualHeight - this._continueBtn.height - this._verticalPadding;
				this._continueBtn.x = this._horizontalPadding;

				var usableScrollHeight:Number = this._continueBtn.y - this._componentGap - this._medicationList.y;

				if(this._medicationList.height > usableScrollHeight)
				{
					this._medicationList.height = usableScrollHeight;
					this._medicationList.validate();
				}
			}
		}

		private function continueBtnHandler(e:starling.events.Event):void
		{
			var selectedMedicine:XML = medicationXMLList[this._ListToggleGroup.selectedIndex - 1];
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
