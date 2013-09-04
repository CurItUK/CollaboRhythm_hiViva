package collaboRhythm.hiviva.view.screens.patient
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;

	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.*;

	import collaboRhythm.hiviva.view.screens.MessageInboxResultCell;
	import collaboRhythm.hiviva.view.screens.shared.HivivaMessageDetail;

	import feathers.controls.Button;

	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;

	import feathers.layout.VerticalLayout;



	import starling.display.DisplayObject;


	import starling.events.Event;



	public class HivivaPatientMessagesScreen extends Screen
	{
		protected var _header:HivivaHeader;
		private var _remoteCallMade:Boolean = false;
		private var _remoteCallCount:int = 0;
		private var _allReceivedMessages:XMLList;
		private var _pendingConnections:XMLList;
		private var _deleteMessageButton:Button;
		private var _messageCells:Vector.<MessageInboxResultCell> = new <MessageInboxResultCell>[];
//		private var _alertCells:Vector.<AlertInboxResultCell> = new <AlertInboxResultCell>[];
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

			this._header.paddingLeft = Constants.HEADER_HOMEBTN_PADDING;
			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
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
				populatePendingConnections();
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
					hcpMessage.secondaryText = HivivaModifier.getAppIdWithGuid(this._allReceivedMessages[i].UserGuid);
					hcpMessage.dateText = this._allReceivedMessages[i].SentDate;
					hcpMessage.addEventListener(FeathersScreenEvent.MESSAGE_READ, messageSelectedHandler);
					hcpMessage.addEventListener(FeathersScreenEvent.MESSAGE_SELECT, messageCheckBoxSelectedHandler);
					this._cellContainer.addChild(hcpMessage);
					this._messageCells.push(hcpMessage);
				}
				//this._deleteMessageButton.visible = true;
			}
		}

		private function populatePendingConnections():void
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
					connectionRequest.primaryText = "Care provider (" + this._pendingConnections[i].FromAppId + ") has requested to connect";
//					hcpMessage.secondaryText = this._allReceivedMessages[i].Name;
					connectionRequest.dateText = this._pendingConnections[i].SentDate;
					connectionRequest.addEventListener(FeathersScreenEvent.MESSAGE_READ, messageSelectedHandler);
					connectionRequest.addEventListener(FeathersScreenEvent.MESSAGE_SELECT, messageCheckBoxSelectedHandler);
					this._cellContainer.addChild(connectionRequest);
					this._messageCells.push(connectionRequest);
				}
				//this._deleteMessageButton.visible = true;
			}
		}

		private function drawResults():void
		{
			this.addChild(this._cellContainer);
			this._cellContainer.width = Constants.STAGE_WIDTH;
			this._cellContainer.y = Constants.HEADER_HEIGHT;
			this._cellContainer.height = this._deleteMessageButton.y - this._cellContainer.y - Constants.PADDING_BOTTOM;

			for (var i:int = 0; i < this._messageCells.length; i++)
			{
				this._messageCells[i].width = Constants.STAGE_WIDTH;
			}
/*

			for (var j:int = 0; j < this._alertCells.length; j++)
			{
				this._alertCells[j].width = this.actualWidth;
			}
*/

			this._cellContainer.validate();
		}

		private function messageSelectedHandler(e:FeathersScreenEvent):void
		{
			var targetCell:MessageInboxResultCell = e.target as MessageInboxResultCell;
			var messageType:String = targetCell.messageType;
			var messageData:XML;
			// WILL NEVER HAVE STATUS_ALERT_TYPE
			switch(messageType)
			{
				case MessageInboxResultCell.COMPOSED_MESSAGE_TYPE :
					messageData = getMessageXMLByProperty(this._allReceivedMessages,"MessageGuid",targetCell.guid);
					break;
				case MessageInboxResultCell.CONNECTION_REQUEST_TYPE :
					messageData = getMessageXMLByProperty(this._pendingConnections,"FromUserGuid",targetCell.guid);
					break;
				case MessageInboxResultCell.STATUS_ALERT_TYPE :
//					messageData = getMessageXMLByProperty(this._allReceivedMessages,"MessageGuid",targetCell.guid);
					break;
			}
			var screenNavProperties:Object =
			{
				messageData:messageData,
				messageType:messageType,
				parentScreen:this.owner.activeScreenID,
				isSent:false
			};
			if(this.owner.hasScreen(HivivaScreens.MESSAGE_DETAIL_SCREEN))
			{
				this.owner.removeScreen(HivivaScreens.MESSAGE_DETAIL_SCREEN);
			}
			this.owner.addScreen(HivivaScreens.MESSAGE_DETAIL_SCREEN, new ScreenNavigatorItem(HivivaMessageDetail, {messageDetailEvent:messageDetailEventHandler}, screenNavProperties));
			this.owner.showScreen(HivivaScreens.MESSAGE_DETAIL_SCREEN);
		}

		private function messageCheckBoxSelectedHandler(e:FeathersScreenEvent):void
		{
			var msgCount:uint = this._messageCells.length;
			var targetCell:MessageInboxResultCell;
			var isSelectedCount:uint = 0;
			for(var i:uint = 0 ; i < msgCount ; i++)
			{
				targetCell = this._messageCells[i];
				if(targetCell.isSelected)
				{
					isSelectedCount += 1;
				}
			}
			isSelectedCount > 0 ? showHideDeleteButton(true) : showHideDeleteButton(false);
		}

		private function showHideDeleteButton(visible:Boolean):void
		{
			this._deleteMessageButton.visible = visible;
		}

		private function messageDetailEventHandler(e:Event):void
		{
			trace("messageDetailEventHandler");
		}

		private function getMessageXMLByProperty(xmlList:XMLList,property:String,value:String):XML
		{
			var xmlData:XML;
			var listCount:uint = xmlList.length();
			if(listCount > 0)
			{
				for(var i:uint = 0 ; i < listCount ; i++)
				{
					if(xmlList[i][property] == value)
					{
						xmlData = xmlList[i];
						break;
					}
				}
			}
			return xmlData;
		}

		private function deleteMessageButtonHandler(e:Event):void
		{
			var selectedMessage:MessageInboxResultCell;
			for (var i:int = 0; i < this._messageCells.length; i++)
			{
				selectedMessage = this._messageCells[i];
				if(selectedMessage.check.isSelected)
				{
					switch(selectedMessage.messageType)
					{
						case MessageInboxResultCell.CONNECTION_REQUEST_TYPE :
							HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.CONNECTION_IGNORE_COMPLETE, ignoreConnectionHandler);
							HivivaStartup.hivivaAppController.hivivaRemoteStoreController.ignoreConnection(getMessageXMLByProperty(this._pendingConnections,"FromUserGuid",selectedMessage.guid).FromUserGuid);
							break;
						case MessageInboxResultCell.COMPOSED_MESSAGE_TYPE :
							HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.DELETE_USER_MESSAGE_COMPLETE, deleteUserMessageHandler);
							HivivaStartup.hivivaAppController.hivivaRemoteStoreController.deleteUserMessage(selectedMessage.guid);
							break;
					}
					this._cellContainer.removeChild(selectedMessage, true);
					selectedMessage.check.isSelected = false;
				}
			}
			this._cellContainer.validate();
		}

		private function ignoreConnectionHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.CONNECTION_IGNORE_COMPLETE, ignoreConnectionHandler);
			trace("request ignored : " + e.data.xmlResponse.Message);
		}

		private function deleteUserMessageHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.DELETE_USER_MESSAGE_COMPLETE, deleteUserMessageHandler);
			trace('message deleted');
		}

	}
}
