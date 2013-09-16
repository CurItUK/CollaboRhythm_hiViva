package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.NotificationsEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.HivivaHeader;
	import collaboRhythm.hiviva.view.HivivaPopUp;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.components.BoxedButtons;
	import collaboRhythm.hiviva.view.components.TopNavButton;
	import collaboRhythm.hiviva.view.screens.PatientResultCellHome;
	import feathers.controls.Label;

	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.core.PopUpManager;
	import feathers.layout.VerticalLayout;

	import starling.display.DisplayObject;

	import starling.display.Image;

	import starling.events.Event;

	public class HivivaHCPHomesScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _patientCellContainer:ScrollContainer;
		private var _alertLabel:Label;
		private var _connectToPatientBtn:BoxedButtons;
		private var _patientsData:XML;
		private var _patients:Array;
//		private var _filterdPatients:Array;
		private var _patientLabel:Label;
		private var _remoteCallMade:Boolean = false;
		private var _messagesButton:TopNavButton;

		private const BOTTOM:Number = Constants.STAGE_HEIGHT - Constants.FOOTER_BTNGROUP_HEIGHT;
		private var _patientCellYStart:Number;
		private var _patientCellVSpace:Number;
		private var _messageCount:uint = 0;

		private var _pendingConnectionLoaded:Boolean = false;
		private var _alertsLoaded:Boolean = false;
		private var _userSignupPopupContent:HivivaPopUp;

		public function HivivaHCPHomesScreen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;

			this._patientLabel.validate();
			this._patientLabel.x = Constants.PADDING_LEFT;
			this._patientLabel.y = Constants.HEADER_HEIGHT + Constants.PADDING_TOP;
			this._patientLabel.width = Constants.STAGE_WIDTH;

			this._connectToPatientBtn.width = Constants.INNER_WIDTH;
			_connectToPatientBtn.validate();
			_connectToPatientBtn.x = (Constants.STAGE_WIDTH * 0.5) - (_connectToPatientBtn.width * 0.5);
			_connectToPatientBtn.y = BOTTOM - _connectToPatientBtn.height;

			this._patientCellYStart = this._patientLabel.y + this._patientLabel.height + (Constants.PADDING_TOP * 0.5);
			this._patientCellVSpace = _connectToPatientBtn.y - this._patientCellYStart - (Constants.PADDING_TOP * 0.5);

			if(!this._remoteCallMade)
			{
				getApprovedConnectionsWithSummary();
				messageCheckHandler();
				enableAutoHomePageMessageCheck();
				checkHCPSignupStatus();
				this._remoteCallMade = true;
			}
		}

		private function updateVODataHandler(e:NotificationsEvent = null):void
		{
			if(HivivaStartup.hivivaAppController.hivivaNotificationsController.hasEventListener(NotificationsEvent.HOMEPAGE_TICK_COMPLETE))
			{
				HivivaStartup.hivivaAppController.hivivaNotificationsController.disableAutoHomePageMessageCheck();
				HivivaStartup.hivivaAppController.hivivaNotificationsController.removeEventListener(NotificationsEvent.HOMEPAGE_TICK_COMPLETE , messageCheckHandler);
			}

			this._remoteCallMade = false;
			this.draw();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = " ";
			this.addChild(this._header);

			this._patientLabel = new Label();
			this._patientLabel.name = HivivaThemeConstants.SUBHEADER_LABEL;
			this._patientLabel.text = "Patients";
			this.addChild(this._patientLabel);


			_connectToPatientBtn = new BoxedButtons();
			_connectToPatientBtn.labels = ["Connect to patient"];
			_connectToPatientBtn.addEventListener(starling.events.Event.TRIGGERED, connectToPatientBtnHandler);
			this.addChild(_connectToPatientBtn);

			this._messagesButton = new TopNavButton();
			this._messagesButton.hivivaImage = new Image(Main.assets.getTexture("top_nav_icon_02"));
			this._messagesButton.visible = false;
			this._messagesButton.addEventListener(Event.TRIGGERED , messagesButtonHandler);

			this._header.rightItems =  new <DisplayObject>[this._messagesButton];

			// reset and check on global tick
			HivivaStartup.hivivaAppController.hivivaNotificationsController.addEventListener(NotificationsEvent.GLOBAL_TICK, updateVODataHandler);
			// reset and check for new day too (for mobile devices that prevent app running in the background)
			HivivaStartup.hivivaAppController.hivivaNotificationsController.addEventListener(NotificationsEvent.UPDATE_DAILY_VO_DATA, updateVODataHandler);
		}

		private function messagesButtonHandler(e:Event):void
		{
			this.dispatchEventWith("navGoToMessages");
		}

		private function connectToPatientBtnHandler(e:starling.events.Event):void
		{
			this.dispatchEventWith("mainToSubNav" , false , {profileMenu:HivivaScreens.HCP_CONNECT_PATIENT});
		}

		private function checkHCPSignupStatus():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_HCP_COMPLETE , getHCPCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getHCP(HivivaStartup.userVO.appId);
		}

		private function getHCPCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_HCP_COMPLETE , getHCPCompleteHandler);

			var firstName:String = e.data.xmlResponse.FirstName;
			var lastName:String = e.data.xmlResponse.LastName;

			if (firstName.length == 0 && lastName.length == 0)
			{
				initSignupProcess();
			}
		}

		private function getApprovedConnectionsWithSummary():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_WITH_SUMMARY_COMPLETE, getApprovedConnectionsWithSummaryHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getApprovedConnectionsWithSummary();
		}

		private function getPendingConnections():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE, getPendingConnectionsHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPendingConnections();
		}

		private function getHCPAlerts():void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_HCP_ALERTS_COMPLETE, getHCPAlertsHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getHCPAlerts();
		}

		private function getApprovedConnectionsWithSummaryHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_WITH_SUMMARY_COMPLETE, getApprovedConnectionsWithSummaryHandler);

			drawApprovedConnectionsWithSummary();
		}

		private function enableAutoHomePageMessageCheck():void
		{
			HivivaStartup.hivivaAppController.hivivaNotificationsController.addEventListener(NotificationsEvent.HOMEPAGE_TICK_COMPLETE, messageCheckHandler);
			HivivaStartup.hivivaAppController.hivivaNotificationsController.enableAutoHomePageMessageCheck();
		}

		private function messageCheckHandler(e:NotificationsEvent = null):void
		{
			this._messageCount = 0;
			this._pendingConnectionLoaded = false;
			this._alertsLoaded = false;
			getPendingConnections();
			getHCPAlerts();
		}

		private function getPendingConnectionsHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE, getPendingConnectionsHandler);

			if(e.data.xmlResponse.children().length() > 0)
			{
				this._messageCount += e.data.xmlResponse.DCConnection.length();
			}
			this._pendingConnectionLoaded = true;
			if(this._pendingConnectionLoaded && this._alertsLoaded) showNewMessages();
		}

		private function getHCPAlertsHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_HCP_ALERTS_COMPLETE, getHCPAlertsHandler);

			if(e.data.xmlResponse.children().length() > 0)
			{
				this._messageCount += e.data.xmlResponse.DCAlertMessageRecord.length();
			}
			this._alertsLoaded = true;
			if(this._pendingConnectionLoaded && this._alertsLoaded) showNewMessages();
		}

		private function showNewMessages():void
		{
			if (this._messageCount > 0)
			{
				this._messagesButton.visible = true;
				this._messagesButton.subScript = String(this._messageCount);
			}
		}

		private function initAlertText():void
		{
			if(_alertLabel != null)
			{
				if(contains(_alertLabel)) removeChild(_alertLabel);
				_alertLabel.text = "";
				_alertLabel = null;
			}
			this._alertLabel = new Label();
			_alertLabel.name = HivivaThemeConstants.BODY_CENTERED_LABEL;
			_alertLabel.text = "Connect to a patient to get started.";

			this.addChild(_alertLabel);
			_alertLabel.validate();

			_alertLabel.width = Constants.STAGE_WIDTH;
			_alertLabel.y = this._patientCellYStart + (this._patientCellVSpace * 0.5) - (_alertLabel.height * 0.5);
		}

		private function drawApprovedConnectionsWithSummary():void
		{
			var resultsLength:int = HivivaStartup.connectionsVO.users.length;
			var currItem:XML;
			var resultCell:PatientResultCellHome;

			if(_patientCellContainer != null)
			{
				if(contains(_patientCellContainer)) removeChild(_patientCellContainer);
				_patientCellContainer.removeChildren(0,-1,true);
				_patientCellContainer = null;
			}

			this._patientCellContainer = new ScrollContainer();

			if(resultsLength > 0)
			{
				for(var listCount:int = 0; listCount < resultsLength; listCount++)
				{
					currItem = HivivaStartup.connectionsVO.users[listCount];

					resultCell = new PatientResultCellHome();
					resultCell.addEventListener(FeathersScreenEvent.PATIENT_PROFILE_SELECTED, profileSelectedHandler);
					resultCell.patientData = currItem;
					resultCell.isResult = false;
					this._patientCellContainer.addChild(resultCell);
				}
				addChild(this._patientCellContainer);
				drawResults();
			}
			else
			{
				initAlertText();
			}
		}

		private function profileSelectedHandler(e:FeathersScreenEvent):void
		{
			trace("Profile Selected " + e.evtData.profile);
			Main.selectedHCPPatientProfile = e.evtData.profile;
			this.dispatchEventWith("mainToSubNav" , false , {profileMenu:HivivaScreens.HCP_PATIENT_PROFILE});
		}

		private function drawResults():void
		{
			var cellsTotalHeight:Number = 0;
			var patientCell:PatientResultCellHome;

			this._patientCellContainer.width = Constants.STAGE_WIDTH;
			this._patientCellContainer.y = this._patientCellYStart;
			this._patientCellContainer.height = this._patientCellVSpace;

			for (var i:int = 0; i < this._patientCellContainer.numChildren; i++)
			{
				patientCell = this._patientCellContainer.getChildAt(i) as PatientResultCellHome;
				patientCell.width = Constants.STAGE_WIDTH;
				cellsTotalHeight += patientCell.height;
			}

			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = Constants.PADDING_TOP * 0.5;
			this._patientCellContainer.layout = layout;
			this._patientCellContainer.validate();
		}
