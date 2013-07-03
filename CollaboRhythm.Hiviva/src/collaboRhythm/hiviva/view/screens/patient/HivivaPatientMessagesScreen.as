package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;

	import collaboRhythm.hiviva.view.screens.MessageInboxResultCell;

	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;

	import mx.core.ByteArrayAsset;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaPatientMessagesScreen extends Screen
	{
		[Embed("/resources/dummy_patientmessages.xml", mimeType="application/octet-stream")]
		private static const HcpMessageData:Class;


		protected var _header:HivivaHeader;
		private var _hcpMessageData:XML;
		private var _deleteMessageButton:Button;
		private var _resultCells:Vector.<MessageInboxResultCell> = new <MessageInboxResultCell>[];
		private var _cellContainer:ScrollContainer;
		private var _viewedIds:Array = [];

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

//			if(this._cellContainer == null) drawXMLResults();
			if(this._cellContainer == null) drawDummyMessage();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Messages";
			this._header.scale = this.dpiScale;
			addChild(this._header);

			getXMLHcpMessageData();

			this._deleteMessageButton = new Button();
			this._deleteMessageButton.label = "Delete";
			this._deleteMessageButton.addEventListener(Event.TRIGGERED, deleteHandler);
			this.addChild(this._deleteMessageButton);

			var homeBtn:Button = new Button();
			homeBtn.name = "home-button";
			homeBtn.addEventListener(Event.TRIGGERED, homeBtnHandler);
			this._header.leftItems = new <DisplayObject>[homeBtn];

			getViewedIds();
		}

		private function homeBtnHandler(e:Event):void
		{
			this.dispatchEventWith("navGoHome");
		}

		private function getViewedIds():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.PATIENT_MESSAGES_VIEWED_LOAD_COMPLETE, loadPatientMessagesViewedHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.loadPatientMessagesViewed();
		}

		private function loadPatientMessagesViewedHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.PATIENT_MESSAGES_VIEWED_LOAD_COMPLETE, loadPatientMessagesViewedHandler);
			var viewedIdsString:String = e.data.viewedIds;

			try
			{
				this._viewedIds = viewedIdsString.split(",");
			}
			catch(e:Error)
			{
				this._viewedIds = [];
			}
		}

		private function getXMLHcpMessageData():void
		{
			var ba:ByteArrayAsset = ByteArrayAsset(new HcpMessageData());
			this._hcpMessageData = new XML(ba.readUTFBytes(ba.length));
		}


		private function drawXMLResults():void
		{
			this._cellContainer = new ScrollContainer();
			var messagesXMLList:XMLList = this._hcpMessageData.message;
			var viewedIdsLength:int = this._viewedIds.length;
			var body:String;
			var hcp:String;
			if(messagesXMLList.length() > 0)
			{
				var listCount:uint = messagesXMLList.length();
				for(var i:uint = 0 ; i < listCount ; i++)
				{
					var messageInboxResultCell:MessageInboxResultCell = new MessageInboxResultCell();
					if (viewedIdsLength > 0)
					{
						for (var j:int = 0; j < viewedIdsLength; j++)
						{
							if(this._viewedIds[0] == messagesXMLList[i].uniqueId)
							{
								body = messagesXMLList[i].body;
								hcp = messagesXMLList[i].hcp;
								break;
							}
							else
							{
								body = "<font face='ExoBold'>" + messagesXMLList[i].body + "</font>";
								hcp = "<font face='ExoBold'>" + messagesXMLList[i].hcp + "</font>";
							}
						}
					}
					else
					{
						body = messagesXMLList[i].body;
						hcp = messagesXMLList[i].hcp;
					}
					messageInboxResultCell.uniqueId = messagesXMLList[i].uniqueId;
					// TODO : add ability to set the 'name' for primary and secondary textfields so we can make them bold if the message is new
					messageInboxResultCell.primaryText = body;
					messageInboxResultCell.secondaryText = hcp;
					messageInboxResultCell.dateText = messagesXMLList[i].date;
					messageInboxResultCell.scale = this.dpiScale;
					messageInboxResultCell.addEventListener(FeathersScreenEvent.HCP_MESSAGE_SELECTED, messageSelectedHandler);
					this._cellContainer.addChild(messageInboxResultCell);
					this._resultCells.push(messageInboxResultCell);
				}
				this.addChild(this._cellContainer);
			}
			drawResults();
		}

		private function drawDummyMessage():void
		{
			this._cellContainer = new ScrollContainer();

			var messageInboxResultCell:MessageInboxResultCell = new MessageInboxResultCell();
			messageInboxResultCell.uniqueId = "1";
			//messageInboxResultCell.primaryText = "<font face='ExoBold'>Great job, Keep it up!</font>";
			messageInboxResultCell.primaryText = "Great job, Keep it up!";
			messageInboxResultCell.secondaryText = "Dr Richard Gould";
			messageInboxResultCell.dateText = "31/05/2013";
			messageInboxResultCell.scale = this.dpiScale;
			messageInboxResultCell.addEventListener(FeathersScreenEvent.HCP_MESSAGE_SELECTED, messageSelectedHandler);
			this._cellContainer.addChild(messageInboxResultCell);
			this._resultCells.push(messageInboxResultCell);
			this.addChild(this._cellContainer);
			drawResults();
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
			trace("launch message detail screen");
			trace("add to viewedids");
		}

		private function deleteHandler(e:Event):void
		{
			for (var i:int = 0; i < this._resultCells.length; i++)
			{
				if(this._resultCells[i].check.isSelected)
				{
					this._cellContainer.removeChild(this._resultCells[i], true);
				}
			}
			this._cellContainer.validate();
		}


	}
}
