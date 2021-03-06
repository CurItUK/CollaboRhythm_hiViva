package collaboRhythm.hiviva.model.vo
{
	public class UserAuthenticationVO
	{

		private var _enabled:Boolean;
		private var _passcode:String;
		private var _answer:String;
		private var _questionId:uint;


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

		public function get passcode():String
		{
			return _passcode;
		}

		public function set passcode(value:String):void
		{
			_passcode = value;
		}

		public function get answer():String
		{
			return _answer;
		}

		public function set answer(value:String):void
		{
			_answer = value;
		}

		public function get questionId():uint
		{
			return _questionId;
		}

		public function set questionId(value:uint):void
		{
			_questionId = value;
		}
	}
}
