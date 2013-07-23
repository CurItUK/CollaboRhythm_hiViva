package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;

	import feathers.core.FeathersControl;

	import starling.display.BlendMode;
	import starling.display.Image;

	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class TestTableReport extends FeathersControl
	{
		private var _patientData:XMLList;
		private var _testData:Object = {dates:[]};
		// all, Cd4 count, Viral load
		private var _dataCategory:String;
		private var _cellPadding:Number;
		private var _tableWidth:Number;
		private var _tableHeight:Number;
		private var _tableStartX:Number;
		private var _tableStartY:Number;
		private var _totalColumns:int;
		private var _horizontalSegmentWidth:Number;
		private var _verticalSegmentHeight:Number;
		private var _fullColumnWidth:Number;
		private var _fullCellHeight:Number;
		private var _tableHolder:Sprite;

		public static const DATA_ALL:String = "all";
		public static const DATA_CD4:String = "Cd4 count";
		public static const DATA_VIRAL_LOAD:String = "Viral load";

		public function TestTableReport()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._cellPadding = 10;
			this._tableWidth = this.actualWidth;
			this._tableStartY = 0;
			this._tableStartX = 0;
			this._totalColumns = this._dataCategory == DATA_ALL ? 3 : 2;

			var totalWidthOfPaddings:Number = this._cellPadding * (this._totalColumns * 2);
			this._horizontalSegmentWidth = (this._tableWidth - totalWidthOfPaddings) / this._totalColumns;
		}

		override protected function initialize():void
		{
			super.initialize();
		}

		public function drawTestTable():void
		{
			setupTestDataObject();
			populateTestData();

			this._tableHolder = new Sprite();
			addChild(this._tableHolder);
			this._tableHolder.x = this._tableStartX;

			initTableTitleLabel();
			drawTableColumns();
			initBackground();

			this.setSizeInternal(this._tableWidth, this._tableStartY + this._tableHeight, true);
			this.validate();
		}

		private function setupTestDataObject():void
		{
			switch (this._dataCategory)
			{
				case DATA_ALL :
					_testData.cd4s = [];
					_testData.viralLoads = [];
					break;
				case DATA_CD4 :
					_testData.cd4s = [];
					break;
				case DATA_VIRAL_LOAD :
					_testData.viralLoads = [];
					break;
			}
		}
		
		private function populateTestData():void
		{
			switch(this._dataCategory)
			{
				case DATA_ALL :
					populateTestDateWithAll();
					break;
				case DATA_CD4 :
					populateTestDateWithCd4();
					break;
				case DATA_VIRAL_LOAD :
					populateTestDateWithViralLoad();
					break;
			}
		}

		private function populateTestDateWithAll():void
		{
			var patientNode:XML;
			var dataCount:int = 0;
			var dataTypeCount:int = 0;
			var currDataType:String;
			for (var i:int = 0; i < _patientData.length(); i++)
			{
				patientNode = _patientData[i];

				dataTypeCount++;
				if(dataTypeCount == 2)
				{
					_testData.dates.push(HivivaModifier.getCalendarStringFromDate(HivivaModifier.isoDateToFlashDate(patientNode.TestDate)));
					dataTypeCount = 0;
					dataCount++;
				}

				currDataType = patientNode.TestDescription;
				if(currDataType == DATA_CD4) _testData.cd4s.push(Number(patientNode.Result));
				if(currDataType == DATA_VIRAL_LOAD) _testData.viralLoads.push(Number(patientNode.Result));
			}
			trace("dates : " + _testData.dates.join(','));
			trace("cd4s : " + _testData.cd4s.join(','));
			trace("viralLoads : " + _testData.viralLoads.join(','));
			_testData.dataLength = dataCount;
		}

		private function populateTestDateWithCd4():void
		{
			var testDate:Date;
			var patientNode:XML;
			var dataCount:int = 0;
			for (var i:int = 0; i < _patientData.length(); i++)
			{
				patientNode = _patientData[i];
				if(String(patientNode.TestDescription) == DATA_CD4)
				{
					testDate = HivivaModifier.isoDateToFlashDate(patientNode.TestDate);
					_testData.dates.push(HivivaModifier.getCalendarStringFromDate(testDate));
					_testData.cd4s.push(Number(patientNode.Result));
					dataCount++;
				}
			}
			trace("dates : " + _testData.dates.join(','));
			trace("cd4s : " + _testData.cd4s.join(','));
			_testData.dataLength = dataCount;
		}

		private function populateTestDateWithViralLoad():void
		{
			var testDate:Date;
			var patientNode:XML;
			var dataCount:int = 0;
			for (var i:int = 0; i < _patientData.length(); i++)
			{
				patientNode = _patientData[i];
				if(String(patientNode.TestDescription) == DATA_VIRAL_LOAD)
				{
					testDate = HivivaModifier.isoDateToFlashDate(patientNode.TestDate);
					_testData.dates.push(HivivaModifier.getCalendarStringFromDate(testDate));
					_testData.viralLoads.push(Number(patientNode.Result));
					dataCount++;
				}
			}
			trace("dates : " + _testData.dates.join(','));
			trace("viralLoads : " + _testData.viralLoads.join(','));
			_testData.dataLength = dataCount;
		}

		private function initTableTitleLabel():void
		{
			var tableTitleLabel:Label = new Label();
			tableTitleLabel.name = HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL;
//			tableTitleLabel.text = "Overall " + (this._dataCategory == "adherence" ? "Adherence" : "Tolerability");
			tableTitleLabel.text = "Test Results";
			this._tableHolder.addChild(tableTitleLabel);
			tableTitleLabel.y = this._tableStartY;
			tableTitleLabel.width = this._tableWidth;
			tableTitleLabel.validate();
			// * 1.5 for padding
			this._tableStartY += tableTitleLabel.height;
		}

		private function drawTableColumns():void
		{
			this._fullColumnWidth = this._horizontalSegmentWidth + (this._cellPadding * 2);

			// use the height of this label to establish row heights
			var sampleLabel:Label = new Label();
			sampleLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			sampleLabel.text = " ";
			this._tableHolder.addChild(sampleLabel);
			sampleLabel.validate();

			this._verticalSegmentHeight = sampleLabel.height;
			this._fullCellHeight = this._verticalSegmentHeight + (this._cellPadding * 2);
			this._tableHeight = this._fullCellHeight * (_testData.dataLength + 1);

			this._tableHolder.removeChild(sampleLabel);

			drawTableCell("Date", 0, this._tableStartY, false, HivivaThemeConstants.BODY_BOLD_LABEL);
			drawValues(_testData.dates, 0);

			switch(this._dataCategory)
			{
				case DATA_ALL :
					drawTableCell("CD4 count", _fullColumnWidth, this._tableStartY, false, HivivaThemeConstants.BODY_BOLD_LABEL);
					drawValues(_testData.cd4s, _fullColumnWidth);
					drawTableCell("Viral Load", _fullColumnWidth * 2, this._tableStartY, false, HivivaThemeConstants.BODY_BOLD_LABEL);
					drawValues(_testData.viralLoads, _fullColumnWidth * 2);
					break;
				case DATA_CD4 :
					drawTableCell("CD4 count", _fullColumnWidth, this._tableStartY, false, HivivaThemeConstants.BODY_BOLD_LABEL);
					drawValues(_testData.cd4s, _fullColumnWidth);
					break;
				case DATA_VIRAL_LOAD :
					drawTableCell("Viral Load", _fullColumnWidth, this._tableStartY, false, HivivaThemeConstants.BODY_BOLD_LABEL);
					drawValues(_testData.viralLoads, _fullColumnWidth);
					break;
			}

			// draw bottom line
			var horizLineTexture:Texture = Main.assets.getTexture("header_line");
			var horizontalLine:Image = new Image(horizLineTexture);
			horizontalLine.width = _tableWidth;
			horizontalLine.y = _tableStartY + _tableHeight;
			this._tableHolder.addChild(horizontalLine);

			// draw left line
			var vertLineTexture:Texture = Assets.getTexture("VerticleLinePng");
			var verticalLine:Image = new Image(vertLineTexture);
			verticalLine.height = _tableHeight;
			verticalLine.x = _tableWidth;
			verticalLine.y = _tableStartY;
			this._tableHolder.addChild(verticalLine);
		}

		private function drawValues(data:Array, xPos:Number):void
		{
			var yPos:Number;
			var value:String;
			for (var i:int = 0; i < _testData.dataLength; i++)
			{
				yPos = this._tableStartY + (_fullCellHeight * (i + 1));
				value = data[i];

				drawTableCell(value, xPos, yPos, i % 2 == 0);
			}
		}

		private function drawTableCell(value:String, xPos:Number, yPos:Number, drawLighter:Boolean = false, labelClass:String = ""):void
		{
			var valueLabel:Label;
			var horizLineTexture:Texture = Main.assets.getTexture("header_line");
			var horizontalLine:Image;
			var vertLineTexture:Texture = Assets.getTexture("VerticleLinePng");
			var verticalLine:Image;
			var evenLighter:Quad;

			if(drawLighter)
			{
				evenLighter = new Quad(_fullColumnWidth, _fullCellHeight, 0xffffff);
				evenLighter.alpha = 0.2;
				this._tableHolder.addChild(evenLighter);
				evenLighter.x = xPos;
				evenLighter.y = yPos;
			}

			valueLabel = new Label();
			valueLabel.text = value;
			valueLabel.name = labelClass;
			this._tableHolder.addChild(valueLabel);
			valueLabel.validate();
			valueLabel.width = this._horizontalSegmentWidth;
			valueLabel.x = xPos + this._cellPadding;
			valueLabel.y = yPos + this._cellPadding;

			horizontalLine = new Image(horizLineTexture);
			this._tableHolder.addChild(horizontalLine);
			horizontalLine.width = _fullColumnWidth;
			horizontalLine.x = xPos;
			horizontalLine.y = yPos;

			verticalLine = new Image(vertLineTexture);
			this._tableHolder.addChild(verticalLine);
			verticalLine.height = _fullCellHeight;
			verticalLine.x = xPos;
			verticalLine.y = yPos;
		}

		private function initBackground():void
		{
			var tableBg:Quad = new Quad(this._tableWidth, this._tableHeight, 0x4c5f76);
			tableBg.alpha = 0.25;
			tableBg.blendMode = BlendMode.MULTIPLY;
			addChild(tableBg);
			tableBg.x = this._tableStartX;
			tableBg.y = this._tableStartY;
			swapChildren(this._tableHolder,tableBg);
		}

		public function get patientData():XMLList
		{
			return _patientData;
		}

		public function set patientData(value:XMLList):void
		{
			_patientData = value;
		}

		public function get dataCategory():String
		{
			return _dataCategory;
		}

		public function set dataCategory(value:String):void
		{
			_dataCategory = value;
		}
	}
}
