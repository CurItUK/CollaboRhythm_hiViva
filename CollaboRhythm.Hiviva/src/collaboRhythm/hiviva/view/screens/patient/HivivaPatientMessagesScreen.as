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

	import collaboRhythm.hiviva.view.screens.MessageInboxResultCell;

	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;

	import mx.core.ByteArrayAsset;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaPatientMessagesScreen extends Screen
	{
		protected var _header:HivivaHeader;
		private var _remoteCallMade:Boolean = false;
		private var _allRecievedMessages:XMLList;
		private var _deleteMessageButton:Button;
		private var _resultCells:Vector.<MessageInboxResultCell> = new <MessageInboxResultCell>[];
		private var _cellContainer:ScrollContainer;

		private var _scaledPadding:Number;

		public function HivivaPatientMessagesScreen()
		{

		}

		override protected function draw():void
		{
			this._scaledPadding = (this.actualHeight * 0.04) * this.dpiScale;
			super.draw();

			this._header.paddingLeft = this._scaledPadding;
			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			this._deleteMessageButton.validate();
			this._deleteMessageButton.width = this.actualWidth * 0.25;
			this._deleteMessageButton.y = this.actualHeight - this._scaledPadding - this._deleteMessageButton.height;
			this._deleteMessageButton.x = (this.actualWidth * 0.5) - (this._deleteMessageButton.width * 0.5);

			if(!this._remoteCallMade) getReceivedMessagesFromRemoteService();
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
			this._deleteMessageButton.addEventListener(Event.TRIGGERED, deleteHandler);
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

		private function getReceivedMessagesFromRemoteService():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE, getUserReceivedMessagesHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getUserReceivedMessages();
			this._remoteCallMade = true;
		}

		private function getUserReceivedMessagesHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_USER_RECEIVED_MESSAGES_COMPLETE, getUserReceivedMessagesHandler);

			this._allRecievedMessages = e.data.xmlResponse.DCMessageRecord;

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

			populateMessages();
		}

		private function populateMessages():void
		{
			this._cellContainer = new ScrollContainer();

			var listCount:uint = this._allRecievedMessages.length();
			var messageInboxResultCell:MessageInboxResultCell;
			if(listCount > 0)
			{
				for(var i:uint = 0 ; i < listCount ; i++)
				{
					messageInboxResultCell = new MessageInboxResultCell();

					messageInboxResultCell.guid = this._allRecievedMessages[i].MessageGuid;
					messageInboxResultCell.primaryText = this._allRecievedMessages[i].Message;
					messageInboxResultCell.secondaryText = this._allRecievedMessages[i].Name;
					messageInboxResultCell.dateText = this._allRecievedMessages[i].SentDate;
					messageInboxResultCell.scale = this.dpiScale;
					messageInboxResultCell.addEventListener(FeathersScreenEvent.HCP_MESSAGE_SELECTED, messageSelectedHandler);
					this._cellContainer.addChild(messageInboxResultCell);
					this._resultCells.push(messageInboxResultCell);
				}
				this.addChild(this._cellContainer);
			}

			drawResults();
		}

		private function getMessageXMLByGuid(guid:String):XML
		{
			var messageData:XML;
			var listCount:uint = this._allRecievedMessages.length();
			if(listCount > 0)
			{
				for(var i:uint = 0 ; i < listCount ; i++)
				{
					if(this._allRecievedMessages[i].MessageGuid == guid)
					{
						messageData = this._allRecievedMessages[i];
						break;
					}
				}
			}
			return messageData;
		}

		private function drawResults():void
		{
			this._cellContainer.width = this.actualWidth;
			this._cellContainer.y = this._header.height;
			this._cellContainer.height = this.actualHeight - this._cellContainer.y -
					this._deleteMessageButton.height - (this._scaledPadding * 2);

			for (var i:int = 0; i < this._resultCells.length; i++)
			{
				this._resultCells[i].width = this.actualWidth;
			}
			this._cellContainer.layout = new VerticalLayout();
			this._cellContainer.validate();
		}

		private function messageSelectedHandler(e:FeathersScreenEvent):void
		{
			var guid:String = String(e.evtData.guid);
			var screenNavProperties:Object = {messageData:getMessageXMLByGuid(guid)};
			if(this.owner.hasScreen(HivivaScreens.PATIENT_MESSAGE_DETAIL_SCREEN))
			{
				this.owner.removeScreen(HivivaScreens.PATIENT_MESSAGE_DETAIL_SCREEN);
			}
			this.owner.addScreen(HivivaScreens.PATIENT_MESSAGE_DETAIL_SCREEN, new ScreenNavigatorItem(HivivaPatientMessageDetail, null, screenNavProperties));
			this.owner.showScreen(HivivaScreens.PATIENT_MESSAGE_DETAIL_SCREEN);
		}

		private function deleteHandler(e:Event):void
		{
			for (var i:int = 0; i < this._resultCells.length; i++)
			{
				if(this._resultCells[i].check.isSelected)
				{
					this._cellContainer.removeChild(this._resultCells[i], true);
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.DELETE_USER_MESSAGE_COMPLETE, deleteUserMessageHandler);
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.deleteUserMessage(this._resultCells[i].guid);
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
