package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.Main;

	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;

	import starling.display.Image;
	import starling.textures.Texture;

	public class BadgeCell extends FeathersControl
	{
		private const IMAGE_SIZE:Number = 150;

		protected var _gap:Number;

		protected var _bg:Scale9Image;
		protected var _seperator:Image;
		protected var _scale:Number = 1;
		protected var _trophy:Image;

		protected var _badgeTextLabel:Label;
		protected var _badgeNameLabel:Label;

		private var _badgeType:String;

		public static const TWO_DAY_TYPE:String = "twoDayType";
		public static const TEN_WEEK_TYPE:String = "tenWeekType";
		public static const TWENTY_FIVE_WEEK_TYPE:String = "twentyFiveWeekType";
		public static const FIFTY_WEEK_TYPE:String = "fiftyWeekType";

		public function BadgeCell()
		{
			super();
		}

		override protected function draw():void
		{
			this._gap = 30 * this._scale;

			super.draw();

			this._seperator.width = this.actualWidth;

			this._trophy.x = this._gap;
			this._trophy.y = this._gap;

			this._badgeTextLabel.x = this._trophy.x + this._trophy.width + this._gap;
			this._badgeTextLabel.width = this.actualWidth - this._trophy.x;
			this._badgeTextLabel.validate();

			this._badgeNameLabel.x = this._trophy.x + this._trophy.width + this._gap;
			this._badgeNameLabel.width = this.actualWidth - this._trophy.x;
			this._badgeNameLabel.validate();

			var textHeight:Number = this._badgeTextLabel.height + this._badgeNameLabel.height;
			this._badgeTextLabel.y = this._gap + (this._trophy.height * 0.5) - (textHeight * 0.5);
			this._badgeNameLabel.y = this._badgeTextLabel.y + this._badgeTextLabel.height;

			setSizeInternal(this.actualWidth, this._trophy.height + (this._gap * 2), true);
		}

		override protected function initialize():void
		{
			this._seperator = new Image(Main.assets.getTexture("header_line"));
			addChild(this._seperator);

			var badgeIcon:Texture;
			var badgeText:String;
			var badgeName:String;
			switch(this._badgeType)
			{
				case TWO_DAY_TYPE :
					badgeIcon = Main.assets.getTexture("star1");
					badgeText = "Nice work.";
					badgeName = "2 days adherence";
					break;
				case TEN_WEEK_TYPE :
					badgeIcon = Main.assets.getTexture("star2");
					badgeText = "Excellent job.";
					badgeName = "10 weeks adherence";
					break;
				case TWENTY_FIVE_WEEK_TYPE :
					badgeIcon = Main.assets.getTexture("star3");
					badgeText = "Outstanding achievement!";
					badgeName = "25 weeks adherence";
					break;
				case FIFTY_WEEK_TYPE :
					badgeIcon = Main.assets.getTexture("star4");
					badgeText = "King of the Meds!";
					badgeName = "50 weeks adherence";
					break;
			}

			this._trophy = new Image(badgeIcon);
			addChild(this._trophy);
//			this._trophy.width = IMAGE_SIZE;
//			this._trophy.scaleY = this._trophy.scaleX;

			this._badgeTextLabel = new Label();
			this._badgeTextLabel.name = HivivaThemeConstants.MEDICINE_BRANDNAME_LABEL;
			this._badgeTextLabel.text = badgeText;
			this.addChild(this._badgeTextLabel);

			this._badgeNameLabel = new Label();
			this._badgeNameLabel.name = HivivaThemeConstants.CELL_SMALL_LABEL;
			this._badgeNameLabel.text = badgeName;
			this.addChild(this._badgeNameLabel);

		}

		public function set scale(value:Number):void
		{
			this._scale = value;
		}

		public function get scale():Number
		{
			return this._scale;
		}

		public function get badgeType():String
		{
			return _badgeType;
		}

		public function set badgeType(value:String):void
		{
			_badgeType = value;
		}
	}
}
