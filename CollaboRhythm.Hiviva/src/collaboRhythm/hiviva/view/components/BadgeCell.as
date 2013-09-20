package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;

	import starling.display.Image;
	import starling.textures.Texture;

	public class BadgeCell extends FeathersControl
	{
		private const IMAGE_SIZE:Number = 150;

		protected var _cellPadding:Number;
		protected var _textPadding:Number;

		protected var _bg:Scale9Image;
		protected var _seperator:Image;
		protected var _scale:Number = 1;
		protected var _trophy:Image;

		protected var _textLabel:Label;
		protected var _dateRangeLabel:Label;
		private var _text:String;
		private var _dateRange:String;

		private var _type:int;

		public static const TWO_DAY_TYPE:int = 2;
		public static const ONE_WEEK_TYPE:int = 7;
		public static const TEN_WEEK_TYPE:int = 70;
		public static const TWENTY_FIVE_WEEK_TYPE:int = 175;
		public static const FIFTY_WEEK_TYPE:int = 350;

		public function BadgeCell()
		{
			super();
		}

		override protected function draw():void
		{
			this._cellPadding = 20 * this._scale;
			this._textPadding = 35 * this._scale;

			super.draw();

			this._seperator.width = this.actualWidth;

			this._trophy.x = this._cellPadding;
			this._trophy.y = this._cellPadding;

			this._textLabel.x = this._trophy.x + this._trophy.width + this._textPadding;
			this._textLabel.width = this.actualWidth - this._textLabel.x;
			this._textLabel.validate();

			this._dateRangeLabel.x = this._trophy.x + this._trophy.width + this._textPadding;
			this._dateRangeLabel.width = this.actualWidth - this._dateRangeLabel.x;
			this._dateRangeLabel.validate();

			var textHeight:Number = this._textLabel.height + this._dateRangeLabel.height;
			this._textLabel.y = this._cellPadding + (this._trophy.height * 0.5) - (textHeight * 0.5);
			this._dateRangeLabel.y = this._textLabel.y + this._textLabel.height;

			setSizeInternal(this.actualWidth, this._trophy.height + (this._cellPadding * 2), true);
		}

		override protected function initialize():void
		{
			this._seperator = new Image(Main.assets.getTexture("header_line"));
			addChild(this._seperator);

			var badgeIcon:Texture;
			switch(this._type)
			{
				case TWO_DAY_TYPE :
					badgeIcon = Main.assets.getTexture("star0");
					break;
				case ONE_WEEK_TYPE :
					badgeIcon = Main.assets.getTexture("star1");
					break;
				case TEN_WEEK_TYPE :
					badgeIcon = Main.assets.getTexture("star2");
					break;
				case TWENTY_FIVE_WEEK_TYPE :
					badgeIcon = Main.assets.getTexture("star3");
					break;
				case FIFTY_WEEK_TYPE :
					badgeIcon = Main.assets.getTexture("star4");
					break;
			}

			this._trophy = new Image(badgeIcon);
			addChild(this._trophy);

			this._textLabel = new Label();
			this._textLabel.name = HivivaThemeConstants.MEDICINE_BRANDNAME_WHITE_LABEL;
			this._textLabel.text = _text;
			this.addChild(this._textLabel);

			this._dateRangeLabel = new Label();
			this._dateRangeLabel.name = HivivaThemeConstants.CELL_SMALL_WHITE_LABEL;
			this._dateRangeLabel.text = _dateRange;
			this.addChild(this._dateRangeLabel);

		}

		public function set scale(value:Number):void
		{
			this._scale = value;
		}

		public function get scale():Number
		{
			return this._scale;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

		public function get dateRange():String
		{
			return _dateRange;
		}

		public function set dateRange(value:String):void
		{
			_dateRange = value;
		}
	}
}
