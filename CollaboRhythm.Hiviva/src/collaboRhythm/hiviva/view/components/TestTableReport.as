package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;

	import feathers.core.FeathersControl;
	import feathers.display.TiledImage;
	import feathers.text.BitmapFontTextFormat;

	import org.purepdf.elements.Element;

	import org.purepdf.elements.Paragraph;
	import org.purepdf.elements.Phrase;

	import org.purepdf.elements.RectangleElement;
	import org.purepdf.pdf.ColumnText;
	import org.purepdf.pdf.PageSize;

	import org.purepdf.pdf.PdfContentByte;

	import org.purepdf.pdf.PdfDocument;
	import org.purepdf.pdf.PdfPCell;
	import org.purepdf.pdf.PdfPTable;
	import org.purepdf.pdf.fonts.BaseFont;

	import starling.display.BlendMode;
	import starling.display.Image;

	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.Color;

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
		private var _greyBg:TiledImage;

		public static const DATA_ALL:String = "all";
		public static const DATA_CD4:String = "Cd4 count";
		public static const DATA_VIRAL_LOAD:String = "Viral load";

		private var _resultsViralLoadA:Array = [];
		private var _resultsCD4A:Array = [];

		private var _resultsDataA:Array = [];

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
			initGreyBg();
			this.validate();

		}

		private function initGreyBg():void
		{
			_greyBg = new TiledImage(Main.assets.getTexture("screen_base"));
			_greyBg.x = this._tableStartX;
			_greyBg.y = this._tableStartY;
			_greyBg.width = this.actualWidth;
			_greyBg.height = this._tableHeight;
			_greyBg.smoothing = TextureSmoothing.NONE;
			_greyBg.touchable = false;
			//_greyBg.flatten();
			addChildAt(_greyBg,0);
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
					_testData.dates.push(HivivaModifier.getCalendarStringFromIsoString(patientNode.TestDate));
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
			var patientNode:XML;
			var dataCount:int = 0;
			for (var i:int = 0; i < _patientData.length(); i++)
			{
				patientNode = _patientData[i];
				if(String(patientNode.TestDescription) == DATA_CD4)
				{
					_testData.dates.push(HivivaModifier.getCalendarStringFromIsoString(patientNode.TestDate));
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
			var patientNode:XML;
			var dataCount:int = 0;
			for (var i:int = 0; i < _patientData.length(); i++)
			{
				patientNode = _patientData[i];
				if(String(patientNode.TestDescription) == DATA_VIRAL_LOAD)
				{
					_testData.dates.push(HivivaModifier.getCalendarStringFromIsoString(patientNode.TestDate));
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
			tableTitleLabel.name = HivivaThemeConstants.BODY_BOLD_WHITE_CENTERED_LABEL;
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
			sampleLabel.name = HivivaThemeConstants.BODY_BOLD_DARK_LABEL;
			sampleLabel.text = " ";
			this._tableHolder.addChild(sampleLabel);
			sampleLabel.validate();

			this._verticalSegmentHeight = sampleLabel.height;
			this._fullCellHeight = this._verticalSegmentHeight + (this._cellPadding * 2);
			// _testData.dataLength + 1 changed to _testData.dataLength + 2 for double lined table header
			this._tableHeight = this._fullCellHeight * (_testData.dataLength + 2);

			this._tableHolder.removeChild(sampleLabel);

//			drawTableCell("Date", 0, this._tableStartY, false, HivivaThemeConstants.BODY_BOLD_DARK_LABEL);
			drawHeaderCell("Date", 0);
			drawValues(_testData.dates, 0);

			switch(this._dataCategory)
			{
				case DATA_ALL :
//					drawTableCell("CD4 count\n(cells/mm3)", _fullColumnWidth, this._tableStartY, false, HivivaThemeConstants.BODY_BOLD_DARK_LABEL);
					drawHeaderCell("CD4 count", _fullColumnWidth);
					drawValues(_testData.cd4s, _fullColumnWidth);
//					drawTableCell("Viral load\n(copies/ml)", _fullColumnWidth * 2, this._tableStartY, false, HivivaThemeConstants.BODY_BOLD_DARK_LABEL);
					drawHeaderCell("Viral load", _fullColumnWidth * 2);
					drawValues(_testData.viralLoads, _fullColumnWidth * 2);
					break;
				case DATA_CD4 :
//					drawTableCell("CD4 count\n(cells/mm3)", _fullColumnWidth, this._tableStartY, false, HivivaThemeConstants.BODY_BOLD_DARK_LABEL);
					drawHeaderCell("CD4 count", _fullColumnWidth);
					drawValues(_testData.cd4s, _fullColumnWidth);
					break;
				case DATA_VIRAL_LOAD :
//					drawTableCell("Viral load\n(copies/ml)", _fullColumnWidth, this._tableStartY, false, HivivaThemeConstants.BODY_BOLD_DARK_LABEL);
					drawHeaderCell("Viral load", _fullColumnWidth);
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
			var vertLineTexture:Texture = Main.assets.getTexture("verticle_line");
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
				// i + 1 changed to i + 2 for double lined table header
				yPos = this._tableStartY + (_fullCellHeight * (i + 2));
				value = data[i];

				drawTableCell(value, xPos, yPos, i % 2 == 0, HivivaThemeConstants.BODY_DARK_LABEL);
			}
		}

		private function drawHeaderCell(value:String, xPos:Number):void
		{
			var valueLabel:Label;
			var unitsLabel1:Label;
			var unitsLabel2:Label;
			var unitsSuperscriptLabel:Label;
			var horizLineTexture:Texture = Main.assets.getTexture("header_line");
			var horizontalLine:Image;
			var vertLineTexture:Texture = Main.assets.getTexture("verticle_line");
			var verticalLine:Image;

			valueLabel = new Label();
			valueLabel.text = value;
			valueLabel.name = HivivaThemeConstants.BODY_BOLD_DARK_LABEL;
			this._tableHolder.addChild(valueLabel);
			valueLabel.validate();
			valueLabel.width = this._horizontalSegmentWidth;
			valueLabel.x = xPos + this._cellPadding;
			valueLabel.y = this._tableStartY + this._cellPadding;

			if(value == "CD4 count")
			{
				unitsLabel1 = new Label();
				unitsLabel1.name = HivivaThemeConstants.BODY_BOLD_DARK_LABEL;
				unitsLabel1.text = "(cells/mm";
				this._tableHolder.addChild(unitsLabel1);
				unitsLabel1.x = valueLabel.x;
				unitsLabel1.y = valueLabel.y + valueLabel.height;
				unitsLabel1.validate();

				unitsSuperscriptLabel = new Label();
				unitsSuperscriptLabel.text = "3";
				this._tableHolder.addChild(unitsSuperscriptLabel);
				unitsSuperscriptLabel.textRendererProperties.textFormat = new BitmapFontTextFormat(TextField.getBitmapFont("engraved-medium-bold"), 18, Color.WHITE);
				unitsSuperscriptLabel.x = unitsLabel1.x + unitsLabel1.width;
				unitsSuperscriptLabel.y = unitsLabel1.y;
				unitsSuperscriptLabel.validate();

				unitsLabel2 = new Label();
				unitsLabel2.name = HivivaThemeConstants.BODY_BOLD_DARK_LABEL;
				unitsLabel2.text = ")";
				this._tableHolder.addChild(unitsLabel2);
				unitsLabel2.x = unitsSuperscriptLabel.x + unitsSuperscriptLabel.width;
				unitsLabel2.y = unitsLabel1.y;
				unitsLabel2.validate();
			}

			if(value == "Viral load")
			{
				unitsLabel1 = new Label();
				unitsLabel1.name = HivivaThemeConstants.BODY_BOLD_DARK_LABEL;
				unitsLabel1.text = "(copies/ml)";
				this._tableHolder.addChild(unitsLabel1);
				unitsLabel1.x = valueLabel.x;
				unitsLabel1.y = valueLabel.y + valueLabel.height;
				unitsLabel1.validate();
			}

			horizontalLine = new Image(horizLineTexture);
			this._tableHolder.addChild(horizontalLine);
			horizontalLine.width = _fullColumnWidth;
			horizontalLine.x = xPos;
			horizontalLine.y = this._tableStartY;

			verticalLine = new Image(vertLineTexture);
			this._tableHolder.addChild(verticalLine);
			verticalLine.height = _fullCellHeight * 2;
			verticalLine.x = xPos;
			verticalLine.y = this._tableStartY;
		}

		private function drawTableCell(value:String, xPos:Number, yPos:Number, drawLighter:Boolean = false, labelClass:String = ""):void
		{
			var valueLabel:Label;
			var horizLineTexture:Texture = Main.assets.getTexture("header_line");
			var horizontalLine:Image;
			var vertLineTexture:Texture = Main.assets.getTexture("verticle_line");
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

		public function generatePDFVersion(pdfDocument:PdfDocument):void
		{
			trace("PurePDF: " + pdfDocument.getInfo());
			trace("PurePDF: " + pdfDocument.pageSize);

			pdfDocument.newPage();
			pdfDocument.setMargins(36,36,36,36);
			var cb:PdfContentByte = pdfDocument.getDirectContent();
			var pagesize:RectangleElement = PageSize.create(595, 842);



			var cell: PdfPCell;
			var table: PdfPTable;

			cb.moveTo(36 , 60);
			cb.moveText(36,60);

			cb.beginText();
			cb.moveText(50, 50);

			table = new PdfPTable(3);
			table.spacingBefore = 30;
			cell = PdfPCell.fromPhrase( new Paragraph("Test Results"));
			cell.fixedHeight = 30;
			cell.colspan = (3);

			table.addCell(cell);
			table.addStringCell("Date");
			table.addStringCell("CD4 Count(Cells/mm3");
			table.addStringCell("Viral Load(copies/ml)");

			var testLoop:uint = _testData.dates.length;
			for(var i:uint = 0; i<testLoop ; i++)
			{
				table.addStringCell(_testData.dates[i]);
				table.addStringCell(_testData.cd4s[i]);
				table.addStringCell(_testData.viralLoads[i]);
			}


			var widths: Vector.<Number> = Vector.<Number>([ 150, 150, 150 ]);
			table.setTotalWidths( widths );
			table.lockedWidth = true;

			pdfDocument.add(table);

			cb.endText();

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
