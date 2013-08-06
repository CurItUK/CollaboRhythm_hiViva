package collaboRhythm.hiviva.view.screens.hcp
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaHeader;
	import collaboRhythm.hiviva.view.HivivaStartup;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Screen;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaHCPSettingsScreen extends Screen
	{
		private var _instructions:Label;
		private var _submitButton:Button;
		private var _backButton:Button;
		private var _header:HivivaHeader;
		private var _scaledPadding:Number;


		public function HivivaHCPSettingsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._scaledPadding = (this.actualWidth * 0.04) * this.dpiScale;

			this._header.paddingLeft = Constants.HEADER_HOMEBTN_PADDING;
			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			this._instructions.validate();
			this._instructions.y = this._header.height + this._scaledPadding;
			this._instructions.x = this.actualWidth/2 - this._instructions.width/2;


			this._submitButton.validate();
			this._submitButton.x = this.actualWidth/2 - this._submitButton.width/2;
			this._submitButton.y = this._instructions.y + this._instructions.height + this._scaledPadding;
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Application settings";
			this.addChild(this._header);

			this._instructions = new Label();
			this._instructions.text = 	"Tap the button below to restore your user settings\nback to their Defaults.";
			this.addChild(this._instructions);

			this._submitButton = new Button();
			this._submitButton.label = "Reset application";
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			this.addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}

		private function submitButtonClick(e:Event):void
		{
			this._submitButton.removeEventListener(Event.TRIGGERED, submitButtonClick);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.APPLICATION_RESET_COMPLETE, resetApplicationHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.resetApplication();
		}

		private function resetApplicationHandler(e:LocalDataStoreEvent):void{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.APPLICATION_RESET_COMPLETE , resetApplicationHandler);
			this.dispatchEventWith("navFromReset");
		}

		private function backBtnHandler(event:Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_PROFILE_SCREEN);
		}
	}
}
