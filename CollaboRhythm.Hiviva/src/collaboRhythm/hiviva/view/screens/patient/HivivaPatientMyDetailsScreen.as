package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;

	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaPatientMyDetailsScreen extends ValidationScreen
	{
		private var _instructionsText:Label;
		private var _nameInput:LabelAndInput;
		private var _emailInput:LabelAndInput;
		private var _photoContainer:ImageUploader;
		private var _updatesCheck:Check;
		private var _researchCheck:Check;
		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _backButton:Button;


		public function HivivaPatientMyDetailsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();
			this._instructionsText.width = this._innerWidth;

			this._nameInput._labelLeft.text = "Name";
			this._nameInput.width = this._innerWidth;
			this._nameInput._input.width = this._innerWidth * 0.7;

			this._emailInput._labelLeft.text = "Email";
			this._emailInput.width = this._innerWidth;
			this._emailInput._input.width = this._innerWidth * 0.7;

			this._photoContainer.width = this._innerWidth;

			this._updatesCheck.width = this._innerWidth;

			this._researchCheck.width = this._innerWidth;

			this._submitButton.width = this._cancelButton.width = this._innerWidth * 0.25;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();
			this._submitButton.y = this._cancelButton.y;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + this._componentGap;
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "My Details";

			this._instructionsText = new Label();
			this._instructionsText.text = "All fields are optional except to connect to a care provider <a>What's this?</a>";
			this._content.addChild(this._instructionsText);

			this._nameInput = new LabelAndInput();
			this._nameInput.scale = this.dpiScale;
			this._nameInput.labelStructure = "left";
			this._content.addChild(this._nameInput);

			this._emailInput = new LabelAndInput();
			this._emailInput.scale = this.dpiScale;
			this._emailInput.labelStructure = "left";
			this._content.addChild(this._emailInput);

			this._photoContainer = new ImageUploader();
			this._photoContainer.scale = this.dpiScale;
			this._photoContainer.fileName = "userprofileimage.jpg";
			this._content.addChild(this._photoContainer);

			this._updatesCheck = new Check();
			this._updatesCheck.isSelected = false;
			this._updatesCheck.label = "Send me updates";
			this._content.addChild(this._updatesCheck);

			this._researchCheck = new Check();
			this._researchCheck.isSelected = false;
			this._researchCheck.label = "Allow anonymised data for research purposes";
			this._content.addChild(this._researchCheck);

			this._cancelButton = new Button();
			this._cancelButton.label = "Cancel";
			this._cancelButton.addEventListener(Event.TRIGGERED, cancelButtonClick);
			this._content.addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.label = "Save";
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			this._content.addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			populateOldData();
		}

		private function cancelButtonClick(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
			hideFormValidation();
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
			hideFormValidation();
		}

		private function submitButtonClick(e:Event):void
		{
			var formValidation:String = patientMyDetailsCheck();
			if(formValidation.length == 0)
			{
				writeDataToSql();
				this._photoContainer.saveTempImageAsMain();
			}
			else
			{
				showFormValidation(formValidation);
			}

		}

		private function patientMyDetailsCheck():String
		{
			var validString:String = "";

			if(this._nameInput._input.text.length == 0) validString += "Please enter your name...";

			return validString;
		}

		private function writeDataToSql():void
		{
			var patientProfile:Object = {};
			patientProfile.name = "'" + this._nameInput._input.text + "'";
			patientProfile.email = "'" + this._emailInput._input.text + "'";
			patientProfile.updates = int(this._updatesCheck.isSelected);
			patientProfile.research = int(this._researchCheck.isSelected);

			localStoreController.addEventListener(LocalDataStoreEvent.PATIENT_PROFILE_SAVE_COMPLETE, setPatientProfileHandler);
			localStoreController.setPatientProfile(patientProfile);
		}

		private function setPatientProfileHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.PATIENT_PROFILE_SAVE_COMPLETE, setPatientProfileHandler);
			trace(LocalDataStoreEvent.PATIENT_PROFILE_SAVE_COMPLETE);
			showFormValidation("Your details have been saved...");
		}

		private function populateOldData():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.PATIENT_PROFILE_LOAD_COMPLETE, getPatientProfileHandler);
			localStoreController.getPatientProfile();

			this._photoContainer.getMainImage();
		}

		private function getPatientProfileHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.PATIENT_PROFILE_LOAD_COMPLETE, getPatientProfileHandler);

			var patientProfile:Array = e.data.patientProfile;

			try
			{
				if(patientProfile != null)
				{
					this._nameInput._input.text = patientProfile[0].name;
					this._emailInput._input.text = patientProfile[0].email;
					this._updatesCheck.isSelected = patientProfile[0].updates as Boolean;
					this._researchCheck.isSelected = patientProfile[0].research as Boolean;
				}
			}
			catch(e:Error)
			{

			}
		}
	}
}
