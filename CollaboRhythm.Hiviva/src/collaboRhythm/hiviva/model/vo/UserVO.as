package collaboRhythm.hiviva.model.vo
{
	public class UserVO
	{

		private var _appId:String;
		private var _guid:String;
		private var _type:String;


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
	}
}
