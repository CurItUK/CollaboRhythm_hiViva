package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;

	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.display.TiledImage;

	import flash.geom.Matrix;
	import flash.utils.Dictionary;

	import org.purepdf.colors.RGBColor;
	import org.purepdf.elements.Element;
	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.PageSize;
	import org.purepdf.pdf.PdfContentByte;
	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.fonts.BaseFont;

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
		private var _dailyAdherenceData:Array;
		private var _lowestValue:Number;
		private var _valueRange:Number;

//		private const LINE_COLOUR:uint = 0x4F81BC;
		private const LINE_COLOUR:uint = 0xFFFFFF;
		private var PLOT_GIRTH:Number;

		private var _leftAxisSpace:Number;
		private var _rightPadding:Number;
		private var _vPadding:Number;
		private var _chartWidth:Number;
		private var _chartHeight:Number;
		private var _chartStartX:Number;
		private var _chartStartY:Number;
		private var _bottomAxisValueHeight:Number;
		private var _daySegmentWidth:Number;
		private var _dayRange:Number;
		private var _dayBreakDownRatio:int;
		private var _xAxisSegmentWidth:Number;
		private var _xAxisTotal:Number;

		private var _plotPointsA:Array = [];
		private var _leftAxisDetails:Array = [];
		private var _leftAxisLinesA:Array = [];
		private var _rightAxisLinesA:Array = [];
		private var _rightAxisDetails:Array = [];

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
			calculateXAxisBreakDown();

			// tiled background here to compensate for no transparency on the draw

			calculateAdherence();

			initChartTitleLabel();
			initBackground();
			initLeftAxisLabels();
			initLeftAxisLines();
			initBottomAxisValuesAndLines();
