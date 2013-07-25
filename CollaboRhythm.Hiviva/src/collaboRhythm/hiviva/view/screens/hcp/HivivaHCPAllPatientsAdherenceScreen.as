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
			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			if(!this._remoteCallMade) getApprovedConnections();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Adherence: patients";
			this.addChild(this._header);
		}

		private function getApprovedConnections():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE, getApprovedConnectionsHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getApprovedConnections();
			this._remoteCallMade = true;
		}

		private function getApprovedConnectionsHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_COMPLETE, getApprovedConnectionsHandler);

			var xmlList:XMLList = e.data.xmlResponse.DCConnection;
			var loop:uint = xmlList.length();
			if (loop > 0)
			{
				for (var i:int = 0; i < xmlList.length(); i++)
				{
					this._patientData.push(establishToFromId(xmlList[i]));
				}
				getAllWeeklyMedicationHistory();
			}
			else
			{
				trace("no connected patients");
			}
		}

		private function establishToFromId(idsToCompare:XML):Object
		{
			var whoEstablishConnection:Object = [];
			if(idsToCompare.FromAppId == HivivaStartup.userVO.appId)
			{
				whoEstablishConnection.appGuid = idsToCompare.ToUserGuid;
				whoEstablishConnection.appId = idsToCompare.ToAppId;
			} else
			{
				whoEstablishConnection.appGuid = idsToCompare.FromUserGuid;
				whoEstablishConnection.appId = idsToCompare.FromAppId;
			}

			return whoEstablishConnection;
		}

		private function getAllWeeklyMedicationHistory():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_ALL_WEEKLY_MEDICATION_HISTORY_COMPLETE, getAllWeeklyMedicationHistoryCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getAllWeeklyMedicationHistory(PatientAdherenceChart.TOTAL_WEEKS);
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
			patientAdherenceChart.patientData = this._patientData;
			patientAdherenceChart.scheduleHistoryData = this._scheduleHistoryData;
			addChild(patientAdherenceChart);
			patientAdherenceChart.y = Constants.HEADER_HEIGHT;
			patientAdherenceChart.width = Constants.STAGE_WIDTH;
			patientAdherenceChart.height = Constants.STAGE_HEIGHT - Constants.HEADER_HEIGHT - Constants.FOOTER_BTNGROUP_HEIGHT;
			patientAdherenceChart.validate();
			patientAdherenceChart.initChart();
		}

	}
}
