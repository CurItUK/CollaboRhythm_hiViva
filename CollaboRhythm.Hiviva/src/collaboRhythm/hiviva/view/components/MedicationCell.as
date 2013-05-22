package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaAssets;

	import feathers.controls.Label;

	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	import flash.geom.Rectangle;

	import starling.display.Quad;

	public class MedicationCell extends FeathersControl
	{

		private const PADDING:Number = 32;
		private const IMAGE_SIZE:Number = 100;

		protected var _scaledPadding:Number;
		protected var _gap:Number;

		protected var _bg:Scale9Image;
		protected var _scale:Number;
		protected var _pillImageBg:Quad;

		protected var _brandNameLabel:Label;
		protected var _brandName:String;

		protected var _genericNameLabel:Label;
		protected var _genericName:String;


		public function MedicationCell()
		{
			super();
		}

		override protected function draw():void
		{
			this._scaledPadding = PADDING * this._scale;
			this._gap = this._scaledPadding * 0.5;

			super.draw();

			this._brandNameLabel.validate();
			this._genericNameLabel.validate();

			this._bg.x = this._scaledPadding;
			this._bg.width = this.actualWidth - (this._scaledPadding * 2);
			this._bg.height = this._pillImageBg.height + this._scaledPadding;
			//trace("this._genericNameLabel " + this._genericNameLabel.height);

			this._pillImageBg.x = this._bg.x + this._gap;
			this._pillImageBg.y = this._bg.y + this._gap;

			this._brandNameLabel.x = this._pillImageBg.x + this._pillImageBg.width + this._gap;
			this._brandNameLabel.y = this._pillImageBg.y;
			this._brandNameLabel.width = this._bg.width - this._pillImageBg.x;

			this._genericNameLabel.x = this._pillImageBg.x + this._pillImageBg.width + this._gap;
			this._genericNameLabel.y = this._brandNameLabel.y + this._brandNameLabel.height;
			this._genericNameLabel.width = this._bg.width - this._pillImageBg.x;


			setSizeInternal(this.actualWidth, this._bg.height, true);
		}

		override protected function initialize():void
		{
			var bgTexture:Scale9Textures = new Scale9Textures(HivivaAssets.INPUT_FIELD, new Rectangle(11, 11, 32, 32));
			this._bg = new Scale9Image(bgTexture, this._scale);
			addChild(this._bg);

			this._pillImageBg = new Quad(IMAGE_SIZE * this._scale, IMAGE_SIZE * this._scale, 0x000000);
			addChild(this._pillImageBg);

			this._brandNameLabel = new Label();
			this._brandNameLabel.text = this._brandName;
			this.addChild(this._brandNameLabel);

			this._genericNameLabel = new Label();
			this._genericNameLabel.text = this.genericName;
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