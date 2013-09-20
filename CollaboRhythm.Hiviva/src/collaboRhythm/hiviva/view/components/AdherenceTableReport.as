package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;

	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.display.TiledImage;

	import flash.utils.Dictionary;

	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	public class AdherenceTableReport extends FeathersControl
	{
		private var _history:Dictionary;
		private var _startDate:Date;
		private var _endDate:Date;
		private var _medications:XMLList;
		private var _totalHeight:Number;
		private var _rowsData:Array = [];
		private var _cellPadding:Number;
		private var _dataHolder:Sprite;
		private var _columnWidth:Number;
		private var _firstRowHeight:Number;
		private var _greyBg:TiledImage;
		private var _bg:Sprite;

		public function AdherenceTableReport()
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
			this._history = HivivaModifier.getChronologicalDictionaryFromXmlList(this._medications);

			initFirstRow();
			initMedicineNamesColumn();

			recordRowHeights();
			populateAdherence();
//			populateTableCells();
			initTableBackground();

			this.setSizeInternal(this.actualWidth,_totalHeight,true);
			this.validate();
		}

		private function initFirstRow():void
		{
			var firstRowHolder:Sprite = new Sprite();
			addChild(firstRowHolder);

			var firstRowLabel:Label = new Label();
			firstRowLabel.name = HivivaThemeConstants.BODY_BOLD_DARK_LABEL;
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
			var medicationCount:uint = _medications.length();
			var medicationCell:MedicationCell;
			var medicationId:String;
			var medIds:Array = [];
			var medExists:Boolean;
			for (var cellCount:int = 0; cellCount < medicationCount; cellCount++)
			{
				medicationId = _medications[cellCount].MedicationID;
				medExists = false;
				for (var i:int = 0; i < medIds.length; i++)
				{
					if(medIds[i] == medicationId)
					{
						medExists = true;
						break;
					}
				}
				if(!medExists)
				{
					medicationCell = new MedicationCell(MedicationCell.DARK_THEME);
					medicationCell.brandName = HivivaModifier.getBrandName(_medications[cellCount].MedicationName);
					medicationCell.genericName = HivivaModifier.getGenericName(_medications[cellCount].MedicationName);

					_dataHolder.addChild(medicationCell);
					medicationCell.width = this._columnWidth;
					medicationCell.validate();
					medicationCell.y = _totalHeight;
					_totalHeight += medicationCell.height;

					var endDate:Date = HivivaModifier.getDateFromIsoString(_medications[cellCount].EndDate, false);
					var startDate:Date = HivivaModifier.getDateFromIsoString(_medications[cellCount].StartDate, false);
					var today:Date = new Date(HivivaStartup.userVO.serverDate.getFullYear(), HivivaStartup.userVO.serverDate.getMonth(), HivivaStartup.userVO.serverDate.getDate(),0,0,0,0);

					this._rowsData.push({
						id: medicationId,
						startDate: new Date(startDate.getFullYear(),startDate.getMonth(),startDate.getDate(),0,0,0,0),
						endDate:  String(_medications[cellCount].Stopped) == "true" ? new Date(endDate.getFullYear(),endDate.getMonth(),endDate.getDate(),0,0,0,0) : today
					});

					medIds.push(medicationId);
				}
			}

			// average row name
			var averageRowLabel:Label = new Label();
			averageRowLabel.name = HivivaThemeConstants.BODY_BOLD_DARK_LABEL;
			averageRowLabel.text = "Average";
			_dataHolder.addChild(averageRowLabel);
//			averageRowLabel.textRendererProperties.textFormat = new BitmapFontTextFormat(TextField.getBitmapFont("engraved-lighter-bold"), 24, Color.WHITE);
			averageRowLabel.x = this._cellPadding * 2; // MedicationCell gap * 2
			averageRowLabel.y = _totalHeight + this._cellPadding; // MedicationCell gap
			averageRowLabel.width = this._columnWidth - averageRowLabel.x;
			averageRowLabel.validate();

			_totalHeight += averageRowLabel.height + (this._cellPadding * 2);

			this._rowsData.push({id: -1});
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

		private function populateAdherence():void
		{
			const medicationLength:int = this._rowsData.length - 1;

			var rowData:Object;
			var scheduleValue:Number;
			var scheduleValueCount:int;
			var overallAverage:Number = 0;
			var currDay:Date = new Date(this._startDate.getFullYear(),this._startDate.getMonth(),this._startDate.getDate(),0,0,0,0);
			var percentTaken:Number;
			// +1 to include the the endDate too
			var range:Number = HivivaModifier.getDaysDiff(this._endDate, this._startDate) + 1;

			for (var rowCount:int = 0; rowCount < medicationLength; rowCount++)
			{
				rowData = this._rowsData[rowCount];
				scheduleValue = 0;
				scheduleValueCount = 0;
				for (var dayCount:int = 0; dayCount < range; dayCount++)
				{
					percentTaken = extractAdherence(currDay, rowData);
					if(percentTaken > -1)
					{
						scheduleValue += percentTaken;
						scheduleValueCount++;
					}
//					trace(currDay.toDateString() + " percentTaken = " + percentTaken);
					currDay.date++;
				}

				if(scheduleValue > 0)
				{
					trace("drug " + rowData.id + " : " + scheduleValue + " / " + scheduleValueCount);
					overallAverage += (scheduleValue / scheduleValueCount);
					drawTableCell(String(Math.round(scheduleValue / scheduleValueCount)), rowCount);
				}
				else
				{
					drawTableCell("0", rowCount);
				}

				currDay = new Date(this._startDate.getFullYear(),this._startDate.getMonth(),this._startDate.getDate(),0,0,0,0);
			}

			drawTableCell(String(Math.round(overallAverage / medicationLength)), medicationLength);
		}

		private function extractAdherence(currDay:Date, rowData:Object):Number
		{
			var percentTaken:Number;
			var columnData:Array;
			var columnDataLength:int;
			var isLargerThanStartDate:Boolean = currDay.getTime() >= rowData.startDate.getTime();
			var isSmallerThanEndDate:Boolean = currDay.getTime() < rowData.endDate.getTime();

			if (isLargerThanStartDate && isSmallerThanEndDate)
			{
				columnData = _history[HivivaModifier.getIsoStringFromDate(currDay, false)];
				if (columnData != null)
				{
					columnDataLength = columnData.length;
					for (var i:int = 0; i < columnDataLength; i++)
					{
						if (columnData[i].id == rowData.id)
						{
							percentTaken = columnData[i].data.PercentTaken;
							break;
						}
					}
				}
				else
				{
					// schedule was missed on this day
					percentTaken = 0;
				}
			}
			else
			{
				// schedule did not exist on this day
				percentTaken = -1;
			}
			if(isNaN(percentTaken)) percentTaken = -1;
			return percentTaken;
		}

		private function drawTableCell(value:String, rowDataId:int):void
		{
			var starty:Number = this._rowsData[rowDataId].y;
			var ypos:Number = starty + (this._rowsData[rowDataId].cellHeight * 0.5);
			var valueLabel:Label;

			valueLabel = new Label();
			valueLabel.text = value + "%";
			valueLabel.name = HivivaThemeConstants.BODY_BOLD_DARK_CENTERED_LABEL;
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
			var vertLineTexture:Texture = Main.assets.getTexture("verticle_line");
			var verticalLine:Image;

			_bg = new Sprite();
			addChildAt(_bg, 0);

			_greyBg = new TiledImage(Main.assets.getTexture("screen_base"));
			_greyBg.width = this.actualWidth;
			_greyBg.height = this._totalHeight;
			_greyBg.smoothing = TextureSmoothing.NONE;
			_greyBg.touchable = false;
			_bg.addChild(_greyBg);

			var tableBg:Quad = new Quad(this.actualWidth, this._totalHeight, 0x4c5f76);
			tableBg.alpha = 0.25;
			_bg.addChild(tableBg);

			var light:Quad;
			for (var i:int = 0; i < this._rowsData.length; i++)
			{
				if(i % 2 == 0)
				{
					light = new Quad(this.actualWidth, this._rowsData[i].cellHeight, 0xffffff);
					light.alpha = 0.2;
					_bg.addChild(light);
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

		public function get medications():XMLList
		{
			return _medications;
		}

		public function set medications(value:XMLList):void
		{
			_medications = value;
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
	}
}
