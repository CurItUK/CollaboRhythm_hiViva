package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.*;

	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.components.BadgeCell;
	import collaboRhythm.hiviva.view.screens.shared.BaseScreen;

	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaPatientBagesScreen extends Screen
	{
		private var _applicationController:HivivaApplicationController;
		protected var _header:HivivaHeader;
		private var _allAdherenceData:Array;
		private var _cellContainer:ScrollContainer;
		private var _deleteMessageButton:Button;
		private var _scaledPadding:Number;

		private const BADGE_LABELS:Array =
		[
			"Nice work. 1 week adherence",
			"Excellent job. 10 weeks adherence",
			"Outstanding achievement! 25 weeks adherence",
			"King of the Meds! 50 weeks adherence"
		];

		public function HivivaPatientBagesScreen()
		{

		}

		override protected function draw():void
		{
			this._scaledPadding = (this.actualHeight * 0.04) * this.dpiScale;
			super.draw();

			this._header.paddingLeft = this._scaledPadding;
			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			this._deleteMessageButton.validate();
			this._deleteMessageButton.width = this.actualWidth * 0.25;
			this._deleteMessageButton.y = this.actualHeight - this._scaledPadding - this._deleteMessageButton.height;
			this._deleteMessageButton.x = (this.actualWidth * 0.5) - (this._deleteMessageButton.width * 0.5);

			if(_cellContainer == null) drawDummyBadges();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Badges";
			this.addChild(this._header);

			// actual logic
			// newBadgesCheck();

			this._deleteMessageButton = new Button();
			this._deleteMessageButton.label = "Clear";
			this._deleteMessageButton.addEventListener(Event.TRIGGERED, deleteHandler);
			this.addChild(this._deleteMessageButton);

			var homeBtn:Button = new Button();
			homeBtn.name = "home-button";
			homeBtn.addEventListener(Event.TRIGGERED, homeBtnHandler);
			this._header.leftItems = new <DisplayObject>[homeBtn];
		}

		private function drawDummyBadges():void
		{
			this._cellContainer = new ScrollContainer();

			var badge:BadgeCell;
			for (var i:int = 0; i < BADGE_LABELS.length; i++)
			{
				badge = new BadgeCell();
				badge.scale = this.dpiScale;
				badge.badgeName = BADGE_LABELS[i];
				badge.dateRange = "Date Range";
				this._cellContainer.addChild(badge);
				badge.width = this.actualWidth;
			}
			this.addChild(this._cellContainer);
			this._cellContainer.width = this.actualWidth;
			this._cellContainer.y = this._header.height;
			this._cellContainer.height = this.actualHeight - this._cellContainer.y -
					this._deleteMessageButton.height - (this._scaledPadding * 2);
			this._cellContainer.layout = new VerticalLayout();
			this._cellContainer.validate();
		}

		private function deleteHandler(e:Event):void
		{
			this._cellContainer.removeChildren(0,-1,true);
			this._cellContainer.validate();
		}

		private function homeBtnHandler():void
		{
			this.dispatchEventWith("navGoHome");
		}

		public function get localStoreController():HivivaLocalStoreController
		{
			return applicationController.hivivaLocalStoreController;
		}

		public function get applicationController():HivivaApplicationController
		{
			return _applicationController;
		}

		public function set applicationController(value:HivivaApplicationController):void
		{
			_applicationController = value;
		}

		private function newBadgesCheck():void
		{
			//get all adherence data
			//compare with current date for 1 7days reward
			localStoreController.addEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE, adherenceLoadCompleteHandler);
			localStoreController.getAdherence();
		}

		private function adherenceLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			trace("adherenceLoadCompleteHandler " + e.data.adherence);
			localStoreController.removeEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE, adherenceLoadCompleteHandler);

			this._allAdherenceData = e.data.adherence;
			if (this._allAdherenceData != null)
			{
				// start with the latest first
				this._allAdherenceData.reverse();
				compareDatesWithToday();
			}
		}

		private function compareDatesWithToday():void
		{
			// TODO : investigate bug with date from getAS3DatefromString. 31st of may returns as 1st of may!
			var compareDate:Date = new Date(),
				currDate:Date,
				currDiff:Number,
				consecutiveDaysAdhered:int = 0,
				currAdherenceData:Object;

			for (var i:int = 0; i < _allAdherenceData.length; i++)
			{
				currAdherenceData = _allAdherenceData[i];
				currDate = HivivaModifier.getAS3DatefromString(currAdherenceData.date);
				currDiff = HivivaModifier.getDaysDiff(compareDate, currDate);
				// don't evaluate today's data
				if(currDiff > 0)
				{
					// continue if patient has filled in data daily
					if(currDiff == 1)
					{
						// continue if schedule is fully adhered to daily
						if(currAdherenceData.adherence_percentage == "100")
						{
							consecutiveDaysAdhered++;
						}
						else
						{
							break;
						}
					}
					else
					{
						break;
					}
				}
				compareDate = currDate;
			}

			if(consecutiveDaysAdhered >= 7)
			{
				trace("award 1 week adherence");
			}

			if(consecutiveDaysAdhered >= 30)
			{
				trace("award 1 month adherence");
			}

		}
	}
}
