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
	import starling.display.Shape;
	import starling.textures.Texture;

	import starling.utils.deg2rad;

	public class PatientAdherenceChart extends FeathersControl
	{
		private const TOTAL_WEEKS:int = 5;
		private const LINE_COLOURS:Array = [0x2e445e,0x0b88ec,0xc20315,0x697a8f,0xffffff,0x000000];

		private var _filterdPatients:Array;
		private var _firstWeek:Date;
		private var _weeks:Vector.<Date>;
		private var _patientAdherence:Array = [];
		
		private var _leftAxisSpace:Number;
		private var _rightPadding:Number;
		private var _vPadding:Number;
		private var _chartWidth:Number;
		private var _chartHeight:Number;
		private var _chartStartX:Number;
		private var _chartStartY:Number;
		private var _horizontalSegmentWidth:Number;
		private var _lowestAdherence:Number;
		private var _adherenceRange:Number;

		public function PatientAdherenceChart()
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
			this._horizontalSegmentWidth = this._chartWidth / (TOTAL_WEEKS - 1);
		}

		override protected function initialize():void
		{
			super.initialize();
		}

		public function drawChart():void
		{
			setFirstWeekCommencing();
			populateDates();
			populatePatientAdherence();

			var patientNumberLabel:Label = new Label();
			patientNumberLabel.name = "centered-label";
			patientNumberLabel.text = "<font face='ExoBold'>" + _filterdPatients.length + " patient" + ((_filterdPatients.length > 1) ? "s" : "") + "</font>";
			addChild(patientNumberLabel);
			patientNumberLabel.x = this._chartStartX;
			patientNumberLabel.y = this._chartStartY;
			patientNumberLabel.width = this._chartWidth;
			patientNumberLabel.validate();
			this._chartStartY += patientNumberLabel.height;

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
			leftAxisBottom.text = "<font face='ExoBold'>"+ this._lowestAdherence + "%</font>";
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

			var chartBg:Quad = new Quad(this._chartWidth,this._chartHeight,0x4c5f76);
			chartBg.alpha = 0.25;
			chartBg.blendMode = BlendMode.MULTIPLY;
			addChild(chartBg);
			chartBg.x = this._chartStartX;
			chartBg.y = this._chartStartY;

			var vertLineTexture:Texture = Assets.getTexture("VerticleLinePng");
			var verticalLine:Image;
			var bottomAxisValue:Label;
			var evenLighter:Quad;
			var xAxisPosition:Number;
			for (var weekCount:int = 0; weekCount < TOTAL_WEEKS; weekCount++)
			{
				xAxisPosition = this._horizontalSegmentWidth * weekCount;

				bottomAxisValue = new Label();
				bottomAxisValue.name = "patient-data-lighter";
				bottomAxisValue.text = addPrecedingZero((_weeks[weekCount].getMonth() + 1).toString()) + "/" + addPrecedingZero(_weeks[weekCount].getDate().toString());
				addChild(bottomAxisValue);
				bottomAxisValue.validate();
				bottomAxisValue.x = this._chartStartX + xAxisPosition;
				if(weekCount == (TOTAL_WEEKS - 1))
				{
					bottomAxisValue.x -= bottomAxisValue.width;
				}
				else if(weekCount > 0)
				{
					bottomAxisValue.x -= bottomAxisValue.width * 0.5;
				}
				bottomAxisValue.y = this._chartStartY + this._chartHeight;

				verticalLine = new Image(vertLineTexture);
				addChild(verticalLine);
				verticalLine.x = this._chartStartX + xAxisPosition;
				verticalLine.y = this._chartStartY;
				verticalLine.height = this._chartHeight;

				if((weekCount / 2).toString().indexOf('.') > -1 && weekCount < (TOTAL_WEEKS - 1))
				{
					evenLighter = new Quad(this._horizontalSegmentWidth, this._chartHeight, 0xffffff);
					evenLighter.alpha = 0.2;
					addChild(evenLighter);
					evenLighter.x = this._chartStartX + xAxisPosition;
					evenLighter.y = this._chartStartY;
				}
			}

			var horizLineTexture:Texture = Main.assets.getTexture("header_line");
			var horizontalLine:Image;
			var verticalSegmentLength:Number = this._adherenceRange / 10;
			var verticalSegmentHeight:Number = this._chartHeight / verticalSegmentLength;
			for (var verticalSegmentCount:int = 0; verticalSegmentCount < verticalSegmentLength; verticalSegmentCount++)
			{
				horizontalLine = new Image(horizLineTexture);
				addChild(horizontalLine);
				horizontalLine.x = this._chartStartX;
				horizontalLine.y = this._chartStartY + (verticalSegmentHeight * verticalSegmentCount);
				horizontalLine.width = this._chartWidth;
			}

			var bottomAxisLabel:Label = new Label();
			bottomAxisLabel.name = "centered-label";
			bottomAxisLabel.text = "<font face='ExoBold'>Week commencing (2013)</font>";
			addChild(bottomAxisLabel);
			bottomAxisLabel.x = this._chartStartX;
			bottomAxisLabel.y = bottomAxisValue.y + bottomAxisValue.height;
			bottomAxisLabel.width = this._chartWidth;
			bottomAxisLabel.validate();

			var bottomAxisGrad:Quad = new Quad(this._chartWidth, bottomAxisValue.height + bottomAxisLabel.height);
			bottomAxisGrad.setVertexColor(0, 0xFFFFFF);
			bottomAxisGrad.setVertexColor(1, 0xFFFFFF);
			bottomAxisGrad.setVertexColor(2, 0x293d54);
			bottomAxisGrad.setVertexColor(3, 0x293d54);
			bottomAxisGrad.alpha = 0.2;
			addChild(bottomAxisGrad);
			bottomAxisGrad.x = this._chartStartX;
			bottomAxisGrad.y = this._chartStartY + this._chartHeight;

			drawPlotPoints();
		}

		private function populateDates():void
		{
			var weeksItar:Date = new Date(this._firstWeek.getFullYear(),this._firstWeek.getMonth(),this._firstWeek.getDate(),0,0,0,0);
			_weeks = new <Date>[];
			for (var weekCount:int = 0; weekCount < TOTAL_WEEKS; weekCount++)
			{
				weeksItar.date += 7;
				_weeks.push(new Date(weeksItar.getFullYear(),weeksItar.getMonth(),weeksItar.getDate(),0,0,0,0));
			}
		}

		private function setFirstWeekCommencing():void
		{
			var dateArr:Array;
			// compareDate will never be larger than currDate on the first loop iteration
			var tempDate:Date = new Date(0,0,0,0,0,0,0);
			var currDate:Date = new Date();
			for (var i:int = 0; i < _filterdPatients.length; i++)
			{
				dateArr = String(_filterdPatients[i].medicationHistory.history[0].date).split("/");
				currDate = new Date(int(dateArr[2]),int(dateArr[0]) - 1,int(dateArr[1]),0,0,0,0);
				if(currDate.getTime() > tempDate.getTime())
				{
					tempDate = currDate;
				}
			}
			// set to week beginning
			HivivaModifier.floorToClosestMonday(tempDate);
			// set to day, week * _totalWeeks before. -1 so the latest week is included in results
			tempDate.date -= 7 * (TOTAL_WEEKS - 1);
			this._firstWeek = tempDate;
		}

		private function populatePatientAdherence():void
		{
			var dayLength:int = TOTAL_WEEKS * 7;
			var daysItar:Date;
			var daysCount:int = 0;
			var patientData:XML;
			var history:XMLList;
			var historyLength:int;
			var adherenceData:Object;
			var adherence:Number;
			var averageAdherence:Number = 0;
			this._lowestAdherence = 100;
			for (var j:int = 0; j < _filterdPatients.length; j++)
			{
				patientData = _filterdPatients[j];

				adherenceData = {};
				adherenceData.patient = _filterdPatients[j].name;
				adherenceData.adherence = [];

				history = patientData.medicationHistory.history as XMLList;
				historyLength = history.length();

				daysItar = new Date(this._firstWeek.getFullYear(),this._firstWeek.getMonth(),this._firstWeek.getDate(),0,0,0,0);
				for (var i:int = 0; i < dayLength; i++)
				{
					for (var k:int = 0; k < historyLength; k++)
					{
						adherence = getPatientAdherenceByDate(history[k], daysItar);
						if(adherence > 0) break;
					}
					averageAdherence += adherence;
					daysItar.date++;
					daysCount++;
					if(daysCount == 7)
					{
						// calculate average adherence
						averageAdherence /= 7;
						adherenceData.adherence.push(averageAdherence);

						if(this._lowestAdherence > averageAdherence && averageAdherence > 0)
						{
							this._lowestAdherence = averageAdherence;
						}

						averageAdherence = 0;
						daysCount = 0
					}
				}
				this._patientAdherence.push(adherenceData);
				trace(adherenceData.adherence.join(","));
			}
			// round down to the closest 10
			this._lowestAdherence = Math.floor(this._lowestAdherence / 10) * 10;
			this._adherenceRange = 100 - this._lowestAdherence;
		}

		private function getPatientAdherenceByDate(patientMedicationHistory:XML, compareDate:Date):Number
		{
			var adherencePercent:Number;
			var medicationHistory:XMLList;
			var medicationHistoryLength:int;
			var adheredCount:int;
			var dateCompareStr:String = addPrecedingZero((compareDate.getMonth() + 1).toString()) + "/" + addPrecedingZero(compareDate.getDate().toString()) + "/" + compareDate.getFullYear();
//			trace(patientMedicationHistory.date + " == " + dateCompareStr);
			if(patientMedicationHistory.date == dateCompareStr)
			{
				medicationHistory = patientMedicationHistory.medication as XMLList;
				medicationHistoryLength = medicationHistory.length();
				adheredCount = 0;
				for (var i:int = 0; i < medicationHistoryLength; i++)
				{
					if(medicationHistory[i].adhered == "yes")
					{
						adheredCount++;
					}
				}
				adherencePercent = (adheredCount / medicationHistoryLength) * 100;
			}
			else
			{
				adherencePercent = 0;
			}
			return adherencePercent;
		}

		private function addPrecedingZero(val:String):String
		{
			var zeroFilledVal:String;
			if(val.length < 2)
			{
				zeroFilledVal = "0" + val;
			}
			else
			{
				zeroFilledVal = val;
			}
			return zeroFilledVal;
		}

		private function drawPlotPoints():void
		{
			var fullAdherenceHeight:Number = this._chartHeight * (100 / this._adherenceRange);
			var plotStartY:Number = this._chartStartY + fullAdherenceHeight;
			var patient:String;
			var adherence:Number;
			var plotLine:Shape;
			var plotCircles:Shape;
			var plotGirth:Number = 4;
			var adherenceY:Number;
			var currColour:uint;
			var patientAdherenceLength:int = _patientAdherence.length;
			for (var patientCount:int = 0; patientCount < patientAdherenceLength; patientCount++)
			{
				patient = this._patientAdherence[patientCount].patient;

				if(patientCount > LINE_COLOURS.length)
				{
					currColour = LINE_COLOURS[patientCount - patientAdherenceLength];
				}
				else
				{
					currColour = LINE_COLOURS[patientCount]
				}

				plotLine = new Shape();
				plotLine.graphics.lineStyle(plotGirth,currColour);
				plotCircles = new Shape();
				for (var weekCount:int = 0; weekCount < TOTAL_WEEKS; weekCount++)
				{
					adherence = this._patientAdherence[patientCount].adherence[weekCount];
					if(adherence > 0)
					{
						adherenceY = (fullAdherenceHeight / 100) * adherence;
						plotLine.graphics.lineTo(this._chartStartX + (this._horizontalSegmentWidth * weekCount),plotStartY - adherenceY);
						plotCircles.graphics.beginFill(currColour);
						plotCircles.graphics.drawCircle(this._chartStartX + (this._horizontalSegmentWidth * weekCount),plotStartY - adherenceY,plotGirth * 2);
						plotCircles.graphics.endFill();
					}
				}
				addChild(plotLine);
				addChild(plotCircles);
			}
		}

		public function get filterdPatients():Array
		{
			return _filterdPatients;
		}

		public function set filterdPatients(value:Array):void
		{
			_filterdPatients = value;
		}
	}
}
