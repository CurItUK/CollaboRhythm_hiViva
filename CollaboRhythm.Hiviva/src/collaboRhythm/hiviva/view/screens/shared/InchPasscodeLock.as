package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.view.HivivaHeader;

	import feathers.controls.Screen;

	public class InchPasscodeLock extends Screen
	{
		private var _header:HivivaHeader;


		public function InchPasscodeLock()
		{

		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Passcode lock";
			addChild(this._header);
		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = Constants.STAGE_WIDTH;
			this._header.paddingLeft = Constants.HEADER_HOMEBTN_PADDING;
			this._header.initTrueTitle();
		}
	}
}
