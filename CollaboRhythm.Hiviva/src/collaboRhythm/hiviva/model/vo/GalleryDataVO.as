package collaboRhythm.hiviva.model.vo
{
	public class GalleryDataVO
	{
		private var _imageData:Array = [];
		private var _changed:Boolean = false;

		public function GalleryDataVO()
		{
		}

		public function getUrlsByCategory(category:String):Array
		{
			var urls:Array = [], imageDataObj:Object;
			for (var i:int = 0; i < _imageData.length; i++)
			{
				imageDataObj = _imageData[i];
				if(imageDataObj.category == category)
				{
					urls = imageDataObj.urls;
					break;
				}
			}
			return urls;
		}

		public function setUrlsByCategory(category:String, urls:Array):void
		{
			var imageDataObj:Object;
			for (var i:int = 0; i < _imageData.length; i++)
			{
				imageDataObj = _imageData[i];
				if(imageDataObj.category == category)
				{
					imageDataObj.urls = urls;
					break;
				}
			}
		}

		public function get imageData():Array
		{
			return _imageData;
		}

		public function set imageData(value:Array):void
		{
			_imageData = value;
		}

		public function get changed():Boolean
		{
			return _changed;
		}

		public function set changed(value:Boolean):void
		{
			_changed = value;
		}
	}
}
