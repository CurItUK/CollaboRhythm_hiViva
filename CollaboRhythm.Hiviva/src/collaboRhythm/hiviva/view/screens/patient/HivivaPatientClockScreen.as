package collaboRhythm.hiviva.view.screens.patient
{


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
		private var _clockTimer:Timer;
		private var _clockCenterX:Number;
		private var _clockCenterY:Number;
		private var _headerHeight:Number;
		private var _tablets:Vector.<Sprite>
		private var _medicationResponse:XML;

		private const CLOCK_TICK:uint						= 120000; //5 Minutes
		private const CLOCK_ANGLE_DEGREES:Number			= 15;

		private var vx :Number
		private var vy : Number

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
			this._clockFace.y = headerHeight + (this._usableHeight * 0.5) - (this._clockFace.height * 0.5);

			this._clockHandHolder.width = this._clockFace.width;
			this._clockHandHolder.scaleY = this._clockHandHolder.scaleX;

			this._clockHandHolder.x = this._clockFace.x + this._clockFace.width / 2;
			this._clockHandHolder.y = this._clockFace.y + this._clockFace.height / 2 - this._clockHandCenterPoint;

			this._clockCenterX = this._clockHandHolder.x;
			this._clockCenterY = this._clockHandHolder.y;

			initClockHandRotation();
			initClockMedication();

		}
		private var tabletHolder : Sprite
		override protected function initialize():void
		{

//			this._clockFace = new Image(Main.assets.getTexture("clock_face"));
			this._clockFace = new Image(Main.assets.getTexture("v2_clock_face"));
			this._clockFace.touchable = false;
			this.addChild(this._clockFace);

			tabletHolder  = new Sprite();
			this.addChild(tabletHolder);

			this._clockHand = new Image(Main.assets.getTexture("clock_face_hand"));
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
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatientMedicationList();
		}


		private function getPatientMedicationListComplete(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);
			trace("medicationsLoadCompleteHandler " + e.data.xmlResponse);

			this._medicationResponse = e.data.xmlResponse;

			if(e.data.xmlResponse.DCUserMedication.length() > 0)
			{
				buildClockMedications();
			}
		}

		private function buildClockMedications():void
		{
			trace("buildClockMedications init");
			this._tablets = new Vector.<Sprite>();

			var medLoop:uint = this._medicationResponse.DCUserMedication.length();
			var clockHandSpacing:Number = 20;

			for(var i:uint = 0 ; i < medLoop ; i++)
			{

				var sheduleLoop:uint = this._medicationResponse.DCUserMedication[i].Schedule.DCMedicationSchedule.length();

				for(var j:uint = 0 ; j < sheduleLoop ; j ++)
				{
					trace("sheduleLoop " + i + " : " + j);
					var holderCell:Sprite = new Sprite();
					var time:Number = this._medicationResponse.DCUserMedication[i].Schedule.DCMedicationSchedule[j].Time;

					holderCell.width = this._clockFace.width;
					holderCell.height = this._clockFace.height;
					var tabletCell:Sprite = new Sprite();

//					var timeSegment:Image = new Image(Main.assets.getTexture("clock_segment"));
					var timeSegment:Image = new Image(Main.assets.getTexture("v2_clock_segment"));
					timeSegment.width = timeSegment.width * 0.96;
					timeSegment.scaleY = timeSegment.scaleX;
					timeSegment.smoothing = TextureSmoothing.TRILINEAR;
					var tempRotation : Number = timeSegment.rotation - HivivaModifier.degreesToRadians(7.5);
					timeSegment.visible = true;

					var tablet:Image = getTabletImage(i + 1);
					this.tabletHolder.addChild(timeSegment);

					tabletCell.addChild(tablet);

					tablet.y = -tablet.width/2;
					tablet.x = clockHandSpacing + (i * tablet.width) + 10;
					holderCell.addChild(tabletCell);

					holderCell.x = this._clockCenterX;
					holderCell.y = this._clockCenterY;

					timeSegment.rotation =  holderCell.rotation = HivivaModifier.degreesToRadians(CLOCK_ANGLE_DEGREES * time) - HivivaModifier.degreesToRadians(90);
					timeSegment.rotation += tempRotation
					timeSegment.x = holderCell.x
					timeSegment.y = holderCell.y

					this.addChild(holderCell);
				}
			}
		}

		private function getTabletImage(medicationCount:int):Image
		{
			const tabletAssetCount:int = 10;
			var tabletId:int;

			if(medicationCount > tabletAssetCount)
			{
				tabletId = medicationCount - tabletAssetCount;
			}
			else
			{
				tabletId = medicationCount;
			}

			return new Image(Main.assets.getTexture("tablet" + tabletId));
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

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_MEDICATION_COMPLETE, getPatientMedicationListComplete);

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
