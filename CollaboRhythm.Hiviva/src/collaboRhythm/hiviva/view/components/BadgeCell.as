package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;

	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	import flash.geom.Rectangle;

	import starling.display.Image;

	import starling.display.Quad;

	public class BadgeCell extends FeathersControl
	{
		private const IMAGE_SIZE:Number = 100;

		protected var _gap:Number;

		protected var _bg:Scale9Image;
		protected var _seperator:Image;
		protected var _scale:Number;
		protected var _pillImageBg:Quad;

		protected var _badgeNameLabel:Label;
		protected var _badgeName:String;

		protected var _dateRangeLabel:Label;
		protected var _dateRange:String;


		public function BadgeCell()
		{
			super();
		}

		override protected function draw():void
		{
			this._gap = 15 * this._scale;

			super.draw();

			this._seperator.width = this.actualWidth;

			this._badgeNameLabel.validate();
			this._dateRangeLabel.validate();
			//trace("this._genericNameLabel " + this._genericNameLabel.height);

			this._pillImageBg.x = this._gap;
			this._pillImageBg.y = this._gap;

			this._badgeNameLabel.x = this._pillImageBg.x + this._pillImageBg.width + this._gap;
			this._badgeNameLabel.y = this._pillImageBg.y;
			this._badgeNameLabel.width = this.actualWidth - this._pillImageBg.x;

			this._dateRangeLabel.x = this._pillImageBg.x + this._pillImageBg.width + this._gap;
			this._dateRangeLabel.y = this._badgeNameLabel.y + this._badgeNameLabel.height;
			this._dateRangeLabel.width = this.actualWidth - this._pillImageBg.x;


			setSizeInternal(this.actualWidth, this._pillImageBg.height + (this._gap * 2), true);
		}

		override protected function initialize():void
		{
			this._seperator = new Image(Assets.getTexture(HivivaAssets.HEADER_LINE));
			addChild(this._seperator);

			this._pillImageBg = new Quad(IMAGE_SIZE * this._scale, IMAGE_SIZE * this._scale, 0x000000);
			addChild(this._pillImageBg);

			this._badgeNameLabel = new Label();
			this._badgeNameLabel.text = "<font face='ExoBold'>" + this._badgeName + "</font>";
			this.addChild(this._badgeNameLabel);

			this._dateRangeLabel = new Label();
			this._dateRangeLabel.text = this.dateRange;
			this._dateRangeLabel.name = "message-date-label";
			this.addChild(this._dateRangeLabel);

		}

		public function set badgeName(value:String):void
		{
			this._badgeName = value;
		}

		public function get badgeName():String
		{
			return this._badgeName;
		}

		public function set dateRange(value:String):void
		{
			this._dateRange = value;
		}

		public function get dateRange():String
		{
			return this._dateRange;
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
