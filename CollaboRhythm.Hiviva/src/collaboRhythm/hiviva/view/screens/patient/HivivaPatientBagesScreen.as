package collaboRhythm.hiviva.view.screens.patient
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;

	import collaboRhythm.hiviva.view.*;


	import collaboRhythm.hiviva.view.components.BadgeCell;


	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;

	import starling.display.DisplayObject;

	import starling.events.Event;


	public class HivivaPatientBagesScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _cellContainer:ScrollContainer;
		private var _scaledPadding:Number;
		private var _badgesAwarded:Number = 0;

		private const BADGE_LABELS:Array =
		[
			"Nice work.\n1 week adherence",
			"Excellent job.\n10 weeks adherence",
			"Outstanding achievement!\n25 weeks adherence",
			"King of the Meds!\n50 weeks adherence"
		];

		private const BADGE_ICONS:Array =
		[
			"star1",
			"star2",
			"star3",
			"star4"
		]

		private const BADGE_DATES:Array =
		[
			"24-30 JULY 2013",
			"24 JULY - 13 SEPTEMBER",
			"24 JULY - 13 SEPTEMBER",
			"24 JULY - 22 JUNE 2013"
		]

		public function HivivaPatientBagesScreen()
		{

		}

		override protected function draw():void
		{
			this._scaledPadding = (this.actualHeight * 0.04) * this.dpiScale;
			super.draw();

			this._header.paddingLeft = Constants.HEADER_HOMEBTN_PADDING;
			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			if(_cellContainer == null) getPatientBadges();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Kudos";
			this.addChild(this._header);


			var homeBtn:Button = new Button();
			homeBtn.name = HivivaThemeConstants.HOME_BUTTON;
			homeBtn.addEventListener(Event.TRIGGERED, homeBtnHandler);
			this._header.leftItems = new <DisplayObject>[homeBtn];
		}


		private function getPatientBadges():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.PATIENT_LOAD_BADGES_COMPLETE , loadPatientBadgesCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.getPatientBadges();
		}

		private function loadPatientBadgesCompleteHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.PATIENT_LOAD_BADGES_COMPLETE , loadPatientBadgesCompleteHandler);

			var badgeCount:Number = e.data.badges.length;
			for(var i:uint = 0 ; i < badgeCount ; i++)
			{
				if(e.data.badges[i].badge_attained == true)
				{
					this._badgesAwarded += 1;
				}
			}
			if(this._badgesAwarded > 0)
			{
				drawBadges();
			}
		}

		private function drawBadges():void
		{
			this._cellContainer = new ScrollContainer();

			var badge:BadgeCell;
			for (var i:int = 0; i < this._badgesAwarded; i++)
			{
				badge = new BadgeCell();
				badge.scale = this.dpiScale;
				badge.badgeName = BADGE_LABELS[i];
				badge.badgeIcon = BADGE_ICONS[i];
				badge.dateRange = BADGE_DATES[i];

				this._cellContainer.addChild(badge);
				badge.width = this.actualWidth;
			}

			this.addChild(this._cellContainer);
			this._cellContainer.width = this.actualWidth;
			this._cellContainer.y = this._header.height;
			this._cellContainer.height = this.actualHeight - this._cellContainer.y - (this._scaledPadding * 2);
			this._cellContainer.layout = new VerticalLayout();
			this._cellContainer.validate();

			HivivaStartup.hivivaAppController.hivivaLocalStoreController.clearDownBadgeAlerts();
		}



		private function homeBtnHandler():void
		{
			this.dispatchEventWith("navGoHome");
		}

	}
}
