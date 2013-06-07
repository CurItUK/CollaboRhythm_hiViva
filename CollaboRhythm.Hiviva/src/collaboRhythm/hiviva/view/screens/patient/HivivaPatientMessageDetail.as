package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.view.*;



	import feathers.controls.Screen;


	public class HivivaPatientMessageDetail extends Screen
	{
		private var _header:HivivaHeader;

		public function HivivaPatientMessageDetail()
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
