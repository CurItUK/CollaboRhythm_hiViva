package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.view.*;



	import feathers.controls.Screen;


	public class HivivaHCPMessageCompose extends Screen
	{
		private var _header:HivivaHeader;

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

		}

	}
}
