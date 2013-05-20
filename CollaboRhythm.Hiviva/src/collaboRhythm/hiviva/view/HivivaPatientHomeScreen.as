package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.utils.MedicationNameModifier;

	import feathers.controls.Label;
	import feathers.controls.Screen;

	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.System;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class HivivaPatientHomeScreen extends Screen
	{
		private var _footerHeight:Number;

		private var _header:HivivaHeader;
//		private var _messagesButton:Button;
//		private var _badgesButton:Button;
		private var _homeImageInstructions:Label;
		private var _sqConn:SQLConnection;
		private var _sqStatement:SQLStatement;
		private var _resultData:Array;
		private var _rim:Image;
		private var _bg:Image;
		private var _shine:Image;
		private var _bgImageHolder:Sprite;
		private var _lensImageHolder:Sprite;
		private var _dayDiff:Number;

		private var IMAGE_SIZE:Number;
		private var _usableHeight:Number;

		public function HivivaPatientHomeScreenScreen():void
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._usableHeight = this.actualHeight - this._footerHeight - this._header.height;
/*
			this._messagesButton.width = 130 * this.dpiScale;
			this._messagesButton.height = 110 * this.dpiScale;

			this._badgesButton.width = 130 * this.dpiScale;
			this._badgesButton.height = 110 * this.dpiScale;
*/
			// 90% of stage width
			IMAGE_SIZE = this.actualWidth * 0.9;

			this._bg.width = IMAGE_SIZE;
			this._bg.scaleY = this._bg.scaleX;
			this._bg.x = (this.actualWidth * 0.5) - (this._bg.width * 0.5);
			this._bg.y = (this._usableHeight * 0.5) + this._header.height - (this._bg.height * 0.5);

			this._rim.scaleX = this._bg.scaleX;
			this._rim.scaleY = this._bg.scaleY;
			this._rim.x = (this.actualWidth * 0.5) - (this._rim.width * 0.5);
			this._rim.y = (this._usableHeight * 0.5) + this._header.height - (this._rim.height * 0.5);

			this._shine.scaleX = this._bg.scaleX;
			this._shine.scaleY = this._bg.scaleY;
			this._shine.x = (this.actualWidth * 0.5) - (this._shine.width * 0.5);
			this._shine.y = (this._usableHeight * 0.5) + this._header.height - (this._shine.height * 0.5);

			this._homeImageInstructions.width = IMAGE_SIZE;
			this._homeImageInstructions.validate();
			this._homeImageInstructions.x =  (this.actualWidth * 0.5) - (this._homeImageInstructions.width * 0.5);
			this._homeImageInstructions.y =  (this._usableHeight * 0.5) + this._header.height - (this._homeImageInstructions.height * 0.5);

			initHomePhoto();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "";
			addChild(this._header);

			this._bgImageHolder = new Sprite();
			addChild(this._bgImageHolder);

			this._rim = new Image(HivivaAssets.HOME_LENS_RIM);
			addChild(this._rim);

			this._bg = new Image(HivivaAssets.HOME_LENS_BG);
			addChild(this._bg);

			this._lensImageHolder = new Sprite();
			addChild(this._lensImageHolder);

			this._shine = new Image(HivivaAssets.HOME_LENS_SHINE);
			addChild(this._shine);

			this._homeImageInstructions = new Label();
			this._homeImageInstructions.name = "home-label";
			this._homeImageInstructions.text = "Go to <A HREF='http://www.google.com/'><FONT COLOR='#016cf9'>profile</FONT></A> then <FONT COLOR='#016cf9'>Homepage Photo</FONT> to upload or set your home page image <br/><br/>The clarity of this image will adjust to how well you stay on track with your medication.";
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
			this._sqStatement.addEventListener(SQLEvent.RESULT, getDate);
			this._sqStatement.text = "SELECT gallery_submission_timestamp FROM app_settings";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();
		}

		private function getDate(e:SQLEvent):void
		{
			this._sqStatement.removeEventListener(SQLEvent.RESULT, getDate);
			this._resultData = this._sqStatement.getResult().data;

			var today:Date = new Date(),
				date:Date = new Date();
			try
			{
				if(this._resultData[0].gallery_submission_timestamp != null)
				{
					//date = DateTransformFactory.convertSQLDateTimeToASDate(this._resultData[0].gallery_submission_timestamp);
					date = MedicationNameModifier.getAS3DatefromString(this._resultData[0].gallery_submission_timestamp);
				}
				else
				{
				}
				trace("gallery_submission_timestamp = " + this._resultData[0].gallery_submission_timestamp);
			}
			catch(e:Error)
			{
				trace("date stamp not there");
			}
			this._dayDiff = MedicationNameModifier.getDaysDiff(today, date);

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

			var resultDataLength:int, chosenImageUrl:String, chosenImageInd:int, daysToImagesRatio:Number;
			try
			{
				resultDataLength = this._resultData.length;
				if(resultDataLength > 0)
				{
					// loop images if the dayDiff exceeds the amount of images
					daysToImagesRatio = Math.floor(this._dayDiff / resultDataLength);
					if(daysToImagesRatio >= 1)
					{
						chosenImageInd = this._dayDiff - (daysToImagesRatio * resultDataLength);
					}
					else
					{
						chosenImageInd = this._dayDiff;
					}

					//chosenImageInd = Math.floor(Math.random() * (resultDataLength - 1));
					chosenImageUrl = this._resultData[chosenImageInd].url;
					// TODO: boolean to define difference between custom photo and stock photo locations in homepage photo screen
					trace("media/stock_images/" + chosenImageUrl);
					doImageLoad("media/stock_images/" + chosenImageUrl);
				}
				this._homeImageInstructions.visible = false;
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

			drawBgHomeImage(sourceBm);

			drawLensHomeImage(sourceBm);

			//clean up
			sourceBm.bitmapData.dispose();
			sourceBm = null;
			System.gc();

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

		private function drawBgHomeImage(sourceBm:Bitmap):void
		{
			var bgHolder:flash.display.Sprite = new flash.display.Sprite();

			var bgBm:Bitmap = new Bitmap(sourceBm.bitmapData,"auto",true);
			cropToFit(bgBm, this.actualWidth, this._usableHeight);
			bgBm.alpha = 0.35;
			bgHolder.addChild(bgBm);

			var bgMask:flash.display.Sprite = new flash.display.Sprite();
			bgMask.graphics.beginFill(0x000000);
			bgMask.graphics.drawRect((bgBm.width * 0.5) - (this.actualWidth * 0.5),(bgBm.height * 0.5) - (this._usableHeight * 0.5),this.actualWidth, this._usableHeight);
			bgHolder.addChild(bgMask);

			bgBm.mask = bgMask;

			var bmd:BitmapData = new BitmapData(bgHolder.width, bgHolder.height, true, 0x00000000);
			bmd.draw(bgHolder, new Matrix(), null, null, null, true);

			var bgImage:Image = new Image(Texture.fromBitmapData(bmd));
			bgImage.touchable = false;
			bgImage.x = (this.actualWidth * 0.5) - (bgImage.width * 0.5);
			bgImage.y = (this._usableHeight * 0.5) + this._header.height - (bgImage.height * 0.5);
			this._bgImageHolder.addChild(bgImage);

			bmd.dispose();
		}

		private function drawLensHomeImage(sourceBm:Bitmap):void
		{
			var circleHolder:flash.display.Sprite = new flash.display.Sprite();

			var circleBm:Bitmap = new Bitmap(sourceBm.bitmapData,"auto",true);
			cropToFit(circleBm, this.actualWidth, this._usableHeight);
			circleHolder.addChild(circleBm);

			var circleMask:flash.display.Sprite = new flash.display.Sprite();
			circleMask.graphics.beginFill(0x000000);
			circleMask.graphics.drawCircle(circleBm.width * 0.5, circleBm.height * 0.5, IMAGE_SIZE * 0.5);
			circleHolder.addChild(circleMask);

			circleBm.mask = circleMask;

			var bmd:BitmapData = new BitmapData(circleHolder.width, circleHolder.height, true, 0x00000000);
			bmd.draw(circleHolder, new Matrix(), null, null, null, true);

			var bgImage:Image = new Image(Texture.fromBitmapData(bmd));
			bgImage.touchable = false;
			bgImage.x = (this.actualWidth * 0.5) - (bgImage.width * 0.5);
			bgImage.y = (this._usableHeight * 0.5) + this._header.height - (bgImage.height * 0.5);
			this._lensImageHolder.addChild(bgImage);

			bmd.dispose();
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

		override public function dispose():void
		{
			super.dispose();
			//custom clear down
		}
	}
}
