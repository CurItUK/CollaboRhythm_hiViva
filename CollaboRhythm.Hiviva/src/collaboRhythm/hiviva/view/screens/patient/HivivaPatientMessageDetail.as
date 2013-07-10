package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.screens.MessageInboxResultCell;

	import feathers.controls.Button;

	import feathers.controls.Label;


	import feathers.controls.Screen;
	import feathers.events.FeathersEventType;

	import starling.display.DisplayObject;
	import starling.events.Event;


	public class HivivaPatientMessageDetail extends Screen
	{
		private var _header:HivivaHeader;
		private var _backButton:Button;

		private var _messageName:String;
		private var _messageDate:String;
		private var _messageText:String;
		private var _messageType:String;

		private var _nameLabel:Label;
		private var _dateLabel:Label;
		private var _messageLabel:Label;
		private var _options:BoxedButtons;
		private var _vPadding:Number;
		private var _hPadding:Number;

		public function HivivaPatientMessageDetail()
		{

		}

		override protected function draw():void
		{
			this._vPadding = Constants.PADDING_TOP;
			this._hPadding = Constants.PADDING_LEFT;

			super.draw();
			this._header.width = Constants.STAGE_WIDTH;
			this._header.initTrueTitle();

			this._nameLabel.width = Constants.STAGE_WIDTH - (this._hPadding * 2);
			this._nameLabel.x = this._hPadding;
			this._nameLabel.y = this._header.height + this._vPadding;
			this._nameLabel.validate();

			this._dateLabel.validate();
			this._dateLabel.x = this._nameLabel.x + this._nameLabel.width - this._dateLabel.width;
			this._dateLabel.y = this._nameLabel.y + (this._nameLabel.height * 0.5) - (this._dateLabel.height * 0.5);

			this._messageLabel.width = Constants.STAGE_WIDTH - (this._hPadding * 2);
			this._messageLabel.x = this._hPadding;
			this._messageLabel.y = this._nameLabel.y + this._nameLabel.height + this._vPadding;
			
			this._options.width = Constants.STAGE_WIDTH - (this._hPadding * 2);
			this._options.validate();
			this._options.x = Constants.PADDING_LEFT;
			this._options.y = Constants.STAGE_HEIGHT - Constants.PADDING_BOTTOM - this._options.height;
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Message detail";
			this.addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._nameLabel = new Label();
			this._nameLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;
//			this._nameLabel.text = _messageData[0].Name;
			this._nameLabel.text = _messageName;
			this.addChild(this._nameLabel);

			this._dateLabel = new Label();
			this._dateLabel.name = HivivaThemeConstants.MESSAGE_DATE_LABEL;
//			this._dateLabel.text = _messageData[0].SentDate;
			this._dateLabel.text = _messageDate;
			this.addChild(this._dateLabel);

			this._messageLabel = new Label();
//			this._messageLabel.text = _messageData[0].Message;
			this._messageLabel.text = _messageText;
			this.addChild(this._messageLabel);

			var optionButtons:Array;
			switch(_messageType)
			{
				case MessageInboxResultCell.COMPOSED_MESSAGE_TYPE :
					optionButtons = ["Delete"];
					break;
				case MessageInboxResultCell.CONNECTION_REQUEST_TYPE :
					optionButtons = ["Ignore","Accept"];
					break;
				case MessageInboxResultCell.STATUS_ALERT_TYPE :
					optionButtons = ["Go to Patient","Edit Alerts"];
					break;
			}

			this._options = new BoxedButtons();
			this._options.labels = optionButtons;
			this._options.addEventListener(starling.events.Event.TRIGGERED, cancelAndSaveHandler);
			addChild(this._options);
		}
		private function cancelAndSaveHandler(e:starling.events.Event):void
		{
			var button:String = e.data.button;

			trace(button);
			switch(button)
			{
				case "Delete" :
					var evt:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.MESSAGE_DELETE);
					dispatchEvent(evt);
					break;
				case "Ignore" :
					break;
				case "Accept" :
					break;
				case "Go to Patient" :
					break;
				case "Edit Alerts" :
					break;
			}
		}

		private function backBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_MESSAGES_SCREEN);
		}
		/*
		public function get messageData():XML
		{
			return _messageData;
		}

		public function set messageData(value:XML):void
		{
			_messageData = value;
		}
		*/
		public function get messageName():String
		{
			return _messageName;
		}

		public function set messageName(value:String):void
		{
			_messageName = value;
		}

		public function get messageDate():String
		{
			return _messageDate;
		}

		public function set messageDate(value:String):void
		{
			_messageDate = value;
		}

		public function get messageText():String
		{
			return _messageText;
		}

		public function set messageText(value:String):void
		{
			_messageText = value;
		}

		public function get messageType():String
		{
			return _messageType;
		}

		public function set messageType(value:String):void
		{
			_messageType = value;
		}
	}
}
