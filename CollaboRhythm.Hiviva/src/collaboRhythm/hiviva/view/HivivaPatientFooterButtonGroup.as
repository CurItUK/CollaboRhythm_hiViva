package collaboRhythm.hiviva.view
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;

	import starling.display.Image;

	public class HivivaPatientFooterButtonGroup extends ButtonGroup
	{
		private var FEATHERS_CLASS:String = "home-footer-buttons";

		public function HivivaPatientFooterButtonGroup(buttonWidth:Number, buttonHeight:Number)
		{
			super();
			customButtonName = FEATHERS_CLASS;
			customFirstButtonName = FEATHERS_CLASS;
			customLastButtonName = FEATHERS_CLASS;

			dataProvider = new ListCollection(
				[
					{ width: buttonWidth, height: buttonHeight, name: "home", triggered: footerBtnHandler },
					{ width: buttonWidth, height: buttonHeight, name: "clock", triggered: footerBtnHandler },
					{ width: buttonWidth, height: buttonHeight, name: "takemeds", triggered: footerBtnHandler },
					{ width: buttonWidth, height: buttonHeight, name: "virus", triggered: footerBtnHandler },
					{ width: buttonWidth, height: buttonHeight, name: "report", triggered: footerBtnHandler }
				]
			);

			buttonInitializer = buttonInit;
		}

		override protected function draw():void
		{

		}

		override protected function initialize():void
		{

		}

		private function buttonInit(button:Button, item:Object):void
		{
			var img:Image;

			button.name = item.name;
			button.addEventListener(Event.TRIGGERED, item.triggered);

			switch(item.name)
			{
				case "home" :
					img = new Image(Assets.getTexture("FooterIconHomePng"));
					button.isSelected = true;
					break;
				case "clock" :
					img = new Image(Assets.getTexture("FooterIconClockPng"));
					break;
				case "takemeds" :
					img = new Image(Assets.getTexture("FooterIconMedicPng"));
					break;
				case "virus" :
					img = new Image(Assets.getTexture("FooterIconVirusPng"));
					break;
				case "report" :
					img = new Image(Assets.getTexture("FooterIconReportPng"));
					break;
			}
			img.width = item.width;
			img.height = item.height;
			button.addChild(img);
		}
	}
}
