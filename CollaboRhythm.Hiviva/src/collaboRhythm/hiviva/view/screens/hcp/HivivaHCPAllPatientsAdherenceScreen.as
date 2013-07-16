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
		private var _patientData:XMLList;
		private var _patientHistoryData:Array = [];
		private var _remoteCallMade:Boolean = false;
		private var _patientCount:int = 0;
		private var _currPatient:Object;

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

			this._patientData = e.data.xmlResponse.DCConnection;
			var loop:uint = this._patientData.length();
			if (loop > 0)
			{
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_WEEKLY_MEDICATION_HISTORY_COMPLETE, getWeeklyMedicationHistoryCompleteHandler);

				this._currPatient = establishToFromId(this._patientData[this._patientCount]);
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getWeeklyMedicationHistory(_currPatient.appGuid);
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

		private function getWeeklyMedicationHistoryCompleteHandler(e:RemoteDataStoreEvent):void
		{
			var xmlData:XML = e.data.xmlResponse;
			var loop:uint = xmlData.children().length();
			if (loop > 0)
			{
				this._patientHistoryData.push({patientAppId:String(this._currPatient.appId),xml:xmlData});
			}

			this._patientCount++;
			if(this._patientCount == _patientData.length())
			{
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_WEEKLY_MEDICATION_HISTORY_COMPLETE, getWeeklyMedicationHistoryCompleteHandler);
				drawAdherenceChart();
			}
			else
			{
				this._currPatient = establishToFromId(this._patientData[this._patientCount]);
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getWeeklyMedicationHistory(_currPatient.appGuid);
			}
		}

		private function drawAdherenceChart():void
		{
			var patientAdherenceChart:PatientAdherenceChart = new PatientAdherenceChart();
			patientAdherenceChart.filterdPatients = this._patientHistoryData;
			addChild(patientAdherenceChart);
			patientAdherenceChart.y = Constants.HEADER_HEIGHT;
			patientAdherenceChart.width = Constants.STAGE_WIDTH;
			patientAdherenceChart.height = Constants.STAGE_HEIGHT - Constants.HEADER_HEIGHT - Constants.FOOTER_BTNGROUP_HEIGHT;
			patientAdherenceChart.validate();
			patientAdherenceChart.drawChart();
		}

	}
}
