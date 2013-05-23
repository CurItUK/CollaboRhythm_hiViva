package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.Screen;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaHCPEditProfile extends Screen
	{
		private var _applicationController:HivivaApplicationController;
		private var _header:HivivaHeader;
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
			var padding:Number = (32 * this.dpiScale);

			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._header.width = this.actualWidth;

			this._instructionsText.width = this.actualWidth - (padding * 2);
			this._instructionsText.y = this._header.height;
			this._instructionsText.x = padding;
			this._instructionsText.validate();

			this._nameInput._labelLeft.text = "Name";
			this._nameInput.width = this.actualWidth;
			this._nameInput.y = this._instructionsText.y + this._instructionsText.height + padding;
			this._nameInput._input.width = this.actualWidth * 0.7;
			this._nameInput.validate();

			this._emailInput._labelLeft.text = "Email";
			this._emailInput.width = this.actualWidth;
			this._emailInput.y = this._nameInput.y + this._nameInput.height;
			this._emailInput._input.width = this.actualWidth * 0.7;
			this._emailInput.validate();

			this._photoContainer.width = this.actualWidth;
			this._photoContainer.validate();
			this._photoContainer.y = this._emailInput.y + this._emailInput.height;

			this._updatesCheck.width = this.actualWidth;
			this._updatesCheck.validate();
			this._updatesCheck.y = this._photoContainer.y + this._photoContainer.height + padding;

			this._researchCheck.width = this.actualWidth;
			this._researchCheck.validate();
			this._researchCheck.y = this._updatesCheck.y + this._updatesCheck.height;

			this._cancelButton.validate();
			this._submitButton.validate();
			this._backButton.validate();

			this._cancelButton.y = this._submitButton.y = this._researchCheck.y + this._researchCheck.height;
			this._cancelButton.x = padding;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + padding;

			populateOldData();

			if(this._isThisFromHome)
			{
				this._backButton.visible = false;
				this._cancelButton.visible = false;
			}
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "My Details";
			addChild(this._header);

			this._instructionsText = new Label();
			this._instructionsText.text = "Profile required in order to connect patients.";
			addChild(this._instructionsText);

			this._nameInput = new LabelAndInput();
			this._nameInput.scale = this.dpiScale;
			this._nameInput.labelStructure = "left";
			addChild(this._nameInput);

			this._emailInput = new LabelAndInput();
			this._emailInput.scale = this.dpiScale;
			this._emailInput.labelStructure = "left";
			addChild(this._emailInput);

			this._photoContainer = new ImageUploader();
			this._photoContainer.scale = this.dpiScale;
			this._photoContainer.fileName = "userprofileimage.jpg";
			addChild(this._photoContainer);

			this._updatesCheck = new Check();
			this._updatesCheck.isSelected = false;
			this._updatesCheck.label = "Send me updates";
			addChild(this._updatesCheck);

			this._researchCheck = new Check();
			this._researchCheck.isSelected = false;
			this._researchCheck.label = "Allow anonymised data for research purposes";
			addChild(this._researchCheck);

			this._cancelButton = new Button();
			this._cancelButton.label = "Cancel";
			this._cancelButton.addEventListener(Event.TRIGGERED, cancelButtonClick);
			addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.label = "Save";
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			populateOldData();

			this._isThisFromHome = this.owner.hasScreen(HivivaScreens.HCP_HOME_SCREEN);
		}

		private function cancelButtonClick(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

		private function submitButtonClick(e:Event):void
		{
			// TODO: validation

			var hcpProfile:Object = {};
			hcpProfile.name = "'" + this._nameInput._input.text + "'";
			hcpProfile.email = "'" + this._emailInput._input.text + "'";
			hcpProfile.updates = int(this._updatesCheck.isSelected);
			hcpProfile.research = int(this._researchCheck.isSelected);

			localStoreController.addEventListener(LocalDataStoreEvent.HCP_PROFILE_SAVE_COMPLETE, setHcpProfileHandler);
			localStoreController.setHcpProfile(hcpProfile);

			this._photoContainer.saveTempImageAsMain();
		}

		private function setHcpProfileHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.HCP_PROFILE_SAVE_COMPLETE, setHcpProfileHandler);
			trace(LocalDataStoreEvent.HCP_PROFILE_SAVE_COMPLETE);

			// TODO: show success message

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
					this._researchCheck.isSelected = hcpProfile[0].research as Boolean;
				}
			}
			catch(e:Error)
			{

			}
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
