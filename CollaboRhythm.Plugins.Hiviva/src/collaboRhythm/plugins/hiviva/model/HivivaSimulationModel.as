package collaboRhythm.plugins.hiviva.model
{
	import collaboRhythm.shared.model.Account;
	import collaboRhythm.shared.model.Record;

	public class HivivaSimulationModel
	{



		private var _activeRecord:Record;

		public function HivivaSimulationModel(activeRecordAccount:Account)
		{
			_activeRecord = activeRecordAccount.primaryRecord;
		}

		public function updateSimulationData():void
		{
			trace("Update Simulation Data");
		}

		public function get activeRecord():Record
		{
			return _activeRecord;
		}

		public function get recordContainsHivivaMedication():Boolean
		{

			return false;
		}
	}
}
