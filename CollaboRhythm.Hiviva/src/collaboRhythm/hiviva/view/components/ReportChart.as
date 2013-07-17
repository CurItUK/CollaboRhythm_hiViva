package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;

	import feathers.core.FeathersControl;
	import feathers.display.TiledImage;

	import starling.display.BlendMode;
	import starling.display.Image;

	import starling.display.Quad;
	import starling.display.Shape;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;

	public class ReportChart extends FeathersControl
	{
		private var _patientData:XMLList;
		// adherence, tolerability
		private var _dataCategory:String;
		private var _startDate:Date;
		private var _endDate:Date;
		private var _dayTotal:Number;
		private var _lowestValue:Number;
		private var _valueData:Array = [];
		private var _valueRange:Number;

		private const LINE_COLOURS:Array = [0x2e445e,0x0b88ec,0xc20315,0x697a8f,0xffffff,0x000000];

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
		}

		override protected function initialize():void
		{
			super.initialize();
		}

		public function drawChart():void
		{
			this._dayTotal = HivivaModifier.getDaysDiff(this._endDate,this._startDate) + 1;
			this._horizontalSegmentWidth = this._chartWidth / (_dayTotal - 1);

			// tiled background here to compensate for no transparency on the draw
			initTiledBackground();

			populatePatientData();
			initChartTitleLabel();
			initBackground();
			initLeftAxisLabels();
			initLeftAxisLines();
			initBottomAxisValuesAndLines();
//			initBottomAxisLabels();
			drawPlotPoints();
		}

		private function initTiledBackground():void
		{
			var screenBase:TiledImage = new TiledImage(Main.assets.getTexture("screen_base"));

			screenBase.width = this.actualWidth;
			screenBase.height = this.actualHeight;
			screenBase.smoothing = TextureSmoothing.NONE;
			screenBase.touchable = false;
			//screenBase.flatten();
			addChild(screenBase);
		}

		private function populatePatientData():void
		{
			var daysItar:Date;
			var referenceDate:Date;
			var valueData:Number;
			var medicationSchedule:XMLList;
			var medicationScheduleLength:int;

			this._lowestValue = 100;

			daysItar = new Date(this._startDate.getFullYear(),this._startDate.getMonth(),this._startDate.getDate(),0,0,0,0);
			for (var i:int = 0; i < _dayTotal; i++)
			{
				for (var j:int = 0; j < _patientData.length(); j++)
				{
					medicationSchedule = _patientData[j].Schedule.DCMedicationSchedule;
					medicationScheduleLength = medicationSchedule.length();
					for (var k:int = 0; k < medicationScheduleLength; k++)
					{
						referenceDate = HivivaModifier.isoDateToFlashDate(String(medicationSchedule[k].DateTaken));
						if(daysItar.getTime() == referenceDate.getTime())
						{
							valueData = int(medicationSchedule[k].PercentTaken);
							if(this._lowestValue > valueData/* && valueData > 0*/)
							{
								this._lowestValue = valueData;
							}
							daysItar.date++;
							this._valueData.push(valueData);
						}
					}
				}
			}
			trace(this._valueData.join(","));

			// round down to the closest 10
			this._lowestValue = Math.floor(this._lowestValue / 10) * 10;
			this._valueRange = 100 - this._lowestValue;
		}

		private function initChartTitleLabel():void
		{
			var chartTitleLabel:Label = new Label();
			chartTitleLabel.name = HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL;
			chartTitleLabel.text = "Overall " + (this._dataCategory == "adherence" ? "Adherence" : "Tolerability");
			addChild(chartTitleLabel);
			chartTitleLabel.x = this._chartStartX;
			chartTitleLabel.y = this._chartStartY;
			chartTitleLabel.width = this._chartWidth;
			chartTitleLabel.validate();
			// * 1.5 for padding
			this._chartStartY += (chartTitleLabel.height * 1.5);
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
			leftAxisTop.name = HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL;
			leftAxisTop.text = "100%";
			addChild(leftAxisTop);
			leftAxisTop.width = this._leftAxisSpace;
			leftAxisTop.validate();
//			leftAxisTop.x = leftPadding;
			leftAxisTop.y = this._chartStartY - (leftAxisTop.height * 0.5);

			var leftAxisBottom:Label = new Label();
			leftAxisBottom.name = HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL;
			leftAxisBottom.text = this._lowestValue + "%";
			addChild(leftAxisBottom);
			leftAxisBottom.width = this._leftAxisSpace;
			leftAxisBottom.validate();
//			leftAxisBottom.x = leftPadding;
			leftAxisBottom.y = this._chartStartY + this._chartHeight - (leftAxisBottom.height * 0.5);

			var leftAxisLabel:Label = new Label();
			leftAxisLabel.name = HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL;
			leftAxisLabel.text = this._dataCategory == "adherence" ? "Adherence" : "Tolerability";
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
				bottomAxisValue.rotation = deg2rad(-90);
				bottomAxisValue.x = this._chartStartX + (xAxisPosition - (bottomAxisValue.height * 0.5));
				// + 4 for padding
				bottomAxisValue.y = this._chartStartY + this._chartHeight + bottomAxisValue.width + 10;

				daysItar.date++;

				verticalLine = new Image(vertLineTexture);
				addChild(verticalLine);
				verticalLine.x = this._chartStartX + xAxisPosition;
				verticalLine.y = this._chartStartY;
				verticalLine.height = this._chartHeight;
				// every even segment
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

		private function initBottomAxisLabels():void
		{
			var bottomAxisLabel:Label = new Label();
			bottomAxisLabel.name = HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL;
			bottomAxisLabel.text = "Week commencing (2013)";
			addChild(bottomAxisLabel);
			bottomAxisLabel.x = this._chartStartX;
			bottomAxisLabel.y = this._chartStartY + this._chartHeight + this._bottomAxisValueHeight;
			bottomAxisLabel.width = this._chartWidth;
			bottomAxisLabel.validate();

			var bottomAxisGrad:Quad = new Quad(this._chartWidth, this._bottomAxisValueHeight + bottomAxisLabel.height);
			bottomAxisGrad.setVertexColor(0, 0xFFFFFF);
			bottomAxisGrad.setVertexColor(1, 0xFFFFFF);
			bottomAxisGrad.setVertexColor(2, 0x293d54);
			bottomAxisGrad.setVertexColor(3, 0x293d54);
			bottomAxisGrad.alpha = 0.2;
			addChild(bottomAxisGrad);
			bottomAxisGrad.x = this._chartStartX;
			bottomAxisGrad.y = this._chartStartY + this._chartHeight;
		}

		private function drawPlotPoints():void
		{
			var fullValueHeight:Number = this._chartHeight * (100 / this._valueRange);
			var plotStartY:Number = this._chartStartY + fullValueHeight;
			var value:Number;
			var plotLine:Shape = new Shape();
			var plotCircles:Shape = new Shape();
			var plotGirth:Number = 4;
			var currColour:uint = LINE_COLOURS[Math.round((Math.random()*LINE_COLOURS.length))];
			var valueY:Number;

			plotLine.graphics.lineStyle(plotGirth,currColour);
			for (var valueCount:int = 0; valueCount < _dayTotal; valueCount++)
			{
				value = this._valueData[valueCount];
				if(value > 0)
				{
					valueY = (fullValueHeight / 100) * value;
					plotLine.graphics.lineTo(this._chartStartX + (this._horizontalSegmentWidth * valueCount),plotStartY - valueY);
					plotCircles.graphics.beginFill(currColour);
					plotCircles.graphics.drawCircle(this._chartStartX + (this._horizontalSegmentWidth * valueCount),plotStartY - valueY,plotGirth * 2);
					plotCircles.graphics.endFill();
				}
			}
			addChild(plotLine);
			addChild(plotCircles);
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

		public function get patientData():XMLList
		{
			return _patientData;
		}

		public function set patientData(value:XMLList):void
		{
			_patientData = value;
		}
	}
}
