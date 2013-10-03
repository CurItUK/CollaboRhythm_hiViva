package collaboRhythm.hiviva.view.screens.shared
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.screens.MessageInboxResultCell;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPAlertSettings;
	import collaboRhythm.hiviva.view.screens.hcp.HivivaHCPPatientProfileScreen;
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientMyDetailsScreen;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.core.PopUpManager;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaMessageDetail extends Screen
	{
		private var _header:HivivaHeader;
		private var _backButton:Button;

		private var _messageData:XML;
		private var _messageType:String;
		private var _parentScreen:String;

		private var _nameLabel:Label;
		private var _dateLabel:Label;
		private var _messageLabel:Label;
		private var _options:BoxedButtons;
		private var _vPadding:Number;
		private var _hPadding:Number;
		private var _isSent:Boolean;
		private var _statusResponse:HivivaPopUp;
		private var _fullName:String;

		public function HivivaMessageDetail()
		{

		}

		override protected function draw():void
		{
			this._vPadding = Constants.PADDING_TOP;
			this._hPadding = Constants.PADDING_LEFT;

			super.draw();
			this._header.width = Constants.STAGE_WIDTH;
			this._header.initTrueTitle();

			this._nameLabel.width = Constants.STAGE_WIDTH - (this._hPadding * 2);
			this._nameLabel.x = this._hPadding;
			this._nameLabel.y = this._header.height + this._vPadding;
			this._nameLabel.validate();

			this._dateLabel.validate();
			this._dateLabel.x = this._nameLabel.x + this._nameLabel.width - this._dateLabel.width;
			this._dateLabel.y = this._nameLabel.y + (this._nameLabel.height * 0.5) - (this._dateLabel.height * 0.5);

			this._messageLabel.width = Constants.STAGE_WIDTH - (this._hPadding * 2);
			this._messageLabel.x = this._hPadding;
			this._messageLabel.y = this._nameLabel.y + this._nameLabel.height + this._vPadding;

			if(!_isSent)
			{
				this._options.width = Constants.STAGE_WIDTH - (this._hPadding * 2);
				this._options.validate();
				this._options.x = Constants.PADDING_LEFT;
				this._options.y = Constants.STAGE_HEIGHT - Constants.PADDING_BOTTOM - this._options.height;
			}
		}

		override protected function initialize():void
		{
			super.initialize();

			var user:String = HivivaStartup.userVO.type == "HCP" ? "Patient" : "Care provider";

			this._header = new HivivaHeader();
			this._header.title = "Message detail";
			this.addChild(this._header);

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];

			this._nameLabel = new Label();
			this._nameLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;

			this._dateLabel = new Label();
			this._dateLabel.name = HivivaThemeConstants.CELL_SMALL_WHITE_LABEL;

			this._messageLabel = new Label();

			this._options = new BoxedButtons();
			this._options.addEventListener(Event.TRIGGERED, optionsHandler);

			switch(_messageType)
			{
				case MessageInboxResultCell.COMPOSED_MESSAGE_TYPE :
					this._fullName = _messageData.FromFirstName + " " + _messageData.FromLastName;
					this._nameLabel.text = this._fullName + " (" + HivivaModifier.getAppIdWithGuid(_messageData.UserGuid) + ")";
					this._dateLabel.text = HivivaModifier.getPrettyStringFromIsoString(_messageData.SentDate,true);
					this._messageLabel.text = _messageData.Message;
					this._options.labels = ["Delete"];

					if(_messageData.read == "false" && !_isSent) markMessageAsRead();

					break;
				case MessageInboxResultCell.CONNECTION_REQUEST_TYPE :
					this._fullName = _messageData.FromFirstName + " " + _messageData.FromLastName;
					this._nameLabel.text = this._fullName + " (" + _messageData.FromAppId + ")";
					this._dateLabel.text = HivivaModifier.getPrettyStringFromIsoString(_messageData.SentDate,true);
					this._messageLabel.text = user + " (" + _messageData.FromAppId + ") has requested to connect";
					this._options.labels = ["Ignore","Accept"];
					break;
				case MessageInboxResultCell.STATUS_ALERT_TYPE :
					this._nameLabel.text = "Status Alert";
					this._dateLabel.text = HivivaModifier.getPrettyStringFromIsoString(_messageData.AlertDate,true);
					this._messageLabel.text = String(_messageData.AlertMessage);

					if(_messageData.Read == "false") markAlertAsRead();

					this._options.labels = ["Go to patient","Edit Alerts"];
					break;
			}

			this.addChild(this._nameLabel);
			this.addChild(this._dateLabel);
			this.addChild(this._messageLabel);
			if(!_isSent) addChild(this._options);

			if(HivivaStartup.userVO.type == "HCP") dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV,true));
		}

		private function markMessageAsRead():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.MARK_MESSAGE_AS_READ_COMPLETE, markMessageAsReadHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.markMessageAsRead(_messageData.MessageGuid);
		}

		private function markAlertAsRead():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.MARK_ALERT_MESSAGE_AS_READ_COMPLETE, markAlertMessageAsReadComplete);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.markAlertMessageAsRead(_messageData.AlertMessageGuid);
		}

		private function markMessageAsReadHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.MARK_MESSAGE_AS_READ_COMPLETE, markMessageAsReadHandler);
			trace("message marked as read");
		}

		private function markAlertMessageAsReadComplete(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.MARK_ALERT_MESSAGE_AS_READ_COMPLETE, markAlertMessageAsReadComplete);
			trace("alert marked as read");
		}

		private function optionsHandler(e:Event):void
		{
			var button:String = e.data.button;
/*
			var guidReference:String;
			switch(_messageType)
			{
				case MessageInboxResultCell.COMPOSED_MESSAGE_TYPE :
					guidReference = _messageData.MessageGuid;
					break;
				case MessageInboxResultCell.CONNECTION_REQUEST_TYPE :
					guidReference = _messageData.FromUserGuid;
					break;
				case MessageInboxResultCell.STATUS_ALERT_TYPE :
					break;
			}*/
			trace(button);
			switch(button)
			{
				case "Delete" :
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.DELETE_USER_MESSAGE_COMPLETE, deleteUserMessageHandler);
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.deleteUserMessage(_messageData.MessageGuid);
					break;
				case "Ignore" :
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.CONNECTION_IGNORE_COMPLETE, ignoreConnectionHandler);
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.ignoreConnection(_messageData.FromUserGuid);
					break;
				case "Accept" :
					if(HivivaStartup.userVO.type != "HCP")
					{
						if(HivivaStartup.userVO.fullName.length > 0)
						{
							trace("accepted!");
//							HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.CONNECTION_APPROVE_COMPLETE, approveConnectionHandler);
//							HivivaStartup.hivivaAppController.hivivaRemoteStoreController.approveConnection(_messageData.FromUserGuid);
						}
						else
						{
							initStatusResponsePopup("Please create a profile in order to accept the connection request", "Create profile", createProfileCallBack);
						}
					}
					else
					{
						trace("accepted!");
//						HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.CONNECTION_APPROVE_COMPLETE, approveConnectionHandler);
//						HivivaStartup.hivivaAppController.hivivaRemoteStoreController.approveConnection(_messageData.FromUserGuid);
					}
					break;
				case "Go to patient" :
					setSelectedHCPPatientProfile();
					if(this.owner.hasScreen(HivivaScreens.HCP_PATIENT_PROFILE))
					{
						this.owner.removeScreen(HivivaScreens.HCP_PATIENT_PROFILE);
					}
					this.owner.addScreen(HivivaScreens.HCP_PATIENT_PROFILE, new ScreenNavigatorItem(HivivaHCPPatientProfileScreen, null, {parentScreen:this.owner.activeScreenID}));
					this.owner.showScreen(HivivaScreens.HCP_PATIENT_PROFILE);

					break;
				case "Edit Alerts" :
					if(this.owner.hasScreen(HivivaScreens.HCP_ALERT_SETTINGS))
					{
						this.owner.removeScreen(HivivaScreens.HCP_ALERT_SETTINGS);
					}
					this.owner.addScreen(HivivaScreens.HCP_ALERT_SETTINGS, new ScreenNavigatorItem(HivivaHCPAlertSettings, null, {parentScreen:this.owner.activeScreenID}));
					this.owner.showScreen(HivivaScreens.HCP_ALERT_SETTINGS);
					break;
				default :
					callBack();
					break;
			}
		}

		private function createProfileCallBack(e:Event):void
		{
			var btn:String = e.data.button;
			switch(btn)
			{
				case "Create profile" :
					if(owner.hasScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN))
					{
						owner.removeScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN);
					}
					owner.addScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN, new ScreenNavigatorItem(HivivaPatientMyDetailsScreen, null, {parentScreen:owner.activeScreenID}));
					owner.showScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN);
				case "Close" :
					PopUpManager.removePopUp(_statusResponse);
					break;
			}
		}

		private function setSelectedHCPPatientProfile():void
		{
			var connectedPatients:Array = HivivaStartup.connectionsVO.users;
			if(connectedPatients.length > 0)
			{
				for (var i:int = 0; i < connectedPatients.length; i++)
				{
					if(connectedPatients[i].guid == String(_messageData.UserGuid))
					{
						Main.selectedHCPPatientProfile = connectedPatients[i];
						break;
					}
				}
			}
		}

		private function deleteUserMessageHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.DELETE_USER_MESSAGE_COMPLETE, deleteUserMessageHandler);

			if(e.data.xmlResponse.StatusCode == "1")
			{
				initStatusResponsePopup("Message deleted", "Ok", callBack);
			}
			else
			{
				initStatusResponsePopup("Error! " + e.data.xmlResponse.Message, "Ok", callBack);
			}
		}

		private function approveConnectionHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.CONNECTION_APPROVE_COMPLETE, approveConnectionHandler);

			var user:String = HivivaStartup.userVO.type == "HCP" ? "patient" : "care provider";

			if(e.data.xmlResponse.StatusCode == "1")
			{
				initStatusResponsePopup("Success! You are now connected to " + user + " (" + _messageData.FromAppId + ")", "Ok", callBack);
				/*if(HivivaStartup.userVO.type == "HCP")
				{
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_WITH_SUMMARY_COMPLETE, getApprovedConnectionsWithSummaryHandler);
					HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getApprovedConnectionsWithSummary();
				}*/
			}
			else
			{
				initStatusResponsePopup("Error! " + e.data.xmlResponse.Message, "Ok", callBack);
			}
		}

		private function ignoreConnectionHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.CONNECTION_IGNORE_COMPLETE, ignoreConnectionHandler);

			var user:String = HivivaStartup.userVO.type == "HCP" ? "patient" : "care provider";

			if(e.data.xmlResponse.StatusCode == "1")
			{
				initStatusResponsePopup("You have ignored the connection request from " + user + " (" + _messageData.FromAppId + ")", "Ok", callBack);
			}
			else
			{
				initStatusResponsePopup("Error! " + e.data.xmlResponse.Message, "Ok", callBack);
			}
		}

		private function initStatusResponsePopup(message:String, buttonName:String, callBackFunc:Function):void
		{
			this._statusResponse = new HivivaPopUp();
			this._statusResponse.buttons = [buttonName];
			this._statusResponse.addEventListener(Event.TRIGGERED, callBackFunc);
			this._statusResponse.message = message;
			this._statusResponse.validate();

			PopUpManager.addPopUp(this._statusResponse,true,true);
			this._statusResponse.validate();
			PopUpManager.centerPopUp(this._statusResponse);
			// draw close button post center so the centering works correctly
			this._statusResponse.drawCloseButton();
		}

		private function callBack():void
		{
			this.dispatchEventWith("messageDetailEvent");
			PopUpManager.removePopUp(this._statusResponse);
			backBtnHandler();
		}

		private function backBtnHandler(e:Event = null):void
		{
			if(HivivaStartup.userVO.type == "HCP") dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.SHOW_MAIN_NAV,true));
			this.owner.showScreen(_parentScreen);
		}

		/*private function getApprovedConnectionsWithSummaryHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_WITH_SUMMARY_COMPLETE, getApprovedConnectionsWithSummaryHandler);
		}*/

		public function get messageData():XML
		{
			return _messageData;
		}

		public function set messageData(value:XML):void
		{
			_messageData = value;
		}

		public function get parentScreen():String
		{
			return _parentScreen;
		}

		public function set parentScreen(value:String):void
		{
			_parentScreen = value;
		}

		public function get messageType():String
		{
			return _messageType;
		}

		public function set messageType(value:String):void
		{
			_messageType = value;
		}

		public function get isSent():Boolean
		{
			return _isSent;
		}

		public function set isSent(value:Boolean):void
		{
			_isSent = value;
		}
	}
}
