package collaboRhythm.hiviva.model.vo
{
	public class ConnectionsVO
	{
		private var _users:Array;

		public function ConnectionsVO()
		{
		}

		public function get users():Array
		{
			return _users;
		}

		public function set users(value:Array):void
		{
			_users = value;
		}
	}
}
