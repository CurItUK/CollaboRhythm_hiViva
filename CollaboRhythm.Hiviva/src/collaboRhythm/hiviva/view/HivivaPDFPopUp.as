package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaAssets;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.ScrollText;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;

	import starling.events.Event;

	public class HivivaPDFPopUp extends FeathersControl
	{

		private var _bg:Scale9Image;
		private var _scale:Number;

		private const PADDING:Number = 40;
		private const GAP:Number = 20;

		private var _cancelBtn:Button
		private var _mailBtn:Button;

		public function HivivaPDFPopUp()
		{
			super();
		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this._scale;
			var scaledGap:Number = GAP * this._scale;
			var fullHeight:Number;

			super.draw();

			this._cancelBtn.x = 20;
			this._cancelBtn.validate();
			this._cancelBtn.y = this.actualHeight - this._cancelBtn.height - 20;

			this._mailBtn.validate();
			this._mailBtn.x = this.actualWidth - this._mailBtn.width - 20;
			this._mailBtn.y = this._cancelBtn.y;



		}

		override protected function initialize():void
		{
			super.initialize();

			this._cancelBtn = new Button();
			this._cancelBtn.label = "Cancel";
			this._cancelBtn.addEventListener(starling.events.Event.TRIGGERED, cancelBtnHandler);
			this.addChild(this._cancelBtn);


			this._mailBtn = new Button();
			this._mailBtn.label = "Send mail";
			this._mailBtn.addEventListener(starling.events.Event.TRIGGERED, mailBtnHandler);
			this.addChild(this._mailBtn);


		}

		private function cancelBtnHandler(e:starling.events.Event):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}

		private function mailBtnHandler(e:starling.events.Event):void
		{
			this.dispatchEventWith("sendMail");
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
