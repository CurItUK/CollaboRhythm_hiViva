package collaboRhythm.hiviva.model.vo
{
	public class UserAuthenticationVO
	{

		private var _enabled:Boolean;


		public function UserAuthenticationVO()
		{
		}


		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
	}
}
