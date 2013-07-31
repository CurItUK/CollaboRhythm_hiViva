package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.display.TiledImage;
	import feathers.text.BitmapFontTextFormat;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;

	public class PatientAdherenceChart extends FeathersControl
	{
		public static const TOTAL_WEEKS:int = 5;
		private const LINE_COLOURS:Array = [0x2e445e,0x0b88ec,0xc20315,0x697a8f,0xffffff,0x000000];
		private const PLOT_GIRTH:int = 4;

//		private var _patientData:Array;
		private var _scheduleHistoryData:XMLList;
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
		private var _legendData:Array = [];
		private var _legend:Sprite;
		private var _isLegendActive:Boolean = false;
		private var _legendInactiveX:Number;
		private var _legendActiveX:Number;

		public function PatientAdherenceChart()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._leftAxisSpace = this.actualWidth * 0.2;
			//var leftPadding:Number = this.actualWidth * 0;
			this._rightPadding = this.actualWidth * 0.1;
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


		public function initChart():void
		{
			setFirstWeekCommencing();
			populateDates();
			populatePatientAdherence();

			//drawChart();
		}

		private function drawChart():void
		{
			drawPatientNumberLabel();
			drawBackground();
			drawLeftAxisLabels();
			drawLeftAxisLines();
			drawBottomAxisValuesAndLines();
			drawBottomAxisLabels();
			drawPlotPoints();
			drawLegend();
		}

		private function drawBottomAxisLabels():void
		{
			var bottomAxisLabel:Label = new Label();
			bottomAxisLabel.name = HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL;
			bottomAxisLabel.text = "Week commencing (" + this._firstWeek.getFullYear() + ")";
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

		private function drawLeftAxisLines():void
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

		private function drawBottomAxisValuesAndLines():void
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

		private function drawPatientNumberLabel():void
		{
			var patientNumberLabel:Label = new Label();
			patientNumberLabel.name = HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL;
			patientNumberLabel.text = _scheduleHistoryData.length() + " patient" + ((_scheduleHistoryData.length() > 1) ? "s" : "");
			addChild(patientNumberLabel);
			patientNumberLabel.x = this._chartStartX;
			patientNumberLabel.y = this._chartStartY;
			patientNumberLabel.width = this._chartWidth;
			patientNumberLabel.validate();
			this._chartStartY += patientNumberLabel.height;
		}

		private function drawBackground():void
		{
			var chartBg:Quad = new Quad(this._chartWidth, this._chartHeight, 0x4c5f76);
			chartBg.alpha = 0.25;
			chartBg.blendMode = BlendMode.MULTIPLY;
			addChild(chartBg);
			chartBg.x = this._chartStartX;
			chartBg.y = this._chartStartY;
		}

		private function drawLeftAxisLabels():void
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
			// tempDate will never be larger than currDate on the first loop iteration
			/*var tempDate:Date = new Date(0,0,0,0,0,0,0);
			var currDate:Date = new Date();
			var medicationList:XMLList;
			var medicationListLength:int;
			var medicationSchedule:XMLList;
			var medicationScheduleLength:int;
			for (var i:int = 0; i < _scheduleHistoryData.length(); i++)
			{
				medicationList = _scheduleHistoryData[i].UsersMedication.DCUserMedication;
				medicationListLength = medicationList.length();
				for (var j:int = 0; j < medicationListLength; j++)
				{
					medicationSchedule = medicationList[j].Schedule.DCMedicationSchedule;
					medicationScheduleLength = medicationSchedule.length();
					for (var k:int = 0; k < medicationScheduleLength; k++)
					{
						currDate = HivivaModifier.getDateFromIsoString(medicationSchedule.DateTaken);
						if(currDate.getTime() > tempDate.getTime())
						{
							tempDate = currDate;
						}
					}
				}
			}*/
			var currentDate:Date = HivivaStartup.userVO.serverDate;
			var tempDate:Date = new Date(currentDate.fullYear,currentDate.month,currentDate.date,currentDate.hours,currentDate.minutes,currentDate.seconds,currentDate.milliseconds);
			// set to week beginning
			HivivaModifier.floorToClosestMonday(tempDate);
			// set to day, week * _totalWeeks before. -1 so the latest week is included in results
			tempDate.date -= 7 * (TOTAL_WEEKS);
			this._firstWeek = tempDate;
		}

		private function getAppIdWithGuid(guid:String):String
		{
			var appId:String;
			var patientData:Array = HivivaStartup.hcpConnectedPatientsVO.patients;

			for (var i:int = 0; i < patientData.length; i++)
			{
				if(patientData[i].guid == guid)
				{
					appId = patientData[i].appid;
					break;
				}
			}

			return appId;
		}

		private function populatePatientAdherence():void
		{
			var weekItar:Date;
			var medicationAdherence:Number = 0;
			var medicationCount:int = 0;
			var patientAverage:Number;
			var adherenceData:Object;
			var medicationSchedule:XMLList;
			var referenceDate:Date;

			for (var i:int = 0; i < _scheduleHistoryData.length(); i++)
			{
				adherenceData = {};
				adherenceData.patient = getAppIdWithGuid(_scheduleHistoryData[i].HealthUserGuid);
				adherenceData.adherence = [];

				medicationSchedule = _scheduleHistoryData[i]..DCMedicationSchedule;

				weekItar = new Date(this._firstWeek.getFullYear(),this._firstWeek.getMonth(),this._firstWeek.getDate(),0,0,0,0);
				for (var weekCount:int = 0; weekCount < TOTAL_WEEKS; weekCount++)
				{
					weekItar.date += 7;

					medicationAdherence = 0;
					medicationCount = 0;

					for (var k:int = 0; k < medicationSchedule.length(); k++)
					{
						referenceDate = HivivaModifier.getDateFromIsoString(String(medicationSchedule[k].DateTaken));
						if(weekItar.getTime() == referenceDate.getTime())
						{
							medicationAdherence += int(medicationSchedule[k].PercentTaken);
							medicationCount++;
						}
					}

					patientAverage = medicationAdherence / medicationCount;
					if(!isNaN(patientAverage))
					{
						adherenceData.adherence.push(patientAverage);
						if(isNaN(this._lowestAdherence) || this._lowestAdherence > patientAverage) this._lowestAdherence = patientAverage;
					}
					else
					{
						adherenceData.adherence.push(0);
					}
				}
				trace(TOTAL_WEEKS + " weeks adherence for " + adherenceData.patient + " = " + adherenceData.adherence.join(','));
				this._patientAdherence.push(adherenceData);
			}
			if(!isNaN(this._lowestAdherence))
			{
				if(this._lowestAdherence < 100)
				{
					// round down to the closest 10
					this._lowestAdherence = Math.floor(this._lowestAdherence / 10) * 10;
				}
				else
				{
					this._lowestAdherence = 90;
				}

				this._adherenceRange = 100 - this._lowestAdherence;

				drawChart();
			}
			else
			{
				drawNoDataMessage();
			}
		}

		private function drawNoDataMessage():void
		{
			var alertLabel:Label = new Label();
			alertLabel.name = HivivaThemeConstants.BODY_CENTERED_LABEL;
			alertLabel.text = "No Medication history for your connected patients.";

			this.addChild(alertLabel);
			alertLabel.validate();

			alertLabel.width = Constants.STAGE_WIDTH;
			alertLabel.y = (this.actualHeight * 0.5) - (alertLabel.height * 0.5);
		}

		private function drawPlotPoints():void
		{
			var fullAdherenceHeight:Number = this._chartHeight * (100 / this._adherenceRange);
			var plotStartY:Number = this._chartStartY + fullAdherenceHeight;
			var patient:String;
			var adherence:Number;
			var plotLine:Shape;
			var plotCircles:Shape;
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
				plotLine.graphics.lineStyle(PLOT_GIRTH,currColour);
				plotCircles = new Shape();
				for (var weekCount:int = 0; weekCount < TOTAL_WEEKS; weekCount++)
				{
					adherence = this._patientAdherence[patientCount].adherence[weekCount];
					if(adherence > 0)
					{
						adherenceY = (fullAdherenceHeight / 100) * adherence;
						plotLine.graphics.lineTo(this._chartStartX + (this._horizontalSegmentWidth * weekCount),plotStartY - adherenceY);
						plotCircles.graphics.beginFill(currColour);
						plotCircles.graphics.drawCircle(this._chartStartX + (this._horizontalSegmentWidth * weekCount),plotStartY - adherenceY,PLOT_GIRTH * 2);
						plotCircles.graphics.endFill();
					}
				}
				addChild(plotLine);
				addChild(plotCircles);

				this._legendData.push({colour:uint(currColour),patient:patient})
			}
		}

		private function drawLegend():void
		{
			const textLeftPadding:Number = (PLOT_GIRTH * 2) + (Constants.PADDING_LEFT * 2);
			const gap:Number = 20;
			const labelFont:BitmapFont = TextField.getBitmapFont("normal-white-regular");
			const labelSize:int = 18;

			var fullLegendHeight:Number = gap;
			var fullLegendWidth:Number = 0;
			var currCompareWidth:Number;
			var legendItem:Object;
			var legendLabel:Label;
			var legendCircle:Shape;

			_legend = new Sprite();
			addChild(_legend);

			var legendBg:Sprite = new Sprite();
			_legend.addChild(legendBg);

			for (var i:int = 0; i < this._legendData.length; i++)
			{
				legendItem = this._legendData[i];

				legendLabel = new Label();
				legendLabel.text = legendItem.patient;
				_legend.addChild(legendLabel);
				legendLabel.textRendererProperties.textFormat = new BitmapFontTextFormat(labelFont,labelSize,uint(legendItem.colour));
				legendLabel.x = textLeftPadding;
				legendLabel.y = fullLegendHeight;
				legendLabel.validate();

				legendCircle = new Shape();
				legendCircle.graphics.beginFill(uint(legendItem.colour));
				legendCircle.graphics.drawCircle(Constants.PADDING_LEFT, fullLegendHeight + (legendLabel.height * 0.5), PLOT_GIRTH * 2);
				legendCircle.graphics.endFill();
				_legend.addChild(legendCircle);

				currCompareWidth = legendLabel.x + legendLabel.width + gap;
				if(fullLegendWidth < currCompareWidth) fullLegendWidth = currCompareWidth;
				fullLegendHeight += legendLabel.height + gap;
			}

			var legendBgQuad:Quad = new Quad(fullLegendWidth,fullLegendHeight,0xFFFFFF);
			legendBg.addChild(legendBgQuad);

			var grainEffect:TiledImage = new TiledImage(Main.assets.getTexture("patient-profile-nav-button-pattern"));
			grainEffect.smoothing = TextureSmoothing.NONE;
			grainEffect.blendMode =  BlendMode.MULTIPLY;
			grainEffect.width = fullLegendWidth;
			grainEffect.height = fullLegendHeight;
			legendBg.addChild(grainEffect);

			var legendBtn:Button = new Button();
			legendBtn.addEventListener(Event.TRIGGERED, legendButtonHandler);
			legendBtn.width = fullLegendWidth;
			legendBtn.height = fullLegendHeight;
			legendBtn.alpha = 0;
			_legend.addChild(legendBtn);

			this._isLegendActive = false;
			this._legendInactiveX = Constants.STAGE_WIDTH - textLeftPadding;
			this._legendActiveX = Constants.STAGE_WIDTH - this._rightPadding - gap - fullLegendWidth;

			_legend.x = this._legendInactiveX;
			_legend.y = this._chartStartY + gap;
		}

		private function legendButtonHandler(e:Event):void
		{
			var xLoc:Number = this._isLegendActive ? this._legendInactiveX : this._legendActiveX;

			var legendTween:Tween = new Tween(this._legend , 0.2 , this._isLegendActive ? Transitions.EASE_IN : Transitions.EASE_OUT);
			legendTween.animate("x" , xLoc);
			legendTween.onComplete = function():void{_isLegendActive = !_isLegendActive; Starling.juggler.remove(legendTween);};
			Starling.juggler.add(legendTween);
		}

		public function get scheduleHistoryData():XMLList
		{
			return _scheduleHistoryData;
		}

		public function set scheduleHistoryData(value:XMLList):void
		{
			_scheduleHistoryData = value;
		}
/*
		public function get patientData():Array
		{
			return _patientData;
		}

		public function set patientData(value:Array):void
		{
			_patientData = value;
		}*/
	}
}
