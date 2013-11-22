package collaboRhythm.hiviva.utils
{
	import collaboRhythm.hiviva.global.RXNORMEvent;

	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class RXNORM_DrugSearch extends EventDispatcher
	{
		private static const RXNORM_BASE_URI:String = "http://rxnav.nlm.nih.gov/REST/";
		private static const RXNORM_DRUGS_API:String = "drugs?name=";

		public function findDrug(name:String):void
		{
			var urlRequest:URLRequest = new URLRequest(RXNORM_BASE_URI + RXNORM_DRUGS_API + name);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(flash.events.Event.COMPLETE, queryDrugName_completeHandler);
			urlLoader.load(urlRequest);
			trace(urlRequest.url)
		}

		private function queryDrugName_completeHandler(e:flash.events.Event):void
		{
			trace("RXNORM_DrugSearch " + e.target.data);
			var xmlResponse:XML = new XML(e.target.data);
			var conceptXMList:XMLList = xmlResponse.drugGroup.conceptGroup.conceptProperties;

			var evt:RXNORMEvent = new RXNORMEvent(RXNORMEvent.DATA_LOAD_COMPLETE);
			evt.data.medicationList = conceptXMList;
			this.dispatchEvent(evt);
		}
	}
}
