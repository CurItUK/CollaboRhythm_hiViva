package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.PatientAdherenceChart;

	import feathers.controls.Screen;

	public class HivivaHCPAllPatientsAdherenceScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _scheduleHistoryData:XMLList;
		private var _patientData:Array = [];
		private var _remoteCallMade:Boolean = false;

		public function HivivaHCPAllPatientsAdherenceScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			if(!this._remoteCallMade) getAllWeeklyMedicationHistory();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Adherence: patients";
			this.addChild(this._header);
		}

		private function getAllWeeklyMedicationHistory():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_ALL_WEEKLY_MEDICATION_HISTORY_COMPLETE, getAllWeeklyMedicationHistoryCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getAllWeeklyMedicationHistory(PatientAdherenceChart.TOTAL_WEEKS);
			this._remoteCallMade = true;
		}

		private function getAllWeeklyMedicationHistoryCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_ALL_WEEKLY_MEDICATION_HISTORY_COMPLETE, getAllWeeklyMedicationHistoryCompleteHandler);

			this._scheduleHistoryData = e.data.xmlResponse.DCAllUsersMedication;
			var loop:uint = this._scheduleHistoryData.length();
			if (loop > 0)
			{
				drawAdherenceChart();
			}
			else
			{
				trace("no patients history");
			}
		}

		private function drawAdherenceChart():void
		{
			var patientAdherenceChart:PatientAdherenceChart = new PatientAdherenceChart();
//			patientAdherenceChart.patientData = this._patientData;
			patientAdherenceChart.scheduleHistoryData = this._scheduleHistoryData;
			addChild(patientAdherenceChart);
			patientAdherenceChart.y = Constants.HEADER_HEIGHT;
			patientAdherenceChart.width = Constants.STAGE_WIDTH;
			patientAdherenceChart.height = Constants.STAGE_HEIGHT - Constants.HEADER_HEIGHT - Constants.FOOTER_BTNGROUP_HEIGHT;
			patientAdherenceChart.validate();
			patientAdherenceChart.initChart();
		}

		override public function dispose():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_ALL_WEEKLY_MEDICATION_HISTORY_COMPLETE, getAllWeeklyMedicationHistoryCompleteHandler);
			super.dispose();
		}

	}
}
