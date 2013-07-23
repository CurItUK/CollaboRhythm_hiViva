package collaboRhythm.hiviva.model.vo
{
	public class ReportVO
	{

		private var _settingsData:Object;


		public function ReportVO()
		{
		}

		public function get settingsData():Object
		{
			return _settingsData;
		}

		public function set settingsData(value:Object):void
		{
			_settingsData = value;
		}
	}
}
