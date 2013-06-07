package collaboRhythm.hiviva.view.screens.hcp.messages
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Button;
	import feathers.controls.Label;


	import feathers.controls.Screen;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaHCPMessageCompose extends Screen
	{
		private var _applicationController:HivivaApplicationController;
		private var _header:HivivaHeader;
		private var _backButton:Button;
		private var _patients:Array;

		private var _scaledPadding:Number;

		public function HivivaHCPMessageCompose()
		{

		}

		override protected function draw():void
		{
			this._scaledPadding = (this.actualHeight * 0.04) * this.dpiScale;
			super.draw();

			this._header.width = this.actualWidth;
			this._header.initTrueTitle();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Compose message";
			this.addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV,true));
		}

		private function getHcpConnections():void
		{
			applicationController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE, getHcpListCompleteHandler)
			applicationController.hivivaLocalStoreController.getHCPConnections();
		}

		private function getHcpListCompleteHandler(e:LocalDataStoreEvent):void
		{
			applicationController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE, getHcpListCompleteHandler)
			if (e.data.connections != null)
			{
				this._patients = e.data.connections;
				initPatientSelectList();
			}
			else
			{
				initAlertText();
			}
		}

		private function initPatientSelectList():void
		{


		}

		private function initAlertText():void
		{

			var alertLabel:Label = new Label();
			alertLabel.text = "Connect to a patient to get started.";

			this.addChild(alertLabel);
			alertLabel.validate();
			alertLabel.x = this.actualWidth / 2 - alertLabel.width / 2;
			alertLabel.y = alertLabel.height * 4;
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_MESSAGE_INBOX_SCREEN)
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
	}
}
