package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.view.*;



	import feathers.controls.Screen;

	import starling.display.Image;
	import collaboRhythm.hiviva.view.media.Assets;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;


	public class HivivaHCPAllPatientsAdherenceScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _chart:Image;
		private var _usableHeight:Number;
		private var _headerHeight:Number;
		private var _footerHeight:Number;
		private var _applicationController:HivivaAppController;


		public function HivivaHCPAllPatientsAdherenceScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

		//	this._usableHeight = this.actualHeight - footerHeight;
		//	trace("usable height " + _usableHeight + " footer height " + _footerHeight)		//	this._chart.scaleX = this._bg.scaleX;
		//	this._chart.scaleY = this._bg.scaleY;
			this._chart.x = (this.actualWidth * 0.5) - (this._chart.width * 0.5);
			this._chart.y = this._header.height;
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Adherence: patients";
			this.addChild(this._header);

			this._chart = new Image(Assets.getTexture("HCPAdherenceChart"));
			addChild(this._chart);
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
