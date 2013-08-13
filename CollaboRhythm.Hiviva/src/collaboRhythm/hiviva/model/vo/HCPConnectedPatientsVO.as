package collaboRhythm.hiviva.model.vo
{
	public class HCPConnectedPatientsVO
	{
		private var _patients:Array;
		private var _updated:Boolean = true;

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

		public function get updated():Boolean
		{
			return _updated;
		}

		public function set updated(checked:Boolean):void
		{
			_updated = checked;
		}
	}
}
