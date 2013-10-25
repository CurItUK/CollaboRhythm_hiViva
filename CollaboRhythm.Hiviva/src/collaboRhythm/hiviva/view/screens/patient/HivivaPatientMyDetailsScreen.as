package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import com.adobe.images.JPGEncoder;

	import feathers.controls.Button;
	import feathers.controls.Label;

	import flash.text.AutoCapitalize;

	import flash.utils.ByteArray;

	import mx.utils.Base64Decoder;

	import mx.utils.Base64Encoder;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaPatientMyDetailsScreen extends ValidationScreen
	{
		private var _instructionsText:Label;
		private var _firstNameInput:LabelAndInput;
		private var _lastNameInput:LabelAndInput;
		private var _photoTitle:Label;
		private var _photoContainer:ImageUploader;
		private var _cancelAndSave:BoxedButtons;
		private var _backButton:Button;
		private var _serviceCount:uint = 0;
		private var _serviceLength:uint = 2;
		private var _validationMessages:Array = [];


		public function HivivaPatientMyDetailsScreen()
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

			this._cancelAndSave.width = this._innerWidth;
		}

		/*override protected function postValidateContent():void
		{
			super.postValidateContent();
		}*/

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Edit profile";

			this._instructionsText = new Label();
//			this._instructionsText.text = "Profile required in order to connect to a care provider";
			this._instructionsText.text = "This will be your display name";
			this._content.addChild(this._instructionsText);

			this._firstNameInput = new LabelAndInput();
//			this._firstNameInput.scale = this.dpiScale;
			this._firstNameInput.labelStructure = "left";
			this._content.addChild(this._firstNameInput);
			this._firstNameInput._input.textEditorProperties.autoCapitalize = AutoCapitalize.WORD;

			this._lastNameInput = new LabelAndInput();
//			this._lastNameInput.scale = this.dpiScale;
			this._lastNameInput.labelStructure = "left";
			this._content.addChild(this._lastNameInput);
			this._lastNameInput._input.textEditorProperties.autoCapitalize = AutoCapitalize.WORD;

			this._photoTitle = new Label();
			this._photoTitle.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._photoTitle.text = "Photo";
			this._content.addChild(this._photoTitle);

			this._photoContainer = new ImageUploader();
			this._photoContainer.defaultImage = "v2_profile_img";
//			this._photoContainer.scale = this.dpiScale;
			this._photoContainer.fileName = Constants.USER_PROFILE_IMAGE;
			this._content.addChild(this._photoContainer);
			this._photoContainer.getMainImage();

			this._cancelAndSave = new BoxedButtons();
			this._cancelAndSave.addEventListener(Event.TRIGGERED, cancelAndSaveHandler);
			this._cancelAndSave.scale = this.dpiScale;
			this._cancelAndSave.labels = ["Cancel", "Save"];
			this._content.addChild(this._cancelAndSave);

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
					backBtnHandler();
					break;
				case "Save" :
					var formValidation:String = patientMyDetailsCheck();
					if(formValidation.length == 0)
					{
						saveUser();
						this._photoContainer.saveTempImageAsMain();
					}
					else
					{
						showFormValidation(formValidation);
					}
					break;
			}
		}

		private function backBtnHandler(e:Event = null):void
		{
			this.owner.showScreen(Main.parentOfPatientMyDetailsScreen);
		}

		private function patientMyDetailsCheck():String
		{
			var validationArray:Array = [];

			if(this._firstNameInput._input.text.length == 0) validationArray.push("Please enter a first name");
			if(this._lastNameInput._input.text.length == 0) validationArray.push("Please enter a last name");

			return validationArray.join(",\n");
		}

		private function saveUser():void
		{
			var guid:String = HivivaStartup.userVO.guid;
			var firstName:String = this._firstNameInput._input.text;
			var lastName:String = this._lastNameInput._input.text;
			var user:XML =
					<DCHealthUser>
						<UserGuid>{guid}</UserGuid>
						<FirstName>{firstName}</FirstName>
						<LastName>{lastName}</LastName>
					</DCHealthUser>;

			var pictureByteArray:ByteArray = this._photoContainer.savableImageBytes;

			var base64Encoder:Base64Encoder = new Base64Encoder();
			base64Encoder.encodeBytes(pictureByteArray);

			var pictureByteString:String = base64Encoder.toString();

			var pictureData:XML;

			if(pictureByteArray.length > 0)
			{
				pictureData =
						<DCPictureFile>
							<PictureName>{guid + ".jpg"}</PictureName>
							<PictureStream>Boo!!!</PictureStream>
						</DCPictureFile>;

				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.SAVE_USER_PICTURE_COMPLETE, saveUserPictureCompleteHandler);
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.saveUserPicture(pictureData);
			}

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.SAVE_USER_COMPLETE, saveUserCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.saveUser(user);

			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.APP_FULLNAME_SAVE_COMPLETE, saveUserFullnameHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.saveUserFullname(firstName + " " + lastName);
		}

		private function saveUserCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.SAVE_USER_COMPLETE, saveUserCompleteHandler);
			showFormValidation("User profile saved");
		}

		private function saveUserPictureCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.SAVE_USER_PICTURE_COMPLETE, saveUserCompleteHandler);
// currently empty string
			trace(e.data.xmlResponse);
		}

		private function saveUserFullnameHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.APP_FULLNAME_SAVE_COMPLETE, saveUserFullnameHandler);
			trace("HivivaStartup.userVO.fullName = " + HivivaStartup.userVO.fullName);
		}

		private function populateOldData():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_COMPLETE , getPatientCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatient(HivivaStartup.userVO.appId);

			this._photoContainer.getMainImage();

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_USER_PICTURE_COMPLETE, getUserPictureCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getUserPicture();
		}

		private function getUserPictureCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_USER_PICTURE_COMPLETE, getUserPictureCompleteHandler);
// currently empty string
			trace(e.data.xmlResponse);
		}

		private function getPatientCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_COMPLETE , getPatientCompleteHandler);

			this._firstNameInput._input.text = e.data.xmlResponse.FirstName;
			this._lastNameInput._input.text = e.data.xmlResponse.LastName;
		}

		/*override public function showFormValidation(valStr:String):void
		{
			_validationMessages.push(valStr);
			_serviceCount++;
			if(this._serviceCount == this._serviceLength)
			{
				super.showFormValidation(_validationMessages.join(",\n"));
			}
		}*/

		public override function dispose():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.SAVE_USER_COMPLETE, saveUserCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_COMPLETE , getPatientCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.APP_FULLNAME_SAVE_COMPLETE, saveUserFullnameHandler);
			super.dispose();
		}
	}
}
