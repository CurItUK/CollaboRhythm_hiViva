package collaboRhythm.hiviva.model.vo
{
	public class HCPConnectedPatientsVO
	{
		private var _patients:Array;

		public function HCPConnectedPatientsVO()
		{
		}

		public function get patients():Array
		{
			return _patients;
		}

		public function set patients(value:Array):void
		{
			_patients = value;
		}
	}
}
