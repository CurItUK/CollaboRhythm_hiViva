package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.display.TiledImage;

	import flash.utils.Dictionary;

	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;

	public class AdherenceChartReport extends FeathersControl
	{
		private var _medications:XMLList;
		private var _history:Dictionary;
		private var _startDate:Date;
		private var _endDate:Date;
		private var _dayTotal:Number;
		private var _dailyAdherenceData:Array;
		private var _lowestValue:Number;
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

		public function AdherenceChartReport()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._leftAxisSpace = this.actualWidth * 0.15;
			//var leftPadding:Number = this.actualWidth * 0;
			this._rightPadding = this.actualWidth * 0.01;
			this._vPadding = 0;
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
//			initTiledBackground();

			calculateAdherence();

			initChartTitleLabel();
			initBackground();
			initLeftAxisLabels();
			initLeftAxisLines();
			initBottomAxisValuesAndLines();
//			initBottomAxisLabels();
			drawPlotPoints();
			this.validate();
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

		private function calculateAdherence():void
		{
			extractHistory();

			this._lowestValue = 100;
			this._dailyAdherenceData = [];

			// get ultimate start and end dates
			var startAndEndDates:Object = getUltimateStartAndEndDates();

			populateAdherenceData(startAndEndDates);
//			trace(this._dailyAdherenceData.join(","));

			if(this._lowestValue == 100)
			{
				// if this._lowestValue is 100 make it 90
				this._lowestValue = 90;
			}
			else
			{
				// round down to the closest 10
				this._lowestValue = Math.floor(this._lowestValue / 10) * 10;
			}
			this._valueRange = 100 - this._lowestValue;
		}

		private function extractHistory():void
		{
			_history = new Dictionary();
			var medicationLength:int = this._medications.length();
			var medicationSchedule:XMLList;
			var medicationScheduleLength:int;
			var referenceDate:Number;
			var medicationId:String;
			for (var i:int = 0; i < medicationLength; i++)
			{
				medicationSchedule = this._medications[i].Schedule.DCMedicationSchedule as XMLList;
				medicationId = _medications[i].MedicationID;

				medicationScheduleLength = medicationSchedule.length();
				for (var j:int = 0; j < medicationScheduleLength; j++)
				{
					referenceDate = HivivaModifier.getDateFromIsoString(String(medicationSchedule[j].DateTaken)).getTime();
					if (_history[referenceDate] == undefined) _history[referenceDate] = [];
					_history[referenceDate].push({id:medicationId,data:medicationSchedule[j]});
				}
			}
		}

		private function populateAdherenceData(startAndEndDates:Object):void
		{
			var earliestSchedule:Number = startAndEndDates.earliestSchedule;
			var latestSchedule:Number = startAndEndDates.latestSchedule;
			var dayTime:Number;
			var columnData:Array;
			var columnDataLength:int;
			var adherence:Number;
			var adherenceCount:int;
			var daysItar:Date = new Date(this._startDate.getFullYear(),this._startDate.getMonth(),this._startDate.getDate(),0,0,0,0);

			for (var dayCount:int = 0; dayCount < _dayTotal; dayCount++)
			{
				dayTime = daysItar.getTime();
				adherence = 0;
				adherenceCount = 0;
				if (dayTime >= earliestSchedule && dayTime <= latestSchedule)
				{
					columnData = _history[dayTime];
					if (columnData != null)
					{
						columnDataLength = columnData.length;
						for (var i:int = 0; i < columnDataLength; i++)
						{
							adherence += Number(columnData[i].data.PercentTaken);
							adherenceCount++;
						}
					}
					else
					{
						// schedule was missed on this day
//						adherence += 0;
						adherenceCount++;
					}
					trace(adherence + " /= " + adherenceCount);
					adherence /= adherenceCount;
					if (adherence < this._lowestValue) this._lowestValue = adherence;
				}
				else
				{
					// schedule did not exist on this day
					adherence = -1;
				}

				this._dailyAdherenceData.push(adherence);
				daysItar.date++;
			}
		}

		private function getUltimateStartAndEndDates():Object
		{
			var startAndEndDates:Object = {};
			var prevStartDate:Date = new Date(0,0,0,0,0,0,0);
			var prevEndDate:Date = new Date(HivivaStartup.userVO.serverDate.getFullYear(),HivivaStartup.userVO.serverDate.getMonth(),HivivaStartup.userVO.serverDate.getDate(),0,0,0,0);
			var yesterday:Date = new Date(HivivaStartup.userVO.serverDate.getFullYear(),HivivaStartup.userVO.serverDate.getMonth(),HivivaStartup.userVO.serverDate.getDate() - 1,0,0,0,0);
			var currStartDate:Date;
			var currEndDate:Date;
			for (var j:int = 0; j < _medications.length(); j++)
			{
				currStartDate = HivivaModifier.getDateFromIsoString(_medications[j].StartDate);
				currEndDate = (String(_medications[j].Stopped)) ==
						"true" ? HivivaModifier.getDateFromIsoString(_medications[j].EndDate) : yesterday;

				if (prevStartDate.getTime() < currStartDate.getTime())
				{
					startAndEndDates.earliestSchedule = prevStartDate.getTime();
				}
				if (prevEndDate.getTime() > currEndDate.getTime())
				{
					startAndEndDates.latestSchedule = prevEndDate.getTime();
				}

				prevStartDate = new Date(currStartDate.getFullYear(), currStartDate.getMonth(), currStartDate.getDate(), 0, 0, 0, 0);
				prevEndDate = new Date(currEndDate.getFullYear(), currEndDate.getMonth(), currEndDate.getDate(), 0, 0, 0, 0);
			}
			return startAndEndDates;
		}

		private function drawPlotPoints():void
		{
			var fullValueHeight:Number = this._chartHeight * (100 / this._valueRange);
			var plotStartY:Number = this._chartStartY + fullValueHeight;
			var value:Number;
			var plotLine:Shape = new Shape();
			var plotCircles:Shape = new Shape();
			var plotGirth:Number = 3;
			var currColour:uint = LINE_COLOURS[Math.round((Math.random()*LINE_COLOURS.length))];
			var valueY:Number;

			plotLine.graphics.lineStyle(plotGirth,currColour);
			for (var dayCount:int = 0; dayCount < _dayTotal; dayCount++)
			{
				value = this._dailyAdherenceData[dayCount];
				if(value > -1)
				{
					valueY = (fullValueHeight / 100) * value;
					plotLine.graphics.lineTo(this._chartStartX + (this._horizontalSegmentWidth * dayCount),plotStartY - valueY);
					plotCircles.graphics.beginFill(currColour);
					plotCircles.graphics.drawCircle(this._chartStartX + (this._horizontalSegmentWidth * dayCount),plotStartY - valueY,plotGirth * 2);
					plotCircles.graphics.endFill();
				}
				else
				{
					addChild(plotLine);
					plotLine = new Shape();
					plotLine.graphics.lineStyle(plotGirth,currColour);
				}
			}
			addChild(plotLine);
			addChild(plotCircles);
		}

		private function initChartTitleLabel():void
		{
			var chartTitleLabel:Label = new Label();
			chartTitleLabel.name = HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL;
			chartTitleLabel.text = "Overall Adherence";
			addChild(chartTitleLabel);
			chartTitleLabel.x = this._chartStartX;
			chartTitleLabel.y = this._chartStartY;
			chartTitleLabel.width = this._chartWidth;
			chartTitleLabel.validate();
			// * 1.5 for padding
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
			leftAxisLabel.text = "Adherence";
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
			var vertLineTexture:Texture = Main.assets.getTexture("verticle_line");
			var verticalLine:Image;
			var bottomAxisValue:Label;
			var evenLighter:Quad;
			var xAxisPosition:Number;
			var daysItar:Date = new Date(this._startDate.getFullYear(),this._startDate.getMonth(),this._startDate.getDate(),0,0,0,0);
			for (var dayCount:int = 0; dayCount < _dayTotal; dayCount++)
			{
				xAxisPosition = this._horizontalSegmentWidth * dayCount;

				bottomAxisValue = new Label();
				bottomAxisValue.name = HivivaThemeConstants.CELL_SMALL_LABEL;
				/*bottomAxisValue.text = HivivaModifier.isoDateToPrettyString((daysItar.getMonth() + 1).toString()) + "/" +
						HivivaModifier.addPrecedingZero(daysItar.getDate().toString());*/
				bottomAxisValue.text = HivivaModifier.getPrettyStringFromDate(daysItar,false);
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

		public function get medications():XMLList
		{
			return _medications;
		}

		public function set medications(value:XMLList):void
		{
			_medications = value;
		}
	}
}
