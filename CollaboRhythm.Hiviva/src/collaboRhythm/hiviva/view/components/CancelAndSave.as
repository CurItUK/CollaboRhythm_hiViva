package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaAssets;

	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	import flash.geom.Rectangle;

	import starling.events.Event;

	public class CancelAndSave extends FeathersControl
	{
		private var _bg:Scale9Image;
		private var _cancel:Button;
		private var _save:Button;
		private var _cancelLabel:String = "Cancel";
		private var _submitLabel:String = "Save";
		private var _scale:Number;

		public function CancelAndSave()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			var gap:Number = (this.actualWidth * 0.02) * this._scale;
			var minButtonWidth:Number = (this.actualWidth * 0.25) * this._scale;

			this._cancel.validate();
			this._save.validate();

			this._cancel.width = this._cancel.width < minButtonWidth ? minButtonWidth : this._cancel.width;
			this._save.width = this._save.width < minButtonWidth ? minButtonWidth : this._save.width;

			this._bg.width = this.actualWidth;
			this._bg.height = this._cancel.height * 1.8;

			this._cancel.x = (this.actualWidth * 0.5) - ((this._cancel.width + gap + this._save.width) * 0.5);
			this._save.x = this._cancel.x + this._cancel.width + gap;
			this._cancel.y = this._save.y = (this._bg.height * 0.5) - (this._cancel.height * 0.5);

			setSizeInternal(this._bg.width, this._bg.height, true);
		}

		override protected function initialize():void
		{
			super.initialize();

			var bgTexture:Scale9Textures = new Scale9Textures(HivivaAssets.INPUT_FIELD, new Rectangle(11,11,32,32));
			this._bg = new Scale9Image(bgTexture, this._scale);
			this._bg.touchable = false;
			addChild(this._bg);

			this._cancel = new Button();
			this._cancel.addEventListener(Event.TRIGGERED, cancelHandler);
			this._cancel.label = this._cancelLabel;
			addChild(this._cancel);

			this._save = new Button();
			this._save.addEventListener(Event.TRIGGERED, saveHandler);
			this._save.label = this._submitLabel;
			addChild(this._save);
		}

		private function cancelHandler(e:Event):void
		{
			dispatchEventWith(Event.TRIGGERED, false, {button:"cancel"});
		}

		private function saveHandler(e:Event):void
		{
			dispatchEventWith(Event.TRIGGERED, false, {button:"save"});
		}

		public function get cancelLabel():String
		{
			return _cancelLabel;
		}

		public function set cancelLabel(value:String):void
		{
			_cancelLabel = value;
		}

		public function get submitLabel():String
		{
			return _submitLabel;
		}

		public function set submitLabel(value:String):void
		{
			_submitLabel = value;
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
		}
	}
}
