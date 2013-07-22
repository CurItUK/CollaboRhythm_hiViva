package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;

	import feathers.controls.Label;
	import feathers.controls.ScrollContainer;
	import feathers.core.FeathersControl;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;

	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;

	import source.themes.HivivaTheme;

	import starling.display.BlendMode;
	import starling.display.DisplayObject;

	import starling.display.Image;
	import starling.display.Quad;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	import starling.utils.rad2deg;

	public class PatientAdherenceTable extends FeathersControl
	{
		private var _medications:XMLList;
		private var _history:Dictionary;
		private var _dayRow:Sprite;
		private var _weekNavHolder:Sprite;
		private var _weekText:Label;
		private const _weekDays:Array = ["M", "T", "W", "T", "F", "S", "S"];
		private var _firstColumnWidth:Number;
		private var _firstRowHeight:Number;
		private var _dataColumnsWidth:Number;
		private var _tableStartY:Number;
		private var _mainScrollContainer:ScrollContainer;
		private var _rowsData:Array = [];
		private var _dataContainer:Sprite;
		private var _currWeekBeginning:Date;
		private var _dailyTolerabilityData:Array;
		private var _patientData:XML;
		private var _scale:Number = 1;

		public function PatientAdherenceTable()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._firstColumnWidth = this.actualWidth * 0.35;
			this._dataColumnsWidth = (this.actualWidth * 0.65) / 8;
		}

		override protected function initialize():void
		{
			super.initialize();
			this._medications = _patientData.DCUserMedication as XMLList;
			extractHistory();
			this._currWeekBeginning = HivivaStartup.userVO.serverDate;
			HivivaModifier.floorToClosestMonday(this._currWeekBeginning);
		}

		public function drawTable():void
		{
			initWeekNav();
			initDayRow();
			initTableContainer();
			initMedicineNamesColumn();
			recordRowHeights();
			updateTableData();
			initTableBackground();
		}

		private function initWeekNav():void
		{
//			var arrowTexture:Texture = Assets.getTexture('ArrowPng');
			this._weekNavHolder = new Sprite();
			addChild(this._weekNavHolder);
			this._weekNavHolder.x = this._firstColumnWidth;

			var viewLabel:Label = new Label();
			viewLabel.name = HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL;
			viewLabel.text = "View:";
			this._weekNavHolder.addChild(viewLabel);
			viewLabel.width = this._dataColumnsWidth * 2;
			viewLabel.validate();

			var leftArrow:Button = new Button();
			leftArrow.name = "calendar-arrows";
//			leftArrow.defaultSkin = new Image(arrowTexture);
			leftArrow.addEventListener(starling.events.Event.TRIGGERED, leftArrowHandler);
			this._weekNavHolder.addChild(leftArrow);
			leftArrow.validate();
			leftArrow.x = viewLabel.x + viewLabel.width;

			var rightArrow:Button = new Button();
			rightArrow.name = "calendar-arrows";
//			rightArrow.defaultSkin = new Image(arrowTexture);
			rightArrow.addEventListener(starling.events.Event.TRIGGERED, rightArrowHandler);
			this._weekNavHolder.addChild(rightArrow);
			rightArrow.scaleX = -1;
			rightArrow.validate();

			this._weekText = new Label();
			this._weekText.touchable = false;
			this._weekText.name = HivivaThemeConstants.BODY_CENTERED_LABEL;
			this._weekNavHolder.addChild(this._weekText);
			this._weekText.width = (this._dataColumnsWidth * 7) -
					rightArrow.width - leftArrow.width - viewLabel.width;
			this._weekText.validate();

			this._weekText.x = leftArrow.x + leftArrow.width;
			leftArrow.y = (this._weekText.height * 0.5) - (leftArrow.height * 0.25);
			rightArrow.y = (this._weekText.height * 0.5) - (rightArrow.height * 0.25);
			rightArrow.x = (this._dataColumnsWidth * 8) - rightArrow.width;
		}

		private function initDayRow():void
		{
			// day names row
			var firstRowPadding:Number = this.actualHeight * 0.02;
			_dayRow = new Sprite();
			_dayRow.y = this._weekNavHolder.height;
			addChild(_dayRow);

			var dayLabel:Label;
			for (var dayCount:int = 0; dayCount < 8; dayCount++)
			{
				dayLabel = new Label();
				dayLabel.name = HivivaThemeConstants.PATIENT_DATA_LIGHTER_LABEL;
				dayLabel.width = this._dataColumnsWidth;
				dayLabel.x = this._firstColumnWidth + (this._dataColumnsWidth * dayCount);
				dayLabel.y = firstRowPadding;
				dayLabel.text = this._weekDays[dayCount];
				_dayRow.addChild(dayLabel);
				dayLabel.validate();
			}
			// need to validate for row height
			this._firstRowHeight = _dayRow.height + (firstRowPadding * 2);
		}

		private function initTableContainer():void
		{
			// data vertical scroll container
			this._tableStartY = this._weekNavHolder.height + this._firstRowHeight;

			this._mainScrollContainer = new ScrollContainer();
			addChild(this._mainScrollContainer);
			this._mainScrollContainer.y = this._tableStartY;

			var vLayout:VerticalLayout = new VerticalLayout();
			vLayout.hasVariableItemDimensions = true;
			this._mainScrollContainer.layout = vLayout;
		}

		private function initMedicineNamesColumn():void
		{
			// names column
			var medicationCount:uint = _medications.length();
			var medicationCell:MedicationCell;
			for (var cellCount:int = 0; cellCount < medicationCount; cellCount++)
			{
				medicationCell = new MedicationCell();
				medicationCell.scale = this._scale;
				medicationCell.brandName = HivivaModifier.getBrandName(_medications[cellCount].MedicationName);
				medicationCell.genericName = HivivaModifier.getGenericName(_medications[cellCount].MedicationName);
				this._mainScrollContainer.addChild(medicationCell);
				medicationCell.width = this._firstColumnWidth;

				this._rowsData.push({id: cellCount});
			}
			// tolerability row name

			var tolerabilityRowHolder:Sprite = new Sprite();
			this._mainScrollContainer.addChild(tolerabilityRowHolder);

			var tolerabilityRowLabel:Label = new Label();
			tolerabilityRowLabel.text = "Tolerability";
			tolerabilityRowHolder.addChild(tolerabilityRowLabel);
			tolerabilityRowLabel.textRendererProperties.textFormat = new BitmapFontTextFormat(TextField.getBitmapFont("engraved-lighter-bold"), 24 * this.scale, Color.WHITE);
			tolerabilityRowLabel.x = 30 * this.scale; // MedicationCell gap * 2
			tolerabilityRowLabel.y = 15 * this.scale; // MedicationCell gap
			tolerabilityRowLabel.width = this._firstColumnWidth - tolerabilityRowLabel.x;
			tolerabilityRowLabel.validate();

			var tolerabilityRowBg:Quad = new Quad(this._firstColumnWidth, tolerabilityRowLabel.height + (30 * this.scale), 0x000000);
			tolerabilityRowBg.alpha = 0;
			tolerabilityRowHolder.addChild(tolerabilityRowBg);

			this._rowsData.push({id: medicationCount});

			this._mainScrollContainer.validate();

			var maxHeight:Number = this.actualHeight - this._tableStartY;
			if (maxHeight < this._mainScrollContainer.height) this._mainScrollContainer.height = maxHeight;
			this._mainScrollContainer.layout = null;
		}

		private function recordRowHeights():void
		{
			var rowsDataLength:int = this._rowsData.length;
			var rowData:Object;
			var cellY:Number = 0;
			var rowLabel:DisplayObject;
			for (var rowCount:int = 0; rowCount < rowsDataLength; rowCount++)
			{
				rowLabel = this._mainScrollContainer.getChildAt(rowCount) as DisplayObject;
				rowData = this._rowsData[rowCount];

				rowData.y = cellY;
				rowData.cellHeight = rowLabel.height;
				cellY += rowLabel.height;
			}
		}

		private function leftArrowHandler(e:Event):void
		{
			this._currWeekBeginning.date -= 7;
			updateTableData();
		}

		private function rightArrowHandler(e:Event):void
		{
			this._currWeekBeginning.date += 7;
			updateTableData();
		}

		private function updateTableData():void
		{
			setCurrentWeek();
			initTableDataContainer();
			populateAdherence();
			populateTolerability();
		}

		private function setCurrentWeek():void
		{
//			HivivaModifier.floorToClosestMonday(this._currWeekBeginning);
			this._weekText.text = "wc: " + HivivaModifier.getCalendarStringFromDate(this._currWeekBeginning);
			this._weekText.validate();
		}

		private function extractHistory():void
		{
			_history = new Dictionary();
			var medicationLength:int = this._medications.length();
			var medicationSchedule:XMLList;
			var medicationScheduleLength:int;
			var referenceDate:Number;
			for (var i:int = 0; i < medicationLength; i++)
			{
				medicationSchedule = this._medications[i].Schedule.DCMedicationSchedule as XMLList;
				medicationScheduleLength = medicationSchedule.length();
				for (var j:int = 0; j < medicationScheduleLength; j++)
				{
					referenceDate = HivivaModifier.isoDateToFlashDate(String(medicationSchedule[j].DateTaken)).getTime();
					if (_history[referenceDate] == undefined) _history[referenceDate] = [];
					_history[referenceDate].push({id:i,data:medicationSchedule[j]});
				}
			}
		}

		private function initTableDataContainer():void
		{
			if(this._dataContainer != null)
			{
				this._dataContainer.removeChildren(0,-1,true);
			}
			this._dataContainer = new Sprite();
			this._mainScrollContainer.addChild(this._dataContainer);
			this._dataContainer.x = this._firstColumnWidth;
		}

		private function populateAdherence():void
		{
			var rowData:Object;
			var currWeekDay:Date = new Date(this._currWeekBeginning.getFullYear(), this._currWeekBeginning.getMonth(),
					this._currWeekBeginning.getDate(), 0, 0, 0, 0);
			var columnData:Array;
			var columnDataLength:int;
			var columnXML:XML;
			var cell:Sprite;
			var tickTexture:Texture = Assets.getTexture("TickPng");
			var crossTexture:Texture = Assets.getTexture("CrossPng");

			this._dailyTolerabilityData = [];

			for (var rowCount:int = 0; rowCount < this._rowsData.length - 1; rowCount++)
			{
				rowData = this._rowsData[rowCount];
				for (var dayCount:int = 0; dayCount < 7; dayCount++)
				{
					columnData = _history[currWeekDay.getTime()];
					if (columnData != null)
					{
						columnDataLength = columnData.length;
						for (var i:int = 0; i < columnDataLength; i++)
						{
							if (columnData[i].id == rowData.id)
							{
								columnXML = columnData[i].data;
								cell = createCell(rowData.cellHeight, this._dataColumnsWidth * dayCount, rowData.y);
								this._dataContainer.addChild(cell);

								var tickCrossImage:Image = new Image(String(columnXML.PercentTaken) ==
										"100" ? tickTexture : crossTexture);
								cell.addChild(tickCrossImage);
								tickCrossImage.x = (cell.width * 0.5) - (tickCrossImage.width * 0.5);
								tickCrossImage.y = (cell.height * 0.5) - (tickCrossImage.height * 0.5);

								this._dailyTolerabilityData.push({day: dayCount, value: int(columnXML.Tolerability)});
							}
						}
					}
					currWeekDay.date++;
				}
				currWeekDay = new Date(this._currWeekBeginning.getFullYear(), this._currWeekBeginning.getMonth(),
						this._currWeekBeginning.getDate(), 0, 0, 0, 0);
			}
		}

		private function populateTolerability():void
		{
			var rowData:Object = this._rowsData[this._rowsData.length - 1];
			var cell:Sprite;
			var medicationTolerability:Number = 0;
			var medicationTolerabilityCount:int = 0;

			for (var dayCount:int = 0; dayCount < 7; dayCount++)
			{
				if(this._dailyTolerabilityData.length > 0)
				{
					for (var tolCount:int = 0; tolCount < this._dailyTolerabilityData.length; tolCount++)
					{
						if(this._dailyTolerabilityData[tolCount].day == dayCount)
						{
							medicationTolerability += this._dailyTolerabilityData[tolCount].value;
							medicationTolerabilityCount++;
						}
					}

					cell = createCell(rowData.cellHeight, this._dataColumnsWidth * dayCount, rowData.y);
					this._dataContainer.addChild(cell);

					var cellLabel:Label = new Label();
					cellLabel.width = this._dataColumnsWidth;
					cellLabel.name = HivivaThemeConstants.PATIENT_DATA_LIGHTER_LABEL;
					cellLabel.text = String(int(medicationTolerability / medicationTolerabilityCount));
					cell.addChild(cellLabel);
					cellLabel.validate();
					cellLabel.y = (cell.height * 0.5) - (cellLabel.height * 0.5);

					medicationTolerability = 0;
					medicationTolerabilityCount = 0;
				}
			}
		}

		private function createCell(cellHeight:Number, cellX:Number, cellY:Number):Sprite
		{
			var cell:Sprite = new Sprite();
			cell.x = cellX;
			cell.y = cellY;

			var cellBg:Quad = new Quad(this._dataColumnsWidth,cellHeight,0x000000);
			cellBg.alpha = 0;
			cell.addChild(cellBg);

			return cell;
		}

		private function initTableBackground():void
		{
			initTableBgColours();
			initDayRowBg();
			initVerticalLines();
			initHorizontalLines();
		}

		private function initTableBgColours():void
		{
			var wholeTableBg:Sprite = new Sprite();
			wholeTableBg.y = this._mainScrollContainer.y;
			addChildAt(wholeTableBg, 0);

			var tableBgColour:Quad = new Quad(this.actualWidth, this._mainScrollContainer.height, 0x4c5f76);
			tableBgColour.alpha = 0.1;
//			tableBgColour.y = dayRowGrad.height;
			tableBgColour.blendMode = BlendMode.MULTIPLY;
			wholeTableBg.addChild(tableBgColour);

			var firstColumnGrad:Quad = new Quad(this._firstColumnWidth, this._mainScrollContainer.height, 0x233448);
			firstColumnGrad.setVertexAlpha(0, 0);
			firstColumnGrad.setVertexAlpha(1, 1);
			firstColumnGrad.setVertexAlpha(2, 0);
			firstColumnGrad.setVertexAlpha(3, 1);
//			firstColumnGrad.y = this._firstRowHeight;
			firstColumnGrad.alpha = 0.1;
			wholeTableBg.addChild(firstColumnGrad);

			var lastColumnGrad:Quad = new Quad(this._firstColumnWidth, this._mainScrollContainer.height, 0x233448);
			lastColumnGrad.setVertexAlpha(0, 1);
			lastColumnGrad.setVertexAlpha(1, 0);
			lastColumnGrad.setVertexAlpha(2, 1);
			lastColumnGrad.setVertexAlpha(3, 0);
			lastColumnGrad.x = this._firstColumnWidth + (this._dataColumnsWidth * 7);
//			lastColumnGrad.y = this._firstRowHeight;
			lastColumnGrad.alpha = 0.1;
			wholeTableBg.addChild(lastColumnGrad);
		}

		private function initDayRowBg():void
		{
			var horizLineTexture:Texture = Main.assets.getTexture("header_line");
			var horizontalLine:Image;

			var dayRowGrad:Quad = new Quad(this.actualWidth, this._firstRowHeight);
			dayRowGrad.setVertexColor(0, 0xFFFFFF);
			dayRowGrad.setVertexColor(1, 0xFFFFFF);
			dayRowGrad.setVertexColor(2, 0x293d54);
			dayRowGrad.setVertexColor(3, 0x293d54);
			dayRowGrad.alpha = 0.2;
			this._dayRow.addChildAt(dayRowGrad, 0);

			horizontalLine = new Image(horizLineTexture);
			horizontalLine.y = this._firstRowHeight;
			horizontalLine.width = this.actualWidth;
			this._dayRow.addChildAt(horizontalLine, 1);
		}

		private function initVerticalLines():void
		{
			var vertLineTexture:Texture = Assets.getTexture("VerticleLinePng");
			var verticalLine:Image;
			for (var dayCount:int = 0; dayCount < 8; dayCount++)
			{
				verticalLine = new Image(vertLineTexture);
				verticalLine.x = this._firstColumnWidth + (this._dataColumnsWidth * dayCount);
				verticalLine.y = this._weekNavHolder.height;
				verticalLine.height = this._firstRowHeight + this._mainScrollContainer.height;
				addChild(verticalLine);
			}
		}

		private function initHorizontalLines():void
		{
			var horizLineTexture:Texture = Main.assets.getTexture("header_line");
			var horizontalLine:Image;
			var rowData:Object;
			for (var rowCount:int = 0; rowCount < this._rowsData.length; rowCount++)
			{
				rowData = this._rowsData[rowCount];
				horizontalLine = new Image(horizLineTexture);
				horizontalLine.y = rowData.y;
				horizontalLine.width = this.actualWidth;
				this._mainScrollContainer.addChild(horizontalLine);
			}
			horizontalLine = new Image(horizLineTexture);
			horizontalLine.y = rowData.y + rowData.cellHeight;
			horizontalLine.width = this.actualWidth;
			this._mainScrollContainer.addChild(horizontalLine);
		}

		public function get patientData():XML
		{
			return _patientData;
		}

		public function set patientData(value:XML):void
		{
			_patientData = value;
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
		}
	}
}
