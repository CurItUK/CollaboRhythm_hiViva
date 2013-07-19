package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.utils.HivivaModifier;

	import feathers.controls.Label;

	import feathers.core.FeathersControl;

	public class ScheduleTableReport extends FeathersControl
	{
		private var _patientData:XMLList;
		private var _medications:XMLList;
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
		private var _horizontalSegmentWidth:Number;
		private var _bottomAxisValueHeight:Number;

		public function ScheduleTableReport()
		{
			super();
		}
		override protected function draw():void
		{
			super.draw();

			this._horizontalSegmentWidth = this.actualWidth / 2;

		}

		override protected function initialize():void
		{
			super.initialize();
			this._medications = _patientData.DCUserMedication as XMLList;
		}
		
		public function drawTable():void
		{
			
		}

		private function initMedicineNamesColumn():void
		{
			// names column
			var medicationCount:uint = _medications.length();
			var medicationCell:MedicationCell;
			for (var cellCount:int = 0; cellCount < medicationCount; cellCount++)
			{
				medicationCell = new MedicationCell();
				medicationCell.brandName = HivivaModifier.getBrandName(_medications[cellCount].MedicationName);
				medicationCell.genericName = HivivaModifier.getGenericName(_medications[cellCount].MedicationName);
				addChild(medicationCell);
				medicationCell.width = this._horizontalSegmentWidth;
			}
			// tolerability row name
			var averageRowLabel:Label = new Label();
			averageRowLabel.name = HivivaThemeConstants.MEDICINE_BRANDNAME_LABEL;
			averageRowLabel.text = "Average";
			addChild(averageRowLabel);
			averageRowLabel.width = this._horizontalSegmentWidth - 30;
			averageRowLabel.validate();
			averageRowLabel.x += 30; // MedicationCell gap * 2
			averageRowLabel.y += 15; // MedicationCell gap
			//height += 30; // MedicationCell gap * 2
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
