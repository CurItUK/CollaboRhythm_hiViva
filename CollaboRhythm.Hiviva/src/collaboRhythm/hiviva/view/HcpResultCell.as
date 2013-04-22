package collaboRhythm.hiviva.view
{
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.Radio;
	import feathers.controls.ScrollText;
	import feathers.core.FeathersControl;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class HcpResultCell extends Sprite
	{
		private var _hcpImage:Sprite;
		private var _hcpName:Label;
		private var _hcpEmail:Label;
		private var _hcpDelete:Button;
		public var _hcpSelect:Radio;
		private var _dpiScale:Number;

		private var _imageFilename:String;
		private var _nameData:String;
		private var _emailData:String;

		private var _explicitWidth:Number;
		public var _appid:String;
		public var _isResult:Boolean;

		public function HcpResultCell(hcpData:XMLList, cellWidth:Number, dpiScale:Number)
		{
			this._explicitWidth = cellWidth;
			this._dpiScale = dpiScale;
			this._imageFilename = hcpData.picture;
			this._nameData = hcpData.name;
			this._emailData = hcpData.email;
			this._appid = hcpData.appid;
			initCell();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function initCell():void
		{
			this._hcpImage = new Sprite();
			var quad:Quad = new Quad(100 * this._dpiScale, 100 * this._dpiScale, 0x000000);
			this._hcpImage.addChild(quad);
			addChild(this._hcpImage);

			this._hcpName = new Label();
			addChild(this._hcpName);

			this._hcpEmail = new Label();
			addChild(this._hcpEmail);

			this._hcpSelect = new Radio();
			addChild(this._hcpSelect);

			this._hcpDelete = new Button();
			this._hcpDelete.label = "x";
			this._hcpDelete.addEventListener(Event.TRIGGERED, onHcpDelete);
			addChild(this._hcpDelete);
		}

		private function onHcpDelete(e:Event):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}

		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);

			var gap:Number = 30 * this._dpiScale;

			this._hcpName.text = this._nameData;
			this._hcpEmail.text = this._emailData;
			doImageLoad("media/hcps/" + this._imageFilename);

			this._hcpName.validate();
			this._hcpEmail.validate();
			this._hcpSelect.validate();
			this._hcpDelete.validate();

			this._hcpSelect.y = (this._hcpImage.height / 2) - this._hcpSelect.height;
			this._hcpImage.x = this._hcpSelect.x + this._hcpSelect.width + gap;
			this._hcpName.x = this._hcpImage.x + this._hcpImage.width + gap;
			this._hcpEmail.x = this._hcpImage.x + this._hcpImage.width + gap;
			this._hcpEmail.y = this._hcpName.height + gap;
			this._hcpDelete.y = (this._hcpImage.height / 2) - this._hcpDelete.height;
			this._hcpDelete.x = this._explicitWidth - this._hcpDelete.width - gap;

			this.height = this._hcpImage.height;

			this._hcpDelete.visible = !this._isResult;
			this._hcpSelect.visible = this._isResult;
		}

		private function doImageLoad(url:String):void
		{
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoaded);
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadFailed);
			imageLoader.load(new URLRequest(url));
		}

		private function imageLoaded(e:flash.events.Event):void
		{
			trace("Image loaded.");

			var sourceBm:Bitmap = e.target.content as Bitmap,
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
			var photoHolder:Image = new Image(Texture.fromBitmap(suitableBm));
			constrainToProportion(photoHolder, 100 * this._dpiScale);

			if (!this._hcpImage.contains(photoHolder)) this._hcpImage.addChild(photoHolder);
		}

		private function imageLoadFailed(e:Event):void
		{
			trace("Image load failed.");
		}

		private function constrainToProportion(img:Object, size:Number):void
		{
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

		override public function dispose():void
		{
			this._hcpImage.removeChildren(0,-1,true);
			removeChildren(0,-1,true);
			removeEventListeners();
			super.dispose();
		}
	}
}
