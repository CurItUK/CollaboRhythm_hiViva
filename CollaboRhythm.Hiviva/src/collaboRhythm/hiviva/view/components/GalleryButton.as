package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.view.Main;

	import feathers.controls.Button;

	import starling.display.Image;

	public class GalleryButton extends Button
	{
		private var _category:String;
		private var _imageSelectedCount:int;
		private var _superScript:SuperscriptCircle;
		private var _defaultIcon:Image;

		private var _leftPadding:Number;
		private var _rightPadding:Number;

		public function GalleryButton()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			var w:Number = this.actualWidth;
			var h:Number = this.actualHeight;

			this._leftPadding = w * 0.1;
			this._rightPadding = w * 0.05;

			this._defaultIcon.x = this._leftPadding;
			this._defaultIcon.y = (h * 0.5) - (this._defaultIcon.height * 0.5);

			if(_imageSelectedCount > 0)
			{
				this._superScript.validate();
				this._superScript.x = w - this._rightPadding - this._superScript.width;
				this._superScript.y = (h * 0.5) - (this._superScript.height * 0.5);
			}
		}

		override protected function initialize():void
		{
			super.initialize();

			iconPosition = ICON_POSITION_LEFT;
			label = this._category;

			switch(this._category)
			{
				case "SPORT" :
					this._defaultIcon = new Image(Main.assets.getTexture("icon_sports"));
					break;
				case "MUSIC" :
					this._defaultIcon = new Image(Main.assets.getTexture("icon_music"));
					break;
				case "CINEMA" :
					this._defaultIcon = new Image(Main.assets.getTexture("icon_cinema"));
					break;
				case "HISTORY" :
					this._defaultIcon = new Image(Main.assets.getTexture("icon_history"));
					break;
				case "TRAVEL" :
					this._defaultIcon = new Image(Main.assets.getTexture("icon_travel"));
					break;
				case "ART" :
					this._defaultIcon = new Image(Main.assets.getTexture("icon_art"));
					break;
			}

			this.addChild(this._defaultIcon);

			if(_imageSelectedCount > 0)
			{
				this._superScript = new SuperscriptCircle();
				this._superScript.scale = 5;
				this._superScript.text = String(this._imageSelectedCount);
				addChild(this._superScript);
			}
		}

		public function get category():String
		{
			return _category;
		}

		public function set category(value:String):void
		{
			_category = value;
		}

		public function get imageSelectedCount():int
		{
			return _imageSelectedCount;
		}

		public function set imageSelectedCount(value:int):void
		{
			_imageSelectedCount = value;
		}
	}
}
