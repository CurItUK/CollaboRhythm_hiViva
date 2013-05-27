package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaPopUp;
	import collaboRhythm.hiviva.view.PatientResultCell;
	import collaboRhythm.hiviva.view.screens.PatientResultCellHome;

	import feathers.controls.Button;

	import feathers.controls.Label;

	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ScrollContainer;
	import feathers.core.PopUpManager;
	import feathers.layout.VerticalLayout;

	import starling.events.Event;

	public class HivivaHCPHomesScreen extends Screen
	{
		private var _footerHeight:Number;
		private var _applicationController:HivivaApplicationController;
		private var _userSignupPopupContent:HivivaPopUp;
		private var _patientCellContainer:ScrollContainer;
		private var _connectToPatientBtn:Button;

		private const PADDING:Number = 20;

		public function HivivaHCPHomesScreen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			var scaledPadding:Number = PADDING * this.dpiScale;
			_connectToPatientBtn.validate();
			_connectToPatientBtn.x = this.actualWidth / 2 - _connectToPatientBtn.width / 2;
			_connectToPatientBtn.y = this.actualHeight - _connectToPatientBtn.height - scaledPadding - footerHeight;

			checkHCPSignupStatus();
		}

		override protected function initialize():void
		{
			super.initialize();

			_connectToPatientBtn = new Button();
			_connectToPatientBtn.label = "Connect to patient";
			_connectToPatientBtn.addEventListener(Event.TRIGGERED, connectToPatientBtnHandler);
			this.addChild(_connectToPatientBtn);

			this._patientCellContainer = new ScrollContainer();

		}

		private function checkHCPSignupStatus():void
		{
			localStoreController.addEventListener(LocalDataStoreEvent.HCP_PROFILE_LOAD_COMPLETE, getHcpProfileHandler);
			localStoreController.getHcpProfile();
		}

		private function getHcpProfileHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.HCP_PROFILE_LOAD_COMPLETE, getHcpProfileHandler);

			if(e.data.hcpProfile != null)
			{
				getHcpConnections();
			}
			else
			{
				initPatientSignupProcess();
			}
		}

		private function getHcpConnections():void
		{
			applicationController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE, getHcpListCompleteHandler)
			applicationController.hivivaLocalStoreController.getHCPConnections();
		}

		private function getHcpListCompleteHandler(e:LocalDataStoreEvent):void
		{
			applicationController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.HCP_CONNECTIONS_LOAD_COMPLETE, getHcpListCompleteHandler)
			if (e.data.connections != null)
			{
				var connectionsLength:uint = e.data.connections.length;

				for (var listCount:int = 0; listCount < connectionsLength; listCount++)
				{
					var patientCell:PatientResultCellHome = new PatientResultCellHome();
					patientCell.patientData = generateXMLNode(e.data.connections[listCount]);
					patientCell.isResult = false;

					patientCell.scale = this.dpiScale;
					patientCell.addEventListener(FeathersScreenEvent.PATIENT_PROFILE_SELECTED , profileSelectedHandler);
					this._patientCellContainer.addChild(patientCell);
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
			this.dispatchEventWith("mainToSubNav" , false , {profileMenu:HivivaScreens.HCP_PATIENT_PROFILE , patientName:e.evtData.profile.name , appID:e.evtData.profile.appid});
		}

		private function drawResults():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var yStartPosition:Number;
			var maxHeight:Number;
			var patientCell:PatientResultCellHome;

			yStartPosition = 120;
			maxHeight = this.actualHeight - yStartPosition -  _connectToPatientBtn.height - footerHeight - 2 * (PADDING * this.dpiScale);

			this._patientCellContainer.width = this.actualWidth;
			this._patientCellContainer.y = yStartPosition;
			this._patientCellContainer.height = maxHeight;

			for (var i:int = 0; i < this._patientCellContainer.numChildren; i++)
			{
				patientCell = this._patientCellContainer.getChildAt(i) as PatientResultCellHome;
				patientCell.width = this.actualWidth;

			}

			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = scaledPadding;
			this._patientCellContainer.layout = layout;
			this._patientCellContainer.validate();
		}

		private function generateXMLNode(record:Object):XML
		{
			var xmlRecord:XML = XML("<patient><name>" + record.name + "</name><email>"
					+ record.email + "</email><appid>"
					+ record.appid + "</appid><picture>"
					+ record.picture + "</picture></patient>");

			return xmlRecord;
		}

		private function initAlertText():void
		{

			var alertLabel:Label = new Label();
			alertLabel.text = "Connect to a patient to get started.";

			this.addChild(alertLabel);
			alertLabel.validate();
			alertLabel.x = this.actualWidth/2 - alertLabel.width/2;
			alertLabel.y = alertLabel.height * 4;
	}

		private function connectToPatientBtnHandler(e:Event):void
		{
			this.dispatchEventWith("mainToSubNav" , false , {profileMenu:HivivaScreens.HCP_CONNECT_PATIENT});
		}

		private function initPatientSignupProcess():void
		{
			this.owner.addScreen(HivivaScreens.HCP_EDIT_PROFILE, new ScreenNavigatorItem(HivivaHCPEditProfile, null, {applicationController:_applicationController}));

			this._userSignupPopupContent = new HivivaPopUp();
			this._userSignupPopupContent.scale = this.dpiScale;
			this._userSignupPopupContent.confirmLabel = "Sign up";
			this._userSignupPopupContent.addEventListener(Event.COMPLETE, userSignupScreen);
			this._userSignupPopupContent.addEventListener(Event.CLOSE, userSignupScreen);
			this._userSignupPopupContent.width = this.actualWidth * 0.75;
			this._userSignupPopupContent.validate();
			this._userSignupPopupContent.message = "You will need to create an account in order to connect to a care provider";

			PopUpManager.addPopUp(this._userSignupPopupContent,true,true);
			this._userSignupPopupContent.validate();
			PopUpManager.centerPopUp(this._userSignupPopupContent);

			this._userSignupPopupContent.drawCloseButton();
		}

		private function userSignupScreen(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_EDIT_PROFILE);
			this._userSignupPopupContent.removeEventListener(Event.COMPLETE, userSignupScreen);
			this._userSignupPopupContent.removeEventListener(Event.CLOSE, userSignupScreen);
			PopUpManager.removePopUp(this._userSignupPopupContent);
			dispatchEvent(new FeathersScreenEvent(FeathersScreenEvent.HIDE_MAIN_NAV, true));
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

		public function get footerHeight():Number
		{
			return _footerHeight;
		}

		public function set footerHeight(value:Number):void
		{
			_footerHeight = value;
		}
	}
}
