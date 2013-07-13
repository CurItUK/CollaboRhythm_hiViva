package collaboRhythm.hiviva.model.vo
{
	public class PatientAdherenceVO
	{

		private var _percentage:Number = 0;

		public function PatientAdherenceVO()
		{
		}

		public function set percentage(value:Number):void
		{
			this._percentage = value;
		}

		public function get percentage():Number
		{
			return this._percentage;
		}
	}
}