//			initBottomAxisLabels();
			drawPlotPoints();
			this.validate();
			initTiledBackground();

		}

		private function calculateXAxisBreakDown():void
		{
			this._dayRange = HivivaModifier.getDaysDiff(this._endDate, this._startDate) + 1;
			this._daySegmentWidth = this._chartWidth / (_dayRange - 1);

			if (this._dayRange <= 14)
			{
				// daily
				this._dayBreakDownRatio = 1;
			}
			else if (this._dayRange > 14 && this._dayRange <= 28)
			{
				// every other daily
				this._dayBreakDownRatio = 2;
			}
			else if (this._dayRange > 28 && this._dayRange <= 98)
			{
				// weekly
				this._dayBreakDownRatio = 7;
			}
			else if (this._dayRange > 98 && this._dayRange <= 196)
			{
				// every other weekly
				this._dayBreakDownRatio = 14;
			}

			this._xAxisTotal = this._dayRange / this._dayBreakDownRatio;
			this._xAxisSegmentWidth = this._daySegmentWidth * this._dayBreakDownRatio;
			PLOT_GIRTH = 5 - (5 * (this._dayRange / 100));
			if(PLOT_GIRTH < 2) PLOT_GIRTH = 2;
		}

		private function initTiledBackground():void
		{
			var screenBase:TiledImage = new TiledImage(Main.assets.getTexture("screen_base"));
			screenBase.x = this._chartStartX;
			screenBase.y = this._chartStartY;
			screenBase.width = this._chartWidth;
			screenBase.height = this._chartHeight;
			screenBase.smoothing = TextureSmoothing.NONE;
			screenBase.touchable = false;
			//screenBase.flatten();
			addChildAt(screenBase,0);
		}

		private function calculateAdherence():void
		{
			this._history = HivivaModifier.getChronologicalDictionaryFromXmlList(this._medications);

			this._lowestValue = 100;
			this._dailyAdherenceData = [];

			// get ultimate start and end dates
			var startAndEndDates:Object = HivivaModifier.getFinalStartAndEndDatesFromXmlList(this._medications);

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

		private function populateAdherenceData(startAndEndDates:Object):void
		{
			var earliestSchedule:Number = startAndEndDates.earliestSchedule;
			var latestSchedule:Number = startAndEndDates.latestSchedule;
			var dayTime:Number;
			var dayStr:String;
			var columnData:Array;
			var columnDataLength:int;
			var adherence:Number;
			var adherenceCount:int;
			var daysItar:Date = new Date(this._startDate.getFullYear(),this._startDate.getMonth(),this._startDate.getDate(),0,0,0,0);

			for (var dayCount:int = 0; dayCount < this._dayRange; dayCount++)
			{
				dayTime = daysItar.getTime();
				dayStr = HivivaModifier.getIsoStringFromDate(daysItar,false);
				adherence = 0;
				adherenceCount = 0;

				// debug
				/*var tempDate:Date = new Date();
				tempDate.setTime(earliestSchedule);
				trace(dayStr + " >= " + HivivaModifier.getIsoStringFromDate(tempDate,false) + " ? " + (dayTime >= earliestSchedule));
				tempDate.setTime(latestSchedule);
				trace(dayStr + " < " + HivivaModifier.getIsoStringFromDate(tempDate,false) + " ? " + (dayTime < latestSchedule));*/

				if (dayTime >= earliestSchedule && dayTime < latestSchedule)
				{
					columnData = _history[dayStr];
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
						adherence += 0;
						adherenceCount++;
					}
//					trace(adherence + " /= " + adherenceCount);
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
			trace(this._dailyAdherenceData.join(','));
		}

		private function drawPlotPoints():void
		{
			var fullValueHeight:Number = this._chartHeight * (100 / this._valueRange);
			var plotStartY:Number = this._chartStartY + fullValueHeight;
			var value:Number;
			var plotLine:Shape = new Shape();
			var plotCircles:Shape = new Shape();
			var valueY:Number;

			plotLine.graphics.lineStyle(PLOT_GIRTH,LINE_COLOUR);
			for (var dayCount:int = 0; dayCount < this._dayRange; dayCount++)
			{
				value = this._dailyAdherenceData[dayCount];
				if(value > -1)
				{
					valueY = (fullValueHeight / 100) * value;
					plotLine.graphics.lineTo(this._chartStartX + (this._daySegmentWidth * dayCount),plotStartY - valueY);
					plotCircles.graphics.beginFill(LINE_COLOUR);
					plotCircles.graphics.drawCircle(this._chartStartX + (this._daySegmentWidth * dayCount),plotStartY - valueY,PLOT_GIRTH * 2);
					plotCircles.graphics.endFill();
					this._plotPointsA.push({x:this._chartStartX + (this._daySegmentWidth * dayCount) , y:plotStartY - valueY});
				}
				else
				{
					addChild(plotLine);
					plotLine = new Shape();
					plotLine.graphics.lineStyle(PLOT_GIRTH,LINE_COLOUR);
				}
			}
			addChild(plotLine);
			addChild(plotCircles);
		}

		private function initChartTitleLabel():void
		{
			var chartTitleLabel:Label = new Label();
			chartTitleLabel.name = HivivaThemeConstants.BODY_BOLD_WHITE_CENTERED_LABEL;
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
			leftAxisTop.name = HivivaThemeConstants.BODY_BOLD_WHITE_CENTERED_LABEL;
			leftAxisTop.text = "100%";
			addChild(leftAxisTop);
			leftAxisTop.width = this._leftAxisSpace;
			leftAxisTop.validate();
//			leftAxisTop.x = leftPadding;
			leftAxisTop.y = this._chartStartY - (leftAxisTop.height * 0.5);

			var leftAxisBottom:Label = new Label();
			leftAxisBottom.name = HivivaThemeConstants.BODY_BOLD_WHITE_CENTERED_LABEL;
			leftAxisBottom.text = this._lowestValue + "%";
			addChild(leftAxisBottom);
			leftAxisBottom.width = this._leftAxisSpace;
			leftAxisBottom.validate();
//			leftAxisBottom.x = leftPadding;
			leftAxisBottom.y = this._chartStartY + this._chartHeight - (leftAxisBottom.height * 0.5);

			var leftAxisLabel:Label = new Label();
			leftAxisLabel.name = HivivaThemeConstants.BODY_BOLD_WHITE_CENTERED_LABEL;
			leftAxisLabel.text = "Adherence";
			addChild(leftAxisLabel);
			leftAxisLabel.width = 400;
			leftAxisLabel.validate();
			leftAxisLabel.rotation = deg2rad(-90);
			leftAxisLabel.x = leftAxisTop.x + (leftAxisTop.width * 0.5) - (leftAxisLabel.height * 0.5);
			leftAxisLabel.y = this._chartStartY + (this._chartHeight * 0.5) + (leftAxisLabel.width * 0.5);

			_leftAxisDetails.push({x:leftAxisTop.x , y:leftAxisTop.y , text:leftAxisTop.text});
			_leftAxisDetails.push({x:leftAxisBottom.x , y:leftAxisBottom.y , text:leftAxisBottom.text});
			_leftAxisDetails.push({x:leftAxisLabel.x , y:leftAxisLabel.y , text:leftAxisLabel.text});
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
				this._leftAxisLinesA.push({x:horizontalLine.x , y:horizontalLine.y , width:horizontalLine.width});   //PDF DATA
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
			for (var segmentCount:int = 0; segmentCount < _xAxisTotal; segmentCount++)
			{
				xAxisPosition = this._xAxisSegmentWidth * segmentCount;

				bottomAxisValue = new Label();
				bottomAxisValue.name = HivivaThemeConstants.CELL_SMALL_WHITE_LABEL;
				/*bottomAxisValue.text = HivivaModifier.isoDateToPrettyString((daysItar.getMonth() + 1).toString()) + "/" +
						HivivaModifier.addPrecedingZero(daysItar.getDate().toString());*/
				bottomAxisValue.text = HivivaModifier.getPrettyStringFromDate(daysItar,false);
				addChild(bottomAxisValue);
				bottomAxisValue.validate();
				bottomAxisValue.rotation = deg2rad(-90);
				bottomAxisValue.x = this._chartStartX + (xAxisPosition - (bottomAxisValue.height * 0.5));
				// + 4 for padding
				bottomAxisValue.y = this._chartStartY + this._chartHeight + bottomAxisValue.width + 10;

//				daysItar.date++;
				daysItar.date += this._dayBreakDownRatio;

				verticalLine = new Image(vertLineTexture);
				addChild(verticalLine);
				verticalLine.x = this._chartStartX + xAxisPosition;
				verticalLine.y = this._chartStartY;
				verticalLine.height = this._chartHeight;
				this._rightAxisLinesA.push({x:verticalLine.x , y:verticalLine.y , height:verticalLine.height})     //PDF DATA
				this._rightAxisDetails.push({x:bottomAxisValue.x , y:bottomAxisValue.y , text:bottomAxisValue.text})
				// every even segment
				if ((segmentCount / 2).toString().indexOf('.') > -1)
				{
					if(segmentCount < (_xAxisTotal - 1))
					{
						evenLighter = new Quad(this._xAxisSegmentWidth, this._chartHeight, 0xffffff);
						evenLighter.alpha = 0.2;
						addChild(evenLighter);
						evenLighter.x = this._chartStartX + xAxisPosition;
						evenLighter.y = this._chartStartY;
					}
					else
					{
						evenLighter = new Quad(this._chartWidth - xAxisPosition, this._chartHeight, 0xffffff);
						evenLighter.alpha = 0.2;
						addChild(evenLighter);
						evenLighter.x = this._chartStartX + xAxisPosition;
						evenLighter.y = this._chartStartY;
					}
				}
			}
			this._bottomAxisValueHeight = bottomAxisValue.height;
		}

		private function initBottomAxisLabels():void
		{
			var bottomAxisLabel:Label = new Label();
			bottomAxisLabel.name = HivivaThemeConstants.BODY_BOLD_WHITE_CENTERED_LABEL;
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


		public function generatePDFVersion(pdfDocument:PdfDocument):void
		{
			trace("PurePDF: " + pdfDocument.getInfo());
			trace("PurePDF: " + pdfDocument.pageSize);
			trace("PurePDF: this._chartStartY " + this._chartStartY);

			pdfDocument.newPage();
			pdfDocument.setMargins(36,36,36,36);
			var cb:PdfContentByte = pdfDocument.getDirectContent();
			var pagesize:RectangleElement = PageSize.create(595, 842);

			var xCompensate:Number = 40;
			var yCompensate:Number = 100;


			cb.setTransform( new Matrix( 1, 0, 0, -1, 0, pagesize.height ))

			//Draw Backing

			cb.saveState();
			var r: RectangleElement = new RectangleElement( this._chartStartX - xCompensate, this._chartStartY + yCompensate, this._chartStartX + this._chartWidth - xCompensate , this._chartStartY + this._chartHeight + yCompensate);
			r.borderSides = RectangleElement.ALL;
			r.borderColor = new RGBColor(204,204,204);
			r.backgroundColor = new RGBColor(245,245,245);
			r.borderWidth = 0.25;

			cb.rectangle( r );
			cb.restoreState();

			//left axis lines
			cb.saveState();
			cb.setLineWidth(0.25);
			cb.setColorStroke(new RGBColor(204,204,204));

			var loop2:uint =   this._leftAxisLinesA.length;
			for(var j:uint = 0 ; j < loop2 ; j++)
			{
				cb.moveTo(this._leftAxisLinesA[j].x - xCompensate , (this._leftAxisLinesA[j].y + yCompensate));
				cb.lineTo(this._leftAxisLinesA[j].width + this._chartStartX - xCompensate , (this._leftAxisLinesA[j].y + yCompensate));
				cb.stroke();
			}
			cb.restoreState();


			//vert axis lines
			cb.saveState();
			cb.setLineWidth(0.25);
			cb.setColorStroke(new RGBColor(204,204,204));

			var loop3:uint =   this._rightAxisLinesA.length;
			for(var s:uint = 0 ; s < loop3 ; s++)
			{
				cb.moveTo(this._rightAxisLinesA[s].x - xCompensate , this._rightAxisLinesA[s].y + yCompensate);
				cb.lineTo(this._rightAxisLinesA[s].x - xCompensate , this._rightAxisLinesA[s].height + this._chartStartY + yCompensate);
				cb.stroke();
			}
			cb.restoreState();


			//Draw line Points
			cb.saveState();
			cb.setLineWidth(1);
			cb.moveTo(this._plotPointsA[0].x - xCompensate , (this._plotPointsA[0].y + yCompensate));

			var loop:uint =   this._plotPointsA.length;
			for(var l:uint = 0 ; l < loop ; l++)
			{
				cb.lineTo(this._plotPointsA[l].x - xCompensate , (this._plotPointsA[l].y + yCompensate));
			}
			cb.stroke();
			cb.restoreState();

			//Draw Circle Points
			cb.saveState();
			for(var m:uint = 0 ; m < loop ; m++)
			{
				cb.setColorFill(new RGBColor(0,0,0));
				cb.circle(this._plotPointsA[m].x - xCompensate , (this._plotPointsA[m].y + yCompensate),4);
				cb.fillStroke();
			}
			cb.restoreState();



			cb.setTransform(new Matrix( 1, 0, 0, -1, -1, pagesize.height ));

			//Draw Chart Title

			var bf:BaseFont = BaseFont.createFont( BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.EMBEDDED );
			cb.setFontAndSize(bf, 20);
			cb.saveState();
			cb.beginText();
			cb.moveText(this._chartStartX + 130, 842 - this._chartStartY - yCompensate + 30);
			cb.showText("Overall Adherence");
			cb.endText();
			cb.restoreState();

			//bottom axis text
			cb.setFontAndSize(bf, 8);
			cb.saveState();
			var loop4:uint =  this._rightAxisDetails.length;
			for(var v:uint = 0 ; v <loop4 ; v++)
			{
				cb.beginText();
				cb.showTextAligned( Element.ALIGN_RIGHT, _rightAxisDetails[v].text, _rightAxisDetails[v].x - xCompensate + 16, 842-_rightAxisDetails[0].y - yCompensate + this._chartStartY + 10, 90 );
				cb.endText();
			}
			cb.restoreState();

			//left axis top
			cb.saveState();
			cb.beginText();
			cb.showTextAligned( Element.ALIGN_RIGHT, _leftAxisDetails[0].text, _leftAxisDetails[0].x + xCompensate , 842-_leftAxisDetails[0].y - yCompensate - 15 , 0);
			cb.endText();
			cb.restoreState();

			//left axis bottom
			cb.saveState();
			cb.beginText();
			cb.showTextAligned( Element.ALIGN_RIGHT, _leftAxisDetails[1].text, _leftAxisDetails[1].x + xCompensate , 842-_leftAxisDetails[1].y - yCompensate - 15 , 0);
			cb.endText();
			cb.restoreState();

			//left axis center
			cb.setFontAndSize(bf, 20);
			cb.saveState();
			cb.beginText();
			cb.showTextAligned( Element.ALIGN_LEFT, _leftAxisDetails[2].text, _leftAxisDetails[2].x, 842-_leftAxisDetails[2].y + 50, 90 );
			cb.endText();
			cb.restoreState();

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
