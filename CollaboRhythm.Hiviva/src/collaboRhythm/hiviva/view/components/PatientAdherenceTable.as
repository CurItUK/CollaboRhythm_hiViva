package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;

	import feathers.controls.Label;
	import feathers.controls.ScrollContainer;
	import feathers.core.FeathersControl;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.VerticalLayout;

	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import source.themes.HivivaTheme;

	import starling.display.BlendMode;

	import starling.display.Image;
	import starling.display.Quad;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	import starling.utils.rad2deg;

	public class PatientAdherenceTable extends FeathersControl
	{
		private var _weekNavHolder:Sprite;
		private var _weekText:Label;
		private const _weekDays:Array = ["M", "T", "W", "T", "F", "S", "S"];
		private var _firstColumnWidth:Number;
		private var _firstRowHeight:Number;
		private var _dataColumnsWidth:Number;
		private var _tableStartY:Number;
		private var _mainScrollContainer:ScrollContainer;
		private var _rowsData:Array = [];
		private var _dataContainer:ScrollContainer;
		private var _currWeekBeginning:Date;
		private var _historyLength:int;
		private var _patientData:XML;
		private var _scale:Number;

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
		}

		public function drawTable():void
		{
			initWeekNav();
			initDayRow();
			initTableContainer();
			initMedicineNamesColumn();
			recordRowHeights();
			initTableData();
			initTableBackground();
		}

		private function initWeekNav():void
		{
//			var arrowTexture:Texture = Assets.getTexture('ArrowPng');
			this._weekNavHolder = new Sprite();
			addChild(this._weekNavHolder);
			this._weekNavHolder.x = this._firstColumnWidth;

			var viewLabel:Label = new Label();
			viewLabel.text = "<font face='ExoBold'>View:</font>";
			viewLabel.name = "medicine-brandname";
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
			this._weekText.name = "centered-label";
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
			var dayRow:Sprite = new Sprite();
			dayRow.x = this._firstColumnWidth;
			dayRow.y = this._weekNavHolder.height + firstRowPadding;
			addChild(dayRow);

			var dayLabel:Label;
			for (var dayCount:int = 0; dayCount < 8; dayCount++)
			{
				dayLabel = new Label();
				dayLabel.name = "patient-data-lighter";
				dayLabel.width = this._dataColumnsWidth;
				dayLabel.x = this._dataColumnsWidth * dayCount;
				dayLabel.text = this._weekDays[dayCount];
				dayRow.addChild(dayLabel);
				dayLabel.validate();
			}
			// need to validate for row height
			this._firstRowHeight = dayRow.height + (firstRowPadding * 2);
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
			var medications:XMLList = _patientData.medications.medication as XMLList;
			var medicationCount:uint = medications.length();
			var medicationCell:MedicationCell;
			for (var cellCount:int = 0; cellCount < medicationCount; cellCount++)
			{
				medicationCell = new MedicationCell();
				medicationCell.scale = this._scale;
				medicationCell.brandName = medications[cellCount].brandname;
				medicationCell.genericName = medications[cellCount].genericname;
				this._mainScrollContainer.addChild(medicationCell);
				medicationCell.width = this._firstColumnWidth;

				this._rowsData.push({id: medications[cellCount].id});
			}
			// tolerability row name
			medicationCell = new MedicationCell();
			medicationCell.scale = this._scale;
			medicationCell.brandName = "Tolerability";
			this._mainScrollContainer.addChild(medicationCell);
			medicationCell.width = this._firstColumnWidth;

			this._rowsData.push({id: "tolerability"});

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
			var medicationCell:MedicationCell;
			for (var rowCount:int = 0; rowCount < rowsDataLength; rowCount++)
			{
				medicationCell = this._mainScrollContainer.getChildAt(rowCount) as MedicationCell;
				rowData = this._rowsData[rowCount];

				rowData.y = cellY;
				rowData.cellHeight = medicationCell.height;
				cellY += medicationCell.height;
			}
		}

		private function leftArrowHandler(e:Event):void
		{
			this._currWeekBeginning.setDate(this._currWeekBeginning.getDate() - 7);
			changeTableData();
		}

		private function rightArrowHandler(e:Event):void
		{
			this._currWeekBeginning.setDate(this._currWeekBeginning.getDate() + 7);
			changeTableData();
		}

		private function initTableData():void
		{
			var history:XMLList = _patientData.medicationHistory.history as XMLList;
			var dateArr:Array = String(history[0].date).split("/");
			this._currWeekBeginning = new Date(int(dateArr[2]),int(dateArr[0]) - 1,int(dateArr[1]),0,0,0,0);

			setCurrentWeek();
			initTableDataContainer();
			populateData();
		}

		private function changeTableData():void
		{
			setCurrentWeek();
			this._dataContainer.removeChildren();
			populateData();
		}

		private function setCurrentWeek():void
		{
			HivivaModifier.floorToClosestMonday(this._currWeekBeginning);
			this._weekText.text = "wc: " + (this._currWeekBeginning.getMonth() + 1) + "/" + this._currWeekBeginning.getDate() + "/" + this._currWeekBeginning.getFullYear();
			this._weekText.validate();
		}

		private function initTableDataContainer():void
		{
// data horizontal
//			const hLayout:TiledColumnsLayout = new TiledColumnsLayout();
//			hLayout.paging = TiledColumnsLayout.PAGING_HORIZONTAL;
//			hLayout.useSquareTiles = false;
//			hLayout.horizontalAlign = TiledColumnsLayout.HORIZONTAL_ALIGN_LEFT;
//			hLayout.verticalAlign = TiledColumnsLayout.VERTICAL_ALIGN_TOP;

			this._dataContainer = new ScrollContainer();
			//dataContainer.layout = hLayout;
			this._dataContainer.scrollerProperties.snapToPages = TiledColumnsLayout.PAGING_HORIZONTAL;
			this._dataContainer.scrollerProperties.snapScrollPositionsToPixels = true;
			this._mainScrollContainer.addChild(this._dataContainer);
			this._dataContainer.x = this._firstColumnWidth;
			//dataContainer.y = firstRowHeight;
			this._dataContainer.width = this._dataColumnsWidth * 8;
			this._dataContainer.height = this._mainScrollContainer.height;
		}

		private function populateData():void
		{
			var history:XMLList = _patientData.medicationHistory.history as XMLList;
			this._historyLength = history.length();
			var currWeekDay:Date = new Date(this._currWeekBeginning.getFullYear(),this._currWeekBeginning.getMonth(),this._currWeekBeginning.getDate(),0,0,0,0);
			var dateData:Array;
//			var historyDay:Date = new Date(null,null,null,0,0,0,0);
			var historyDate:Date;
			var historicalMedication:XMLList;
			var rowData:Object;
			var cell:Sprite;
			var cellX:Number;
			var cellBg:Quad;
			var cellLabel:Label;
			var tickTexture:Texture = Assets.getTexture("TickPng");
			var crossTexture:Texture = Assets.getTexture("CrossPng");
			var tickCrossImage:Image;
			for (var dayCount:int = 0; dayCount < 7; dayCount++)
			{
				for (var historyCount:int = 0; historyCount < _historyLength; historyCount++)
				{
					dateData = String(history[historyCount].date).split("/");
					historyDate = new Date(int(dateData[2]),int(dateData[0]) - 1,int(dateData[1]),0,0,0,0);

					if(historyDate.getTime() == currWeekDay.getTime())
					{
						cellX = this._dataColumnsWidth * dayCount;
						for (var rowCount:int = 0; rowCount < this._rowsData.length; rowCount++)
						{
							rowData = this._rowsData[rowCount];

							cell = new Sprite();
							cell.x = cellX;
							cell.y = rowData.y;
							this._dataContainer.addChild(cell);

							cellBg = new Quad(this._dataColumnsWidth,rowData.cellHeight,0x000000);
							cellBg.alpha = 0;
							cell.addChild(cellBg);

							if (rowData.id == "tolerability")
							{
								// write tolerability data cell
								// history[historyCount].tolerability
								cellLabel = new Label();
								cellLabel.width = this._dataColumnsWidth;
								cellLabel.name = "patient-data-lighter";
								cellLabel.text = history[historyCount].tolerability;
								cell.addChild(cellLabel);
								cellLabel.validate();
								cellLabel.y = (cellBg.height * 0.5) - (cellLabel.height * 0.5);
							}
							else
							{
								historicalMedication = history[historyCount].medication.(@id == rowData.id);
								if (historicalMedication.adhered == "yes")
								{
									// tick
									tickCrossImage = new Image(tickTexture);
								}
								else
								{
									// cross
									tickCrossImage = new Image(crossTexture);
								}
								cell.addChild(tickCrossImage);
								tickCrossImage.x = (cellBg.width * 0.5) - (tickCrossImage.width * 0.5);
								tickCrossImage.y = (cellBg.height * 0.5) - (tickCrossImage.height * 0.5);
							}
						}
					}
				}
				currWeekDay.date++;
			}
		}

		private function initTableBackground():void
		{

			// whole table background
			var wholeTableBg:Sprite = new Sprite();
			addChild(wholeTableBg);
			swapChildren(wholeTableBg, this._mainScrollContainer);
			wholeTableBg.y = this._weekNavHolder.height;

			var dayRowGrad:Quad = new Quad(this.actualWidth, this._firstRowHeight);
			dayRowGrad.setVertexColor(0, 0xFFFFFF);
			dayRowGrad.setVertexColor(1, 0xFFFFFF);
			dayRowGrad.setVertexColor(2, 0x293d54);
			dayRowGrad.setVertexColor(3, 0x293d54);
			dayRowGrad.alpha = 0.2;
			wholeTableBg.addChild(dayRowGrad);

			var tableBgColour:Quad = new Quad(this.actualWidth, this._mainScrollContainer.height, 0x4c5f76);
			tableBgColour.alpha = 0.1;
			tableBgColour.y = dayRowGrad.height;
			tableBgColour.blendMode = BlendMode.MULTIPLY;
			wholeTableBg.addChild(tableBgColour);

			var firstColumnGrad:Quad = new Quad(this._firstColumnWidth, this._mainScrollContainer.height, 0x233448);
			firstColumnGrad.setVertexAlpha(0, 0);
			firstColumnGrad.setVertexAlpha(1, 1);
			firstColumnGrad.setVertexAlpha(2, 0);
			firstColumnGrad.setVertexAlpha(3, 1);
			firstColumnGrad.y = this._firstRowHeight;
			firstColumnGrad.alpha = 0.1;
			wholeTableBg.addChild(firstColumnGrad);

			var lastColumnGrad:Quad = new Quad(this._firstColumnWidth, this._mainScrollContainer.height, 0x233448);
			lastColumnGrad.setVertexAlpha(0, 1);
			lastColumnGrad.setVertexAlpha(1, 0);
			lastColumnGrad.setVertexAlpha(2, 1);
			lastColumnGrad.setVertexAlpha(3, 0);
			lastColumnGrad.x = this._firstColumnWidth + (this._dataColumnsWidth * 7);
			lastColumnGrad.y = this._firstRowHeight;
			lastColumnGrad.alpha = 0.1;
			wholeTableBg.addChild(lastColumnGrad);

			var vertLineTexture:Texture = Assets.getTexture("VerticleLinePng");
			var verticalLine:Image;
			for (var dayCount:int = 0; dayCount < 8; dayCount++)
			{
				verticalLine = new Image(vertLineTexture);
				verticalLine.x = this._firstColumnWidth + (this._dataColumnsWidth * dayCount);
				verticalLine.height = this._firstRowHeight + this._mainScrollContainer.height;
				wholeTableBg.addChild(verticalLine);
			}

			var horizLineTexture:Texture = Main.assets.getTexture("header_line");
			var horizontalLine:Image;
			var rowData:Object;
			for (var rowCount:int = 0; rowCount < this._rowsData.length; rowCount++)
			{
				rowData = this._rowsData[rowCount];
				horizontalLine = new Image(horizLineTexture);
				horizontalLine.y = this._firstRowHeight + rowData.y;
				horizontalLine.width = this.actualWidth;
				wholeTableBg.addChild(horizontalLine);
			}
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
