package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;
	import feathers.core.FeathersControl;

	import flash.utils.Dictionary;

	import starling.display.BlendMode;
	import starling.display.Image;

	import starling.display.Quad;
	import starling.display.Shape;
	import starling.textures.Texture;

	import starling.utils.deg2rad;

	public class PatientAdherenceChart extends FeathersControl
	{
		private var TOTAL_WEEKS:int = 5;
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
		private var _bottomAxisValueHeight:Number;
		private var _history:Dictionary;

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
			extractHistory();
			setFirstWeekCommencing();
			populateDates();
			populatePatientAdherence();

			initPatientNumberLabel();
			initBackground();
			initLeftAxisLabels();
			initLeftAxisLines();
			initBottomAxisValuesAndLines();
			initBottomAxisLabels();
			drawPlotPoints();
		}

		private function extractHistory():void
		{
			_history = new Dictionary();
			var medicationList:XMLList;
			var medicationListLength:int;
			var medicationSchedule:XMLList;
			var medicationScheduleLength:int;
			var referenceDate:Number;

			for (var i:int = 0; i < _filterdPatients.length; i++)
			{
				medicationList = _filterdPatients[i].xml.DCUserMedication;
				medicationListLength = medicationList.length();
				for (var j:int = 0; j < medicationListLength; j++)
				{
					medicationSchedule = medicationList[j].Schedule.DCMedicationSchedule;
					medicationScheduleLength = medicationSchedule.length();
					for (var k:int = 0; k < medicationScheduleLength; k++)
					{
						referenceDate = HivivaModifier.isoDateToFlashDate(String(medicationSchedule[k].DateTaken)).getTime();
						if (_history[referenceDate] == undefined) _history[referenceDate] = [];
						_history[referenceDate].push({patientId:_filterdPatients[i].patientAppId,data:int(medicationSchedule[k].PercentTaken)});
					}
				}
			}
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

		private function initLeftAxisLines():void
		{
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
		}

		private function initBottomAxisValuesAndLines():void
		{
			var vertLineTexture:Texture = Assets.getTexture("VerticleLinePng");
			var verticalLine:Image;
			var bottomAxisValue:Label;
			var evenLighter:Quad;
			var xAxisPosition:Number;
			for (var weekCount:int = 0; weekCount < TOTAL_WEEKS; weekCount++)
			{
				xAxisPosition = this._horizontalSegmentWidth * weekCount;

				bottomAxisValue = new Label();
				bottomAxisValue.name = HivivaThemeConstants.PATIENT_DATA_LIGHTER_LABEL;
				bottomAxisValue.text = HivivaModifier.addPrecedingZero((_weeks[weekCount].getMonth() + 1).toString()) + "/" +
						HivivaModifier.addPrecedingZero(_weeks[weekCount].getDate().toString());
				addChild(bottomAxisValue);
				bottomAxisValue.validate();
				bottomAxisValue.x = this._chartStartX + xAxisPosition;
				if (weekCount == (TOTAL_WEEKS - 1))
				{
					bottomAxisValue.x -= bottomAxisValue.width;
				}
				else if (weekCount > 0)
				{
					bottomAxisValue.x -= bottomAxisValue.width * 0.5;
				}
				bottomAxisValue.y = this._chartStartY + this._chartHeight;

				verticalLine = new Image(vertLineTexture);
				addChild(verticalLine);
				verticalLine.x = this._chartStartX + xAxisPosition;
				verticalLine.y = this._chartStartY;
				verticalLine.height = this._chartHeight;
				// ever even segment
				if ((weekCount / 2).toString().indexOf('.') > -1 && weekCount < (TOTAL_WEEKS - 1))
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

		private function initPatientNumberLabel():void
		{
			var patientNumberLabel:Label = new Label();
			patientNumberLabel.name = HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL;
			patientNumberLabel.text = _filterdPatients.length + " patient" + ((_filterdPatients.length > 1) ? "s" : "");
			addChild(patientNumberLabel);
			patientNumberLabel.x = this._chartStartX;
			patientNumberLabel.y = this._chartStartY;
			patientNumberLabel.width = this._chartWidth;
			patientNumberLabel.validate();
			this._chartStartY += patientNumberLabel.height;
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
			leftAxisBottom.text = this._lowestAdherence + "%";
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
			// compareDate will never be larger than currDate on the first loop iteration
			var tempDate:Date = new Date(0,0,0,0,0,0,0);
			var currDate:Date = new Date();
			for (var i:int = 0; i < _filterdPatients.length; i++)
			{
				var xml:XMLList = _filterdPatients[i].xml.DCUserMedication[0].Schedule.DCMedicationSchedule;
				currDate = HivivaModifier.isoDateToFlashDate(xml.DateTaken);
				if(currDate.getTime() > tempDate.getTime())
				{
					tempDate = currDate;
				}
			}
			// set to week beginning
			HivivaModifier.floorToClosestMonday(tempDate);
			// set to day, week * _totalWeeks before. -1 so the latest week is included in results
			tempDate.date -= 7 * (TOTAL_WEEKS);
			this._firstWeek = tempDate;
		}

		private function populatePatientAdherence():void
		{var historyData:Array;
					var weekItar:Date;
					var comparePatient:String;
					var medicationAdherence:Number = 0;
					var medicationCount:int = 0;
					var patientAverage:Number;
					var adherenceData:Object;
					this._lowestAdherence = 100;

			_history = new Dictionary();
			var medicationList:XMLList;
			var medicationListLength:int;
			var medicationSchedule:XMLList;
			var medicationScheduleLength:int;
			var referenceDate:Date;

			for (var i:int = 0; i < _filterdPatients.length; i++)
			{
				adherenceData = {};
				adherenceData.patient = _filterdPatients[i].patientAppId;
				adherenceData.adherence = [];
				weekItar = new Date(this._firstWeek.getFullYear(),this._firstWeek.getMonth(),this._firstWeek.getDate(),0,0,0,0);
				for (var weekCount:int = 0; weekCount < TOTAL_WEEKS; weekCount++)
				{
					medicationAdherence = 0;
					medicationCount = 0;

					weekItar.date += 7;

					medicationList = _filterdPatients[i].xml.DCUserMedication;
					medicationListLength = medicationList.length();
					for (var j:int = 0; j < medicationListLength; j++)
					{

						medicationSchedule = medicationList[j].Schedule.DCMedicationSchedule;
						medicationScheduleLength = medicationSchedule.length();
						for (var k:int = 0; k < medicationScheduleLength; k++)
						{
							referenceDate = HivivaModifier.isoDateToFlashDate(String(medicationSchedule[k].DateTaken));
							if(weekItar.getTime() == referenceDate.getTime())
							{
								medicationAdherence += int(medicationSchedule[k].PercentTaken);
								medicationCount++;
							}
						}
					}

						patientAverage = medicationAdherence / medicationCount;
						adherenceData.adherence.push(patientAverage);
						this._patientAdherence.push(adherenceData);
						if(patientAverage < this._lowestAdherence) this._lowestAdherence = patientAverage;
				}
			}
			// round down to the closest 10
			this._lowestAdherence = Math.floor(this._lowestAdherence / 10) * 10;
			this._adherenceRange = 100 - this._lowestAdherence;


			/*var historyData:Array;
			var weekItar:Date = new Date(this._firstWeek.getFullYear(),this._firstWeek.getMonth(),this._firstWeek.getDate(),0,0,0,0);
			var comparePatient:String;
			var medicationAdherence:Number = 0;
			var medicationCount:int = 0;
			var patientAverage:Number;
			var adherenceData:Object;
			this._lowestAdherence = 100;
			for (var i:int = 0; i < TOTAL_WEEKS; i++)
			{
				historyData = _history[weekItar.getTime()];
				if(historyData != null)
				{
					comparePatient = historyData[0].patientId;
					for (var j:int = 0; j < historyData.length; j++)
					{
						if(historyData[j].patientId != comparePatient)
						{

							patientAverage = medicationAdherence / medicationCount;
							this._patientAdherence.push({patientAverage:patientAverage,date:weekItar.getTime(),patient:historyData[j].patientId});
							if(patientAverage < this._lowestAdherence) this._lowestAdherence = patientAverage;

							medicationAdherence = 0;
							medicationCount = 0;
						}

						medicationAdherence += historyData[j].data;
						medicationCount++;

						comparePatient = historyData[j].patientId;
					}
				}
				weekItar.date += 7;
			}
			trace(this._patientAdherence.join(','));
			// round down to the closest 10
			this._lowestAdherence = Math.floor(this._lowestAdherence / 10) * 10;
			this._adherenceRange = 100 - this._lowestAdherence;
*/
			/*



			var dayLength:int = TOTAL_WEEKS * 7;
			var daysItar:Date;
			var daysCount:int = 0;
			var patientData:XMLList;
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

				daysItar = new Date(this._firstWeek.getFullYear(),this._firstWeek.getMonth(),this._firstWeek.getDate(),0,0,0,0);
				for (var i:int = 0; i < dayLength; i++)
				{
					adherence = HivivaModifier.getPatientAdherenceByDate(patientData, daysItar);
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
			this._adherenceRange = 100 - this._lowestAdherence;*/
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
