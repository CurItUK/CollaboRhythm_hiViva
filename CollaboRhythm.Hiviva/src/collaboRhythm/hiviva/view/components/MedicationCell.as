package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.Main;

	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;

	import starling.display.Image;
	import starling.display.Quad;

	public class MedicationCell extends FeathersControl
	{
		private const IMAGE_SIZE:Number = 100;

		protected var _gap:Number;

		protected var _bg:Scale9Image;
		protected var _seperator:Image;
		protected var _scale:Number = 1;
		protected var _pillImageBg:Quad;

		protected var _brandNameLabel:Label;
		protected var _brandName:String;

		protected var _genericNameLabel:Label;
		protected var _genericName:String;

		protected var _theme:String;
		public static const WHITE_THEME:String = "whiteTheme";
		public static const DARK_THEME:String = "darkTheme";
		public static const WHITE_THEME_LITE:String = "whiteLiteTheme";


		public function MedicationCell(theme:String = MedicationCell.WHITE_THEME)
		{
			_theme = theme;
			super();
		}

		override protected function draw():void
		{
			this._gap = 15 * this._scale;

			super.draw();

			this._seperator.width = this.actualWidth;

			//trace("this._genericNameLabel " + this._genericNameLabel.height);

			this._pillImageBg.x = this._gap;
			this._pillImageBg.y = this._gap;

			this._brandNameLabel.validate();
			this._brandNameLabel.x = this._pillImageBg.x + this._pillImageBg.width + this._gap;
			this._brandNameLabel.width = this.actualWidth - this._brandNameLabel.x - this._gap;
			this._brandNameLabel.y = this._gap;

			this._genericNameLabel.width = this._brandNameLabel.width;
			positionGenericLabel();

			setSizeInternal(this.actualWidth, this._genericNameLabel.y + this._genericNameLabel.height + this._gap, false);
		}

		protected function positionGenericLabel():void
		{
			this._brandNameLabel.validate();
			this._genericNameLabel.validate();
			this._genericNameLabel.x = this._brandNameLabel.x;
			this._genericNameLabel.y = this._brandNameLabel.y + this._brandNameLabel.height;
		}

		override protected function initialize():void
		{
			super.initialize();

			this._seperator = new Image(Main.assets.getTexture("header_line"));
			addChild(this._seperator);

			//TODO insert correct images for beta?
			//this._pillImageBg = new Quad(IMAGE_SIZE * this._scale, IMAGE_SIZE * this._scale, 0x000000);
			this._pillImageBg = new Quad(0 , IMAGE_SIZE * this._scale, 0x000000);
			addChild(this._pillImageBg);

			this._brandNameLabel = new Label();
//			this._brandNameLabel.name = HivivaThemeConstants.MEDICINE_BRANDNAME_LABEL;
			this._brandNameLabel.text = this._brandName;

			this._genericNameLabel = new Label();
//			this._genericNameLabel.name = HivivaThemeConstants.CELL_SMALL_LABEL;
			this._genericNameLabel.text = this._genericName;


			switch(_theme)
			{
				case MedicationCell.WHITE_THEME :
					this._brandNameLabel.name = HivivaThemeConstants.MEDICINE_BRANDNAME_WHITE_LABEL;
					this._genericNameLabel.name = HivivaThemeConstants.CELL_SMALL_WHITE_LABEL;
					break;
				case MedicationCell.DARK_THEME :
					this._brandNameLabel.name = HivivaThemeConstants.MEDICINE_BRANDNAME_DARK_LABEL;
					this._genericNameLabel.name = HivivaThemeConstants.CELL_SMALL_DARK_LABEL;
					break;
				 case MedicationCell.WHITE_THEME_LITE :
					 this._brandNameLabel.name = HivivaThemeConstants.MEDICINE_BRANDNAME_WHITE_LABEL;
					// this._genericNameLabel.name = HivivaThemeConstants.CELL_SMALL_WHITE_LABEL;
				 break;
			}




			this.addChild(this._brandNameLabel);
			this.addChild(this._genericNameLabel);

		}

		public function set brandName(value:String):void
		{
			this._brandName = value;
		}

		public function get brandName():String
		{
			return this._brandName;
		}

		public function set genericName(value:String):void
		{
			this._genericName = value;
		}

		public function get genericName():String
		{
			return this._genericName;
		}


		public function set scale(value:Number):void
		{
			this._scale = value;
		}

		public function get scale():Number
		{
			return this._scale;
		}
	}
}
