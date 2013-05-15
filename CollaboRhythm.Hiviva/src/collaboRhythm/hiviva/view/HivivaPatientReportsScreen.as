package collaboRhythm.hiviva.view
{

	import feathers.controls.Check;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;


	public class HivivaPatientReportsScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _startLabel:Label;
		private var _finishLabel:Label;
		private var _reportDatesLabel:Label;
		private var _includeLabel:Label;
		private var _adherenceCheck:Check;

		public function HivivaPatientReportsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._reportDatesLabel.y = this._header.height + 30;
			this._reportDatesLabel.x = 10;
			this._reportDatesLabel.width = 200;

			this._startLabel.y = this._reportDatesLabel.y + this._reportDatesLabel.height + 60;
			this._startLabel.x = 10
			this._startLabel.width = 200;

			this._finishLabel.y = this._startLabel.y + this._startLabel.height + 60;
			this._finishLabel.x = 10;
			this._finishLabel.width = 200;

			this._includeLabel.y = this._finishLabel.y + this._finishLabel.height + 60;
			this._includeLabel.x = 10;
			this._includeLabel.width = 200;

		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Generate Reports";
			this.addChild(this._header);

			this._reportDatesLabel = new Label();
			this._reportDatesLabel.text = "Report dates";
			this.addChild(this._reportDatesLabel);

			this._startLabel = new Label();
			this._startLabel.text = "Start";
			this.addChild(this._startLabel);

			this._finishLabel = new Label();
			this._finishLabel.text = "Finish";
			this.addChild(this._finishLabel);

			this._includeLabel = new Label();
			this._includeLabel.text = "Include";
			this.addChild(this._includeLabel);

			/*this._adherenceCheck = new Check();
			this._updatesCheck.isSelected = false;
						this._updatesCheck.label = "Send me updates";
						addChild(this._updatesCheck);

						*/





		}


	}
}
