package collaboRhythm.hiviva.view.screens.hcp.messages
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.TopNavButton;
	import collaboRhythm.hiviva.view.media.Assets;
	import collaboRhythm.hiviva.view.screens.MessageInboxResultCell;
	import collaboRhythm.hiviva.view.screens.shared.HivivaMessageDetail;

	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;

	public class HivivaHCPMessageInbox extends Screen
	{
		private var _header:HivivaHeader;
		private var _composeBtn:TopNavButton;
		private var _sentBtn:TopNavButton;
		private var _alerts:XMLList;
		private var _remoteCallCount:int = 0;
		private var _pendingConnections:XMLList;
		private var _remoteCallMade:Boolean = false;
		private var _deleteMessageButton:Button;
		private var _messageCells:Vector.<MessageInboxResultCell> = new <MessageInboxResultCell>[];
		private var _cellContainer:ScrollContainer;

		public function HivivaHCPMessageInbox()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			this._deleteMessageButton.validate();
			this._deleteMessageButton.width = Constants.STAGE_WIDTH * 0.25;
			this._deleteMessageButton.y = Constants.STAGE_HEIGHT - this._deleteMessageButton.height - Constants.FOOTER_BTNGROUP_HEIGHT;
			this._deleteMessageButton.x = (Constants.STAGE_WIDTH * 0.5) - (this._deleteMessageButton.width * 0.5);

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

			this._sentBtn = new TopNavButton();
//			this._sentBtn.hivivaImage = new Image(Main.assets.getTexture("message_icon_sent"));
			this._sentBtn.hivivaImage = new Image(Main.assets.getTexture("v2_message_icon_sent"));
			this._sentBtn.addEventListener(Event.TRIGGERED , sentBtnHandler);

			this._composeBtn = new TopNavButton();
//			this._composeBtn.hivivaImage = new Image(Main.assets.getTexture("message_icon_compose"));
			this._composeBtn.hivivaImage = new Image(Main.assets.getTexture("v2_message_icon_compose"));
			this._composeBtn.addEventListener(Event.TRIGGERED , composeBtnHandler);

			this._header.rightItems = new <DisplayObject>[this._sentBtn, this._composeBtn];

			// added this because header.padding doesn't work, header.titleProperties.paddingLeft doesn't work.
			var dudForPadding:Quad = new Quad(130, Constants.HEADER_HEIGHT, 0x000000);
			dudForPadding.alpha = 0;
			this._header.leftItems = new <DisplayObject>[dudForPadding];

			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.SHOW_MAIN_NAV,true));
		}

		private function getAllMessagesFromRemoteService():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_HCP_ALERTS_COMPLETE, getHCPAlertsHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getHCPAlerts();

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE, getPendingConnectionsHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPendingConnections();

			this._remoteCallMade = true;
		}

		private function getHCPAlertsHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_HCP_ALERTS_COMPLETE, getHCPAlertsHandler);

			this._alerts = e.data.xmlResponse.DCAlertMessageRecord;
			this._remoteCallCount++;
			allDataLoadedCheck();
		}

		private function getPendingConnectionsHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE, getPendingConnectionsHandler);

			this._pendingConnections = e.data.xmlResponse.DCConnection;
			this._remoteCallCount++;
			allDataLoadedCheck();
		}

		private function allDataLoadedCheck():void
		{
			if(this._remoteCallCount == 2)
//			if(this._remoteCallCount == 1)
			{
				this._cellContainer = new ScrollContainer();
				this._cellContainer.layout = new VerticalLayout();

				if(this._alerts != null) populateAlerts();
				if(this._pendingConnections != null) populatePendingConnections();
				drawResults()
			}
		}

		private function populateAlerts():void
		{
			var listCount:uint = this._alerts.length();
			var alert:MessageInboxResultCell;
			if(listCount > 0)
			{
				for(var i:uint = 0 ; i < listCount ; i++)
				{
					alert = new MessageInboxResultCell();
					alert.messageType = MessageInboxResultCell.STATUS_ALERT_TYPE;
					alert.guid = this._alerts[i].AlertMessageGuid;
					alert.primaryText = this._alerts[i].AlertMessage;
					alert.dateText = this._alerts[i].AlertDate;
					alert.addEventListener(FeathersScreenEvent.MESSAGE_READ, messageSelectedHandler);
					alert.addEventListener(FeathersScreenEvent.MESSAGE_SELECT, messageCheckBoxSelectedHandler);
					this._cellContainer.addChild(alert);
					this._messageCells.push(alert);
				}
			}
		}

		private function populatePendingConnections():void
		{
			var listCount:uint = this._pendingConnections.length();
			var connectionRequest:MessageInboxResultCell;
			var fullName:String;
			if(listCount > 0)
			{
				for(var i:uint = 0 ; i < listCount ; i++)
				{
					fullName = this._pendingConnections[i].FromFirstName + " " + this._pendingConnections[i].FromLastName;
					connectionRequest = new MessageInboxResultCell();
					connectionRequest.messageType = MessageInboxResultCell.CONNECTION_REQUEST_TYPE;
					connectionRequest.guid = this._pendingConnections[i].FromUserGuid;
//					connectionRequest.primaryText = fullName + " (" + this._pendingConnections[i].FromAppId + ") has requested to connect";
					connectionRequest.primaryText = fullName + " has requested to connect";
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
				this._alertCells[j].width = Constants.STAGE_WIDTH;
			}
*/

			this._cellContainer.validate();
		}

		private function messageSelectedHandler(e:FeathersScreenEvent):void
		{
			var targetCell:MessageInboxResultCell = e.target as MessageInboxResultCell;
			var messageType:String = targetCell.messageType;
			var messageData:XML;
			switch(messageType)
			{
//				case MessageInboxResultCell.COMPOSED_MESSAGE_TYPE :
//					messageData = getMessageXMLByProperty(this._alerts,"MessageGuid",targetCell.guid);
//					break;
				case MessageInboxResultCell.CONNECTION_REQUEST_TYPE :
					messageData = getMessageXMLByProperty(this._pendingConnections,"FromUserGuid",targetCell.guid);
					break;
				case MessageInboxResultCell.STATUS_ALERT_TYPE :
					messageData = getMessageXMLByProperty(this._alerts,"AlertMessageGuid",targetCell.guid);
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

		private function messageDetailEventHandler(e:Event):void
		{
			trace("messageDetailEventHandler");
		}

		private function messageCheckBoxSelectedHandler(e:FeathersScreenEvent):void
		{
			trace("messageCheckBoxSelectedHandler");
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
						case MessageInboxResultCell.STATUS_ALERT_TYPE :
							HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.DELETE_ALERT_MESSAGE_COMPLETE, deleteAlertMessageHandler);
							HivivaStartup.hivivaAppController.hivivaRemoteStoreController.deleteAlertMessage(getMessageXMLByProperty(this._alerts,"AlertMessageGuid",selectedMessage.guid));
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

		private function deleteAlertMessageHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.DELETE_ALERT_MESSAGE_COMPLETE, deleteAlertMessageHandler);
			trace("alert message deleted : " + e.data.xmlResponse.Message);
		}


		private function composeBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_MESSAGE_COMPOSE_SCREEN);
		}

		private function sentBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_MESSAGE_SENT_SCREEN);

		}
	}
}
