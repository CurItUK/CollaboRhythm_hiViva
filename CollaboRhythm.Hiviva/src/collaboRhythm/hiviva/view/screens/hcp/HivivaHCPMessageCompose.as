package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Button;


	import feathers.controls.Screen;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaHCPMessageCompose extends Screen
	{
		private var _header:HivivaHeader;
		private var _applicationController:HivivaApplicationController;
		private var _backButton:Button;

		public function HivivaHCPMessageCompose()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;
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
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

		}

		private function backBtnHandler(e:starling.events.Event):void
		{
			this.dispatchEventWith("navGoHome");
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
