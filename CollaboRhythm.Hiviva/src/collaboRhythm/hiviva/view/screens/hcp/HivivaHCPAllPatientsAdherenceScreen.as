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

		//	this._usableHeight = this.actualHeight - footerHeight;
		//	trace("usable height " + _usableHeight + " footer height " + _footerHeight)		//	this._chart.scaleX = this._bg.scaleX;
		//	this._chart.scaleY = this._bg.scaleY;
//			this._chart.x = (this.actualWidth * 0.5) - (this._chart.width * 0.5);
//			this._chart.y = this._header.height;

		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Adherence: patients";
			this.addChild(this._header);
			/*
			this._chart = new Image(Assets.getTexture("HCPAdherenceChart"));
			addChild(this._chart);
			*/
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
/*

			var patientAdherenceTable:PatientAdherenceTable = new PatientAdherenceTable();
			patientAdherenceTable.scale = this.dpiScale;
			patientAdherenceTable.patientData = _patientData;
			addChild(patientAdherenceTable);
			patientAdherenceTable.y = this._reportAndMessage.y + this._reportAndMessage.height + (this.actualHeight * 0.02);
			patientAdherenceTable.width = this.actualWidth;
			patientAdherenceTable.height = this.actualHeight - patientAdherenceTable.y;
			patientAdherenceTable.validate();
			patientAdherenceTable.drawTable();

			this._usableHeight = this.actualHeight - this._header.height - Main.footerBtnGroupHeight;
			var leftAxisSpace:Number = this.actualWidth * 0.2;
			//var leftPadding:Number = this.actualWidth * 0;
			var rightPadding:Number = this.actualWidth * 0.05;
			var vPadding:Number = this.actualHeight * 0.02;
			var chartWidth:Number = this.actualWidth - leftAxisSpace - rightPadding;
			var chartHeight:Number = this._usableHeight * 0.75;
			var chartStartX:Number = leftAxisSpace;
			var chartStartY:Number = vPadding + this._header.height;
			var weekTotal:int = 5;
			var chartHorizontalSegmentWidth:Number = chartWidth / (weekTotal - 1);

			var patientNumberLabel:Label = new Label();
			patientNumberLabel.name = "centered-label";
			patientNumberLabel.text = "<font face='ExoBold'>" + _filterdPatients.length + " patient" + ((_filterdPatients.length > 1) ? "s" : "") + "</font>";
			addChild(patientNumberLabel);
			patientNumberLabel.x = chartStartX;
			patientNumberLabel.y = chartStartY;
			patientNumberLabel.width = chartWidth;
			patientNumberLabel.validate();
			chartStartY += patientNumberLabel.height;

			var leftAxisTop:Label = new Label();
			leftAxisTop.name = "centered-label";
			leftAxisTop.text = "<font face='ExoBold'>100%</font>";
			addChild(leftAxisTop);
			leftAxisTop.width = leftAxisSpace;
			leftAxisTop.validate();
//			leftAxisTop.x = leftPadding;
			leftAxisTop.y = chartStartY - (leftAxisTop.height * 0.5);

			var leftAxisLabel:Label = new Label();
			leftAxisLabel.name = "centered-label";
			leftAxisLabel.text = "<font face='ExoBold'>Adherence</font>";
			addChild(leftAxisLabel);
			leftAxisLabel.width = 400;
			leftAxisLabel.validate();
			leftAxisLabel.rotation = deg2rad(-90);
			leftAxisLabel.x = leftAxisTop.x + (leftAxisTop.width * 0.5) - (leftAxisLabel.height * 0.5);
			leftAxisLabel.y = chartStartY + (chartHeight * 0.5) + (leftAxisLabel.width * 0.5);

			var chartBg:Quad = new Quad(chartWidth,chartHeight,0x4c5f76);
			chartBg.alpha = 0.25;
			chartBg.blendMode = BlendMode.MULTIPLY;
			addChild(chartBg);
			chartBg.x = chartStartX;
			chartBg.y = chartStartY;

			var vertLineTexture:Texture = Assets.getTexture("VerticleLinePng");
			var verticalLine:Image;
			var bottomAxisValue:Label;
			var evenLighter:Quad;
			var xAxisPosition:Number;
			for (var weekCount:int = 0; weekCount < weekTotal; weekCount++)
			{
				xAxisPosition = chartHorizontalSegmentWidth * weekCount;

				bottomAxisValue = new Label();
				bottomAxisValue.name = "patient-data-lighter";
				bottomAxisValue.text = "55/55";
				addChild(bottomAxisValue);
				bottomAxisValue.validate();
				bottomAxisValue.x = chartStartX + xAxisPosition;
				if(weekCount == (weekTotal - 1))
				{
					bottomAxisValue.x -= bottomAxisValue.width;
				}
				else if(weekCount > 0)
				{
					bottomAxisValue.x -= bottomAxisValue.width * 0.5;
				}
				bottomAxisValue.y = chartStartY + chartHeight;

				verticalLine = new Image(vertLineTexture);
				addChild(verticalLine);
				verticalLine.x = chartStartX + xAxisPosition;
				verticalLine.y = chartStartY;
				verticalLine.height = chartHeight;

				if((weekCount / 2).toString().indexOf('.') > -1 && weekCount < (weekTotal - 1))
				{
					evenLighter = new Quad(chartHorizontalSegmentWidth, chartHeight, 0xffffff);
					evenLighter.alpha = 0.2;
					addChild(evenLighter);
					evenLighter.x = chartStartX + xAxisPosition;
					evenLighter.y = chartStartY;
				}
			}

			var bottomAxisLabel:Label = new Label();
			bottomAxisLabel.name = "centered-label";
			bottomAxisLabel.text = "<font face='ExoBold'>Week commencing (2013)</font>";
			addChild(bottomAxisLabel);
			bottomAxisLabel.x = chartStartX;
			bottomAxisLabel.y = bottomAxisValue.y + bottomAxisValue.height;
			bottomAxisLabel.width = chartWidth;
			bottomAxisLabel.validate();

			var bottomAxisGrad:Quad = new Quad(chartWidth, bottomAxisValue.height + bottomAxisLabel.height);
			bottomAxisGrad.setVertexColor(0, 0xFFFFFF);
			bottomAxisGrad.setVertexColor(1, 0xFFFFFF);
			bottomAxisGrad.setVertexColor(2, 0x293d54);
			bottomAxisGrad.setVertexColor(3, 0x293d54);
			bottomAxisGrad.alpha = 0.2;
			addChild(bottomAxisGrad);
			bottomAxisGrad.x = chartStartX;
			bottomAxisGrad.y = chartStartY + chartHeight;
			*/
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
