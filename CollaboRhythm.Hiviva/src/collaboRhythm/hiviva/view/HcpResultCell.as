package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Radio;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;

	public class HcpResultCell extends FeathersControl
	{
		private var _scale:Number;
		public function set scale(value:Number):void
		{
			this._scale = value;
		}
		public function get scale():Number
		{
			return this._scale;
		}

		private var _isResult:Boolean;
		public function set isResult(value:Boolean):void
		{
			this._isResult = value;
		}
		public function get isResult():Boolean
		{
			return this._isResult;
		}
		/*
		{picture:String, name:String, email:String, appid:String}
		*/
		private var _hcpData:XMLList;
		public function set hcpData(value:XMLList):void
		{
			this._hcpData = value;
		}
		public function get hcpData():XMLList
		{
			return this._hcpData;
		}

		private var _bg:Scale9Image;
		private var _hcpImageBg:Quad;
		private var _photoHolder:Image;
		private var _hcpName:Label;
		private var _hcpEmail:Label;
		private var _hcpDelete:Button;
		public var _hcpSelect:Radio;

		private const IMAGE_SIZE:Number = 100;
		private const PADDING:Number = 32;

		public function HcpResultCell()
		{
			super();
		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this._scale,
				gap:Number = scaledPadding * 0.5;
				fullHeight:Number;

			super.draw();

			doImageLoad("media/hcps/" + hcpData.picture);
			this._hcpName.validate();
			this._hcpEmail.validate();
			this._hcpSelect.padding = 0;
			this._hcpSelect.validate();
			this._hcpDelete.validate();

			this._bg.x = scaledPadding;
			this._bg.width = this.actualWidth - (scaledPadding * 2);
			this._bg.height = scaledPadding + this._hcpImageBg.height;

			this._hcpSelect.y = this._bg.y + (this._bg.height * 0.5) - (this._hcpSelect.height * 0.5);
			this._hcpSelect.x = this._bg.x + gap;

			this._hcpImageBg.x = this._isResult ? (this._hcpSelect.x + this._hcpSelect.width) + gap : this._bg.x + gap;
			this._hcpImageBg.y = this._bg.y + gap;

			this._hcpName.x = this._hcpImageBg.x + this._hcpImageBg.width + gap;
			this._hcpName.y = this._hcpImageBg.y + gap;
			this._hcpName.width = this._bg.width - this._hcpName.x;

			this._hcpEmail.x = this._hcpImageBg.x + this._hcpImageBg.width + gap;
			this._hcpEmail.y = this._hcpName.y + this._hcpName.height;
			this._hcpEmail.width = this._bg.width - this._hcpEmail.x;

			this._hcpDelete.y = (this._bg.height * 0.5) - (this._hcpDelete.height * 0.5);
			this._hcpDelete.x = this._bg.x + this._bg.width - gap - this._hcpDelete.width;

			setSizeInternal(this.actualWidth, this._bg.height, true);

			this._hcpDelete.visible = !this._isResult;
			this._hcpSelect.visible = this._isResult;
		}

		override protected function initialize():void
		{
			super.initialize();
			var bgTexture:Scale9Textures = new Scale9Textures(Assets.getTexture(HivivaAssets.INPUT_FIELD), new Rectangle(11,11,32,32));
			this._bg = new Scale9Image(bgTexture, this._scale);
			addChild(this._bg);

			this._hcpImageBg = new Quad(IMAGE_SIZE * this._scale, IMAGE_SIZE * this._scale, 0x000000);
			addChild(this._hcpImageBg);

			this._hcpName = new Label();
			this._hcpName.name = "";
			this._hcpName.text = hcpData.name;
			addChild(this._hcpName);

			this._hcpEmail = new Label();
			this._hcpEmail.text = hcpData.email;
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

			var suitableBm:Bitmap = getSuitableBitmap(e.target.content as Bitmap);

			this._photoHolder = new Image(Texture.fromBitmap(suitableBm));
			constrainToProportion(this._photoHolder, IMAGE_SIZE * this._scale);
			// TODO : Check if if (img.height >= img.width) then position accordingly. right now its only Ypos
			this._photoHolder.x = this._hcpImageBg.x;
			this._photoHolder.y = this._hcpImageBg.y + (this._hcpImageBg.height / 2) - (this._photoHolder.height / 2);
			if (!contains(this._photoHolder)) addChild(this._photoHolder);
		}

		private function imageLoadFailed(e:Event):void
		{
			trace("Image load failed.");
		}

		private function getSuitableBitmap(sourceBm:Bitmap):Bitmap
		{
			var bm:Bitmap;
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
				bm = new Bitmap(bmd, 'auto', true);
			}
			else
			{
				bm = sourceBm;
			}
			return bm;
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
			this._hcpImageBg.dispose();
			this._photoHolder.dispose();
			removeChildren(0,-1,true);
			removeEventListeners();

			this._hcpImageBg = null;
			this._photoHolder = null;

			super.dispose();
		}
	}
}
