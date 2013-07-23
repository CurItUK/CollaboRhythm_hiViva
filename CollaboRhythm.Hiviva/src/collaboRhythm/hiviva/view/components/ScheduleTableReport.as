package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;

	import feathers.core.FeathersControl;
	import feathers.text.BitmapFontTextFormat;

	import flash.utils.Dictionary;

	import starling.display.BlendMode;

	import starling.display.DisplayObject;
	import starling.display.Image;

	import starling.display.Quad;

	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;

	public class ScheduleTableReport extends FeathersControl
	{
		private var _patientData:XMLList;
		private var _totalHeight:Number;
		private var _rowsData:Array = [];
		private var _cellPadding:Number;
		private var _dataHolder:Sprite;
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
		private var _columnWidth:Number;
		private var _firstRowHeight:Number;

		public function ScheduleTableReport()
		{
			super();
		}
		override protected function draw():void
		{
			super.draw();

			this._cellPadding = 15;
			this._columnWidth = this.actualWidth * 0.5;
		}

		override protected function initialize():void
		{
			super.initialize();
		}
		
		public function drawTable():void
		{
			initFirstRow();
			initMedicineNamesColumn();
			recordRowHeights();
			populateTableCells();
			initTableBackground();

			this.setSizeInternal(this.actualWidth,_totalHeight,true);
			this.validate();
		}

		private function initFirstRow():void
		{
			var firstRowHolder:Sprite = new Sprite();
			addChild(firstRowHolder);

			var firstRowLabel:Label = new Label();
			firstRowLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			firstRowLabel.text = "Adherence for this period (%)";
			firstRowHolder.addChild(firstRowLabel);
			firstRowLabel.x = this._columnWidth + this._cellPadding; // MedicationCell gap * 2
			firstRowLabel.y = this._cellPadding; // MedicationCell gap
			firstRowLabel.width = this._columnWidth - (this._cellPadding * 2);
			firstRowLabel.validate();

			var firstRowBg:Quad = new Quad(this._columnWidth, firstRowLabel.height + (this._cellPadding * 2), 0x000000);
			firstRowBg.alpha = 0;
			firstRowHolder.addChild(firstRowBg);
			_firstRowHeight = firstRowLabel.height + (this._cellPadding * 2);
		}

		private function initMedicineNamesColumn():void
		{
			_dataHolder = new Sprite();
			addChild(_dataHolder);

			_totalHeight = _firstRowHeight;
			// names column
			var medicationCount:uint = _patientData.length();
			var medicationCell:MedicationCell;
			for (var cellCount:int = 0; cellCount < medicationCount; cellCount++)
			{
				medicationCell = new MedicationCell();
				medicationCell.brandName = HivivaModifier.getBrandName(_patientData[cellCount].MedicationName);
				medicationCell.genericName = HivivaModifier.getGenericName(_patientData[cellCount].MedicationName);
				_dataHolder.addChild(medicationCell);
				medicationCell.width = this._columnWidth;
				medicationCell.validate();
				medicationCell.y = _totalHeight;
				_totalHeight += medicationCell.height;
				this._rowsData.push({id: cellCount});
			}

			// average row name
			var averageRowLabel:Label = new Label();
			averageRowLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			averageRowLabel.text = "Average";
			_dataHolder.addChild(averageRowLabel);
//			averageRowLabel.textRendererProperties.textFormat = new BitmapFontTextFormat(TextField.getBitmapFont("engraved-lighter-bold"), 24, Color.WHITE);
			averageRowLabel.x = this._cellPadding * 2; // MedicationCell gap * 2
			averageRowLabel.y = _totalHeight + this._cellPadding; // MedicationCell gap
			averageRowLabel.width = this._columnWidth - averageRowLabel.x;
			averageRowLabel.validate();

			_totalHeight += averageRowLabel.height + (this._cellPadding * 2);

			this._rowsData.push({id: medicationCount});
		}

		private function recordRowHeights():void
		{
			var rowsDataLength:int = this._rowsData.length;
			var rowData:Object;
			var cellY:Number = _firstRowHeight;
			var rowLabel:DisplayObject;
			for (var rowCount:int = 0; rowCount < rowsDataLength; rowCount++)
			{
				rowLabel = _dataHolder.getChildAt(rowCount) as DisplayObject;
				rowData = this._rowsData[rowCount];

				rowData.y = cellY;
				rowData.cellHeight = rowLabel.height;
				cellY += rowLabel.height;
			}
			rowData.cellHeight += (this._cellPadding * 2);
		}

		private function populateTableCells():void
		{
			var medicationLength:int = this._patientData.length();
			var medicationSchedule:XMLList;
			var medicationScheduleLength:int;
			var medicineAverage:Number;
			var overallAverage:Number = 0;
			for (var i:int = 0; i < medicationLength; i++)
			{
				medicineAverage = 0;

				medicationSchedule = this._patientData[i].Schedule.DCMedicationSchedule as XMLList;
				medicationScheduleLength = medicationSchedule.length();
				for (var j:int = 0; j < medicationScheduleLength; j++)
				{
					medicineAverage += int(medicationSchedule[j].PercentTaken)
				}
				overallAverage += (medicineAverage / medicationScheduleLength);
				drawTableCell(String(Math.round(medicineAverage / medicationScheduleLength)), i);
			}
			drawTableCell(String(Math.round(overallAverage / medicationLength)), medicationLength);
		}

		private function drawTableCell(value:String, rowDataId:int):void
		{
			var starty:Number = this._rowsData[rowDataId].y;
			var ypos:Number = starty + (this._rowsData[rowDataId].cellHeight * 0.5);
			var valueLabel:Label;

			valueLabel = new Label();
			valueLabel.text = value + "%";
			valueLabel.name = HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL;
			addChild(valueLabel);
			valueLabel.width = this._columnWidth - (this._cellPadding * 2);
			valueLabel.validate();
			valueLabel.x = this._columnWidth + this._cellPadding;
			valueLabel.y = ypos - (valueLabel.height * 0.5);
		}

		private function initTableBackground():void
		{
			var horizLineTexture:Texture = Main.assets.getTexture("header_line");
			var horizontalLine:Image;
			var vertLineTexture:Texture = Assets.getTexture("VerticleLinePng");
			var verticalLine:Image;

			var bg:Sprite = new Sprite();
			addChildAt(bg, 0);

			var tableBg:Quad = new Quad(this.actualWidth, _totalHeight, 0x4c5f76);
			tableBg.alpha = 0.25;
			tableBg.blendMode = BlendMode.MULTIPLY;
			bg.addChild(tableBg);

			var light:Quad;
			for (var i:int = 0; i < this._rowsData.length; i++)
			{
				if(i % 2 == 0)
				{
					light = new Quad(this.actualWidth, this._rowsData[i].cellHeight, 0xffffff);
					light.alpha = 0.2;
					bg.addChild(light);
					light.y = this._rowsData[i].y;
				}

				horizontalLine = new Image(horizLineTexture);
				addChild(horizontalLine);
				horizontalLine.width = this.actualWidth;
				horizontalLine.y = this._rowsData[i].y;
			}

			var horPosLines:Array = [0, this._columnWidth, this.actualWidth];
			for (var j:int = 0; j < horPosLines.length; j++)
			{
				verticalLine = new Image(vertLineTexture);
				addChild(verticalLine);
				verticalLine.height = this._totalHeight;
				verticalLine.x = horPosLines[j];
			}
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