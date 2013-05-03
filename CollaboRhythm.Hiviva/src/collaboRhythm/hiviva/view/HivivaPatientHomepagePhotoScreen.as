package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.galleryscreens.SportsGalleryScreen;

	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.layout.TiledColumnsLayout;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaPatientHomepagePhotoScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _galleriesButtons:ScrollContainer;
		private var _photoContainer:ImageUploader;
		private var _cancelButton:Button;
		private var _submitButton:Button;
		private var _backButton:Button;

		private const GALLERY_BUTTON_LABELS:Array = ["Sport","Music","Cinema","History","Traveling","Art"];

		public function HivivaPatientHomepagePhotoScreen()
		{

		}

		override protected function draw():void
		{
			var padding:Number = (32 * this.dpiScale);

			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._header.width = this.actualWidth;
			this._header.validate();

			this._galleriesButtons.y = this._header.height;
			this._galleriesButtons.width = this.actualWidth;
			this._galleriesButtons.height = (this.actualHeight - this._galleriesButtons.y) * 0.5;

			this._photoContainer.width = this.actualWidth;
			this._photoContainer.validate();
			this._photoContainer.y = this._galleriesButtons.y + this._galleriesButtons.height + padding;

			this._cancelButton.y = this._photoContainer.y + this._photoContainer.height + padding;

			this._cancelButton.validate();
			this._submitButton.validate();
			this._backButton.validate();

			this._submitButton.y = this._cancelButton.y;
			this._cancelButton.x = padding;
			this._submitButton.x = this._cancelButton.x + this._cancelButton.width + (20 * this.dpiScale);
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Homepage Photo";
			addChild(this._header);

			initGalleryButtons();

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

		private function initGalleryButtons():void
		{
			const layout:TiledColumnsLayout = new TiledColumnsLayout();
			layout.paging = TiledColumnsLayout.PAGING_NONE;
			layout.gap = 0;
			layout.padding = 0;
			layout.horizontalAlign = TiledColumnsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = TiledColumnsLayout.VERTICAL_ALIGN_MIDDLE;
			layout.tileHorizontalAlign = TiledColumnsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			layout.tileVerticalAlign = TiledColumnsLayout.TILE_VERTICAL_ALIGN_MIDDLE;

			this._galleriesButtons = new ScrollContainer();
			this._galleriesButtons.layout = layout;
			addChild(this._galleriesButtons);

			var currGalleryButton:Button,
				galleryButtonLength:int = GALLERY_BUTTON_LABELS.length;
			for (var i:int = 0; i < galleryButtonLength; i++)
			{
				currGalleryButton = new Button();
				currGalleryButton.label = GALLERY_BUTTON_LABELS[i];
				currGalleryButton.addEventListener(Event.TRIGGERED, onOpenGallery);
				this._galleriesButtons.addChild(currGalleryButton);
			}
		}

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
		}
	}
}
