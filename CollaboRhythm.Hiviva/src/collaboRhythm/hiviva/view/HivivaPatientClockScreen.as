package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;

	import feathers.controls.Screen;

	import flash.events.TimerEvent;

	import flash.utils.Timer;


	import starling.display.Image;
	import starling.display.Sprite;

	public class HivivaPatientClockScreen extends Screen
	{

		private var IMAGE_SIZE:Number;
		private var _clockFace:Image;
		private var _clockHand:Image;
		private var _clockHandHolder:Sprite;
		private var _usableHeight:Number;
		private var _clockHandCenterPoint:Number;
		private var _footerHeight:Number;
		private var _headerHeight:Number;
		private var _applicationController:HivivaApplicationController;
		private var _amMedication:Array = [];
		private var _pmMedication:Array = [];
		private var _clockTimer:Timer;
		private var _clockCenterX:Number;
		private var _clockCenterY:Number;

		private const CLOCK_TICK:uint						= 120000; //5 Minutes
		private const CLOCK_ANGLE_DEGREES:Number			= 15;

		public function HivivaPatientClockScreen()
		{

		}

		override protected function draw():void
		{
			//TODO calculate center point based on when image is scaled, currently fixed.
			this._clockHandCenterPoint = 25;

			IMAGE_SIZE = this.actualWidth * 0.9;
			this._usableHeight = this.actualHeight - footerHeight - headerHeight;


			this._clockFace.width = IMAGE_SIZE;
			this._clockFace.scaleY = this._clockFace.scaleX;
			this._clockFace.x = (this.actualWidth * 0.5) - (this._clockFace.width * 0.5);
			this._clockFace.y = (this._usableHeight * 0.5) + headerHeight - (this._clockFace.height * 0.5);

			this._clockHandHolder.width = this._clockFace.width;
			this._clockHandHolder.scaleY = this._clockHandHolder.scaleX;

			this._clockHandHolder.x = this._clockFace.x + this._clockFace.width / 2;
			this._clockHandHolder.y = this._clockFace.y + this._clockFace.height / 2 - this._clockHandCenterPoint;

			this._clockCenterX = this._clockHandHolder.x;
			this._clockCenterY = this._clockHandHolder.y;

			initClockHandRotation();
			initClockMedication();

		}

		override protected function initialize():void
		{

			this._clockFace = new Image(Assets.getTexture("ClockFacePng"));
			this.addChild(this._clockFace);

			this._clockHand = new Image(Assets.getTexture("ClockFaceHandPng"));
			this._clockHandHolder = new Sprite();
			this._clockHandHolder.addChild(this._clockHand);

			this._clockHand.x = -this._clockHand.width / 2;
			this._clockHand.y = -this._clockHand.height / 2;
			this.addChild(this._clockHandHolder);

		}

		private function initClockHandRotation():void
		{
			this._clockTimer = new Timer(CLOCK_TICK, 0);
			this._clockTimer.addEventListener(TimerEvent.TIMER, timerTickHandler);
			this._clockTimer.start();
			timerTickHandler();
		}

		private function timerTickHandler(e:TimerEvent = null):void
		{
			var currentDate:Date = new Date();
			var currentTime:Number = currentDate.getHours();

			this._clockHandHolder.rotation = HivivaModifier.degreesToRadians(CLOCK_ANGLE_DEGREES * currentTime);
		}

		private function initClockMedication():void
		{
			applicationController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE, medicationLoadCompleteHandler);
			applicationController.hivivaLocalStoreController.getMedicationsSchedule()
		}

		private function medicationLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			//Build list of medications into their time slots am,pm
			applicationController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE, medicationLoadCompleteHandler);
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
			var clockHandSpacing:Number = 20;

			var loop:uint = _amMedication.length;
			if (loop > 0)
			{
				var tabletColorCount:uint = 1;
				for (var i:uint = 0; i < loop; i++)
				{
					var holderCell:Sprite = new Sprite();
					holderCell.width = this._clockFace.width;
					holderCell.height = this._clockFace.height;

					var tabletCell:Sprite = new Sprite();
					var tablet:Image = new Image(Assets.getTexture("Tablet" + tabletColorCount + "Png"));
					tabletCell.addChild(tablet);
					tablet.x = clockHandSpacing + (i * tablet.width) + 10;
					holderCell.addChild(tabletCell);
					tabletColorCount++;
					if (tabletColorCount > 4)
					{
						tabletColorCount = 1;
					}
					this.addChild(holderCell);
					holderCell.x = this._clockCenterX;
					holderCell.y = this._clockCenterY;
					trace(Number(_amMedication[i].time));
					holderCell.rotation = HivivaModifier.degreesToRadians(CLOCK_ANGLE_DEGREES * Number(_amMedication[i].time)) - HivivaModifier.degreesToRadians(90);

				}
			}
		}

		private function buildTabletPMCells():void
		{
			trace("buildTabletAMCells " + _pmMedication.length);
			var clockHandSpacing:Number = 20;

			var loop:uint = _pmMedication.length;
			if (loop > 0)
			{
				var tabletColorCount:uint = 1;
				for (var i:uint = 0; i < loop; i++)
				{
					var holderCell:Sprite = new Sprite();
					holderCell.width = this._clockFace.width;
					holderCell.height = this._clockFace.height;

					var tabletCell:Sprite = new Sprite();
					var tablet:Image = new Image(Assets.getTexture("Tablet" + tabletColorCount + "Png"));
					tabletCell.addChild(tablet);
					tablet.x = clockHandSpacing + (i * tablet.width) + 10;
					holderCell.addChild(tabletCell);
					tabletColorCount++;
					if (tabletColorCount > 4)
					{
						tabletColorCount = 1;
					}
					this.addChild(holderCell);
					holderCell.x = this._clockCenterX;
					holderCell.y = this._clockCenterY;
					trace(Number(_pmMedication[i].time));
					holderCell.rotation = HivivaModifier.degreesToRadians(CLOCK_ANGLE_DEGREES *	Number(_pmMedication[i].time)) - HivivaModifier.degreesToRadians(90);

				}
			}
		}

		override public function dispose():void
		{
			super.dispose();
			this._clockTimer.stop();
			this._clockTimer.removeEventListener(TimerEvent.TIMER, timerTickHandler);
			this._clockTimer = null;

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
