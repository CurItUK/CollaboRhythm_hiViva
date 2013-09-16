package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class HivivaHCPMyDetailsScreen extends ValidationScreen
	{
		private var _instructionsText:Label;
//		private var _nameInputIns:Label;
		private var _firstNameInput:LabelAndInput;
		private var _lastNameInput:LabelAndInput;
		private var _photoTitle:Label;
		private var _photoContainer:ImageUploader;
//		private var _seperator1:Image;
//		private var _emailTitle:Label;
//		private var _updatesCheck:Check;
//		private var _emailInput:LabelAndInput;
//		private var _emailInputIns:Label;
//		private var _seperator2:Image;
//		private var _researchTitle:Label;
//		private var _researchCheck:Check;
		private var _cancelAndSave:BoxedButtons;
		//private var _cancelButton:Button;
		//private var _submitButton:Button;
//		private var _agreeLabel:Label;
		private var _backButton:Button;

		private const USER_PROFILE_IMAGE:String = "userprofileimage.jpg";


		public function HivivaHCPMyDetailsScreen()
		{

		}

		override protected function draw():void
		{
			this._componentGap *= 0.5;
			super.draw();
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();
			this._instructionsText.width = this._innerWidth;

			this._firstNameInput._labelLeft.text = "First name";
			this._firstNameInput.width = this._innerWidth;
			this._firstNameInput._input.width = this._innerWidth * 0.7;

			this._lastNameInput._labelLeft.text = "Last name";
			this._lastNameInput.width = this._innerWidth;
			this._lastNameInput._input.width = this._innerWidth * 0.7;

			this._photoTitle.width = this._innerWidth;

			this._photoContainer.width = this._innerWidth;

//			this._seperator1.width = this._innerWidth;

//			this._emailTitle.width = this._innerWidth;

//			this._updatesCheck.defaultLabelProperties.width = this._innerWidth * 0.9;

//			this._emailInput._labelLeft.text = "Email";
//			this._emailInput.width = this._innerWidth;
//			this._emailInput._input.width = this._innerWidth * 0.8;

//			this._seperator2.width = this._innerWidth;

			//this._researchTitle.width = this._innerWidth;

			//this._researchCheck.defaultLabelProperties.width = this._innerWidth * 0.9;

			this._cancelAndSave.width = this._innerWidth;

//			this._agreeLabel.width = this._innerWidth;
		}

		override protected function postValidateContent():void
		{
			super.postValidateContent();
			// manual position components.y because of custom gaps between them

//			this._nameInputIns.width = this._lastNameInput._input.width;
//			this._nameInputIns.x = this._horizontalPadding + this._lastNameInput._input.x;
//			this._nameInputIns.y = this._lastNameInput.y + this._lastNameInput.height;

//			this._photoTitle.y = this._lastNameInput.y + this._lastNameInput.height;
//
//			this._photoContainer.y = this._photoTitle.y + this._photoTitle.height + (this._componentGap * 0.5);

//			this._seperator1.y = this._photoContainer.y + this._photoContainer.height + this._componentGap;

//			this._emailTitle.y = this._seperator1.y + (this._componentGap * 0.5);

//			this._updatesCheck.y = this._emailTitle.y + this._emailTitle.height + (this._componentGap * 0.5);

//			this._emailInput.y = this._updatesCheck.y + this._updatesCheck.height + this._componentGap;

//			this._emailInputIns.width = this._emailInput._input.width;
//			this._emailInputIns.x = this._horizontalPadding + this._emailInput._input.x;
//			this._emailInputIns.y = this._emailInput.y + this._emailInput.height;

//			this._seperator2.y = this._emailInputIns.y + this._emailInputIns.height + this._componentGap;

			//this._researchTitle.y = this._seperator2.y + (this._componentGap * 0.5);

			//this._researchCheck.y = this._researchTitle.y + this._researchTitle.height + (this._componentGap * 0.5);

//			this._cancelAndSave.y = this._photoContainer.y + this._photoContainer.height + this._componentGap;
//
//			this._agreeLabel.y = this._cancelAndSave.y + this._cancelAndSave.height + this._componentGap;

			// valdate content again but without vertical layout
//			this._content.validate();
		}

		override protected function initialize():void
		{
			super.initialize();

//			var seperatorTexture:Texture = Main.assets.getTexture("header_line");

			this._header.title = "Edit profile";

			this._instructionsText = new Label();
//			this._instructionsText.text = "Profile required in order to connect to a care provider";
			this._instructionsText.text = "This will be your display name";
			this._content.addChild(this._instructionsText);

			this._firstNameInput = new LabelAndInput();
//			this._firstNameInput.scale = this.dpiScale;
			this._firstNameInput.labelStructure = "left";
			this._content.addChild(this._firstNameInput);

			this._lastNameInput = new LabelAndInput();
//			this._lastNameInput.scale = this.dpiScale;
			this._lastNameInput.labelStructure = "left";
			this._content.addChild(this._lastNameInput);

			/*this._nameInputIns = new Label();
			this._nameInputIns.name = HivivaThemeConstants.INSTRUCTIONS_LABEL;
			this._nameInputIns.text = "This will be your display name";
			this._content.addChild(this._nameInputIns);*/

			this._photoTitle = new Label();
			this._photoTitle.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._photoTitle.text = "Photo";
			this._content.addChild(this._photoTitle);

			this._photoContainer = new ImageUploader();
//			this._photoContainer.scale = this.dpiScale;
			this._photoContainer.fileName = USER_PROFILE_IMAGE;
			this._content.addChild(this._photoContainer);
			this._photoContainer.getMainImage();

			/*this._seperator1 = new Image(seperatorTexture);
			this._content.addChild(this._seperator1);

			this._emailTitle = new Label();
			this._emailTitle.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._emailTitle.text = "Get email updates";
			this._content.addChild(this._emailTitle);

			this._updatesCheck = new Check();
			this._updatesCheck.isSelected = false;
			this._updatesCheck.label = "Send me updates about the app";
			this._content.addChild(this._updatesCheck);

			this._emailInput = new LabelAndInput();
			this._emailInput.scale = this.dpiScale;
			this._emailInput.labelStructure = "left";
			this._content.addChild(this._emailInput);

			this._emailInputIns = new Label();
			this._emailInputIns.name = HivivaThemeConstants.INSTRUCTIONS_LABEL;
			this._emailInputIns.text = "Only required if you would like to receive app notifications by email";
			this._content.addChild(this._emailInputIns);

			this._seperator2 = new Image(seperatorTexture);
			this._content.addChild(this._seperator2);*/

			//this._researchTitle = new Label();
			//this._researchTitle.name = HivivaThemeConstants.SUBHEADER_LABEL;
			//this._researchTitle.text = "Help us improve the app";
			//this._content.addChild(this._researchTitle);

			//this._researchCheck = new Check();
			//this._researchCheck.isSelected = false;
			//this._researchCheck.label = "Allow anonymised data for research purposes";
			//this._content.addChild(this._researchCheck);

			this._cancelAndSave = new BoxedButtons();
			this._cancelAndSave.addEventListener(Event.TRIGGERED, cancelAndSaveHandler);
			this._cancelAndSave.scale = this.dpiScale;
			this._cancelAndSave.labels = ["Cancel", "Save"];
			this._content.addChild(this._cancelAndSave);

			/*this._agreeLabel = new Label();
			this._agreeLabel.name = HivivaThemeConstants.INSTRUCTIONS_LABEL;
			this._agreeLabel.text = "By clicking the button above, you agree to the Terms of Use\nView our Privacy Policy";
			this._content.addChild(this._agreeLabel);*/

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			populateOldData();
		}

		private function cancelAndSaveHandler(e:Event):void
		{
			var button:String = e.data.button;
			switch(button)
			{
				case "Cancel" :
					this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
					hideFormValidation();
					break;
				case "Save" :
					var formValidation:String = patientMyDetailsCheck();
					if(formValidation.length == 0)
					{
//						writeDataToSql();
						this._photoContainer.saveTempImageAsMain();
					}
					else
					{
						showFormValidation(formValidation);
					}
					break;
			}
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
			hideFormValidation();
		}

		private function patientMyDetailsCheck():String
		{
			var validString:String = "";

			if(this._firstNameInput._input.text.length == 0) validString += "Please enter your name...";

			return validString;
		}

		/*private function writeDataToSql():void
		{
			var patientProfile:Object = {};
			patientProfile.name = "'" + this._nameInput._input.text + "'";
			patientProfile.updates = int(this._updatesCheck.isSelected);
			patientProfile.email = this._updatesCheck.isSelected ? "'" + this._emailInput._input.text + "'" : "''";
			patientProfile.research = int(false); //TODO REMOVE Cleaning as not used anymore.

			localStoreController.addEventListener(LocalDataStoreEvent.PATIENT_PROFILE_SAVE_COMPLETE, setPatientProfileHandler);
			localStoreController.setPatientProfile(patientProfile);
		}

		private function setPatientProfileHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.PATIENT_PROFILE_SAVE_COMPLETE, setPatientProfileHandler);
			trace(LocalDataStoreEvent.PATIENT_PROFILE_SAVE_COMPLETE);
			showFormValidation("Your details have been saved...");
		}*/

		private function populateOldData():void
		{
//			localStoreController.addEventListener(LocalDataStoreEvent.PATIENT_PROFILE_LOAD_COMPLETE, getPatientProfileHandler);
//			localStoreController.getPatientProfile();

			this._photoContainer.getMainImage();
		}

		/*private function getPatientProfileHandler(e:LocalDataStoreEvent):void
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
					//this._researchCheck.isSelected = patientProfile[0].research as Boolean;
				}
			}
			catch(e:Error)
			{

			}
		}*/
	}
}