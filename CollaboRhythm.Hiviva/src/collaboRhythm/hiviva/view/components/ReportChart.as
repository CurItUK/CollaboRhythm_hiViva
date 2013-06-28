package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;

	import feathers.core.FeathersControl;

	import starling.display.BlendMode;
	import starling.display.Image;

	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.utils.deg2rad;

	public class ReportChart extends FeathersControl
	{
		private var _patientData:XML;
		// adherence, tolerability
		private var _dataCategory:String;
		private var _startDate:Date;
		private var _endDate:Date;
		private var _dayTotal:Number;
		private var _lowestValue:Number;
		private var _valueData:Array;
		private var _valueRange:Number;

		private const LINE_COLOURS:Array = [0x2e445e,0x0b88ec,0xc20315,0x697a8f,0xffffff,0x000000];
		private var _patientAdherence:Array = [];

		private var _leftAxisSpace:Number;
		private var _rightPadding:Number;
		private var _vPadding:Number;
		private var _chartWidth:Number;
		private var _chartHeight:Number;
		private var _chartStartX:Number;
		private var _chartStartY:Number;
		private var _horizontalSegmentWidth:Number;
		private var _bottomAxisValueHeight:Number;

		public function ReportChart()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._leftAxisSpace = this.actualWidth * 0.2;
			//var leftPadding:Number = this.actualWidth * 0;
			this._rightPadding = this.actualWidth * 0.05;
			this._vPadding = this.actualHeight * 0.02;
			this._chartWidth = this.actualWidth - this._leftAxisSpace - this._rightPadding;
			this._chartHeight = this.actualHeight * 0.75;
			this._chartStartX = this._leftAxisSpace;
			this._chartStartY = this._vPadding;
			this._horizontalSegmentWidth = this._chartWidth / (_dayTotal - 1);
		}

		override protected function initialize():void
		{
			super.initialize();
		}

		public function drawChart():void
		{
			this._dayTotal = HivivaModifier.getDaysDiff(this._endDate,this._startDate);

			populatePatientData();
			initChartTitleLabel();
			initBackground();
			initLeftAxisLabels();
			initLeftAxisLines();
		}

		private function populatePatientData():void
		{
			var daysItar:Date;
			var valueData:Number;
			this._lowestValue = 100;

			daysItar = new Date(this._startDate.getFullYear(),this._startDate.getMonth(),this._startDate.getDate(),0,0,0,0);
			for (var i:int = 0; i < _dayTotal; i++)
			{
				valueData = this._dataCategory == "adherence" ? HivivaModifier.getPatientAdherenceByDate(_patientData, daysItar) : HivivaModifier.getPatientTolerabilityByDate(_patientData, daysItar);
				daysItar.date++;
				this._valueData.push(valueData);
			}
			trace(this._valueData.join(","));

			// round down to the closest 10
			this._lowestValue = Math.floor(this._lowestValue / 10) * 10;
			this._valueRange = 100 - this._lowestValue;
		}

		private function initChartTitleLabel():void
		{
			var chartTitleLabel:Label = new Label();
			chartTitleLabel.name = "centered-label";
			chartTitleLabel.text = "<font face='ExoBold'>Overall " + (this._dataCategory == "adherence" ? "Adherence" : "Tolerability") + "</font>";
			addChild(chartTitleLabel);
			chartTitleLabel.x = this._chartStartX;
			chartTitleLabel.y = this._chartStartY;
			chartTitleLabel.width = this._chartWidth;
			chartTitleLabel.validate();
			this._chartStartY += chartTitleLabel.height;
		}

		private function initBackground():void
		{
			var chartBg:Quad = new Quad(this._chartWidth, this._chartHeight, 0x4c5f76);
			chartBg.alpha = 0.25;
			chartBg.blendMode = BlendMode.MULTIPLY;
			addChild(chartBg);
			chartBg.x = this._chartStartX;
			chartBg.y = this._chartStartY;
		}

		private function initLeftAxisLabels():void
		{
			var leftAxisTop:Label = new Label();
			leftAxisTop.name = "centered-label";
			leftAxisTop.text = "<font face='ExoBold'>100%</font>";
			addChild(leftAxisTop);
			leftAxisTop.width = this._leftAxisSpace;
			leftAxisTop.validate();
//			leftAxisTop.x = leftPadding;
			leftAxisTop.y = this._chartStartY - (leftAxisTop.height * 0.5);

			var leftAxisBottom:Label = new Label();
			leftAxisBottom.name = "centered-label";
			leftAxisBottom.text = "<font face='ExoBold'>" + this._lowestValue + "%</font>";
			addChild(leftAxisBottom);
			leftAxisBottom.width = this._leftAxisSpace;
			leftAxisBottom.validate();
//			leftAxisBottom.x = leftPadding;
			leftAxisBottom.y = this._chartStartY + this._chartHeight - (leftAxisBottom.height * 0.5);

			var leftAxisLabel:Label = new Label();
			leftAxisLabel.name = "centered-label";
			leftAxisLabel.text = "<font face='ExoBold'>Adherence</font>";
			addChild(leftAxisLabel);
			leftAxisLabel.width = 400;
			leftAxisLabel.validate();
			leftAxisLabel.rotation = deg2rad(-90);
			leftAxisLabel.x = leftAxisTop.x + (leftAxisTop.width * 0.5) - (leftAxisLabel.height * 0.5);
			leftAxisLabel.y = this._chartStartY + (this._chartHeight * 0.5) + (leftAxisLabel.width * 0.5);
		}

		private function initLeftAxisLines():void
		{
			var horizLineTexture:Texture = Main.assets.getTexture("header_line");
			var horizontalLine:Image;
			var verticalSegmentLength:Number = this._valueRange / 10;
			var verticalSegmentHeight:Number = this._chartHeight / verticalSegmentLength;
			for (var verticalSegmentCount:int = 0; verticalSegmentCount < verticalSegmentLength; verticalSegmentCount++)
			{
				horizontalLine = new Image(horizLineTexture);
				addChild(horizontalLine);
				horizontalLine.x = this._chartStartX;
				horizontalLine.y = this._chartStartY + (verticalSegmentHeight * verticalSegmentCount);
				horizontalLine.width = this._chartWidth;
			}
		}
		private function initBottomAxisValuesAndLines():void
		{
			var vertLineTexture:Texture = Assets.getTexture("VerticleLinePng");
			var verticalLine:Image;
			var bottomAxisValue:Label;
			var evenLighter:Quad;
			var xAxisPosition:Number;
			var daysItar:Date = new Date(this._startDate.getFullYear(),this._startDate.getMonth(),this._startDate.getDate(),0,0,0,0);
			for (var dayCount:int = 0; dayCount < _dayTotal; dayCount++)
			{
				xAxisPosition = this._horizontalSegmentWidth * dayCount;

				bottomAxisValue = new Label();
				bottomAxisValue.name = "patient-data-lighter";
				bottomAxisValue.text = HivivaModifier.addPrecedingZero((daysItar.getMonth() + 1).toString()) + "/" +
						HivivaModifier.addPrecedingZero(daysItar.getDate().toString());
				addChild(bottomAxisValue);
				bottomAxisValue.validate();
				bottomAxisValue.x = this._chartStartX + xAxisPosition;
				if (dayCount == (_dayTotal - 1))
				{
					bottomAxisValue.x -= bottomAxisValue.width;
				}
				else if (dayCount > 0)
				{
					bottomAxisValue.x -= bottomAxisValue.width * 0.5;
				}
				bottomAxisValue.y = this._chartStartY + this._chartHeight;

				daysItar.date++;

				verticalLine = new Image(vertLineTexture);
				addChild(verticalLine);
				verticalLine.x = this._chartStartX + xAxisPosition;
				verticalLine.y = this._chartStartY;
				verticalLine.height = this._chartHeight;
				// ever even segment
				if ((dayCount / 2).toString().indexOf('.') > -1 && dayCount < (_dayTotal - 1))
				{
					evenLighter = new Quad(this._horizontalSegmentWidth, this._chartHeight, 0xffffff);
					evenLighter.alpha = 0.2;
					addChild(evenLighter);
					evenLighter.x = this._chartStartX + xAxisPosition;
					evenLighter.y = this._chartStartY;
				}
			}
			this._bottomAxisValueHeight = bottomAxisValue.height;
		}

		public function get dataCategory():String
		{
			return _dataCategory;
		}

		public function set dataCategory(value:String):void
		{
			_dataCategory = value;
		}

		public function get startDate():Date
		{
			return _startDate;
		}

		public function set startDate(value:Date):void
		{
			_startDate = value;
		}

		public function get endDate():Date
		{
			return _endDate;
		}

		public function set endDate(value:Date):void
		{
			_endDate = value;
		}

		public function get patientData():XML
		{
			return _patientData;
		}

		public function set patientData(value:XML):void
		{
			_patientData = value;
		}
	}
}
