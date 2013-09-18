package collaboRhythm.hiviva.view.screens.hcp.messages
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Radio;
	import feathers.core.ToggleGroup;

	import starling.display.DisplayObject;
	import starling.events.Event;


	public class HivivaHCPPatientMessageCompose extends ValidationScreen
	{
		private var _backButton:Button;
		private var _hcpName:Label;
		private var _patientName:Label;
		private var _selectMessage:Label;
		private var _selectedPatient:XML;
		private var _remoteCallMade:Boolean;
		private var _allSendableMessages:XMLList;
		private var _radioGroup:ToggleGroup;
		private var _cancelAndSend:BoxedButtons;

		public function HivivaHCPPatientMessageCompose()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._content.layout = this._contentLayout;
			if(!this._remoteCallMade) getMessageTypesAndConnections();

		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Compose message";

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);
			this.addChild(this._backButton);

			this._header.leftItems = new <DisplayObject>[this._backButton];

			this._hcpName = new Label();
			this._hcpName.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._hcpName.text = "From : " + HivivaStartup.userVO.fullName + " (" + HivivaStartup.userVO.appId + ")";
			this._content.addChild(this._hcpName);

			this._patientName = new Label();
			this._patientName.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._patientName.text = "To : " + selectedPatient.name + " (" + selectedPatient.appid + ")";
			this._content.addChild(this._patientName);

			this._selectMessage = new Label();
			this._selectMessage.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._selectMessage.text = "Select Message ";
			this._content.addChild(this._selectMessage);

			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV,true));
		}


		private function getMessageTypesAndConnections():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_MESSAGES_COMPLETE, getMessagesHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getMessages();

			this._remoteCallMade = true;
		}

		private function getMessagesHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_MESSAGES_COMPLETE, getMessagesHandler);

			this._allSendableMessages = e.data.xmlResponse.DCMessage;

			populateMessages();
		}

		private function populateMessages():void
		{
			var sendableMessageLength:int = this._allSendableMessages.length();
			var sendableMessage:Radio;
			this._radioGroup = new ToggleGroup();
			for (var i:int = 0; i < sendableMessageLength; i++)
			{
				sendableMessage = new Radio();
				sendableMessage.label = this._allSendableMessages[i].Message;
				this._radioGroup.addItem(sendableMessage);
				this._content.addChild(sendableMessage);
			}
			drawBoxedSendCancelButtons();
		}

		private function drawBoxedSendCancelButtons():void
		{

			this._cancelAndSend = new BoxedButtons();
			this._cancelAndSend.labels = ["Cancel","Send"];
			this._cancelAndSend.addEventListener(starling.events.Event.TRIGGERED, cancelAndSendHandler);
			this.addChild(this._cancelAndSend);

			this._cancelAndSend.width = this._innerWidth
			this._cancelAndSend.validate();
			this._cancelAndSend.x = Constants.PADDING_LEFT;
			this._cancelAndSend.y = Constants.STAGE_HEIGHT - this._cancelAndSend.height - Constants.PADDING_BOTTOM;

			this._content.height = this._cancelAndSend.y - this._content.y - Constants.PADDING_BOTTOM;
			this._content.validate();
		}

		private function cancelAndSendHandler(e:starling.events.Event):void
		{
			var button:String = e.data.button;

			switch(button)
			{
				case "Cancel" :
					backBtnHandler();
					break;
				case "Send" :
					var messageGuid:String = this._allSendableMessages[this._radioGroup.selectedIndex].MessageGuid;

					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.SEND_USER_MESSAGE_COMPLETE, sendUserMessageHandler);
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.sendUserMessage(selectedPatient.guid , messageGuid);
					break;
			}
		}

		private function sendUserMessageHandler(e:RemoteDataStoreEvent):void
		{

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.SEND_USER_MESSAGE_COMPLETE, sendUserMessageHandler);

			if(e.data.xmlResponse.Message == "Success")
			{
				showFormValidation("Success! Your message has been sent");
			}
			else
			{
				showFormValidation("There was a problem sending the message, your message has not been sent");
			}
		}

		private function backBtnHandler(e:starling.events.Event = null):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PATIENT_PROFILE);
		}



		public function get selectedPatient():XML
		{
			return this._selectedPatient;
		}

		public function set selectedPatient(patient:XML):void
		{
			this._selectedPatient = patient;
		}
	}
}
