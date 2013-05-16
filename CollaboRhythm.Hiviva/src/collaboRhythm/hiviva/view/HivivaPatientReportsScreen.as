package collaboRhythm.hiviva.view
{

	import feathers.controls.Button;
	import feathers.controls.Check;
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
		private var _feelingCheck:Check;
		private var _cd4Check:Check;
		private var _viralLoadCheck:Check;
		private var _previewAndSendBtn:Button;

		public function HivivaPatientReportsScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;

			this._reportDatesLabel.y = this._header.height + 10;
			this._reportDatesLabel.x = 10;
			this._reportDatesLabel.width = 200;
			this._reportDatesLabel.validate();

			this._startLabel.y = this._reportDatesLabel.y + this._reportDatesLabel.height + 60;
			this._startLabel.x = 10
			this._startLabel.width = 200;
			this._startLabel.validate();

			this._finishLabel.y = this._startLabel.y + this._startLabel.height + 60;
			this._finishLabel.x = 10;
			this._finishLabel.width = 200;
			this._finishLabel.validate();

			this._includeLabel.y = this._finishLabel.y + this._finishLabel.height + 30;
			this._includeLabel.x = 10;
			this._includeLabel.width = 200;
			this._includeLabel.validate();

			this._adherenceCheck.width = this.actualWidth;
			this._adherenceCheck.validate();
			this._adherenceCheck.y = this._includeLabel.y + this._includeLabel.height + 20;

			this._feelingCheck.width = this.actualWidth;
			this._feelingCheck.validate();
			this._feelingCheck.y = this._adherenceCheck.y + this._adherenceCheck.height;

			this._cd4Check.width = this.actualWidth;
			this._cd4Check.validate();
			this._cd4Check.y = this._feelingCheck.y + this._feelingCheck.height;

			this._viralLoadCheck.width = this.actualWidth;
			this._viralLoadCheck.validate();
			this._viralLoadCheck.y = this._cd4Check.y + this._cd4Check.height;

			this._previewAndSendBtn.validate();
			this._previewAndSendBtn.x = this.actualWidth / 2 - this._previewAndSendBtn.width / 2;
			this._previewAndSendBtn.y = this._viralLoadCheck.y + this._viralLoadCheck.height + 20;


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

			this._adherenceCheck = new Check();
			this._adherenceCheck.isSelected = false;
			this._adherenceCheck.label = "Adherence";
			addChild(this._adherenceCheck);

			this._feelingCheck = new Check();
			this._feelingCheck.isSelected = false;
			this._feelingCheck.label = "How I am feeling";
			addChild(this._feelingCheck);

			this._cd4Check = new Check();
			this._cd4Check.isSelected = false;
			this._cd4Check.label = "CD4 count test results";
			addChild(this._cd4Check);

			this._viralLoadCheck = new Check();
			this._viralLoadCheck.isSelected = false;
			this._viralLoadCheck.label = "Viral load test results";
			addChild(this._viralLoadCheck);

			this._previewAndSendBtn = new Button();
			this._previewAndSendBtn.label = "Preview and send";
			addChild(this._previewAndSendBtn);






		}



	}
}
