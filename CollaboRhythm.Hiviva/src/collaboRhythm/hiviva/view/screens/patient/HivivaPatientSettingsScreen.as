package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.view.*;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;

	import starling.display.DisplayObject;
	import starling.events.Event;


	public class HivivaPatientSettingsScreen extends Screen
	{
		private var _header:HivivaHeader;

		public function HivivaPatientSettingsScreen()
		{
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;
		}

		override protected function initialize():void
		{

			this._header = new HivivaHeader();
			this._header.title = "Settings";
			addChild(this._header);

			var backBtn:Button = new Button();
			backBtn.label = "Back";
			backBtn.addEventListener(Event.TRIGGERED , backBtnHandler);

			this._header.leftItems = new <DisplayObject>[backBtn];

			var resetAppSettingsBtn:Button = new Button();
			resetAppSettingsBtn.label = "Reset Application Settings";
			resetAppSettingsBtn.addEventListener(Event.TRIGGERED , resetAppBtnHandler);
			resetAppSettingsBtn.y = 200;
			this.addChild(resetAppSettingsBtn);

		}

		private function backBtnHandler(e:Event):void
		{
			this.dispatchEventWith("navGoBack");
		}

		private function resetAppBtnHandler(e:Event):void
		{
			this.dispatchEventWith("resetAppSettings");
		}
	}
}
