package collaboRhythm.hiviva.view.galleryscreens
{
	public class GalleryData
	{
		public static var ImageData:Array = [];
		public static var comingFromGallery:Boolean = false;

		public static function getUrlsByCategory(category:String):Array
		{
			var urls:Array = [], imageDataObj:Object;
			for (var i:int = 0; i < ImageData.length; i++)
			{
				imageDataObj = ImageData[i];
				if(imageDataObj.category == category)
				{
					urls = imageDataObj.urls;
					break;
				}
			}
			return urls;
		}

		public static function setUrlsByCategory(category:String, urls:Array):void
		{
			var imageDataObj:Object;
			for (var i:int = 0; i < ImageData.length; i++)
			{
				imageDataObj = ImageData[i];
				if(imageDataObj.category == category)
				{
					imageDataObj.urls = urls;
					break;
				}
			}
		}
	}
}
