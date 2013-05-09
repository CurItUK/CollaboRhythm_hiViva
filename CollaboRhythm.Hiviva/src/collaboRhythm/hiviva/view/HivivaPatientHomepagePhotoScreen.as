package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.galleryscreens.Gallery;
	import collaboRhythm.hiviva.view.galleryscreens.GalleryItem;
	import collaboRhythm.hiviva.view.galleryscreens.SportsGalleryScreen;

	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;

	import flash.filesystem.File;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaPatientHomepagePhotoScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _galleriesContainer:ScrollContainer;
		private var _photoContainer:ImageUploader;
		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _backButton:Button;
		private var _galleries:Vector.<Gallery>;
		private var _galleryCount:int;
		private var _galleryLength:int;
		private var _galleryPadding:Number;

		private const GALLERY_CATEGORIES:Array = ["sport","music","cinema","history","traveling","art"];
		private const PADDING:Number = 32

		public function HivivaPatientHomepagePhotoScreen()
		{

		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;

			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._header.width = this.actualWidth;
			this._header.validate();
/*

			this._galleriesButtons.y = this._header.height;
			this._galleriesButtons.width = this.actualWidth;
			this._galleriesButtons.height = (this.actualHeight - this._galleriesButtons.y) * 0.5;
*/

			this._cancelButton.validate();
			this._cancelButton.y = this.actualHeight - this._cancelButton.height - scaledPadding;
			this._cancelButton.x = scaledPadding;

			this._submitButton.validate();
			this._submitButton.y = this._cancelButton.y;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + (20 * this.dpiScale);

			this._photoContainer.width = this.actualWidth;
			this._photoContainer.validate();
			this._photoContainer.y = this._cancelButton.y - scaledPadding - this._photoContainer.height;

			if (this._galleries.length == 0) initGallery();
		}

		override protected function initialize():void
		{
			this._galleries = new <Gallery>[];

			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Homepage Photo";
			addChild(this._header);

			this._photoContainer = new ImageUploader();
			this._photoContainer.scale = this.dpiScale;
			this._photoContainer.fileName = "homepageimage.jpg";
			addChild(this._photoContainer);

			this._cancelButton = new Button();
			this._cancelButton.label = "Cancel";
			this._cancelButton.addEventListener(Event.TRIGGERED, cancelButtonClick);
			addChild(this._cancelButton);

			this._submitButton = new Button();
			this._submitButton.label = "Save";
			this._submitButton.addEventListener(Event.TRIGGERED, submitButtonClick);
			addChild(this._submitButton);

			this._backButton = new Button();
			this._backButton.name = "back-button";
			this._backButton.label = "Back";
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
			this._photoContainer.saveTempImageAsMain();
		}

		private function initGallery():void
		{
			var currGalleryContainer:Gallery;

			this._galleryPadding = 15 * this.dpiScale;

			const horizontalLayout:HorizontalLayout = new HorizontalLayout();
			horizontalLayout.gap = this._galleryPadding;
			horizontalLayout.padding = 0;
			horizontalLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			horizontalLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;

			this._galleryCount = 0;
			this._galleryLength = GALLERY_CATEGORIES.length;
			for (var i:int = 0; i < this._galleryLength; i++)
			{
				currGalleryContainer = new Gallery(GALLERY_CATEGORIES[i]);
				currGalleryContainer.layout = horizontalLayout;
				currGalleryContainer.addEventListener(Event.COMPLETE, galleryReady);
				this._galleries.push(currGalleryContainer);
			}
		}

		private function galleryReady(e:Event):void
		{
			var currGalleryContainer:Gallery = e.target as Gallery;
			currGalleryContainer.removeEventListener(Event.COMPLETE, galleryReady);

			this._galleryCount++;

			if(this._galleryCount == this._galleryLength)
			{
				initGalleriesContainer();
				this._galleries.forEach(drawGalleries);
			}
		}

		private function initGalleriesContainer():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var startYPosition:Number = this._header.y + this._header.height;

			this._galleriesContainer = new ScrollContainer();
			addChild(this._galleriesContainer);

			this._galleriesContainer.x = scaledPadding;
			this._galleriesContainer.y = startYPosition;
			this._galleriesContainer.width = this.actualWidth - (scaledPadding * 2);
			this._galleriesContainer.height = this._photoContainer.y - startYPosition - scaledPadding;
		}

		private function drawGalleries(item:Gallery, index:int, vector:Vector.<Gallery>):void
		{
			var galleryHeight:Number = 125 * this.dpiScale;

			this._galleriesContainer.addChild(item);
			item.height = galleryHeight;
			item.width = this._galleriesContainer.width;
			item.y = (galleryHeight + this._galleryPadding) * index;
			item.drawGallery();
		}
/*
		private function onOpenGallery(e:Event):void
		{
			const button:Button = Button(e.currentTarget);
			var category:String;
			//trace(button.label + " triggered.");
			switch(button.label)
			{
				case "Sport" :
					//var sportsScreen:SportsGalleryScreen = new SportsGalleryScreen();
					//addChild(sportsScreen);
					category = "sport";
					break;
				case "Music" :
					break;
				case "Cinema" :
					break;
				case "History" :
					break;
				case "Traveling" :
					break;
				case "Art" :
					break;
			}
			if(this.owner.hasScreen("gallery")) this.owner.removeScreen("gallery");
			this.owner.addScreen("gallery", new ScreenNavigatorItem(SportsGalleryScreen, null, {category:category}));
			this.owner.showScreen("gallery");
		}*/
	}
}
