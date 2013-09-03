package collaboRhythm.hiviva.view.screens.hcp
{

	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.Screen;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaHCPEditProfile extends ValidationScreen
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
		private var _isThisFromHome:Boolean;

		public function HivivaHCPEditProfile()
		{

		}

		override protected function draw():void
		{
			super.draw();

			if(this._isThisFromHome)
			{
				this._backButton.visible = false;
				this._cancelButton.visible = false;
			}
		}

		override protected function preValidateContent():void
		{
			super.preValidateContent();

			this._nameInput._labelLeft.text = "Name";
			this._nameInput.width = this._innerWidth;
			this._nameInput._input.width = this._innerWidth * 0.7;

			this._emailInput._labelLeft.text = "Email";
			this._emailInput.width = this._innerWidth;
			this._emailInput._input.width = this._innerWidth * 0.7;

			this._photoContainer.width = this._innerWidth;

			this._updatesCheck.width = this._innerWidth;

			//this._researchCheck.width = this._innerWidth;

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

			//this._researchCheck = new Check();
			//this._researchCheck.isSelected = false;
			//this._researchCheck.label = "Allow anonymised data for research purposes";
			//this._content.addChild(this._researchCheck);

			this._cancelButton = new Button();
			this._cancelButton.label = "Cancel";
			this._cancelButton.addEventListener(starling.events.Event.TRIGGERED, cancelButtonClick);
			this._content.addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.label = "Save";
			this._submitButton.addEventListener(starling.events.Event.TRIGGERED, submitButtonClick);
			this._content.addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			populateOldData();

			this._isThisFromHome = this.owner.hasScreen(HivivaScreens.HCP_HOME_SCREEN);
		}

		private function cancelButtonClick(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

		private function backBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

		private function submitButtonClick(e:starling.events.Event):void
		{
			var formValidation:String = hcpMyDetailsCheck();
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

		private function hcpMyDetailsCheck():String
		{
			var validString:String = "";

			if(this._nameInput._input.text.length == 0) validString += "Please enter your name...";

			return validString;
		}

		private function writeDataToSql():void
		{
			var hcpProfile:Object = {};
			hcpProfile.name = "'" + this._nameInput._input.text + "'";
			hcpProfile.email = "'" + this._emailInput._input.text + "'";
			hcpProfile.updates = int(this._updatesCheck.isSelected);
			hcpProfile.research = int(false); //TODO Remove Cleanly as no longer required for beta.

			localStoreController.addEventListener(LocalDataStoreEvent.HCP_PROFILE_SAVE_COMPLETE, setHcpProfileHandler);
			localStoreController.setHcpProfile(hcpProfile);
		}

		private function setHcpProfileHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.HCP_PROFILE_SAVE_COMPLETE, setHcpProfileHandler);
			trace(LocalDataStoreEvent.HCP_PROFILE_SAVE_COMPLETE);
			showFormValidation("Your details have been saved...");

			if(this._isThisFromHome)
			{
				dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.SHOW_MAIN_NAV, true));
				this.owner.showScreen(HivivaScreens.HCP_HOME_SCREEN);
			}
		}

		private function populateOldData():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.HCP_PROFILE_LOAD_COMPLETE, getHcpProfileHandler);
			localStoreController.getHcpProfile();

			this._photoContainer.getMainImage();
		}

		private function getHcpProfileHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.HCP_PROFILE_LOAD_COMPLETE, getHcpProfileHandler);

			var hcpProfile:Array = e.data.hcpProfile;

			try
			{
				if(hcpProfile != null)
				{
					this._nameInput._input.text = hcpProfile[0].name;
					this._emailInput._input.text = hcpProfile[0].email;
					this._updatesCheck.isSelected = hcpProfile[0].updates as Boolean;
					//this._researchCheck.isSelected = hcpProfile[0].research as Boolean; //TODO Remove Cleanly as no longer required for beta.
				}
			}
			catch(e:Error)
			{

			}
		}
	}
}
