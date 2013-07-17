package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.utils.HivivaModifier;
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

	import starling.display.DisplayObject;

	import starling.display.DisplayObject;

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
		private var _takeMedicationCellHolder:ScrollContainer;

		private var _medicationData:XML;
		private var _patientKudosCount:Number;
		private var _remoteCallMade:Boolean = false;

		private const PADDING:Number = 20;

		public function HivivaPatientTakeMedsScreen()
		{

		}

		override protected function draw():void
		{
			this._customHeight = Constants.STAGE_HEIGHT - Constants.FOOTER_BTNGROUP_HEIGHT;
			super.draw();
			if(!_remoteCallMade) checkMedicationScheduleExist();
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();

			this._contentLayout.paddingLeft = this._contentLayout.paddingRight = 0;

			this._feelingQuestion.width = Constants.STAGE_WIDTH;
			this._feelingSlider.width = this._innerWidth * 0.8;
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
			// scroll not needed for this screen
			killContentScroll();
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
		}

		private function checkMedicationScheduleExist():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatientMedicationList();
			this._remoteCallMade = true;
		}

		private function getPatientMedicationListComplete(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);

			this._medicationData = e.data.xmlResponse;

			if(this._medicationData.children().length() > 0)
			{
				this._medicationSchedule = [];
				var medicationCount:uint = this._medicationData.DCUserMedication.length();
				for(var i:uint = 0 ; i < medicationCount ; i++)
				{

					var medicationScheduleCount:uint = this._medicationData.DCUserMedication[i].Schedule.DCMedicationSchedule.length();
					for(var j:uint = 0 ; j < medicationScheduleCount ; j++)
					{
						var medObj:Object =
						{
							medication_name: this._medicationData.DCUserMedication[i].MedicationName ,
							tablet_count: this._medicationData.DCUserMedication[i].Schedule.DCMedicationSchedule[j].Count ,
							tablet_taken: this._medicationData.DCUserMedication[i].Schedule.DCMedicationSchedule[j].Taken ,
							tolerability: this._medicationData.DCUserMedication[i].Schedule.DCMedicationSchedule[j].Tolerability ,
							schedule_id: this._medicationData.DCUserMedication[i].Schedule.DCMedicationSchedule[j].MedicationScheduleID ,
							medication_guid: this._medicationData.DCUserMedication[i].UserMedicationGuid ,
							time: this._medicationData.DCUserMedication[i].Schedule.DCMedicationSchedule[j].Time
						};

						this._medicationSchedule.push(medObj);
					}
				}
				populateMedications();
			}
		}

		private function populateMedications():void
		{
			var medicationsLoop:uint = this._medicationSchedule.length;
			for (var i:uint = 0; i < medicationsLoop; i++)
			{
				var takeMedicationCell:SelectMedicationCell = new SelectMedicationCell();
				takeMedicationCell.medicationScheduleId = this._medicationSchedule[i].schedule_id;
				takeMedicationCell.medicationGuid = this._medicationSchedule[i].medication_guid;
				takeMedicationCell.scale = this.dpiScale;
				takeMedicationCell.brandName = HivivaModifier.getBrandName(this._medicationSchedule[i].medication_name);
				takeMedicationCell.genericName = HivivaModifier.getGenericName(this._medicationSchedule[i].medication_name);
				takeMedicationCell.doseDetails = HivivaModifier.getNeatTabletText(this._medicationSchedule[i].tablet_count) + " " + HivivaModifier.getNeatTime(this._medicationSchedule[i].time);
				takeMedicationCell.width = Constants.STAGE_WIDTH;
				this._takeMedicationCellHolder.addChild(takeMedicationCell);
				takeMedicationCell.checkBox.addEventListener(Event.TRIGGERED, medCellChangeHandler);
				if(this._medicationSchedule[i].tablet_taken == "true")
				{
					takeMedicationCell.checkBox.isSelected = true;
					takeMedicationCell.validate();
				}
			}
			drawResults()
		}

		private function medCellChangeHandler(e:Event):void
		{
			if (this._submitButton == null)
			{
				this._submitButton = new Button();
				this._submitButton.addEventListener(Event.TRIGGERED, submitButtonHandler);
				this._submitButton.label = "Save";
				this._content.addChild(this._submitButton);
				this._submitButton.width = this._innerWidth * 0.25;
				this._submitButton.validate();
				this._submitButton.x = (Constants.STAGE_WIDTH * 0.5) - (this._submitButton.width * 0.5);
				this._submitButton.y = this._content.height - this._submitButton.height;

				this._takeMedicationCellHolder.height = this._submitButton.y - this._takeMedicationCellHolder.y;
				this._takeMedicationCellHolder.validate();
			}

			var takeMedicationCell:SelectMedicationCell = (DisplayObject(e.currentTarget).parent) as SelectMedicationCell;

			var dcUserMedication:XML = XML(this._medicationData.DCUserMedication.(UserMedicationGuid == takeMedicationCell.medicationGuid));
			var dcUserSchedule:XML = XML(dcUserMedication.Schedule.DCMedicationSchedule.(MedicationScheduleID == takeMedicationCell.medicationScheduleId));
			dcUserSchedule.Taken = !takeMedicationCell.checkBox.isSelected;
			dcUserSchedule.Tolerability = this._feelingSlider.value;
		}

		private function drawResults():void
		{
			this._takeMedicationCellHolder.y = this._feelingSliderRightLabel.y + this._feelingSliderRightLabel.height + PADDING;
			this._takeMedicationCellHolder.width = Constants.STAGE_WIDTH;
			this._takeMedicationCellHolder.height = this._customHeight - this._takeMedicationCellHolder.y;

			this._takeMedicationCellHolder.layout = new VerticalLayout();
			this._takeMedicationCellHolder.validate();
		}

		private function submitButtonHandler(e:Event):void
		{

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.TAKE_PATIENT_MEDICATION_COMPLETE , takePatientMedicationCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.takeMedication(this._medicationData);
		}

		private function takePatientMedicationCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.TAKE_PATIENT_MEDICATION_COMPLETE , takePatientMedicationCompleteHandler);
			showFormValidation("medicine schedule updated");
			updateUserDailyAdherence();
		}

		private function updateUserDailyAdherence():void
		{
			trace(this._medicationData);
			HivivaStartup.patientAdherenceVO.percentage = HivivaModifier.calculateDailyAdherence(this._medicationData.DCUserMedication.Schedule.DCMedicationSchedule);
			trace("patientAdherenceVO " + HivivaStartup.patientAdherenceVO.percentage);
			if(HivivaStartup.patientAdherenceVO.percentage == 100)
			{
				updateUserLocalAdherenceCount();
			}
		}

		private function updateUserLocalAdherenceCount():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.PATIENT_LOAD_KUDOS_COMPLETE , kudosLoadCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.getPatientKudosData();
		}

		private function kudosLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.PATIENT_LOAD_KUDOS_COMPLETE , kudosLoadCompleteHandler);
			var currentTakeMedDate:String = this._medicationData.DCUserMedication.Schedule.DCMedicationSchedule[0].DateTaken;

			if(e.data.kudos[0].medication_take_date == "0")
			{
				trace("First time: Medication Take");
				HivivaStartup.hivivaAppController.hivivaLocalStoreController.savePatientKudosData(currentTakeMedDate , String(1));
			}
			else
			{
				var storedTakeMedDate:Date = HivivaModifier.isoDateToFlashDate(e.data.kudos[0].medication_take_date);
				var takeMedDate:Date = HivivaModifier.isoDateToFlashDate(this._medicationData.DCUserMedication.Schedule.DCMedicationSchedule[0].DateTaken);
				var daysDifference:Number = HivivaModifier.getDaysDiffence(takeMedDate , storedTakeMedDate);

				trace(daysDifference);
				if(daysDifference == 0)
				{
					trace("KUDOS: Do nothing dates same");
					return;
				}
				else if(daysDifference == 1)
				{
					trace("KUDOS: add 1 to count");
					this._patientKudosCount = Number(e.data.kudos[0].count) + 1;
				}
				else if(daysDifference > 1)
				{
					trace("KUDOS: reset count to 1");
					this._patientKudosCount = 1;
				}

				HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.PATIENT_SAVE_KUDOS_COMPLETE , patientKudosSaveCompleteHandler);
				HivivaStartup.hivivaAppController.hivivaLocalStoreController.savePatientKudosData(currentTakeMedDate , String(this._patientKudosCount));
			}
		}

		private function patientKudosSaveCompleteHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.PATIENT_SAVE_KUDOS_COMPLETE , patientKudosSaveCompleteHandler);

			var badgeAttained:uint = 0 ;

			switch (this._patientKudosCount)
			{
				case 7 :
					badgeAttained = 1;
					break;

				case 70 :
					badgeAttained = 2;
					break;

				case 175 :
					badgeAttained = 3;
					break;

				case 350 :
					badgeAttained = 4;
					break;
			}

			if(badgeAttained > 0)
			{
				HivivaStartup.hivivaAppController.hivivaLocalStoreController.updatePatientBadges(badgeAttained);
			}
		}
	}
}


