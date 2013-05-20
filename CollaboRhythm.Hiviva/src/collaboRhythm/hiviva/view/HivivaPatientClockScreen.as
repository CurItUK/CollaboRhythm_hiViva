package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;

	import feathers.controls.Screen;



	import starling.display.Image;

	public class HivivaPatientClockScreen extends Screen
	{

		private var IMAGE_SIZE:Number;
		private var _clockFace:Image;
		private var _usableHeight:Number;
		private var _footerHeight:Number;
		private var _headerHeight:Number;
		private var _applicationController:HivivaApplicationController;
		private var _amMedication:Array = [];
		private var _pmMedication:Array = [];

		public function HivivaPatientClockScreen()
		{

		}

		override protected function draw():void
		{

			IMAGE_SIZE = this.actualWidth * 0.9;

			this._usableHeight = this.actualHeight - footerHeight - headerHeight;
			trace("HivivaPatientClockScreen _usableHeight " + headerHeight);

			this._clockFace.width = IMAGE_SIZE;
			this._clockFace.scaleY = this._clockFace.scaleX;

			this._clockFace.x = (this.actualWidth * 0.5) - (this._clockFace.width * 0.5);
			this._clockFace.y = (this._usableHeight * 0.5) + headerHeight - (this._clockFace.height * 0.5);
			initClockMedication()

		}

		override protected function initialize():void
		{
			this._clockFace = new Image(Assets.getTexture("ClockFacePng"));
			addChild(this._clockFace);
		}

		private function initClockMedication():void
		{
			applicationController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE, medicationLoadCompleteHandler);
			applicationController.hivivaLocalStoreController.getMedicationsSchedule()
		}

		private function medicationLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			//Build list of medications into their time slots am,pm
			applicationController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE,medicationLoadCompleteHandler);
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
				buildTabletAMCells();
				buildTabletPMCells();
			}
		}

		private function buildTabletAMCells():void
		{
			trace("buildTabletAMCells " + _amMedication.length);
			var loop:uint = _amMedication.length;
			if (loop > 0)
			{
				var tabletColorCount:uint = 1;
				for (var i:uint = 0; i < loop; i++)
				{
					var tablet:Image = new Image(Assets.getTexture("Tablet" + tabletColorCount + "Png"));
					var tabletCount:Label = new Label();
					tabletCount.text = _amMedication[i].tablet_count;
					tabletColorCount++;
					if (tabletColorCount > 4)
					{
						tabletColorCount = 1;
					}
					this.addChild(tablet);
					this.addChild(tabletCount);
				}
			}
		}

		private function buildTabletPMCells():void
		{
			trace("buildTabletAMCells " + _pmMedication.length);
			var loop:uint = _pmMedication.length;
			if (loop > 0)
			{
				var tabletColorCount:uint = 1;
				for (var i:uint = 0; i < loop; i++)
				{
					var tablet:Image = new Image(Assets.getTexture("Tablet" + tabletColorCount + "Png"));
					var tabletCount:Label = new Label();
					tabletCount.text = _pmMedication[i].tablet_count;
					tabletColorCount++;
					if (tabletColorCount > 4)
					{
						tabletColorCount = 1;
					}
					this.addChild(tablet);
					this.addChild(tabletCount);
				}
			}
		}

		public function get applicationController():HivivaApplicationController
		{
			return _applicationController;
		}

		public function set applicationController(value:HivivaApplicationController):void
		{
			_applicationController = value;
		}

		public function get footerHeight():Number
		{
			return _footerHeight;
		}

		public function set footerHeight(value:Number):void
		{
			_footerHeight = value;
		}

		public function get headerHeight():Number
		{
			return _headerHeight;
		}

		public function set headerHeight(value:Number):void
		{
			_headerHeight = value;
		}
	}
}
