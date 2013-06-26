package collaboRhythm.hiviva.model
{
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteServiceAPI;

	import flash.events.Event;

	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class HivivaRemoteStoreService extends EventDispatcher
	{
		private static const RS_BASE_URL_DEV:String = "http://pwshealthtest.dev/services/";

		public function HivivaRemoteStoreService()
		{

		}

		public function createUser(appType:String):void
		{
			var urlRequest:URLRequest = new URLRequest(RS_BASE_URL_DEV + RemoteServiceAPI.RS_CREATE_USER + appType);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, createUserCompleteHandler);
			urlLoader.load(urlRequest);
		}

		private function createUserCompleteHandler(e:Event):void
		{
			trace("createUserCompleteHandler " + e);
			var evt:RemoteDataStoreEvent = new RemoteDataStoreEvent(RemoteDataStoreEvent.CREATE_USER_COMPLETE);
			this.dispatchEvent(evt)

		}


	}
}
