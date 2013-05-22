package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.view.*;



	import feathers.controls.Screen;


	public class HivivaHCPMessageDetail extends Screen
	{
		private var _header:HivivaHeader;

		public function HivivaHCPMessageDetail()
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
			this._header.title = "Message detail";
			this.addChild(this._header);

		}

	}
}