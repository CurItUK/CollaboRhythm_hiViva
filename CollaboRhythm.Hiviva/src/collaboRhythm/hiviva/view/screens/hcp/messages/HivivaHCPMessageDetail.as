package collaboRhythm.hiviva.view.screens.hcp.messages
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Button;


	import feathers.controls.Screen;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaHCPMessageDetail extends Screen
	{
		private var _applicationController:HivivaAppController;
		private var _messageData:Object;
		private var _header:HivivaHeader;
		private var _backButton:Button;

		private var _scaledPadding:Number;

		public function HivivaHCPMessageDetail()
		{

		}

		override protected function draw():void
		{
			this._scaledPadding = (this.actualHeight * 0.04) * this.dpiScale;
			super.draw();

			this._header.paddingLeft = this._scaledPadding;
			this._header.width = this.actualWidth;
			this._header.initTrueTitle();
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
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV,true));
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_MESSAGE_INBOX_SCREEN)
		}

		public function get localStoreController():HivivaLocalStoreController
		{
			return applicationController.hivivaLocalStoreController;
		}

		public function get applicationController():HivivaAppController
		{
			return _applicationController;
		}

		public function set applicationController(value:HivivaAppController):void
		{
			_applicationController = value;
		}

		public function get messageData():Object
		{
			return _messageData;
		}

		public function set messageData(value:Object):void
		{
			_messageData = value;
		}
	}
}
