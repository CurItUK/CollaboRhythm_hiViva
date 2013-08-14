package collaboRhythm.hiviva.model.vo
{
	public class HCPConnectedPatientsVO
	{
		private var _patients:Array;
		private var _changed:Boolean = false;

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

		public function get changed():Boolean
		{
			return _changed;
		}

		public function set changed(checked:Boolean):void
		{
			_changed = checked;
		}
	}
}
