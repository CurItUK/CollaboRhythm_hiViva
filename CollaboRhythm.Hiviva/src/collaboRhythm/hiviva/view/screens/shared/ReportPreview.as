package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.components.ReportChart;

	import feathers.controls.Button;

	import flash.events.Event;

	import starling.display.DisplayObject;

	import starling.events.Event;

	public class ReportPreview extends BaseScreen
	{
		private var _backButton:Button;
		private var _adherenceIsChecked:Boolean = false;
		private var _feelingIsChecked:Boolean = false;
		private var _cd4IsChecked:Boolean = false;
		private var _viralLoadIsChecked:Boolean = false;
		private var _startDate:Date;
		private var _endDate:Date;
		private var _patientGuid:String;
		private var _filteredMedicationHistory:XMLList;
		private var _filteredTestResults:XMLList;
		private var _adherenceReportChart:ReportChart;
		private var _tolerabilityReportChart:ReportChart;

		public function ReportPreview()
		{
			super();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Report preview";

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			if(this._adherenceIsChecked || this._feelingIsChecked)
			{
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_DAILY_MEDICATION_HISTORY_COMPLETE, getDailyMedicationHistoryCompleteHandler);
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getDailyMedicationHistory(this._patientGuid);
			}

			if(this._cd4IsChecked || this._viralLoadIsChecked)
			{
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_ALL_RESULTS_COMPLETE, getPatientAllTestResultsCompleteHandler);
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatientAllTestResults(this._patientGuid);
			}
		}

		private function backBtnHandler(e:starling.events.Event):void
		{

		}

		private function getDailyMedicationHistoryCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_DAILY_MEDICATION_HISTORY_COMPLETE, getDailyMedicationHistoryCompleteHandler);

			this._filteredMedicationHistory = e.data.xmlResponse.DCUserMedication;
			if(this._filteredMedicationHistory.length() > 0)
			{
				prepareSelectedMedicalData();
			}
			else
			{
				trace("Medical history data requested but this patient has no medical history");
			}
		}

		private function getPatientAllTestResultsCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_ALL_RESULTS_COMPLETE, getPatientAllTestResultsCompleteHandler);

			this._filteredTestResults = e.data.xmlResponse.DCTestResult;
			if(this._filteredTestResults.length() > 0)
			{
				prepareSelectedTestResultData();
			}
			else
			{
				trace("Test result data requested but this patient has no test result history");
			}
		}

		private function prepareSelectedMedicalData():void
		{
			if(this._adherenceIsChecked)
			{
				this._adherenceReportChart = new ReportChart();
				this._adherenceReportChart.dataCategory = "adherence";
				this._adherenceReportChart.startDate = this._startDate;
				this._adherenceReportChart.endDate = this._endDate;
				this._adherenceReportChart.patientData = this._filteredMedicationHistory;
				// must be added to stage or snapshot will be blank
				addChild(this._adherenceReportChart);
				this._adherenceReportChart.width = this.actualWidth;
				this._adherenceReportChart.height = this.actualHeight;
				this._adherenceReportChart.validate();
				this._adherenceReportChart.drawChart();
			}
			if(this._adherenceIsChecked)
			{
				this._tolerabilityReportChart = new ReportChart();
				this._tolerabilityReportChart.dataCategory = "tolerability";
				this._tolerabilityReportChart.startDate = this._startDate;
				this._tolerabilityReportChart.endDate = this._endDate;
				this._tolerabilityReportChart.patientData = this._filteredMedicationHistory;
				// must be added to stage or snapshot will be blank
				addChild(this._tolerabilityReportChart);
				this._tolerabilityReportChart.width = this.actualWidth;
				this._tolerabilityReportChart.height = this.actualHeight;
				this._tolerabilityReportChart.validate();
				this._tolerabilityReportChart.drawChart();
			}
		}

		private function prepareSelectedTestResultData():void
		{

		}

		public function get adherenceIsChecked():Boolean
		{
			return _adherenceIsChecked;
		}

		public function set adherenceIsChecked(value:Boolean):void
		{
			_adherenceIsChecked = value;
		}

		public function get feelingIsChecked():Boolean
		{
			return _feelingIsChecked;
		}

		public function set feelingIsChecked(value:Boolean):void
		{
			_feelingIsChecked = value;
		}

		public function get cd4IsChecked():Boolean
		{
			return _cd4IsChecked;
		}

		public function set cd4IsChecked(value:Boolean):void
		{
			_cd4IsChecked = value;
		}

		public function get viralLoadIsChecked():Boolean
		{
			return _viralLoadIsChecked;
		}

		public function set viralLoadIsChecked(value:Boolean):void
		{
			_viralLoadIsChecked = value;
		}

		public function get startDate():Date
		{
			return _startDate;
		}

		public function set startDate(value:Date):void
		{
			_startDate = value;
		}

		public function get endDate():Date
		{
			return _endDate;
		}

		public function set endDate(value:Date):void
		{
			_endDate = value;
		}

		public function get patientGuid():String
		{
			return _patientGuid;
		}

		public function set patientGuid(value:String):void
		{
			_patientGuid = value;
		}
	}
}
