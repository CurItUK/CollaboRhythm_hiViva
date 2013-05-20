package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Screen;

	import starling.display.Image;

	public class HivivaPatientClockScreen extends Screen
	{

		private var IMAGE_SIZE:Number;
		private var _clockFace:Image;
		private var _usableHeight:Number;
		private var _footerHeight:Number;
		private var _headerHeight:Number;

		public function HivivaPatientClockScreen()
		{

		}

		override protected function draw():void
		{

			IMAGE_SIZE = this.actualWidth * 0.9;

			this._usableHeight = this.actualHeight - footerHeight - headerHeight;
			trace("HivivaPatientClockScreen _usableHeight " + headerHeight);

			this._clockFace.width = IMAGE_SIZE;
			this._clockFace.scaleY = this._clockFace.scaleX;

			this._clockFace.x = (this.actualWidth * 0.5) - (this._clockFace.width * 0.5);
			this._clockFace.y = (this._usableHeight * 0.5) + headerHeight - (this._clockFace.height * 0.5);

		}

		override protected function initialize():void
		{
			this._clockFace = new Image(Assets.getTexture("ClockFacePng"));
			addChild(this._clockFace);



		}

		public function get footerHeight():Number
		{
			return _footerHeight;
		}

		public function set footerHeight(value:Number):void
		{
			_footerHeight = value;
		}

		public function get headerHeight():Number
		{
			return _headerHeight;
		}

		public function set headerHeight(value:Number):void
		{
			_headerHeight = value;
		}
	}
}
