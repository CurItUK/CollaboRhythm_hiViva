package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.HivivaHeader;

	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.data.ListCollection;

	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaResourceScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _btnGroup:ButtonGroup;

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

			this._btnGroup.width = Constants.STAGE_WIDTH;
			_btnGroup.validate();
			_btnGroup.y = (Constants.STAGE_HEIGHT / 2) - (_btnGroup.height / 2);
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

			_btnGroup = new ButtonGroup();
			_btnGroup.customFirstButtonName = HivivaThemeConstants.SPLASH_FOOTER_BUTTON;
			_btnGroup.customButtonName = HivivaThemeConstants.SPLASH_FOOTER_BUTTON;
			_btnGroup.customLastButtonName = HivivaThemeConstants.SPLASH_FOOTER_BUTTON;
			_btnGroup.dataProvider = new ListCollection(
				[
					{ label: "http://www.aids.gov/hiv-aids-basics   ", triggered: launchLink},
					{ label: "http://www.thebody.com   ", triggered: launchLink},
					{ label: "http://www.cdc.gov/hiv/   ", triggered: launchLink},
					{ label: "http://m.aidsinfo.nih.gov/   ", triggered: launchLink}
				]
			);
			addChild(_btnGroup);
			this._btnGroup.direction = ButtonGroup.DIRECTION_VERTICAL;
		}

		private function launchLink(e:Event):void
		{
			navigateToURL(new URLRequest(Button(e.target).label));
		}

		private function homeBtnHandler(e:Event):void
		{
			this.dispatchEventWith("navGoHome");
		}
	}
}
