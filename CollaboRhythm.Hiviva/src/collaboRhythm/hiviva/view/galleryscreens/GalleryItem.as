package collaboRhythm.hiviva.view.galleryscreens
{
	import feathers.controls.Button;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class GalleryItem extends Button
	{
		private var _id:int;
		public function set id(val:int):void
		{
			this._id = val;
		}
		public function get id():int
		{
			return this._id;
		}

		private var _url:String;
		public function set url(val:String):void
		{
			this._url = val;
		}
		public function get url():String
		{
			return this._url;
		}

		private var _photo:Image;

		public function GalleryItem()
		{

		}

		override protected function draw():void
		{
			super.draw();

			constrainToProportion(this._photo, this.actualWidth);
		}

		override protected function initialize():void
		{
			super.initialize();

			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoaded);
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadFailed);
			imageLoader.load(new URLRequest(this._url));
		}

		private function imageLoadFailed(e:IOErrorEvent):void
		{
			trace("Image load failed.");
		}

		private function imageLoaded(e:flash.events.Event):void
		{
			trace("Image loaded.");

			this._photo = new Image(getStarlingCompatibleTexture(e.target.content));

			if (!contains(this._photo)) addChild(this._photo);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function getStarlingCompatibleTexture(content:Bitmap):Texture
		{
			var sourceBm:Bitmap = content as Bitmap,
					suitableBm:Bitmap,
					xRatio:Number,
					yRatio:Number;
			// if source bitmap is larger than starling size limit of 2048x2048 than resize
			if (sourceBm.width >= 2048 || sourceBm.height >= 2048)
			{
				// TODO: may need to remove size adjustment from bm! only adjust the data (needs formula)
				constrainToProportion(sourceBm, 2040);
				// copy source bitmap at adjusted size
				var bmd:BitmapData = new BitmapData(sourceBm.width, sourceBm.height);
				var m:Matrix = new Matrix();
				m.scale(sourceBm.scaleX, sourceBm.scaleY);
				bmd.draw(sourceBm, m, null, null, null, true);
				suitableBm = new Bitmap(bmd, 'auto', true);
			}
			else
			{
				suitableBm = sourceBm;
			}
			// use suitable bitmap for texture
			return Texture.fromBitmap(suitableBm);
		}

		private function constrainToProportion(img:Object, size:Number):void
		{
			// TODO : this function goes as a global method
			// TODO : add "crop to proportion" logic
			if (img.height >= img.width)
			{
				img.height = size;
				img.scaleX = img.scaleY;
			}
			else
			{
				img.width = size;
				img.scaleY = img.scaleX;
			}
		}
	}
}
