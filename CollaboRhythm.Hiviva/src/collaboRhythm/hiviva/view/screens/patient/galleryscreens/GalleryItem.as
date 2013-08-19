package collaboRhythm.hiviva.view.screens.patient.galleryscreens
{
	import collaboRhythm.hiviva.utils.HivivaModifier;

	import feathers.controls.Button;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	import source.themes.HivivaTheme;

	import starling.display.Image;
	import starling.display.Quad;
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

		private var _filename:String;
		public function set filename(val:String):void
		{
			this._filename = val;
		}
		public function get filename():String
		{
			return this._filename;
		}

		private var _isActive:Boolean;
		public function set isActive(val:Boolean):void
		{
			this._isActive = val;
			this._tint.alpha = this._isActive ? 1 : 0;
		}
		public function get isActive():Boolean
		{
			return this._isActive;
		}

		private var _givenWidth:Number;

		private var _photo:Image;
		private var _tint:Quad;
		private var _isClipped:Boolean = false;

		public function GalleryItem()
		{

		}

		override protected function draw():void
		{
			super.draw();

			if(!this._isClipped)
			{
				HivivaModifier.clipImage(this._photo);
				this._photo.width = this._photo.height = this._givenWidth;
				this._isClipped = true;
			}

			this._tint.height = this._photo.height + 10;
			this._tint.width = this._photo.width + 10;
			this._tint.x = this._photo.x - 5;
			this._tint.y = this._photo.y - 5;

			setSizeInternal(this._photo.width, this._photo.height, false);
		}

		override protected function initialize():void
		{
			super.initialize();

			this.name = HivivaTheme.NONE_THEMED;
			this.label = "galleryItem";
			this.defaultLabelProperties.visible = false;
		}

		public function doImageLoad():void
		{
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
			var imageLoader:LoaderInfo = e.target as LoaderInfo;

			var bm:Bitmap = imageLoader.content as Bitmap;
			bm.scaleX = bm.scaleY = 0.3;
			trace("Image loaded.");

			//this._photo = new Image(getStarlingCompatibleTexture(e.target.content));
			this._photo = new Image(Texture.fromBitmap(bm));
			bm.bitmapData.dispose();
			bm = null;

			this._tint = new Quad(this._photo.width, this._photo.height, 0x0073ff);
			this._tint.alpha = this._isActive ? 1 : 0;

			addChild(this._tint);
			addChild(this._photo);

			dispatchEventWith(Event.COMPLETE, false, {id:this._id});
		}

		public function get givenWidth():Number
		{
			return _givenWidth;
		}

		public function set givenWidth(value:Number):void
		{
			_givenWidth = value;
		}
	}
}
