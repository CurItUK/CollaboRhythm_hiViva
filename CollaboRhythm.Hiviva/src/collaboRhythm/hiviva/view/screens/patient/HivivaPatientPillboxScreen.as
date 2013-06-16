package collaboRhythm.hiviva.view.screens.patient
{

	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.components.SuperscriptCircle;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;

	import feathers.controls.Screen;

	import starling.display.Image;

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
			this._pillBox.y = (this._usableHeight * 0.5) + headerHeight - (this._pillBox.height * 0.5);

			this._pillboxYCellSpacing = this._pillBox.height / 8;


			this._amTableXloc = this._pillBox.x + 120;
			this._pmTableXloc = this._pillBox.x + this._pillBox.width/2 + 60;

			this._amTableYloc = this._pillBox.y + this._pillboxYCellSpacing + 20;
			this._pmTableYloc = this._pillBox.y + this._pillboxYCellSpacing + 20;
			initPillboxMedication();
		}

		override protected function initialize():void
		{
			this._pillBox = new Image(Assets.getTexture("PillboxPng"));
			addChild(this._pillBox);
		}

		private function initPillboxMedication():void
		{
			trace("initPillboxMedication pillbox height" + this._pillBox.height);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE , medicationLoadCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.getMedicationsSchedule()

		}

		private function medicationLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			//Build list of medications into their time slots am,pm
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE , medicationLoadCompleteHandler)
			if (e.data.medicationSchedule != null)
			{
				trace(e.data.medicationSchedule);
				var loop:uint = e.data.medicationSchedule.length;

				for (var i:uint = 0; i < loop; i++)
				{
					if (e.data.medicationSchedule[i].time >= 0 && e.data.medicationSchedule[i].time <= 11)
					{
						_amMedication.push(e.data.medicationSchedule[i]);
					}
					else if (e.data.medicationSchedule[i].time >= 12 && e.data.medicationSchedule[i].time <= 23)
					{
						_pmMedication.push(e.data.medicationSchedule[i]);
					}
				}
				if(_amMedication.length > 0) buildTabletAMCells();
				if(_pmMedication.length > 0) buildTabletPMCells();
			}
		}

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
						tabletCount.text = _amMedication[i].tablet_count;
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
						tabletCount.text = _pmMedication[i].tablet_count;
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
