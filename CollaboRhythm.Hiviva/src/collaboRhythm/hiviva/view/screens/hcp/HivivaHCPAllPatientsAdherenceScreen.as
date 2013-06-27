package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.PatientAdherenceChart;

	import feathers.controls.Label;


	import feathers.controls.Screen;

	import flash.events.Event;

	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import starling.display.BlendMode;

	import starling.display.Image;
	import collaboRhythm.hiviva.view.media.Assets;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;

	import starling.display.Quad;

	import starling.textures.Texture;
	import starling.utils.deg2rad;


	public class HivivaHCPAllPatientsAdherenceScreen extends Screen
	{
		private var _header:HivivaHeader;
//		private var _chart:Image;
		private var _usableHeight:Number;
		private var _headerHeight:Number;
		private var _footerHeight:Number;
		private var _applicationController:HivivaAppController;
		private var _patientsData:XML;
		private var _patients:Array;
		private var _filterdPatients:Array;

		public function HivivaHCPAllPatientsAdherenceScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.initTrueTitle();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Adherence: patients";
			this.addChild(this._header);

			getHcpConnections();
		}

		private function getHcpConnections():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController..addEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE, getHcpListCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.getHCPConnections();
		}

		private function getHcpListCompleteHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE, getHcpListCompleteHandler);
			if (e.data.connections != null)
			{
				this._patients = e.data.connections;
				initPatientXMLData();
			}
		}

		private function initPatientXMLData():void
		{
			var patientToLoadURL:String = "/resources/dummy_patientlist.xml";
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE, patientXMLFileLoadHandler);
			loader.load(new URLRequest(patientToLoadURL));
		}

		private function patientXMLFileLoadHandler(e:flash.events.Event):void
		{
			_patientsData = XML(e.target.data);
			setPatientProfiles();
			drawAdherenceChart();
		}

		private function setPatientProfiles():void
		{
			//TODO add better xml search for patients by appid.
			var patientsXMLList:XMLList = patientsData.patient;
			_filterdPatients = [];

			var patientsLength:uint = patientsXMLList.length();
			var innerLoop:uint = patients.length;
			for (var i:uint = 0; i < patientsLength; i++)
			{
				for (var j:uint = 0; j < innerLoop; j++)
				{
					if (patientsXMLList[i].appid == patients[j].appid)
					{
						_filterdPatients.push(patientsXMLList[i]);
					}
				}
			}
		}

		private function drawAdherenceChart():void
		{
			var patientAdherenceChart:PatientAdherenceChart = new PatientAdherenceChart();
			patientAdherenceChart.filterdPatients = _filterdPatients;
			addChild(patientAdherenceChart);
			patientAdherenceChart.y = this._header.height;
			patientAdherenceChart.width = this.actualWidth;
			patientAdherenceChart.height = this.actualHeight - this._header.height - Main.footerBtnGroupHeight;
			patientAdherenceChart.validate();
			patientAdherenceChart.drawChart();
		}

		public function get footerHeight():Number
		{
			return _footerHeight;
		}

		public function set footerHeight(value:Number):void
		{
			_footerHeight = value;
		}

		public function get headerHeight():Number
		{
			return _headerHeight;
		}

		public function set headerHeight(value:Number):void
		{
			_headerHeight = value;
		}

		public function set patientsData(value:XML):void
		{
			this._patientsData = value;
		}

		public function get patientsData():XML
		{
			return this._patientsData;
		}

		public function set patients(value:Array):void
		{
			this._patients = value;
		}

		public function get patients():Array
		{
			return this._patients;
		}

	}
}
