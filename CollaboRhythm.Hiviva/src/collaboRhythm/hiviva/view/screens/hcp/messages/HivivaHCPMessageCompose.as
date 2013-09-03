package collaboRhythm.hiviva.view.screens.hcp.messages
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaPopUp;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.screens.shared.ValidationScreen;
	import collaboRhythm.hiviva.view.components.MessageCell;
	import collaboRhythm.hiviva.model.HivivaLocalStoreService;
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.PickerList;
	import feathers.controls.Screen
	import feathers.controls.Radio;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	import feathers.core.ToggleGroup;
	import feathers.controls.Radio;
	import flash.events.MouseEvent

	import feathers.controls.Screen;

	import flash.events.MouseEvent;
	import starling.events.Event;


	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaHCPMessageCompose extends ValidationScreen
	{


		private var _backButton:Button;
		private var _remoteCallCount:int = 0;

		private var _hcpName:Label;
		private var _patientName:Label;
		private var _selectMessage:Label;

		private var _patientPickerList:PickerList;

		private var _cancelAndSend:BoxedButtons;

		private var _popupContainer:HivivaPopUp;

		private var _radioGroup:ToggleGroup;
//		private var _radioButton:Radio;

		private var _remoteCallMade:Boolean;
		private var _allSendableMessages:XMLList;
		private var _patientConnections:Array;

		private const MESSAGE_LABELS:Array =
		[
			"Great job, keep it up!",
			"Let's schedule an office visit"
		];

		private const MESSAGE_ICONS:Array =
		[
			"STAR1",
			"STAR2"
		]

		public function HivivaHCPMessageCompose()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._patientPickerList.width = this._innerWidth;

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

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._hcpName = new Label();
			this._hcpName.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._hcpName.text = "From : " + HivivaStartup.userVO.appId;
			this._content.addChild(this._hcpName);

			this._patientName = new Label();
			this._patientName.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._patientName.text = "To : "// + _main.selectedHCPPatientProfile.name;
			this._content.addChild(this._patientName);

			this._patientPickerList = new PickerList();
			this._patientPickerList.prompt = "Loading connections...";
			this._patientPickerList.selectedIndex = -1;
			this._patientPickerList.isEnabled = false;
			this._patientPickerList.addEventListener(starling.events.Event.CHANGE, patientSelectedHandler);
			this._content.addChild(this._patientPickerList);

			this._selectMessage = new Label();
			this._selectMessage.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._selectMessage.text = "Select Message "// + _main.selectedHCPPatientProfile.name;
			this._content.addChild(this._selectMessage);

			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV,true));
		}

		private function getMessageTypesAndConnections():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_MESSAGES_COMPLETE, getMessagesHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getMessages();

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE , getApprovedConnectionsCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getApprovedConnections();

			this._remoteCallMade = true;
		}

		private function getMessagesHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_MESSAGES_COMPLETE, getMessagesHandler);

			this._allSendableMessages = e.data.xmlResponse.DCMessage;
			/*<MessageGuid>649c68bb-e87c-4eb7-bd74-52fa271cea53</MessageGuid>
			<Message>Great job, keep it up!</Message>*/
			this._remoteCallCount++;
			allDataLoadedCheck();
		}

		private function getApprovedConnectionsCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE , getApprovedConnectionsCompleteHandler);

			var xml:XML = e.data.xmlResponse;

			this._patientConnections = [];
			if(xml.children().length() > 0)
			{

				var loop:uint = xml.children().length();
				var approvedHCPList:XMLList  = xml.DCConnection;
				for(var i:uint = 0 ; i <loop ; i++)
				{

					var establishedUser:Object = establishToFromId(approvedHCPList[i]);
					var patientObj:Object = {userAppId:establishedUser.appId , userGuid:establishedUser.appGuid};
					this._patientConnections.push(patientObj);
				}
				populateConnectionsPickerlist();
			}
			else
			{
				trace("No Approved Connections");
				this._patientPickerList.prompt = "No connections";
			}

			this._remoteCallCount++;
			allDataLoadedCheck();
		}

		private function establishToFromId(idsToCompare:XML):Object
		{
			var whoEstablishConnection:Object = [];
			if(idsToCompare.FromAppId == HivivaStartup.userVO.appId)
			{
				whoEstablishConnection.appGuid = (idsToCompare.ToUserGuid).toString();
				whoEstablishConnection.appId = (idsToCompare.ToAppId).toString();
			} else
			{
				whoEstablishConnection.appGuid = (idsToCompare.FromUserGuid).toString();
				whoEstablishConnection.appId = (idsToCompare.FromAppId).toString();
			}

			return whoEstablishConnection;

		}

		private function allDataLoadedCheck():void
		{
			if(this._remoteCallCount == 2)
			{
				populateMessages();
			}
		}

		private function populateMessages():void
		{
			var sendableMessageLength:int = this._allSendableMessages.length();
			var sendableMessage:Radio;
			this._radioGroup = new ToggleGroup();
			for (var i:int = 0; i < sendableMessageLength; i++)
			{
//				this._allSendableMessages[i].Message

				sendableMessage = new Radio();
				sendableMessage.label = this._allSendableMessages[i].Message;
				this._radioGroup.addItem(sendableMessage);
				this._content.addChild(sendableMessage);
			}
//			this._radioGroup.addEventListener( starling.events.Event.CHANGE, group_changeHandler );
		}

		private function populateConnectionsPickerlist():void
		{
			var patients:ListCollection = new ListCollection( this._patientConnections );

			this._patientPickerList.dataProvider = patients;
			this._patientPickerList.prompt = "Select patient";
			this._patientPickerList.isEnabled = true;
			this._patientPickerList.selectedIndex = -1;
			this._patientPickerList.listProperties.@itemRendererProperties.labelField = "userAppId";
			this._patientPickerList.labelField = "userAppId";
			this._patientPickerList.addEventListener( Event.CHANGE, pickerListonChangeHandler );
		}

		private function pickerListonChangeHandler(e:Event):void
		{
			if(this._cancelAndSend == null)
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
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.sendUserMessage(this._patientPickerList.selectedItem.userGuid,messageGuid);
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

		private function initAlertText():void
		{

			var alertLabel:Label = new Label();
			alertLabel.text = "Connect to a patient to get started.";

			this.addChild(alertLabel);
			alertLabel.validate();
			alertLabel.x = this._innerWidth / 2 - alertLabel.width / 2;
			alertLabel.y = alertLabel.height * 4;
		}

		private function initPatientSelectList():void
		{

		}

		private function patientSelectedHandler(e:starling.events.Event):void
		{
			//TODO change patient PDF report details
		}

		private function backBtnHandler(e:starling.events.Event = null):void
		{
			this._owner.showScreen(HivivaScreens.HCP_MESSAGE_INBOX_SCREEN);
		}
	}
}
