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

	import starling.events.Event;


	public class HivivaHCPMessagesInbox extends Screen
	{
		private var _header:HivivaHeader;
		private var _messagesData:XML;
		private var _messageCellContainer:ScrollContainer;
		private var _footerHeight:Number;
		private var _applicationController:HivivaApplicationController;
		private var _composeMessage:Button;


		private const PADDING:Number = 20;

		public function HivivaHCPMessagesInbox()
		{

		}

		override protected function draw():void
		{
			super.draw();
			var scaledPadding:Number = PADDING * this.dpiScale;

			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._composeMessage.validate();
			this._composeMessage.x = 10;
			this._composeMessage.y = this.actualHeight - this._composeMessage.height - scaledPadding - footerHeight;

			initHCPMessagesXMLData();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Messages";
			this.addChild(this._header);

			this._composeMessage = new Button();
			this._composeMessage.label = "Compose message";
			this._composeMessage.addEventListener(starling.events.Event.TRIGGERED , composeMessageBtnHandler);
			this.addChild(this._composeMessage);
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
			maxHeight = this.actualHeight - yStartPosition - footerHeight - 2 * (PADDING * this.dpiScale) - this._composeMessage.height;

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

		private function composeMessageBtnHandler():void
		{
			this.dispatchEventWith("mainToSubNav" , false , {profileMenu:HivivaScreens.HCP_COMPOSE_MESSAGE});

		}

		private function messageSelectedHandler(e:FeathersScreenEvent):void
		{

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
