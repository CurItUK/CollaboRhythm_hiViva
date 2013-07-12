package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.view.*;



	import feathers.controls.Screen;


	public class HivivaHCPPatientDetailsScreen extends Screen
	{
		private var _header:HivivaHeader;

		public function HivivaHCPPatientDetailsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Patient Details";
			this.addChild(this._header);

		}

	}
}
