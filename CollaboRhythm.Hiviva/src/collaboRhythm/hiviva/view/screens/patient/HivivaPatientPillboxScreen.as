package collaboRhythm.hiviva.view.screens.patient
{


	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.components.SuperscriptCircle;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;

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

			//_amMedication
			//_pmMedication

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

			trace("_amMedication " + _amMedication);
			trace("_pmMedication " + _pmMedication);




			//var medicationsXML:XMLList = e.data.xmlResponse.DCUserMedication.Schedule.DCMedicationSchedule;


			/*
			if(medicationsXML.length() >0)
			{

				var loop:uint = medicationsXML.length();
				for(var i:uint = 0 ; i < loop ; i++)
				{
					if (medicationsXML[i].Time >= 0 && medicationsXML[i].Time <= 11)
					{
						_amMedication.push(medicationsXML[i]);
					}
					else if (medicationsXML[i].Time >= 12 && medicationsXML[i].Time <= 23)
					{
						_pmMedication.push(medicationsXML[i]);
					}
				}
				if(_amMedication.length > 0) buildTabletAMCells();
				if(_pmMedication.length > 0) buildTabletPMCells();
			}

			*/


			//this._medicationResponse = e.data.xmlResponse;

			/*
			if(e.data.xmlResponse.DCUserMedication.length() > 0)
			{
				buildAMMedications();
			}
			*/

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

		/*
		private function buildAMMedications():void
		{
			var daysLoop:uint = 7;

			for(var j:uint=0  ; j <daysLoop ; j++)
			{
				var medLoop:uint = this._medicationResponse.DCUserMedication.length();
				for(var i:uint = 0 ; i < medLoop ; i++)
				{

					var scheduleLoop:uint = this._medicationResponse.DCUserMedication[i].Schedule.DCMedicationSchedule.length();
					var amTabletCount:Number = 0;
					var amTabletCount:Number = 0;
					for(var k:uint = 0 ; k < scheduleLoop ; k++)
					{
						var tabCount:Number = Number(this._medicationResponse.DCUserMedication[i].Schedule.DCMedicationSchedule[k].Count);
						amTabletCount += tabCount;
					}

					var tablet:Image = new Image(Main.assets.getTexture("tablet" + (i+1)));
					this.addChild(tablet);

					tablet.x = this._amTableXloc + (i * tablet.width) + 10;
					tablet.y = this._amTableYloc + this._pillboxYCellSpacing * j;



					var tabletCount:SuperscriptCircle = new SuperscriptCircle();
					tabletCount.text = String(amTabletCount);
					tabletCount.x = tablet.x + tablet.width/3;
					tabletCount.y = tablet.y - tablet.height/2;

					this.addChild(tabletCount);



				}
			}
		}
		*/

		private function buildTabletAMCells():void
		{
			trace("buildTabletAMCells " + _amMedication.length);
			var daysLoop:uint = 7;

			for(var j:uint=0  ; j <daysLoop ; j++)
			{
				var loop:uint = _amMedication.length;
				if (loop > 0)
				{
					var tabletColorCount:uint = 1;
					for (var i:uint = 0; i < loop; i++)
					{
						var tablet:Image = new Image(Main.assets.getTexture("tablet" + tabletColorCount));
						var tabletCount:SuperscriptCircle = new SuperscriptCircle();
						tabletCount.text = _amMedication[i].Count;
						tabletColorCount++;
						if (tabletColorCount > 4)
						{
							tabletColorCount = 1;
						}
						this.addChild(tablet);
						this.addChild(tabletCount);
						tablet.x = this._amTableXloc + (i * tablet.width) + 10;
						tablet.y = this._amTableYloc + this._pillboxYCellSpacing * j;
						tabletCount.x = tablet.x + tablet.width/3;
						tabletCount.y = tablet.y - tablet.height/2;
					}
					tabletColorCount = 1;
				}
			}
		}

		private function buildTabletPMCells():void
		{
			trace("buildTabletAMCells " + _pmMedication.length);
			var daysLoop:uint = 7;

			for(var j:uint=0  ; j <daysLoop ; j++)
			{
				var loop:uint = _pmMedication.length;
				if (loop > 0)
				{
					var tabletColorCount:uint = 1;
					for (var i:uint = 0; i < loop; i++)
					{
						var tablet:Image = new Image(Main.assets.getTexture("tablet" + tabletColorCount));
						var tabletCount:SuperscriptCircle = new SuperscriptCircle();
						tabletCount.text = _pmMedication[i].Count;
						tabletColorCount++;
						if (tabletColorCount > 4)
						{
							tabletColorCount = 1;
						}
						this.addChild(tablet);
						this.addChild(tabletCount);
						tablet.x = this._pmTableXloc + (i * tablet.width) + 10;
						tablet.y = this._pmTableYloc + this._pillboxYCellSpacing * j;
						tabletCount.x = tablet.x + tablet.width/3;
						tabletCount.y = tablet.y - tablet.height/2;
					}
					tabletColorCount = 1;
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

			super.dispose();
		}
	}
}
