package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.screens.MessageInboxResultCell;

	import feathers.controls.Button;


	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;

	import flash.events.Event;

	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaHCPMessageInbox extends Screen
	{
		private var _footerHeight:Number;
		private var _applicationController:HivivaApplicationController;
		private var _header:HivivaHeader;
		private var _messagesData:XML;
		private var _messageCellContainer:ScrollContainer;
		private var _composeBtn:Button;
		private var _sentBtn:Button;
		private var _deleteBtn:Button;

		private var _scaledPadding:Number;

		private const PADDING:Number = 20;

		public function HivivaHCPMessageInbox()
		{

		}

		override protected function draw():void
		{
			this._scaledPadding = (this.actualHeight * 0.04) * this.dpiScale;
			super.draw();

			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			this._deleteBtn.validate();
			this._deleteBtn.x = (this.actualWidth * 0.5) - (this._deleteBtn.width * 0.5);
			this._deleteBtn.y = this.actualHeight - _header.height - _footerHeight -
								this._deleteBtn.height - _scaledPadding;

			initHCPMessagesXMLData();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Messages";
			this.addChild(this._header);

			this._deleteBtn = new Button();
			this._deleteBtn.label = "Delete";
			this._deleteBtn.addEventListener(starling.events.Event.TRIGGERED , deleteBtnHandler);
			this.addChild(this._header);

			this._composeBtn = new Button();
			this._composeBtn.label = "Compose";
			this._composeBtn.addEventListener(starling.events.Event.TRIGGERED , composeBtnHandler);

			this._sentBtn = new Button();
			this._sentBtn.label = "Sent";
			this._sentBtn.addEventListener(starling.events.Event.TRIGGERED , sentBtnHandler);

			this._header.rightItems = new <DisplayObject>[this._composeBtn, this._sentBtn];

			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.SHOW_MAIN_NAV,true));
		}

		private function initHCPMessagesXMLData():void
		{
			var patientToLoadURL:String = "/resources/dummy_hcpmessages.xml";
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE, messagesXMLFileLoadHandler);
			loader.load(new URLRequest(patientToLoadURL));
		}

		private function messagesXMLFileLoadHandler(e:flash.events.Event):void
		{
			_messagesData = XML(e.target.data);
			drawXMLResults();
		}

		private function drawXMLResults():void
		{
			var messagesXMLList:XMLList = _messagesData.message;
			if(messagesXMLList.length() > 0)
			{
				this._messageCellContainer = new ScrollContainer();

				var listCount:uint = messagesXMLList.length();
				for(var i:uint = 0 ; i < listCount ; i++)
				{
					var messageInboxResultCell:MessageInboxResultCell = new MessageInboxResultCell();
					messageInboxResultCell.primaryText = messagesXMLList[i].body;
					messageInboxResultCell.dateText = messagesXMLList[i].date;
					messageInboxResultCell.scale = this.dpiScale;
					messageInboxResultCell.addEventListener(FeathersScreenEvent.HCP_MESSAGE_SELECTED, messageSelectedHandler);
					this._messageCellContainer.addChild(messageInboxResultCell);
				}
				this.addChild(this._messageCellContainer);

			}
			drawResults();
		}

		private function drawResults():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var yStartPosition:Number;
			var maxHeight:Number;
			var messageCell:MessageInboxResultCell;

			yStartPosition = this._header.height;
			maxHeight = this.actualHeight - yStartPosition - footerHeight - 2 * (PADDING * this.dpiScale) - this._composeBtn.height;

			this._messageCellContainer.width = this.actualWidth;
			this._messageCellContainer.y = yStartPosition;
			this._messageCellContainer.height = maxHeight;

			for (var i:int = 0; i < this._messageCellContainer.numChildren; i++)
			{
				messageCell = this._messageCellContainer.getChildAt(i) as MessageInboxResultCell;
				messageCell.width = this.actualWidth;
			}

			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = scaledPadding;
			this._messageCellContainer.layout = layout;
			this._messageCellContainer.validate();
		}

		private function composeBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_MESSAGE_COMPOSE_SCREEN);

		}

		private function sentBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_MESSAGE_SENT_SCREEN);

		}

		private function deleteBtnHandler(e:starling.events.Event):void
		{
			// delete selected messages
		}

		private function messageSelectedHandler(e:FeathersScreenEvent):void
		{
			var messageInboxResultCell:MessageInboxResultCell = e.target as MessageInboxResultCell;
			var evtData:Object = {};
			evtData.primaryText = messageInboxResultCell.primaryText;
			evtData.secondaryText = messageInboxResultCell.secondaryText;
			evtData.dateText = messageInboxResultCell.dateText;
			dispatchEventWith("messageNavGoDetails", false, evtData);
		}

		public function get localStoreController():HivivaLocalStoreController
		{
			return applicationController.hivivaLocalStoreController;
		}

		public function get applicationController():HivivaApplicationController
		{
			return _applicationController;
		}

		public function set applicationController(value:HivivaApplicationController):void
		{
			_applicationController = value;
		}

		public function get footerHeight():Number
		{
			return _footerHeight;
		}

		public function set footerHeight(value:Number):void
		{
			_footerHeight = value;
		}


	}
}
