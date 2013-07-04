package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Button;

	import feathers.controls.Label;


	import feathers.controls.Screen;

	import starling.display.DisplayObject;
	import starling.events.Event;


	public class HivivaPatientMessageDetail extends Screen
	{
		private var _header:HivivaHeader;
		private var _backButton:Button;
		private var _messageData:XML;
		/*<MessageGuid>d656a765-5c34-404f-a582-9c51bdd4c1e3</MessageGuid>
		<SentDate>2013-07-04T16:00:50.587</SentDate>
		<UserGuid>b5f2d31c-7c4a-4266-87b7-2527c4811dfb</UserGuid>
		<Name>no email</Name>
		<Message>Let's schedule an office visit</Message>
		<read>false</read>*/

		private var _nameLabel:Label;
		private var _dateLabel:Label;
		private var _messageLabel:Label;
		private var _vPadding:Number;
		private var _hPadding:Number;

		public function HivivaPatientMessageDetail()
		{

		}

		override protected function draw():void
		{
			this._vPadding = (this.actualHeight * 0.04) * this.dpiScale;
			this._hPadding = (this.actualWidth * 0.04) * this.dpiScale;

			super.draw();
			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			this._nameLabel.width = this.actualWidth - (this._hPadding * 2);
			this._nameLabel.x = this._hPadding;
			this._nameLabel.y = this._header.height + this._vPadding;
			this._nameLabel.validate();

			this._dateLabel.validate();
			this._dateLabel.x = this._nameLabel.x + this._nameLabel.width - this._dateLabel.width;
			this._dateLabel.y = this._nameLabel.y + (this._nameLabel.height * 0.5) - (this._dateLabel.height * 0.5);

			this._messageLabel.width = this.actualWidth - (this._hPadding * 2);
			this._messageLabel.x = this._hPadding;
			this._messageLabel.y = this._nameLabel.y + this._nameLabel.height + this._vPadding;
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
			this._nameLabel.text = _messageData[0].Name;
			this.addChild(this._nameLabel);

			this._dateLabel = new Label();
			this._dateLabel.name = HivivaThemeConstants.MESSAGE_DATE_LABEL;
			this._dateLabel.text = _messageData[0].SentDate;
			this.addChild(this._dateLabel);

			this._messageLabel = new Label();
			this._messageLabel.text = _messageData[0].Message;
			this.addChild(this._messageLabel);
		}

		private function backBtnHandler(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_MESSAGES_SCREEN);
		}

		public function get messageData():XML
		{
			return _messageData;
		}

		public function set messageData(value:XML):void
		{
			_messageData = value;
		}
	}
}