/*

		private function getHcpConnections():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE, getHcpListCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.getHCPConnections();
		}

		private function getHcpListCompleteHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE, getHcpListCompleteHandler);
			if (e.data.connections != null)
			{
				this._patients = e.data.connections;
				initPatientXMLData();
			}
			else
			{
				initAlertText();
			}
		}

		private function initPatientXMLData():void
		{
			var patientToLoadURL:String = "/resources/dummy_patientlist.xml";
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(flash.events.Event.COMPLETE, patientXMLFileLoadHandler);
			loader.load(new URLRequest(patientToLoadURL));
		}

		private function patientXMLFileLoadHandler(e:flash.events.Event):void
		{
			_patientsData = XML(e.target.data);
			drawPatientProfiles();
		}

		private function drawPatientProfiles():void
		{
			//TODO add better xml search for patients by appid.
			var patientsXMLList:XMLList = patientsData.patient;
			_filterdPatients = [];

			var patientsLength:uint = patientsXMLList.length();
			var innerLoop:uint = patients.length;
			for (var i:uint = 0; i < patientsLength; i++)
			{
				for (var j:uint = 0; j < innerLoop; j++)
				{
					if (patientsXMLList[i].appid == patients[j].appid)
					{
						_filterdPatients.push(patientsXMLList[i]);
					}
				}
			}

			var connectionsLength:uint = _filterdPatients.length;

			for (var listCount:int = 0; listCount < connectionsLength; listCount++)
			{
				var patientCell:PatientResultCellHome = new PatientResultCellHome();
				patientCell.patientData = _filterdPatients[listCount];
				patientCell.isResult = false;

				patientCell.scale = this.dpiScale;
				patientCell.addEventListener(FeathersScreenEvent.PATIENT_PROFILE_SELECTED, profileSelectedHandler);
				this._patientCellContainer.addChild(patientCell);
			}

			addChild(this._patientCellContainer);
			drawResults();

		}
		*/

		private function initSignupProcess():void
		{
			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV, true));

			this.owner.addScreen(HivivaScreens.HCP_MY_DETAILS_SCREEN, new ScreenNavigatorItem(HivivaHCPMyDetailsScreen));

			this._userSignupPopupContent = new HivivaPopUp();
			this._userSignupPopupContent.buttons = ["Sign up"];
			this._userSignupPopupContent.addEventListener(starling.events.Event.TRIGGERED, userSignupScreen);
			this._userSignupPopupContent.width = Constants.STAGE_WIDTH * 0.75;
			this._userSignupPopupContent.validate();
			this._userSignupPopupContent.message = "You will need to create an account in order to connect to a patient";

			PopUpManager.addPopUp(this._userSignupPopupContent,true,true);
			this._userSignupPopupContent.validate();
			PopUpManager.centerPopUp(this._userSignupPopupContent);

			this._userSignupPopupContent.drawCloseButton();
		}

		private function userSignupScreen(e:starling.events.Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_MY_DETAILS_SCREEN);
			PopUpManager.removePopUp(this._userSignupPopupContent);
			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV, true));
		}
		override public function dispose():void
		{
			closeDownApplicationNotifications();
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_HCP_COMPLETE , getHCPCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_APPROVED_CONNECTIONS_WITH_SUMMARY_COMPLETE, getApprovedConnectionsWithSummaryHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_HCP_ALERTS_COMPLETE, getHCPAlertsHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PENDING_CONNECTIONS_COMPLETE, getPendingConnectionsHandler);
			if(this._userSignupPopupContent != null) this._userSignupPopupContent.removeEventListener(starling.events.Event.TRIGGERED, userSignupScreen);
			super.dispose();
		}

		private function closeDownApplicationNotifications():void
		{
			HivivaStartup.hivivaAppController.hivivaNotificationsController.disableAutoHomePageMessageCheck();
			HivivaStartup.hivivaAppController.hivivaNotificationsController.removeEventListener(NotificationsEvent.HOMEPAGE_TICK_COMPLETE , messageCheckHandler);
			HivivaStartup.hivivaAppController.hivivaNotificationsController.removeEventListener(NotificationsEvent.GLOBAL_TICK, updateVODataHandler);
			HivivaStartup.hivivaAppController.hivivaNotificationsController.removeEventListener(NotificationsEvent.UPDATE_DAILY_VO_DATA, updateVODataHandler);
		}

		public function set patients(value:Array):void
		{
			this._patients = value;
		}

		public function get patients():Array
		{
			return this._patients;
		}

	}
}
