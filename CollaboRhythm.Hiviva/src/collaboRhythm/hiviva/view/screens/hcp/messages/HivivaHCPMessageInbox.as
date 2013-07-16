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
	import feathers.core.PopUpManager;
	import feathers.layout.VerticalLayout;

	import source.themes.HivivaTheme;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;


	public class HivivaHCPMessageInbox extends Screen
	{

		private var _header:HivivaHeader;
		private var _messagesData:XML;
		private var _messageCellContainer:ScrollContainer;
		private var _composeBtn:TopNavButton;
		private var _sentBtn:TopNavButton;
		private var _deleteBtn:Button;
		private var _messageCentre:Array;
		private var _allReceivedMessages:XMLList;
		private var _remoteCallCount:int = 0;
		private var _pendingConnections:XMLList;


		private var _scaledPadding:Number;

		private const PADDING:Number = 20;
		private var _remoteCallMade:Boolean = false;

		private var messagesXMLList:XMLList;
		private var _deleteMessageButton:Button;


		private var _messageCells:Vector.<MessageInboxResultCell> = new <MessageInboxResultCell>[];
//		private var _alertCells:Vector.<AlertInboxResultCell> = new <AlertInboxResultCell>[];
		private var _cellContainer:ScrollContainer;
		private var _approveAlert:HivivaPopUp;
		private var _alertGuidToAccept:String;

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
			this._sentBtn.hivivaImage = new Image(Assets.getTexture("MessageIconSentPng"));
			this._sentBtn.addEventListener(starling.events.Event.TRIGGERED , sentBtnHandler);

			this._composeBtn = new TopNavButton();
			this._composeBtn.hivivaImage = new Image(Assets.getTexture("MessageIconComposePng"));
			this._composeBtn.addEventListener(starling.events.Event.TRIGGERED , composeBtnHandler);

			this._header.rightItems = new <DisplayObject>[this._sentBtn, this._composeBtn];

			// added this because header.padding doesn't work, header.titleProperties.paddingLeft doesn't work.
			var dudForPadding:Quad = new Quad(130, Constants.HEADER_HEIGHT, 0x000000);
			dudForPadding.alpha = 0;
			this._header.leftItems = new <DisplayObject>[dudForPadding];

			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.SHOW_MAIN_NAV,true));
		}

		private function getAllMessagesFromRemoteService():void
		{
			/*
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE, getUserReceivedMessagesHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getUserReceivedMessages();
*/
			// TODO : get alerts

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE, getPendingConnectionsHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPendingConnections();
			this._remoteCallMade = true;
		}

		private function getUserReceivedMessagesHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE, getUserReceivedMessagesHandler);

			this._allReceivedMessages = e.data.xmlResponse.DCMessageRecord;
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
//			if(this._remoteCallCount == 2)
			if(this._remoteCallCount == 1)
			{
				this._cellContainer = new ScrollContainer();
				this._cellContainer.layout = new VerticalLayout();

//				populateMessages();
				populatePendingConnections();
				drawResults()
			}
		}

		private function populateMessages():void
		{
			var listCount:uint = this._allReceivedMessages.length();
			var messageInboxResultCell:MessageInboxResultCell;
			if(listCount > 0)
			{
				for(var i:uint = 0 ; i < listCount ; i++)
				{
					messageInboxResultCell = new MessageInboxResultCell();

					messageInboxResultCell.guid = this._allReceivedMessages[i].MessageGuid;
					messageInboxResultCell.primaryText = this._allReceivedMessages[i].Message;
					messageInboxResultCell.secondaryText = this._allReceivedMessages[i].Name;
					messageInboxResultCell.dateText = this._allReceivedMessages[i].SentDate;
					messageInboxResultCell.scale = this.dpiScale;
					messageInboxResultCell.addEventListener(FeathersScreenEvent.MESSAGE_SELECT, messageSelectedHandler);
					messageInboxResultCell.addEventListener(FeathersScreenEvent.MESSAGE_CB_SELECT, messageCheckBoxSelectedHandler);
					this._cellContainer.addChild(messageInboxResultCell);
					this._messageCells.push(messageInboxResultCell);
				}
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
					connectionRequest.primaryText = "Patient (" + this._pendingConnections[i].FromAppId + ") has requested to connect";
//					hcpMessage.secondaryText = this._allReceivedMessages[i].Name;
					connectionRequest.dateText = this._pendingConnections[i].SentDate;
					connectionRequest.addEventListener(FeathersScreenEvent.MESSAGE_SELECT, messageSelectedHandler);
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
			this._cellContainer.y = Constants.HEADER_HEIGHT + Constants.PADDING_TOP;
			this._cellContainer.height = Constants.STAGE_HEIGHT - this._cellContainer.y - this._deleteMessageButton.height - Constants.PADDING_BOTTOM;

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
				customHeight:Constants.STAGE_HEIGHT - Constants.FOOTER_BTNGROUP_HEIGHT,
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

		private function messageCheckBoxSelectedHandler():void
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
			for (var i:int = 0; i < this._messageCells.length; i++)
			{
				if(this._messageCells[i].check.isSelected)
				{
					this._cellContainer.removeChild(this._messageCells[i], true);
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.DELETE_USER_MESSAGE_COMPLETE, deleteUserMessageHandler);
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.deleteUserMessage(this._messageCells[i].guid);
				}
			}
			this._cellContainer.validate();
		}

		private function deleteUserMessageHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.DELETE_USER_MESSAGE_COMPLETE, deleteUserMessageHandler);
			trace('message deleted');
		}

		private function composeBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_MESSAGE_COMPOSE_SCREEN);
		}

		private function sentBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_MESSAGE_SENT_SCREEN);

		}
	}
}
