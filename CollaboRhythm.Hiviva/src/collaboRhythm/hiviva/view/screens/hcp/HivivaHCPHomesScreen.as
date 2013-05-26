package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaPopUp;
	import collaboRhythm.hiviva.view.PatientResultCell;

	import feathers.controls.Button;

	import feathers.controls.Label;

	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.core.PopUpManager;

	import starling.events.Event;

	public class HivivaHCPHomesScreen extends Screen
	{
		private var _footerHeight:Number;
		private var _applicationController:HivivaApplicationController;
		private var _userSignupPopupContent:HivivaPopUp;

		private const PADDING:Number = 20;

		public function HivivaHCPHomesScreen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			checkHCPSignupStatus();
		}

		override protected function initialize():void
		{
			super.initialize();

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
			trace(e.data.connections);
			if (e.data.connections != null)
			{
				var connectionsLength:uint = e.data.connections.length;




			}
			else
			{
				initAlertText();
			}
		}

		private function initAlertText():void
		{
			var scaledPadding:Number = PADDING * this.dpiScale;
			var alertLabel:Label = new Label();
			alertLabel.text = "Connect to a patient to get started.";

			this.addChild(alertLabel);
			alertLabel.validate();
			alertLabel.x = this.actualWidth/2 - alertLabel.width/2;
			alertLabel.y = alertLabel.height * 4;

			var connectToPatientBtn:Button = new Button();
			connectToPatientBtn.label = "Connect to patient";
			connectToPatientBtn.addEventListener(Event.TRIGGERED , connectToPatientBtnHandler);
			this.addChild(connectToPatientBtn);

			connectToPatientBtn.validate();
			connectToPatientBtn.x = this.actualWidth / 2 - connectToPatientBtn.width / 2;
			connectToPatientBtn.y = this.actualHeight - connectToPatientBtn.height - scaledPadding - footerHeight;
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
