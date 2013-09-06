package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.HivivaHeader;

	import feathers.controls.Button;
	import feathers.controls.Screen;

	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaResourceScreen extends Screen
	{
		private const LINKS:Array = ["http://www.google.com/","http://www.pharmiwebsolutions.com/"];

		private var _header:HivivaHeader;
		private var _btn1:Button;
		private var _btn2:Button;

		public function HivivaResourceScreen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._header.paddingLeft = Constants.HEADER_HOMEBTN_PADDING;
			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			this._btn1.y = Constants.HEADER_HEIGHT;
			this._btn1.validate();

			this._btn2.y = this._btn1.y + this._btn1.height + 10;
			this._btn2.validate();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Resources";
			this.addChild(this._header);

			var homeBtn:Button = new Button();
			homeBtn.name = HivivaThemeConstants.HOME_BUTTON;
			homeBtn.addEventListener(Event.TRIGGERED, homeBtnHandler);
			this._header.leftItems = new <DisplayObject>[homeBtn];


			_btn1 = new Button();
			_btn1.addEventListener(Event.TRIGGERED, launchLink1);
			_btn1.label = "link 1";
			addChild(_btn1);

			_btn2 = new Button();
			_btn2.addEventListener(Event.TRIGGERED, launchLink2);
			_btn2.label = "link 2";
			addChild(_btn2);
		}

		private function launchLink1(e:Event):void
		{
			navigateToURL(new URLRequest(LINKS[0]));
		}

		private function launchLink2(e:Event):void
		{
			navigateToURL(new URLRequest(LINKS[1]));
		}

		private function homeBtnHandler(e:Event):void
		{
			this.dispatchEventWith("navGoHome");
		}
	}
}
