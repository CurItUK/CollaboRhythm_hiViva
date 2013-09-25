package collaboRhythm.hiviva.view.screens.patient
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
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

		public function HivivaPatientBagesScreen()
		{

		}

		override protected function draw():void
		{
			this._scaledPadding = (this.actualHeight * 0.04) * this.dpiScale;
			super.draw();

			this._header.paddingLeft = Constants.HEADER_HOMEBTN_PADDING;
			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			this._cellContainer.width = this.actualWidth;
			this._cellContainer.y = Constants.HEADER_HEIGHT;
			this._cellContainer.height = this.actualHeight - this._cellContainer.y - Constants.PADDING_BOTTOM;

			if(this._cellContainer.numChildren == 0) getCurrentBadges();
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

			this._cellContainer = new ScrollContainer();
			this._cellContainer.layout = new VerticalLayout();
			addChild(this._cellContainer);
		}

		private function getCurrentBadges():void
		{
			var badgesAwardedLength:int = HivivaStartup.userVO.badges.length();
			var badgeXml:XML;
			var badgeGuid:String;
			var startDate:Date;
			var endDate:Date;
			var dateRange:String;
			var alertDays:int;
			var alertMessage:String;
			var badgeCell:BadgeCell;

			for (var badgeCount:int = 0; badgeCount < badgesAwardedLength; badgeCount++)
			{
				badgeXml = HivivaStartup.userVO.badges[badgeCount];

				badgeGuid = badgeXml.AlertMessageGuid;
				alertMessage = badgeXml.AlertMessage;
				alertDays = badgeXml.AlertDays;
				endDate = HivivaModifier.getDateFromIsoString(badgeXml.AlertDate);
				startDate = new Date(endDate.getFullYear(),endDate.getMonth(),endDate.getDate(),endDate.getHours(),endDate.getMinutes(),endDate.getSeconds(),endDate.getMilliseconds());
				startDate.date -= alertDays;
				dateRange = HivivaModifier.getPrettyStringFromDate(startDate,false) + " - " + HivivaModifier.getPrettyStringFromDate(endDate,false);

				if(badgeXml.Read == "false")
				{
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.MARK_ALERT_MESSAGE_AS_READ_COMPLETE, markAlertMessageAsReadComplete);
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.markAlertMessageAsRead(badgeGuid);
				}

				badgeCell = new BadgeCell();
				badgeCell.text = alertMessage;
				badgeCell.dateRange = dateRange;
				badgeCell.type = alertDays;
				this._cellContainer.addChild(badgeCell);
				badgeCell.width = this.actualWidth;
			}
			this._cellContainer.validate();
		}

		private function markAlertMessageAsReadComplete(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.MARK_ALERT_MESSAGE_AS_READ_COMPLETE, markAlertMessageAsReadComplete);
		}

		private function homeBtnHandler(e:Event):void
		{
			this.dispatchEventWith("navGoHome");
		}

		override public function dispose():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.MARK_ALERT_MESSAGE_AS_READ_COMPLETE, markAlertMessageAsReadComplete);
			super.dispose();
		}



	}
}
