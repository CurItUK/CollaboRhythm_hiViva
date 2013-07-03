package collaboRhythm.hiviva.view.screens.patient
{

	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Label;

	import feathers.controls.Screen;

	import flash.events.TimerEvent;

	import flash.utils.Timer;


	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.TextureSmoothing;

	public class HivivaPatientClockScreen extends Screen
	{

		private var IMAGE_SIZE:Number;
		private var _clockFace:Image;
		private var _clockHand:Image;
		private var _clockHandHolder:Sprite;
		private var _usableHeight:Number;
		private var _clockHandCenterPoint:Number;
		private var _amMedication:Array = [];
		private var _pmMedication:Array = [];
		private var _clockTimer:Timer;
		private var _clockCenterX:Number;
		private var _clockCenterY:Number;
		private var _headerHeight:Number;

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
			this._usableHeight = this.actualHeight - Constants.FOOTER_BTNGROUP_HEIGHT - headerHeight;


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
			this._clockFace.touchable = false;
			this.addChild(this._clockFace);

			this._clockHand = new Image(Assets.getTexture("ClockFaceHandPng"));
			this._clockHandHolder = new Sprite();
			this._clockHandHolder.touchable = false;
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
			//HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE, medicationLoadCompleteHandler);
			//HivivaStartup.hivivaAppController.hivivaLocalStoreController.getMedicationsSchedule()

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatientMedicationList();
		}


		private function getPatientMedicationListComplete(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			trace("medicationsLoadCompleteHandler " + e.data.xmlResponse);

			var medicationsXML:XMLList = e.data.xmlResponse.DCUserMedication.Schedule.DCMedicationSchedule;

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
				buildTabletAMCells();
				buildTabletPMCells();
			}
		}

		private function medicationLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			//Build list of medications into their time slots am,pm
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.MEDICATIONS_SCHEDULE_LOAD_COMPLETE, medicationLoadCompleteHandler);
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
					//var timeSegment:Image = new Image(Assets.getTexture("ClockFaceSegmentPng"));
					//timeSegment.smoothing = TextureSmoothing.TRILINEAR;

					//timeSegment.rotation = timeSegment.rotation - HivivaModifier.degreesToRadians(7.5);
					var tablet:Image = new Image(Main.assets.getTexture("tablet" + tabletColorCount));
					//tabletCell.addChild(timeSegment);
					tabletCell.addChild(tablet);
					tablet.y = -tablet.width/2;
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
					trace(Number(_amMedication[i].Time));
					holderCell.rotation = HivivaModifier.degreesToRadians(CLOCK_ANGLE_DEGREES * Number(_amMedication[i].Time)) - HivivaModifier.degreesToRadians(90);

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
					var tablet:Image = new Image(Main.assets.getTexture("tablet" + tabletColorCount));
					tabletCell.addChild(tablet);
					tablet.x = clockHandSpacing + (i * tablet.width) + 10;
					tablet.y = -tablet.width/2;
					holderCell.addChild(tabletCell);
					tabletColorCount++;
					if (tabletColorCount > 4)
					{
						tabletColorCount = 1;
					}
					this.addChild(holderCell);
					holderCell.x = this._clockCenterX;
					holderCell.y = this._clockCenterY;
					trace(Number(_pmMedication[i].Time));
					holderCell.rotation = HivivaModifier.degreesToRadians(CLOCK_ANGLE_DEGREES *	Number(_pmMedication[i].Time)) - HivivaModifier.degreesToRadians(90);

				}
			}
		}

		public function set headerHeight(height:Number):void
		{
			_headerHeight = height;
		}

		public function get headerHeight():Number
		{
			return _headerHeight ;
		}

		override public function dispose():void
		{
			trace("HivivaPatientClockScreen dispose");

			this._clockTimer.stop();
			this._clockTimer.removeEventListener(TimerEvent.TIMER, timerTickHandler);
			this._clockTimer = null;

			this._clockFace.dispose();
			this._clockFace = null;

			this._clockHand.dispose();
			this._clockHand = null;

			super.dispose();

		}
	}
}
