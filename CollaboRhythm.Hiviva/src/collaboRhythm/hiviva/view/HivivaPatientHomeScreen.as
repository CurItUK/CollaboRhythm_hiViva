package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.Bitmap;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.SQLEvent;

	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	import source.themes.HivivaTheme;

	import starling.display.DisplayObject;
	import starling.display.Image;

	import starling.events.Event;
	import starling.textures.Texture;

	public class HivivaPatientHomeScreen extends Screen
	{
		private var _footerHeight:Number;

		private var _header:HivivaHeader;
//		private var _messagesButton:Button;
//		private var _badgesButton:Button;
		private var _homeImageInstructions:ScrollText;
		private var _sqConn:SQLConnection;
		private var _sqStatement:SQLStatement;
		private var _resultData:Array;
		private var _imageHolder:Image;

		private var IMAGE_SIZE:Number;

		public function HivivaPatientHomeScreenScreen():void
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;
/*
			this._messagesButton.width = 130 * this.dpiScale;
			this._messagesButton.height = 110 * this.dpiScale;

			this._badgesButton.width = 130 * this.dpiScale;
			this._badgesButton.height = 110 * this.dpiScale;
*/
			// 90% of stage width
			IMAGE_SIZE = this.actualWidth * 0.9;

			initHomePhoto();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "";
			addChild(this._header);

			this._homeImageInstructions = new ScrollText();
			this._homeImageInstructions.text = "Go to 'PROFILE' then 'Homepage Photo' to upload or set your home page image \n\nThe clarity of this image will adjust to how well you stay on track with your medication.";
			this._homeImageInstructions.visible = false;
			addChild(this._homeImageInstructions);

/*
			this._messagesButton = new Button();
			this._messagesButton.nameList.add(HivivaTheme.NONE_THEMED);
			this._messagesButton.defaultIcon = new Image(HivivaAssets.TOPNAV_ICON_MESSAGES);
			this._messagesButton.addEventListener(Event.TRIGGERED , messagesButtonHandler);

			this._badgesButton = new Button();
			this._badgesButton.nameList.add(HivivaTheme.NONE_THEMED);
			this._badgesButton.defaultIcon = new Image(HivivaAssets.TOPNAV_ICON_BADGES);
			this._badgesButton.addEventListener(Event.TRIGGERED , rewardsButtonHandler);

			this._header.rightItems =  new <DisplayObject>[this._messagesButton,this._badgesButton];*/
		}
		/*
		private function messagesButtonHandler(e:Event):void
		{
			
		}

		private function rewardsButtonHandler(e:Event):void
		{

		}*/

		private function initHomePhoto():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.addEventListener(SQLEvent.RESULT, sqlGetAllHomeImageData);
			this._sqStatement.text = "SELECT url FROM homepage_photos";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();
		}

		private function sqlGetAllHomeImageData(e:SQLEvent):void
		{
			this._sqStatement.removeEventListener(SQLEvent.RESULT, sqlGetAllHomeImageData);
			this._resultData = this._sqStatement.getResult().data;

			var resultDataLength:int, chosenImageUrl:String, chosenImageInd:int;
			try
			{
				resultDataLength = this._resultData.length;
				if(resultDataLength > 0)
				{

					chosenImageUrl = this._resultData[0].url;
					// TODO: boolean to define difference between custom photo and stock photo locations in homepage photo screen
					trace("media/stock_images/" + chosenImageUrl);
					doImageLoad("media/stock_images/" + chosenImageUrl);
				}
			}
			catch(e:Error)
			{
				this._homeImageInstructions.visible = true;
			}
		}

		private function doImageLoad(url:String):void
		{
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoaded);
			imageLoader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, imageLoadFailed);
			imageLoader.load(new URLRequest(url));
		}

		private function imageLoaded(e:flash.events.Event):void
		{
			trace("Image loaded.");
			var sourceBm:Bitmap = e.target.content as Bitmap;
			var usableHeight:Number = this.actualHeight - this._footerHeight - this._header.height;

			var circleHolder:flash.display.Sprite = new flash.display.Sprite();

			var bgBm:Bitmap = new Bitmap(sourceBm.bitmapData,"auto",true);
			cropToFit(bgBm, this.actualWidth, usableHeight);
			bgBm.alpha = 0.35;
			circleHolder.addChild(bgBm);

			var bgMask:flash.display.Sprite = new flash.display.Sprite();
			bgMask.graphics.beginFill(0x000000);
			bgMask.graphics.drawRect((bgBm.width * 0.5) - (this.actualWidth * 0.5),(bgBm.height * 0.5) - (usableHeight * 0.5),this.actualWidth,usableHeight);
			circleHolder.addChild(bgMask);

			var circleBm:Bitmap = new Bitmap(sourceBm.bitmapData,"auto",true);
			cropToFit(circleBm, this.actualWidth, usableHeight);
			circleHolder.addChild(circleBm);

			var circleMask:flash.display.Sprite = new flash.display.Sprite();
			circleMask.graphics.beginFill(0x000000);
			circleMask.graphics.drawCircle(circleBm.width * 0.5, circleBm.height * 0.5, IMAGE_SIZE * 0.5);
			circleHolder.addChild(circleMask);

			bgBm.mask = bgMask;
			circleBm.mask = circleMask;

			var bmd:BitmapData = new BitmapData(circleHolder.width, circleHolder.height, true, 0x00000000);
			var m:Matrix = new Matrix();
			bmd.draw(circleHolder, m, null, null, null, true);


			this._imageHolder = new Image(Texture.fromBitmapData(bmd));
			this._imageHolder.touchable = false;
			this._imageHolder.x = (this.actualWidth * 0.5) - (this._imageHolder.width * 0.5);
			this._imageHolder.y = (usableHeight * 0.5) + this._header.height - (this._imageHolder.height * 0.5);
			addChild(this._imageHolder);

			/*var suitableBm:Bitmap = getSuitableBitmap(sourceBm);
			this._imageHolder = new Image(Texture.fromBitmap(suitableBm));
			sourceBm.bitmapData.dispose();
			suitableBm.bitmapData.dispose();

			constrainToProportion(this._imageHolder, IMAGE_SIZE);
			// TODO : Check if if (img.height >= img.width) then position accordingly. right now its only Ypos
			this._imageHolder.x = this._imageBg.x;
			this._imageHolder.y = this._imageBg.y + (this._imageBg.height / 2) - (this._imageHolder.height / 2);
			if (!contains(this._imageHolder)) addChild(this._imageHolder);*/
		}

		private function imageLoadFailed(e:flash.events.IOErrorEvent):void
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

		private function cropToFit(img:Object, w:Number, h:Number):void
		{
			if (img.height >= img.width)
			{
				// portrait
				img.width = w;
				img.scaleY = img.scaleX;
			}
			else
			{
				// landscape
				img.height = h;
				img.scaleX = img.scaleY;
			}
		}

		public function get footerHeight():Number
		{
			return _footerHeight;
		}

		public function set footerHeight(value:Number):void
		{
			_footerHeight = value;
		}
	}
}
