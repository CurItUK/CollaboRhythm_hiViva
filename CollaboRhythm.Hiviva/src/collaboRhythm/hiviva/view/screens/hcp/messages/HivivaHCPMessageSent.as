package collaboRhythm.hiviva.view.screens.hcp.messages
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
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

	public class HivivaHCPMessageSent extends Screen
	{
		private var _header:HivivaHeader;
		private var _backButton:Button;
		private var _scaledPadding:Number;
		private var _remoteCallMade:Boolean = false;
		private var _allSentMessages:XMLList;
		private var _cellContainer:ScrollContainer;
		private var _messageCells:Vector.<MessageInboxResultCell> = new <MessageInboxResultCell>[];

		public function HivivaHCPMessageSent()
		{

		}

		override protected function draw():void
		{
			this._scaledPadding = (Constants.STAGE_HEIGHT * 0.04) * this.dpiScale;
			super.draw();

			this._header.width = Constants.STAGE_WIDTH;
			this._header.initTrueTitle();

			if(!this._remoteCallMade) getMessagesFromRemoteService();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Sent messages";
			this._header.scale = this.dpiScale;
			addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV,true));
		}

		private function backBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_MESSAGE_INBOX_SCREEN)
		}

		private function getMessagesFromRemoteService():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_HCP_SENT_MESSAGES_COMPLETE,
					getHCPSentMessagesHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getHCPSentMessages();
			this._remoteCallMade = true;
		}

		private function getHCPSentMessagesHandler(e:RemoteDataStoreEvent):void
		{
			this._allSentMessages = e.data.xmlResponse.DCMessageRecord;

			this._cellContainer = new ScrollContainer();
			this._cellContainer.layout = new VerticalLayout();
			this.addChild(this._cellContainer);

			populateMessages();
			drawResults()
		}

		private function populateMessages():void
		{
			var listCount:uint = this._allSentMessages.length();
			var hcpSentMessage:MessageInboxResultCell;
			if(listCount > 0)
			{

				for(var i:uint = 0 ; i < listCount ; i++)
				{
					hcpSentMessage = new MessageInboxResultCell();
					hcpSentMessage.messageType = MessageInboxResultCell.COMPOSED_MESSAGE_TYPE;
					hcpSentMessage.isSent = true;
					hcpSentMessage.guid = this._allSentMessages[i].MessageGuid;
					hcpSentMessage.primaryText = this._allSentMessages[i].Message;
//					hcpMessage.secondaryText = this._allSentMessages[i].Name;
					hcpSentMessage.dateText = this._allSentMessages[i].SentDate;
					hcpSentMessage.addEventListener(FeathersScreenEvent.MESSAGE_SELECT, messageSelectedHandler);
					this._cellContainer.addChild(hcpSentMessage);
					this._messageCells.push(hcpSentMessage);
					hcpSentMessage.validate();
				}
				this._cellContainer.validate();
			}
		}

		private function drawResults():void
		{
			this._cellContainer.width = Constants.STAGE_WIDTH;
			this._cellContainer.y = this._header.height;
			this._cellContainer.height = Constants.STAGE_HEIGHT - this._cellContainer.y - Constants.PADDING_BOTTOM;

			for (var i:int = 0; i < this._messageCells.length; i++)
			{
				this._messageCells[i].width = Constants.STAGE_WIDTH;
			}

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
					messageData = getMessageXMLByProperty(this._allSentMessages,"MessageGuid",targetCell.guid);
					break;
			}
			var screenNavProperties:Object =
			{
				customHeight:Constants.STAGE_HEIGHT,
				messageData:messageData,
				messageType:messageType,
				parentScreen:this.owner.activeScreenID,
				isSent:true
			};
			if(this.owner.hasScreen(HivivaScreens.MESSAGE_DETAIL_SCREEN))
			{
				this.owner.removeScreen(HivivaScreens.MESSAGE_DETAIL_SCREEN);
			}
			this.owner.addScreen(HivivaScreens.MESSAGE_DETAIL_SCREEN, new ScreenNavigatorItem(HivivaMessageDetail, null, screenNavProperties));
			this.owner.showScreen(HivivaScreens.MESSAGE_DETAIL_SCREEN);
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

		private function messageDetailEventHandler(e:Event):void
		{
			trace("messageDetailEventHandler");
		}

		override public function dispose():void
		{
			super.dispose();
		}
	}
}
