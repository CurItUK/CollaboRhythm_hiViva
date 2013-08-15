package collaboRhythm.hiviva.model.vo
{
	public class UserVO
	{

		private var _appId:String;
		private var _guid:String;
		private var _type:String;
		private var _serverDate:Date;
		private var _badges:Array = [];

		public function UserVO()
		{
		}

		public function set appId(value:String):void
		{
			this._appId = value;
		}

		public function get appId():String
		{
			return this._appId;
		}

		public function set guid(value:String):void
		{
			this._guid = value;
		}

		public function get guid():String
		{
			return this._guid;
		}

		public function set type(value:String):void
		{
			this._type = value;
		}

		public function get type():String
		{
			return this._type;
		}

		public function get serverDate():Date
		{
			return _serverDate;
		}

		public function set serverDate(value:Date):void
		{
			_serverDate = new Date();
			var timezoneOffset:Number = _serverDate.getTimezoneOffset();
			_serverDate.setTime(value.getTime() + timezoneOffset);

//			_serverDate = value;
		}

		public function get badges():Array
		{
			return _badges;
		}

		public function set badges(value:Array):void
		{
			_badges = value;
		}
	}
}
