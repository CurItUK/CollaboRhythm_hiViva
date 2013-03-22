package collaboRhythm.hiviva.vo
{
	public class AppDataVO
	{
		public var _userAppType:String;

		public function update(o:Object):void
		{
			this._userAppType = o.userAppType;
		}
	}
}
