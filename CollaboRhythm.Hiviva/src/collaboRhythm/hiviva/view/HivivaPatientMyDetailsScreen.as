package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	import feathers.layout.VerticalLayout;
	import feathers.layout.ViewPortBounds;

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.net.URLRequest;

	import starling.display.DisplayObject;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;


	public class HivivaPatientMyDetailsScreen extends ScreenBase
	{
		private var _header:Header;
		private var _instructionsText:Label;
		private var _nameLabel:Label;
		private var _nameInput:TextInput;
		private var _emailLabel:Label;
		private var _emailInput:TextInput;
		private var _photoContainer:Sprite;
		private var _photoHolder:Image;
		private var _updatesCheck:Check;
		private var _researchCheck:Check;
		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _sqConn:SQLConnection;
		private var _sqStatement:SQLStatement;
		private var _backButton:Button;


		public function HivivaPatientMyDetailsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = this.actualWidth;

			this._instructionsText.text = "All fields are optional except to connect to a care provider";
			//this._instructionsText.y = this._header.height;
			this._instructionsText.width = this.actualWidth;

			this._nameLabel.text = "Name";
			//this._nameLabel.y = 100;
			this._nameLabel.width = this.actualWidth / 2;

			//this._nameInput.y = 100;
			this._nameInput.width = this.actualWidth / 2;

			this._emailLabel.text = "Email";
			//this._emailLabel.y = 150;
			this._emailLabel.width = this.actualWidth / 2;

			//this._emailInput.y = 150;
			this._emailInput.width = this.actualWidth / 2;

			//this._photoContainer.y = 200;

			//this._updatesCheck.y = 250;
			this._updatesCheck.isSelected = false;
			this._updatesCheck.label = "Send me updates";

			//this._updatesCheck.y = 300;
			this._researchCheck.isSelected = false;
			this._researchCheck.label = "Allow anonymised data for research purposes";

			this._cancelButton.label = "Cancel";
			this._submitButton.label = "Save";
			this._backButton.label = "Back";

			var items:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			items.push(this._instructionsText);
			items.push(this._nameInput);
			items.push(this._emailInput);
			items.push(this._photoContainer);
			items.push(this._updatesCheck);
			items.push(this._researchCheck);
			items.push(this._cancelButton);

			autoLayout(items, 50);

			this._nameLabel.y = this._nameInput.y;
			this._emailLabel.y = this._emailInput.y;
			this._nameInput.x = this.actualWidth / 2;
			this._emailInput.x = this.actualWidth / 2;
			this._submitButton.y = this._cancelButton.y;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + 20;

			populateOldData();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new Header();
			this._header.title = "My Details";
			addChild(this._header);

			this._instructionsText = new Label();
			addChild(this._instructionsText);

			this._nameLabel = new Label();
			addChild(this._nameLabel);

			this._nameInput = new TextInput();
			addChild(this._nameInput);

			this._emailLabel = new Label();
			addChild(this._emailLabel);

			this._emailInput = new TextInput();
			addChild(this._emailInput);

			setupPhotoContainer();

			this._updatesCheck = new Check();
			addChild(this._updatesCheck);

			this._researchCheck = new Check();
			addChild(this._researchCheck);

			this._cancelButton = new Button();
			this._cancelButton.addEventListener(Event.TRIGGERED, cancelButtonClick);
			addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}

		private function cancelButtonClick(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function backBtnHandler(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_PROFILE_SCREEN);
		}

		private function submitButtonClick(e:Event):void
		{
			// TODO : display confirmation dialogue

			//trace("UPDATE user_details SET user_name='" + this._nameInput.text + "', user_email='" + this._emailInput.text + "', user_updates=" + int(this._updatesCheck.isSelected) + ", user_research=" + int(this._researchCheck.isSelected));

			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "UPDATE user_details SET user_name='" + this._nameInput.text + "', user_email='" + this._emailInput.text + "', user_updates=" + int(this._updatesCheck.isSelected) + ", user_research=" + int(this._researchCheck.isSelected);
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.addEventListener(SQLEvent.RESULT, sqlResultHandler);
			this._sqStatement.execute();
		}

		private function populateOldData():void
		{
			var dbFile:File = File.applicationStorageDirectory;
			dbFile = dbFile.resolvePath("settings.sqlite");

			this._sqConn = new SQLConnection();
			this._sqConn.open(dbFile);

			this._sqStatement = new SQLStatement();
			this._sqStatement.text = "SELECT * FROM user_details";
			this._sqStatement.sqlConnection = this._sqConn;
			this._sqStatement.execute();

			var sqlRes:SQLResult = this._sqStatement.getResult();
			//trace(sqlRes.data[0].user_name);
			//trace(sqlRes.data[0].user_email);
			//trace(sqlRes.data[0].user_updates);
			//trace(sqlRes.data[0].user_research);
			try
			{
				this._nameInput.text = sqlRes.data[0].user_name;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._nameInput.text = "";
			}
			this._nameInput.invalidate();

			try
			{
				this._emailInput.text = sqlRes.data[0].user_email;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._emailInput.text = "";
			}
			this._emailInput.invalidate();

			try
			{
				this._updatesCheck.isSelected = sqlRes.data[0].user_updates as Boolean;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._updatesCheck.isSelected = false;
			}
			this._updatesCheck.invalidate();

			try
			{
				this._researchCheck.isSelected = sqlRes.data[0].user_research as Boolean;
			}
			catch(e:Error)
			{
				//trace("fail");
				this._researchCheck.isSelected = false;
			}
			this._researchCheck.invalidate();

		}

		private function sqlResultHandler(e:SQLEvent):void
		{
			trace("sqlResultHandler " + e);
		}

		private function autoLayout(items:Vector.<DisplayObject>, gap:Number):void
		{
			var bounds:ViewPortBounds = new ViewPortBounds();
			bounds.x = 0;
			bounds.y = this._header.height;
			bounds.maxHeight = this.actualHeight - this._header.height;
			bounds.maxWidth = this.actualWidth;

			var contentLayout:VerticalLayout = new VerticalLayout();
			contentLayout.gap = gap;
			contentLayout.layout(items,bounds);
		}

		private function setupPhotoContainer():void
		{
			this._photoContainer = new Sprite();

			var destination:File = File.applicationStorageDirectory;
			destination = destination.resolvePath("profileimage.jpg");
			if (destination.exists)
			{
				doImageLoad(destination.url);
			}
			else
			{
				// TODO : put empty holder into this._photoHolder e.g. black square ( may need guidance from design team )
			}

			var uploadPhotoButton:Button = new Button();
			uploadPhotoButton.x = 120;
			uploadPhotoButton.label = "Upload Photo";
			uploadPhotoButton.addEventListener(Event.TRIGGERED, onUploadClick);
			this._photoContainer.addChild(uploadPhotoButton);

			addChild(this._photoContainer);
		}

		private function onUploadClick(e:Event):void
		{
			if (CameraRoll.supportsBrowseForImage)
			{
				trace("Browsing for image...");
				var mediaSource:CameraRoll = new CameraRoll();
				mediaSource.addEventListener(MediaEvent.SELECT, imageSelected);
				mediaSource.addEventListener(Event.CANCEL, browseCanceled);
				mediaSource.browseForImage();
			}
			else
			{
				trace("Browsing in camera roll is not supported.");
			}
		}

		private function imageSelected(e:MediaEvent):void
		{
			trace("Image selected...");

			//this._photoHolder.visible = false;

			var imageSource:MediaPromise = e.data;
			// get file extension
			var extension:String = imageSource.file.extension;
			// set destination location
			var destination:File = File.applicationStorageDirectory;
			destination = destination.resolvePath("profileimage." + extension);
			// copy source to destination
			imageSource.file.copyTo(destination, true);
			var copiedFile:File = File.applicationStorageDirectory;
			copiedFile = copiedFile.resolvePath("profileimage." + extension);
			trace("destination : " + copiedFile.url);

			doImageLoad(copiedFile.url);
		}

		private function doImageLoad(url:String):void
		{
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, imageLoaded);
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadFailed);
			imageLoader.load(new URLRequest(url));
		}

		private function browseCanceled(e:Event):void
		{
			trace("Image browse canceled.");
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
			this._photoHolder = new Image(Texture.fromBitmap(suitableBm));
			constrainToProportion(this._photoHolder, 100);

			if (!this._photoContainer.contains(this._photoHolder)) this._photoContainer.addChild(this._photoHolder);
		}

		private function imageLoadFailed(e:Event):void
		{
			trace("Image load failed.");
		}

		private function constrainToProportion(img:Object, scale:Number):void
		{
			if (img.height >= img.width)
			{
				img.height = scale;
				img.scaleX = img.scaleY;
			}
			else
			{
				img.width = scale;
				img.scaleY = img.scaleX;
			}
		}
	}
}
