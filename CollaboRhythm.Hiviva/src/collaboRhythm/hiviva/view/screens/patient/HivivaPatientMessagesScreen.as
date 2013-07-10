package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.screens.AlertInboxResultCell;

	import collaboRhythm.hiviva.view.screens.MessageInboxResultCell;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.core.FeathersControl;
	import feathers.core.PopUpManager;
	import feathers.layout.VerticalLayout;

	import source.themes.HivivaTheme;

	import starling.display.DisplayObject;
	import starling.display.Image;

	import starling.events.Event;
	import starling.textures.Texture;


	public class HivivaPatientMessagesScreen extends Screen
	{
		protected var _header:HivivaHeader;
		private var _remoteCallMade:Boolean = false;
		private var _remoteCallCount:int = 0;
		private var _allReceivedMessages:XMLList;
		private var _pendingConnections:XMLList;
		private var _deleteMessageButton:Button;
		private var _messageCells:Vector.<MessageInboxResultCell> = new <MessageInboxResultCell>[];
		private var _alertCells:Vector.<AlertInboxResultCell> = new <AlertInboxResultCell>[];
		private var _cellContainer:ScrollContainer;
		private var _approveAlert:HivivaPopUp;
		private var _alertGuidToAccept:String;

		private var _vPadding:Number;
		private var _hPadding:Number;

		public function HivivaPatientMessagesScreen()
		{

		}

		override protected function draw():void
		{
			this._vPadding = (this.actualHeight * 0.04) * this.dpiScale;
			this._hPadding = (this.actualWidth * 0.04) * this.dpiScale;
			super.draw();

			this._header.paddingLeft = this._hPadding;
			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			this._deleteMessageButton.validate();
			this._deleteMessageButton.width = this.actualWidth * 0.25;
			this._deleteMessageButton.y = this.actualHeight - this._vPadding - this._deleteMessageButton.height;
			this._deleteMessageButton.x = (this.actualWidth * 0.5) - (this._deleteMessageButton.width * 0.5);

			if(!this._remoteCallMade) getAllMessagesFromRemoteService();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Messages";
			this._header.scale = this.dpiScale;
			addChild(this._header);

			this._deleteMessageButton = new Button();
			this._deleteMessageButton.label = "Delete";
			this._deleteMessageButton.visible = false;
			this._deleteMessageButton.addEventListener(Event.TRIGGERED, deleteMessageButtonHandler);
			this.addChild(this._deleteMessageButton);

			var homeBtn:Button = new Button();
			homeBtn.name = HivivaThemeConstants.HOME_BUTTON;
			homeBtn.addEventListener(Event.TRIGGERED, homeBtnHandler);
			this._header.leftItems = new <DisplayObject>[homeBtn];
		}

		private function homeBtnHandler(e:Event):void
		{
			if(this.owner.hasScreen(HivivaScreens.PATIENT_MESSAGE_DETAIL_SCREEN))
			{
				this.owner.removeScreen(HivivaScreens.PATIENT_MESSAGE_DETAIL_SCREEN);
			}

			this.dispatchEventWith("navGoHome");
		}

		private function getAllMessagesFromRemoteService():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE, getUserReceivedMessagesHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getUserReceivedMessages();

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE, getPendingConnectionsHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPendingConnections();
			this._remoteCallMade = true;
		}

		private function getUserReceivedMessagesHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE, getUserReceivedMessagesHandler);

			this._allReceivedMessages = e.data.xmlResponse.DCMessageRecord;

			/*
			<DCMessageRecord>
				<MessageGuid>d656a765-5c34-404f-a582-9c51bdd4c1e3</MessageGuid>
				<SentDate>2013-07-04T16:00:50.587</SentDate>
				<UserGuid>b5f2d31c-7c4a-4266-87b7-2527c4811dfb</UserGuid>
				<Name>no email</Name>
				<Message>Let's schedule an office visit</Message>
				<read>false</read>
			</DCMessageRecord>
			*/
			this._remoteCallCount++;
			allDataLoadedCheck();
		}

		private function getPendingConnectionsHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE, getPendingConnectionsHandler);

			this._pendingConnections = e.data.xmlResponse.DCConnection;

			/*
			<DCConnection>
				<FromUserGuid>7db0dc07-a6a9-4e37-b04b-a1a3639d49a2</FromUserGuid>
				<FromAppId>531-447-249</FromAppId>
				<ToUserGuid>94fcb80a-ca94-4a6a-bb57-241c95a06108</ToUserGuid>
				<ToAppId>752-974-210</ToAppId>
				<Status>0</Status>
			</DCConnection>
			*/
			this._remoteCallCount++;
			allDataLoadedCheck();
		}

		private function allDataLoadedCheck():void
		{
			if(this._remoteCallCount == 2)
			{
				this._cellContainer = new ScrollContainer();
				this._cellContainer.layout = new VerticalLayout();

				populateMessages();
				populateAlerts();
				drawResults()
			}
		}

		private function populateMessages():void
		{
			var listCount:uint = this._allReceivedMessages.length();
			var hcpMessage:MessageInboxResultCell;
			if(listCount > 0)
			{

				for(var i:uint = 0 ; i < listCount ; i++)
				{
					hcpMessage = new MessageInboxResultCell();
					hcpMessage.messageType = MessageInboxResultCell.COMPOSED_MESSAGE_TYPE;
					hcpMessage.read = this._allReceivedMessages[i].read == "true";
					hcpMessage.guid = this._allReceivedMessages[i].MessageGuid;
					hcpMessage.primaryText = this._allReceivedMessages[i].Message;
//					hcpMessage.secondaryText = this._allReceivedMessages[i].Name;
					hcpMessage.dateText = this._allReceivedMessages[i].SentDate;
					hcpMessage.addEventListener(FeathersScreenEvent.MESSAGE_SELECT, messageSelectedHandler);
					this._cellContainer.addChild(hcpMessage);
					this._messageCells.push(hcpMessage);
				}
				this._deleteMessageButton.visible = true;
			}
		}

		private function populateAlerts():void
		{
			var listCount:uint = this._pendingConnections.length();
			var connectionRequest:MessageInboxResultCell;
			if(listCount > 0)
			{
				for(var i:uint = 0 ; i < listCount ; i++)
				{
					connectionRequest = new MessageInboxResultCell();
					connectionRequest.messageType = MessageInboxResultCell.CONNECTION_REQUEST_TYPE;
					connectionRequest.guid = this._pendingConnections[i].FromUserGuid;
					connectionRequest.primaryText = "User (" + this._pendingConnections[i].FromAppId + ") has requested to connect";
//					hcpMessage.secondaryText = this._allReceivedMessages[i].Name;
					connectionRequest.dateText = this._pendingConnections[i].SentDate;
					connectionRequest.addEventListener(FeathersScreenEvent.MESSAGE_SELECT, messageSelectedHandler);
					this._cellContainer.addChild(connectionRequest);
					this._messageCells.push(connectionRequest);
				}
				this._deleteMessageButton.visible = true;
			}
		}

		private function drawResults():void
		{
			this.addChild(this._cellContainer);
			this._cellContainer.width = this.actualWidth;
			this._cellContainer.y = this._header.height;
			this._cellContainer.height = this.actualHeight - this._cellContainer.y -
					this._deleteMessageButton.height - (this._vPadding * 2);

			for (var i:int = 0; i < this._messageCells.length; i++)
			{
				this._messageCells[i].width = this.actualWidth;
			}

			for (var j:int = 0; j < this._alertCells.length; j++)
			{
				this._alertCells[j].width = this.actualWidth;
			}

			this._cellContainer.validate();
		}

		private function messageSelectedHandler(e:FeathersScreenEvent):void
		{
			var targetCell:MessageInboxResultCell = e.target as MessageInboxResultCell;
			var messageData:XML = getMessageXMLByGuid(targetCell.guid);
			var messageType:String = targetCell.messageType;
			var screenNavProperties:Object =
			{
				messageName:messageData.Name,
				messageDate:messageData.SentDate,
				messageText:messageData.Message,
				messageType:messageType
			};
			if(this.owner.hasScreen(HivivaScreens.PATIENT_MESSAGE_DETAIL_SCREEN))
			{
				this.owner.removeScreen(HivivaScreens.PATIENT_MESSAGE_DETAIL_SCREEN);
			}
			this.owner.addScreen(HivivaScreens.PATIENT_MESSAGE_DETAIL_SCREEN, new ScreenNavigatorItem(HivivaPatientMessageDetail, null, screenNavProperties));
			this.owner.showScreen(HivivaScreens.PATIENT_MESSAGE_DETAIL_SCREEN);
		}

		private function alertSelectedHandler(e:FeathersScreenEvent):void
		{
			this._alertGuidToAccept = e.evtData.guid;

			this._approveAlert = new HivivaPopUp();
			this._approveAlert.scale = this.dpiScale;
			this._approveAlert.confirmLabel = "Accept";
			this._approveAlert.addEventListener(Event.COMPLETE, remoteApproveConnection);
			this._approveAlert.addEventListener(Event.CLOSE, closePopup);
			this._approveAlert.width = this.actualWidth * 0.8;
			this._approveAlert.validate();
			this._approveAlert.message = "Approve connection request from this HCP?";

			PopUpManager.addPopUp(this._approveAlert,true,true);
			this._approveAlert.validate();
			PopUpManager.centerPopUp(this._approveAlert);
			// draw close button post center so the centering works correctly
			this._approveAlert.drawCloseButton();
		}

		private function remoteApproveConnection(e:Event):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.CONNECTION_APPROVE_COMPLETE, approveConnectionHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.approveConnection(this._alertGuidToAccept);
		}

		private function approveConnectionHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.CONNECTION_APPROVE_COMPLETE, approveConnectionHandler);

			if(e.data.xmlResponse.StatusCode == "1")
			{
				removeAlertCell();
			}
			closePopup();
		}

		private function removeAlertCell():void
		{
			for (var i:int = 0; i < this._alertCells.length; i++)
			{
				if(this._alertCells[i].guid == this._alertGuidToAccept)
				{
					this._cellContainer.removeChild(this._alertCells[i], true);
				}
			}
			this._cellContainer.validate();
		}

		private function closePopup(e:Event = null):void
		{
			PopUpManager.removePopUp(this._approveAlert);
			this._alertGuidToAccept = "";
		}

		private function getMessageXMLByGuid(guid:String):XML
		{
			var messageData:XML;
			var listCount:uint = this._allReceivedMessages.length();
			if(listCount > 0)
			{
				for(var i:uint = 0 ; i < listCount ; i++)
				{
					if(this._allReceivedMessages[i].MessageGuid == guid)
					{
						messageData = this._allReceivedMessages[i];
						break;
					}
				}
			}
			return messageData;
		}

		private function deleteMessageButtonHandler(e:Event):void
		{
			for (var i:int = 0; i < this._messageCells.length; i++)
			{
				if(this._messageCells[i].check.isSelected)
				{
					switch(this._messageCells[i].messageType)
					{
						case MessageInboxResultCell.COMPOSED_MESSAGE_TYPE :
							HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.DELETE_USER_MESSAGE_COMPLETE, deleteUserMessageHandler);
							HivivaStartup.hivivaAppController.hivivaRemoteStoreController.deleteUserMessage(this._messageCells[i].guid);
							break;
						case MessageInboxResultCell.CONNECTION_REQUEST_TYPE :
							// TODO : call 'add to ignore list' remote service
							break;
						case MessageInboxResultCell.STATUS_ALERT_TYPE :
							// TODO : call 'remove alert' remote service
							break;
					}
					this._cellContainer.removeChild(this._messageCells[i], true);
				}
			}
			this._cellContainer.validate();
		}

		private function deleteUserMessageHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.DELETE_USER_MESSAGE_COMPLETE, deleteUserMessageHandler);
			trace('message deleted');
		}

	}
}
