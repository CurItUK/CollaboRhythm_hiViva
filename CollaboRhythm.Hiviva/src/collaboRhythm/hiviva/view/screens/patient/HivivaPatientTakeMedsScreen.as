package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.components.SelectMedicationCell;
	import collaboRhythm.hiviva.view.media.Assets;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Slider;
	import feathers.layout.VerticalLayout;

	import starling.display.Image;
	import starling.events.Event;

	public class HivivaPatientTakeMedsScreen extends ValidationScreen
	{
		private var _feelingQuestion:Label;
		private var _feelingSlider:Slider;
		private var _feelingSliderLeftLabel:Label;
		private var _feelingSliderCenterLabel:Label;
		private var _feelingSliderRightLabel:Label;
		private var _feelingSliderLeftImage:Image;
		private var _feelingSliderRightImage:Image;
		private var _submitButton:Button;
		private var _medicationSchedule:Array;
		private var _latestAdherenceData:Object;
		private var _takeMedicationCellHolder:ScrollContainer;


		private const PADDING:Number = 20;

		public function HivivaPatientTakeMedsScreen()
		{

		}

		override protected function draw():void
		{
			this._customHeight = this.actualHeight - Constants.FOOTER_BTNGROUP_HEIGHT;
			super.draw();
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();

			this._feelingQuestion.width = this._innerWidth;

			this._feelingSlider.width = this._innerWidth * 0.8;

			this._submitButton.width = this._innerWidth * 0.25;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();

			this._feelingSlider.x = (this.actualWidth * 0.5) - (this._feelingSlider.width * 0.5);
			this._feelingSlider.y -= this._componentGap;

			this._feelingSliderLeftImage.y = this._feelingSliderRightImage.y = this._feelingSlider.y + (this._feelingSlider.height * 0.5)

			this._feelingSliderLeftImage.x = this._feelingSlider.x - this._feelingSliderLeftImage.width;
			this._feelingSliderLeftImage.y -= this._feelingSliderLeftImage.height * 0.5;

			this._feelingSliderRightImage.x = this._feelingSlider.x + this._feelingSlider.width;
			this._feelingSliderRightImage.y -= this._feelingSliderRightImage.height * 0.5;

			this._feelingSliderLeftLabel.x = this._feelingSliderLeftImage.x + (this._feelingSliderLeftImage.width * 0.5) - (this._feelingSliderLeftLabel.width * 0.5);
			this._feelingSliderLeftLabel.y = this._feelingSlider.y + this._feelingSlider.height;

			this._feelingSliderCenterLabel.x = this._feelingSlider.x + (this._feelingSlider.width * 0.5) - (this._feelingSliderCenterLabel.width * 0.5);
			this._feelingSliderCenterLabel.y = this._feelingSlider.y + this._feelingSlider.height;

			this._feelingSliderRightLabel.x = this._feelingSliderRightImage.x + (this._feelingSliderRightImage.width * 0.5) - (this._feelingSliderRightLabel.width * 0.5);
			this._feelingSliderRightLabel.y = this._feelingSlider.y + this._feelingSlider.height;

			this._submitButton.y = this._content.height - this._submitButton.height;
			// scroll not needed for this screen
			killContentScroll();
			checkMedicationScheduleExist();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Take Medication";

			this._feelingQuestion = new Label();
			this._feelingQuestion.name = HivivaThemeConstants.BODY_CENTERED_LABEL;
			this._feelingQuestion.text = "How am I feeling on my meds today?";
			this._content.addChild(this._feelingQuestion);

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
			this._content.addChild(this._feelingSlider);

			this._feelingSliderLeftImage = new Image(Main.assets.getTexture("feeling_slider_cloud"));
			this._content.addChild(this._feelingSliderLeftImage);

			this._feelingSliderRightImage = new Image(Main.assets.getTexture("feeling_slider_sun"));
			this._content.addChild(this._feelingSliderRightImage);

			this._feelingSliderLeftLabel = new Label();
			this._feelingSliderLeftLabel.name = HivivaThemeConstants.FEELING_SLIDER_LABEL;
			this._feelingSliderLeftLabel.text = "AWFUL";
			this._content.addChild(this._feelingSliderLeftLabel);

			this._feelingSliderCenterLabel = new Label();
			this._feelingSliderCenterLabel.name = HivivaThemeConstants.FEELING_SLIDER_LABEL;
			this._feelingSliderCenterLabel.text = "OK";
			this._content.addChild(this._feelingSliderCenterLabel);

			this._feelingSliderRightLabel = new Label();
			this._feelingSliderRightLabel.name = HivivaThemeConstants.FEELING_SLIDER_LABEL;
			this._feelingSliderRightLabel.text = "AWESOME";
			this._content.addChild(this._feelingSliderRightLabel);

			this._takeMedicationCellHolder = new ScrollContainer();
			this._content.addChild(this._takeMedicationCellHolder);

			this._submitButton = new Button();
			this._submitButton.visible = false;
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonHandler);
			this._submitButton.label = "Save";
			this._content.addChild(this._submitButton);
		}

		private function submitButtonHandler(e:Event):void
		{
			// submit changed data only
			var medicationsLoop:uint = this._medicationSchedule.length,
				takeMedicationCell:SelectMedicationCell,
				data:Array = [],
				today:String = HivivaModifier.getSQLStringFromDate(new Date());
			for (var i:uint = 0; i < medicationsLoop; i++)
			{
				takeMedicationCell = this._takeMedicationCellHolder.getChildAt(i) as SelectMedicationCell;
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

			showFormValidation("medicine schedule updated");
		}

		private function checkMedicationScheduleExist():void
		{
			//localStoreController.addEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE, medicationsScheduleLoadCompleteHandler);
			//localStoreController.getMedicationsSchedule();

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatientMedicationList();

		}

		private function getPatientMedicationListComplete(e:RemoteDataStoreEvent):void
		{
			/*HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
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
			}*/
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
			var medicationsLoop:uint = this._medicationSchedule.length;
			for (var i:uint = 0; i < medicationsLoop; i++)
			{
				var takeMedicationCell:SelectMedicationCell = new SelectMedicationCell();
				takeMedicationCell.medicationScheduleId = this._medicationSchedule[i].id;
				takeMedicationCell.scale = this.dpiScale;
				takeMedicationCell.brandName = HivivaModifier.getBrandName(this._medicationSchedule[i].medication_name);
				takeMedicationCell.genericName = HivivaModifier.getGenericName(this._medicationSchedule[i].medication_name);
				takeMedicationCell.doseDetails = HivivaModifier.getNeatTabletText(this._medicationSchedule[i].tablet_count) + " " + HivivaModifier.getNeatTime(this._medicationSchedule[i].time);
				takeMedicationCell.width = this._innerWidth;
				this._takeMedicationCellHolder.addChild(takeMedicationCell);
				takeMedicationCell.checkBox.addEventListener(Event.TRIGGERED, medCellChangeHandler);
			}
			drawResults()
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
			this._takeMedicationCellHolder.y = this._feelingSliderRightLabel.y + this._feelingSliderRightLabel.height;
			this._takeMedicationCellHolder.width = this._innerWidth;
			this._takeMedicationCellHolder.height = this._submitButton.y - this._takeMedicationCellHolder.y;

			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = this._componentGap * 0.5;
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
				latestAdherenceData:Array = String(this._latestAdherenceData.data).split(","),
				rawIdData:String,
				medicationId:int,
				feeling:Number,
				takeMedicationCell:SelectMedicationCell;

			// latestAdherence.date
			// latestAdherence.data[i].medication_id
			// latestAdherence.data[i].feeling
			// its the same day since the last adherence update so select taken medicines
			if (HivivaModifier.getDaysDiff(today, latestAdherenceDate) == 0)
			{
				for (var i:int = 0; i < latestAdherenceData.length; i++)
				{
					rawIdData = String(latestAdherenceData[i]).split(";")[0];
					medicationId = int(rawIdData.split(":")[1]);
					//feeling = latestAdherenceData[i].feeling;

					var medicationsLoop:uint = this._medicationSchedule.length;
					for (var j:uint = 0; j < medicationsLoop; j++)
					{
						takeMedicationCell = this._takeMedicationCellHolder.getChildAt(j) as SelectMedicationCell;
						if(takeMedicationCell.medicationScheduleId == medicationId)
						{
							takeMedicationCell.checkBox.isSelected = true;
							takeMedicationCell.validate();
						}
					}
				}
			}
		}


	}
}
