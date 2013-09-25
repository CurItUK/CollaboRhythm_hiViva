package collaboRhythm.hiviva.view.screens.patient
{


	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.components.SuperscriptCircle;

	import feathers.controls.Screen;

	import starling.display.Image;
	import starling.display.Sprite;

	public class HivivaPatientPillboxScreen extends Screen
	{

		private var _pillBox:Image;
		private var IMAGE_SIZE:Number;

		private var _usableHeight:Number;

		private var _headerHeight:Number;

		private var _amMedication:Array = [];
		private var _pmMedication:Array = [];
		private var _amTableXloc:Number;
		private var _pmTableXloc:Number;
		private var _amTableYloc:Number;
		private var _pmTableYloc:Number;
		private var _pillboxYCellSpacing:Number;
		private var _medicationResponse:XML;
		private var _tablets:Vector.<Sprite>

		public function HivivaPatientPillboxScreen()
		{

		}

		override protected function draw():void
		{

			IMAGE_SIZE = this.actualWidth * 0.9;

			this._usableHeight = this.actualHeight - Constants.FOOTER_BTNGROUP_HEIGHT - headerHeight;
			this._pillBox.width = IMAGE_SIZE;
			this._pillBox.scaleY = this._pillBox.scaleX;

			this._pillBox.x = (this.actualWidth * 0.5) - (this._pillBox.width * 0.5);
			this._pillBox.y = headerHeight + (this._usableHeight * 0.5) - (this._pillBox.height * 0.5);

			this._pillboxYCellSpacing = this._pillBox.height / 8;


			this._amTableXloc = this._pillBox.x + 120;
			this._pmTableXloc = this._pillBox.x + this._pillBox.width/2 + 60;

			this._amTableYloc = this._pillBox.y + this._pillboxYCellSpacing + 20;
			this._pmTableYloc = this._pillBox.y + this._pillboxYCellSpacing + 20;
			initPillboxMedication();
		}

		override protected function initialize():void
		{
//			this._pillBox = new Image(Main.assets.getTexture("pillbox"));
			this._pillBox = new Image(Main.assets.getTexture("v2_pillbox"));
			addChild(this._pillBox);
		}

		private function initPillboxMedication():void
		{
			trace("initPillboxMedication pillbox height" + this._pillBox.height);

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatientMedicationList();
		}

		private function getPatientMedicationListComplete(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			trace("medicationsLoadCompleteHandler " + e.data.xmlResponse);

			this._medicationResponse = e.data.xmlResponse;

			var medicationsCount:Number = this._medicationResponse.DCUserMedication.length();

			if(medicationsCount > 0)
			{
				for(var i:uint = 0 ; i < medicationsCount ; i++)
				{

					var scheduleLoop:uint = this._medicationResponse.DCUserMedication[i].Schedule.DCMedicationSchedule.length();
					for(var j:uint = 0 ; j < scheduleLoop ; j++)
					{
						var scheduleXML:XML = this._medicationResponse.DCUserMedication[i].Schedule.DCMedicationSchedule[j];

						if(scheduleXML.Time >= 0 && scheduleXML.Time <= 11)
						{
							_amMedication.push({medicationId:(i+1) , scheduleData:scheduleXML})
						}
						else if(scheduleXML.Time >= 12 && scheduleXML.Time <= 23)
						{
							_pmMedication.push({medicationId:(i+1)  , scheduleData:scheduleXML})
						}
					}
				}
			}

			if(_amMedication.length > 0)
			{
				buildAMPillData();
			}

			if(_pmMedication.length > 0)
			{
				buildPMPillData();
			}

		}

		private function buildAMPillData():void
		{
			trace("buildTabletAMCells " + _amMedication.length);
			var daysLoop:uint = 7;

			for(var j:uint=0  ; j <daysLoop ; j++)
			{
				var loop:uint = _amMedication.length;
				for (var i:uint = 0; i < loop; i++)
				{
					var tablet:Image = new Image(Main.assets.getTexture("tablet" + _amMedication[i].medicationId));
					var tabletCount:SuperscriptCircle = new SuperscriptCircle();
					tabletCount.text = _amMedication[i].scheduleData.Count;

					this.addChild(tablet);
					this.addChild(tabletCount);
					tablet.x = this._amTableXloc + (i * tablet.width) + 10;
					tablet.y = this._amTableYloc + this._pillboxYCellSpacing * j;
					tabletCount.x = tablet.x + tablet.width/3;
					tabletCount.y = tablet.y - tablet.height/2;

					var tickCell:Sprite = new Sprite();
					var takenTick:Image = new Image(Main.assets.getTexture("v2_pill_icon_tick"));

					/*
					tickCell.addChild(takenTick);
					takenTick.y = -takenTick.width/2;
					takenTick.x = -takenTick.height/2;

					this.addChild(tickCell);

					tickCell.x = tablet.x ;
					tickCell.y = tablet.y ;
					*/

				}
			}
		}

		private function buildPMPillData():void
		{
			trace("buildTabletAMCells " + _pmMedication.length);
			var daysLoop:uint = 7;

			for(var j:uint=0  ; j <daysLoop ; j++)
			{
				var loop:uint = _pmMedication.length;
				for (var i:uint = 0; i < loop; i++)
				{
					var tablet:Image = new Image(Main.assets.getTexture("tablet" + _pmMedication[i].medicationId));
					var tabletCount:SuperscriptCircle = new SuperscriptCircle();
					tabletCount.text = _pmMedication[i].scheduleData.Count;

					this.addChild(tablet);
					this.addChild(tabletCount);
					tablet.x = this._pmTableXloc + (i * tablet.width) + 10;
					tablet.y = this._pmTableYloc + this._pillboxYCellSpacing * j;
					tabletCount.x = tablet.x + tablet.width/3;
					tabletCount.y = tablet.y - tablet.height/2;
				}
			}
		}


		public function get headerHeight():Number
		{
			return _headerHeight;
		}

		public function set headerHeight(value:Number):void
		{
			_headerHeight = value;
		}

		override public function dispose():void
		{
			trace("HivivaPatientPillboxScreen dispose");
			this._pillBox.dispose();
			this._pillBox = null;
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);

			super.dispose();
		}
	}
}
