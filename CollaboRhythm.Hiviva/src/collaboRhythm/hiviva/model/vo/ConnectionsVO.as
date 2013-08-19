package collaboRhythm.hiviva.model.vo
{
	public class ConnectionsVO
	{
		private var _users:Array;
		private var _changed:Boolean = false;

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
