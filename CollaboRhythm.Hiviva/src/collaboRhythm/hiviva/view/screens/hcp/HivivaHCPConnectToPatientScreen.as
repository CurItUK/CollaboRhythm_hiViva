package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.view.*;



	import feathers.controls.Screen;

	import mx.core.ByteArrayAsset;


	public class HivivaHCPConnectToPatientScreen extends Screen
	{
		[Embed("/resources/dummy_patientlist.xml", mimeType="application/octet-stream")]
		private static const PatientData:Class;

		private var _header:HivivaHeader;
		private var _patientDataXml:XML;

		public function HivivaHCPConnectToPatientScreen()
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

			getXMLPatientData();
			
			this._header = new HivivaHeader();
			this._header.title = "Template";
			this.addChild(this._header);

		}

		private function getXMLPatientData():void
		{
			var ba:ByteArrayAsset = ByteArrayAsset(new PatientData());
			this._patientDataXml = new XML(ba.readUTFBytes(ba.length));
		}

	}
}
