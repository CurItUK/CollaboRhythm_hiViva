package collaboRhythm.hiviva.view.screens.patient
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
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
		private var _markAsReadCount:int = 0;
		private var _remoteCallMade:Boolean = false;
		private var _NumberOfDaysAdhered:Number;
		private var _newBadges:Vector.<BadgeCell>;

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

			if(!_remoteCallMade) getNumberDaysAdherence();
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


		private function getNumberDaysAdherence():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_NUMBER_DAYS_ADHERENCE_COMPLETE, getNumberDaysAdherenceComplete);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getNumberDaysAdherence();

			this._remoteCallMade = true;
		}

		private function getNumberDaysAdherenceComplete(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_NUMBER_DAYS_ADHERENCE_COMPLETE, getNumberDaysAdherenceComplete);

			this._NumberOfDaysAdhered = e.data.xmlResponse[0];
			trace("PATIENT ADHERED FOR " + this._NumberOfDaysAdhered + " DAYS");

			if(!isNaN(this._NumberOfDaysAdhered) && this._NumberOfDaysAdhered > 0)
			{
				populateNewBadges();
				drawAllBadges();
				markAllNewBadgesAsRead();
			}
		}

		private function populateNewBadges():void
		{
			this._newBadges = new <BadgeCell>[];

			var twoDayBadge:BadgeCell;
			var oneWeekBadge:BadgeCell;
			var tenWeekBadge:BadgeCell;
			var twentyFiveWeekBadge:BadgeCell;
			var fiftyWeekBadge:BadgeCell;

			if(this._NumberOfDaysAdhered > 2)
			{
				twoDayBadge = new BadgeCell();
				twoDayBadge.badgeType = BadgeCell.TWO_DAY_TYPE;
				this._newBadges.push(twoDayBadge);
			}
			if(this._NumberOfDaysAdhered > 7)
			{
				oneWeekBadge = new BadgeCell();
				oneWeekBadge.badgeType = BadgeCell.ONE_WEEK_TYPE;
				this._newBadges.push(oneWeekBadge);
			}
			if(this._NumberOfDaysAdhered > 70)
			{
				tenWeekBadge = new BadgeCell();
				tenWeekBadge.badgeType = BadgeCell.TEN_WEEK_TYPE;
				this._newBadges.push(tenWeekBadge);
			}
			if(this._NumberOfDaysAdhered > 175)
			{
				twentyFiveWeekBadge = new BadgeCell();
				twentyFiveWeekBadge.badgeType = BadgeCell.TWENTY_FIVE_WEEK_TYPE;
				this._newBadges.push(twentyFiveWeekBadge);
			}
			if(this._NumberOfDaysAdhered > 350)
			{
				fiftyWeekBadge = new BadgeCell();
				fiftyWeekBadge.badgeType = BadgeCell.FIFTY_WEEK_TYPE;
				this._newBadges.push(fiftyWeekBadge);
			}
		}

		private function drawAllBadges():void
		{
			this._cellContainer = new ScrollContainer();

			var badge:BadgeCell;
			for (var i:int = 0; i < this._newBadges.length; i++)
			{
				badge = this._newBadges[i];
				this._cellContainer.addChild(badge);
				badge.width = this.actualWidth;
			}

			this.addChild(this._cellContainer);
			this._cellContainer.width = this.actualWidth;
			this._cellContainer.y = this._header.height;
			this._cellContainer.height = this.actualHeight - this._cellContainer.y - (this._scaledPadding * 2);
			this._cellContainer.layout = new VerticalLayout();
			this._cellContainer.validate();
		}

		private function markAllNewBadgesAsRead():void
		{
			var badgeGuids:Array = HivivaStartup.userVO.badges;
			if(HivivaStartup.userVO.badges.length > 0)
			{
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.MARK_ALERT_MESSAGE_AS_READ_COMPLETE, markAlertMessageAsReadComplete);
				for (var badgeCount:int = 0; badgeCount < badgeGuids.length; badgeCount++)
				{
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.markAlertMessageAsRead(badgeGuids[badgeCount]);
				}
			}
		}

		private function markAlertMessageAsReadComplete(e:RemoteDataStoreEvent):void
		{
			trace(e.data.xmlResponse);
			this._markAsReadCount++;
			if(this._markAsReadCount == HivivaStartup.userVO.badges.length)
			{
				HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.MARK_ALERT_MESSAGE_AS_READ_COMPLETE, markAlertMessageAsReadComplete);
				HivivaStartup.userVO.badges = [];
			}
		}

		private function homeBtnHandler(e:Event):void
		{
			this.dispatchEventWith("navGoHome");
		}

	}
}
