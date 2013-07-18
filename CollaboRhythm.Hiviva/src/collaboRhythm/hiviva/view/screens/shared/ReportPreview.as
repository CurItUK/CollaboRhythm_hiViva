package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.components.ReportChart;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.layout.VerticalLayout;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class ReportPreview extends BaseScreen
	{
		private var _backButton:Button;
		private var _cancelAndSend:BoxedButtons;
		private var _parentScreen:String;
		private var _adherenceIsChecked:Boolean = false;
		private var _feelingIsChecked:Boolean = false;
		private var _cd4IsChecked:Boolean = false;
		private var _viralLoadIsChecked:Boolean = false;
		private var _startDate:Date;
		private var _endDate:Date;
		private var _patientGuid:String;
		private var _medicationHistoryCallMade:Boolean = false;
		private var _testResultsCallMade:Boolean = false;
		private var _filteredMedicationHistory:XMLList;
		private var _filteredTestResults:XMLList;
		private var _adherenceReportChart:ReportChart;
		private var _tolerabilityReportChart:ReportChart;

		public function ReportPreview()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			applyPreviewLayout();

			if(!this._medicationHistoryCallMade && (this._adherenceIsChecked || this._feelingIsChecked))
			{
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_DAILY_MEDICATION_HISTORY_COMPLETE, getDailyMedicationHistoryCompleteHandler);
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getDailyMedicationHistory(this._patientGuid);
			}

			if(!this._testResultsCallMade && (this._cd4IsChecked || this._viralLoadIsChecked))
			{
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_ALL_RESULTS_COMPLETE, getPatientAllTestResultsCompleteHandler);
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatientAllTestResults(this._patientGuid);
			}
		}

		private function applyPreviewLayout():void
		{
//			this._contentLayout.gap = 0;
			this._content.layout = this._contentLayout;
			this._content.y = Constants.HEADER_HEIGHT + Constants.PADDING_TOP;
			this._content.height = this._cancelAndSend.y - this._content.y - Constants.PADDING_BOTTOM;
		}

		override protected function preValidateContent():void
		{
			this._cancelAndSend.x = Constants.PADDING_LEFT;
			this._cancelAndSend.width = Constants.INNER_WIDTH;
			this._cancelAndSend.validate();
			this._cancelAndSend.y = Constants.STAGE_HEIGHT - Constants.PADDING_BOTTOM - this._cancelAndSend.height;
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

			this._cancelAndSend = new BoxedButtons();
			this._cancelAndSend.labels = ["Cancel","Send"];
			this._cancelAndSend.addEventListener(starling.events.Event.TRIGGERED, cancelAndSendHandler);
			addChild(this._cancelAndSend);

			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV,true));
		}

		private function backBtnHandler(e:starling.events.Event = null):void
		{
			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.SHOW_MAIN_NAV,true));
			this.owner.showScreen(_parentScreen);
		}

		private function cancelAndSendHandler(e:starling.events.Event):void
		{
			var btn:String = e.data.button;
			switch(btn)
			{
				case "Cancel" :
					backBtnHandler();
					break;
				case "Send" :
					// send
					break;
			}
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

			this._medicationHistoryCallMade = true;
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

			this._testResultsCallMade = true;
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
				this._content.addChild(this._adherenceReportChart);
				this._adherenceReportChart.width = Constants.INNER_WIDTH;
				this._adherenceReportChart.height = this._content.height;
				this._adherenceReportChart.validate();
				this._adherenceReportChart.drawChart();
			}
			if(this._feelingIsChecked)
			{
				this._tolerabilityReportChart = new ReportChart();
				this._tolerabilityReportChart.dataCategory = "tolerability";
				this._tolerabilityReportChart.startDate = this._startDate;
				this._tolerabilityReportChart.endDate = this._endDate;
				this._tolerabilityReportChart.patientData = this._filteredMedicationHistory;
				// must be added to stage or snapshot will be blank
				this._content.addChild(this._tolerabilityReportChart);
				this._tolerabilityReportChart.width = Constants.INNER_WIDTH;
				this._tolerabilityReportChart.height = this._content.height;
				this._tolerabilityReportChart.validate();
				this._tolerabilityReportChart.drawChart();
			}
			this._content.validate();
		}

		private function prepareSelectedTestResultData():void
		{
			if(this._cd4IsChecked)
			{
				drawTestTable("Cd4 count");
			}
			if(this._viralLoadIsChecked)
			{
				drawTestTable("Viral load");
			}
		}

		private function drawTestTable(resultType:String):void
		{
			var testDate:Date;
			var result:Number;
			for (var i:int = 0; i < _filteredTestResults.length(); i++)
			{
				if(String(_filteredTestResults[i].TestDescription) == resultType)
				{
					testDate = HivivaModifier.isoDateToFlashDate(_filteredTestResults[i].TestDate);
					result = _filteredTestResults[i].Result;
					trace(testDate.toDateString() + " = " + result);
				}
			}
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

		public function get parentScreen():String
		{
			return _parentScreen;
		}

		public function set parentScreen(value:String):void
		{
			_parentScreen = value;
		}
	}
}
