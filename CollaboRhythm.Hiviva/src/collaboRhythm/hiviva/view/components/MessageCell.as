package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.view.media.Assets;
	import collaboRhythm.hiviva.view.Main;
	import feathers.controls.Label;

	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	import flash.geom.Rectangle;

	import starling.display.Image;

	import starling.display.Quad;
	import feathers.controls.Check;

	public class MessageCell extends FeathersControl
	{
		private const IMAGE_SIZE:Number = 100;

		protected var _gap:Number;

		protected var _bg:Scale9Image;
		protected var _seperator:Image;
		protected var _scale:Number;
		protected var _messageImageBg:Quad;
		protected var _messageImage:Image;

		protected var _messageNameLabel:Label;
		protected var _messageName:String;
		protected var _messageIcon:String;

		private var _checkBox:Check;

		public function MessageCell()
		{
			super();
		}

		override protected function draw():void
		{
			this._gap = 15 * this._scale;

			super.draw();

			this._seperator.width = this.actualWidth;

			this._checkBox.validate();
			this._checkBox.padding = 0;
			this._checkBox.x = this._gap;
			this._checkBox.y = this._checkBox.width + this._messageImageBg.y + this._gap*2;

			//this._isChanged = false;

			this._messageNameLabel.validate();

			this._messageImageBg.x = this._checkBox.width + this._gap;
			this._messageImageBg.y = this._checkBox.width + this._gap;

			this._messageImage.x = this._checkBox.width + this._gap +(this._messageImageBg.width - this._messageImage.width)/2;
			this._messageImage.y = this._checkBox.width + this._gap + (this._messageImageBg.height - this._messageImage.height)/2;

			this._messageNameLabel.x = this._checkBox.width + this._messageImageBg.x + this._messageImageBg.width + this._gap;
			this._messageNameLabel.y = this._checkBox.width + this._messageImageBg.y + this._gap*2;
			this._messageNameLabel.width = this.actualWidth - this._messageImageBg.x;

			setSizeInternal(this.actualWidth, this._messageImageBg.height + (this._gap * 2), true);
		}

		override protected function initialize():void
		{
			this._checkBox = new Check();
			addChild(this._checkBox);

			this._seperator = new Image(Main.assets.getTexture('header_line'));
			addChild(this._seperator);

			this._messageImageBg = new Quad(IMAGE_SIZE * this._scale, IMAGE_SIZE * this._scale, 0x000000);
			this._messageImageBg.visible = false;
			addChild(this._messageImageBg);

			this._messageImage = new Image(Main.assets.getTexture('star1'));
		//	addChild(this._messageImage);

			this._messageNameLabel = new Label();
			this._messageNameLabel.text = "<font face='ExoBold'>" + this._messageName + "</font>";
			this.addChild(this._messageNameLabel);

		}

		public function set messageName(value:String):void
		{
			this._messageName = value;
		}

		public function get messagebadgeName():String
		{
			return this._messageName;
		}

		public function set messageIcon(value:String):void
		{
			this._messageIcon = value;
		}

		public function get messageIcon():String
		{
			return this._messageIcon;
		}

		public function get checkBox():Check
		{
			return _checkBox;
		}

		public function set checkBox(value:Check):void
		{
			_checkBox = value;
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
