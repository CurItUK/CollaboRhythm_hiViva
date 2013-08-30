package collaboRhythm.hiviva.view.screens.hcp
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaHeader;
	import collaboRhythm.hiviva.view.HivivaPopUp;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.LabelAndInput;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaHCPSettingsScreen extends Screen
	{
		private var _instructions:Label;
		private var _submitButton:Button;
		private var _userFromSubmitButton:Button;
		private var _showUserFormButton:Button;
		private var _backButton:Button;
		private var _header:HivivaHeader;
		private var _scaledPadding:Number;
		private var _userTypePickerList:PickerList;
		private var _userFormAppIdInput:LabelAndInput;
		private var _userFormGuidInput:LabelAndInput;
		private var _userForm:ScrollContainer;
		private var _closeAppPopup:HivivaPopUp;


		public function HivivaHCPSettingsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._scaledPadding = (this.actualWidth * 0.04) * this.dpiScale;

			this._header.paddingLeft = Constants.HEADER_HOMEBTN_PADDING;
			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			this._instructions.validate();
			this._instructions.y = this._header.height + this._scaledPadding;
			this._instructions.x = this.actualWidth/2 - this._instructions.width/2;

			this._submitButton.validate();
			this._submitButton.x = this.actualWidth/2 - this._submitButton.width/2;
			this._submitButton.y = this._instructions.y + this._instructions.height + this._scaledPadding;

			this._userForm.y = this._submitButton.y + this._submitButton.height + this._scaledPadding;
			this._userForm.height = this.actualHeight - this._userForm.y;
			this._userForm.x = this._scaledPadding;
			this._userForm.width = this.actualWidth - (this._scaledPadding * 2);
			this._userForm.validate();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Application settings";
			this.addChild(this._header);

			this._instructions = new Label();
			this._instructions.text = 	"Tap the button below to restore your user settings\nback to their Defaults.";
			this.addChild(this._instructions);

			this._submitButton = new Button();
			this._submitButton.label = "Reset application";
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			this.addChild(this._submitButton);

			this._showUserFormButton = new Button();
			this._showUserFormButton.label = "*";
			this._showUserFormButton.alpha = 0;
			this._showUserFormButton.addEventListener(Event.TRIGGERED, showUserForm);

			this._header.rightItems = new <DisplayObject>[_showUserFormButton];

			setupUserForm();

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}

		private function submitButtonClick(e:Event = null):void
		{
			removeButtonListeners();

			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.APPLICATION_RESET_COMPLETE, resetApplicationHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.resetApplication();
		}

		private function resetApplicationHandler(e:LocalDataStoreEvent):void{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.APPLICATION_RESET_COMPLETE , resetApplicationHandler);
			this.dispatchEventWith("navFromReset");
		}

		private function setupUserForm():void
		{
			this._userForm = new ScrollContainer();
			this._userForm.visible = false;
			this.addChild(this._userForm);

			this._userTypePickerList = new PickerList();
			this._userTypePickerList.listProperties.@itemRendererProperties.labelField = "text";
			this._userTypePickerList.labelField = "text";
//			this._userTypePickerList.addEventListener(Event.CHANGE, userSelectedHandler);
			this._userForm.addChild(this._userTypePickerList);

			var userTypes:ListCollection = new ListCollection( [{text:"Patient"},{text:"HCP"}] );

			this._userTypePickerList.dataProvider = userTypes;
			this._userTypePickerList.prompt = "Select user type";
			this._userTypePickerList.selectedIndex = -1;

			this._userFormAppIdInput = new LabelAndInput();
			this._userFormAppIdInput.labelStructure = "left";
			this._userForm.addChild(this._userFormAppIdInput);
			this._userFormAppIdInput._labelLeft.text = "App Id";

			this._userFormGuidInput = new LabelAndInput();
			this._userFormGuidInput.labelStructure = "left";
			this._userForm.addChild(this._userFormGuidInput);
			this._userFormGuidInput._labelLeft.text = "Guid";

			this._userFromSubmitButton = new Button();
			this._userFromSubmitButton.addEventListener(Event.TRIGGERED, userFormSubmitHandler);
			this._userFromSubmitButton.label = "Change User";
			this._userForm.addChild(this._userFromSubmitButton);
		}

		private function showUserForm(e:Event):void
		{
			var usableWidth:Number = this.actualWidth - (this._scaledPadding * 2);

			this._userTypePickerList.width = usableWidth;

			this._userFormAppIdInput.width = usableWidth;
			this._userFormAppIdInput._input.width = usableWidth * 0.75;

			this._userFormGuidInput.width = usableWidth;
			this._userFormGuidInput._input.width = usableWidth * 0.75;

			var userFormLayout:VerticalLayout = new VerticalLayout();
			userFormLayout.gap = this._scaledPadding;

			this._userForm.layout = userFormLayout;
			this._userForm.validate();

			this._userFromSubmitButton.x = (usableWidth * 0.5) - (this._userFromSubmitButton.width * 0.5);

			this._userForm.visible = true;
		}

		private function userFormSubmitHandler(e:Event):void
		{
			var userType:String = this._userTypePickerList.selectedItem.text;
			var appId:String = this._userFormAppIdInput._input.text;
			var guid:String = this._userFormGuidInput._input.text;

			var userTypeIsValid:Boolean = userType == "Patient" || userType == "HCP";
			var appIdIsValid:Boolean = appId.length > 0;
			var guidIsValid:Boolean = guid.length > 0;

			if(userTypeIsValid && appIdIsValid && guidIsValid)
			{
				removeButtonListeners();

				HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.APP_ID_SAVE_COMPLETE , appIdGuidSaveHandler);
				HivivaStartup.hivivaAppController.hivivaLocalStoreController.setTypeAppIdGuid(appId,guid,userType);
			}
		}

		private function appIdGuidSaveHandler(e:LocalDataStoreEvent):void
		{
			this._closeAppPopup = new HivivaPopUp();
			this._closeAppPopup.buttons = ["ok"];
			this._closeAppPopup.addEventListener(Event.TRIGGERED, okTriggered);
			this._closeAppPopup.validate();
			this._closeAppPopup.message = 'user has been changed, please close and relaunch the application';

			PopUpManager.addPopUp(this._closeAppPopup,true,true);
			this._closeAppPopup.validate();
			PopUpManager.centerPopUp(this._closeAppPopup);
			// draw close button post center so the centering works correctly
			this._closeAppPopup.drawCloseButton();
		}

		private function okTriggered(e:Event):void
		{

		}

		private function backBtnHandler(event:Event):void
		{
			removeButtonListeners();

			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}

		private function removeButtonListeners():void
		{
			this._backButton.removeEventListener(Event.TRIGGERED, backBtnHandler);
			this._submitButton.removeEventListener(Event.TRIGGERED, submitButtonClick);
			this._userFromSubmitButton.removeEventListener(Event.TRIGGERED, userFormSubmitHandler);
		}
	}
}
