package collaboRhythm.hiviva.view.screens.hcp
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.HivivaPopUp;

	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.core.PopUpManager;

	import starling.events.Event;

	public class HivivaHCPHomeScreen extends Screen
	{
		private var _footerHeight:Number;
		private var _applicationController:HivivaApplicationController;
		private var _userSignupPopupContent:HivivaPopUp;

		private var _hasHcpSignedUp:Boolean;

		public function HivivaHCPHomeScreen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._userSignupPopupContent.width = this.actualWidth * 0.75;
			this._userSignupPopupContent.validate();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._userSignupPopupContent = new HivivaPopUp();
			this._userSignupPopupContent.scale = this.dpiScale;
			this._userSignupPopupContent.message = "You will need to create an account in order to connect to a care provider";
			this._userSignupPopupContent.confirmLabel = "Sign up";
			this._userSignupPopupContent.addEventListener(Event.COMPLETE, userSignupScreen);
			this._userSignupPopupContent.addEventListener(Event.CLOSE, userSignupScreen);

			// check if hcp signed up
			localStoreController.addEventListener(LocalDataStoreEvent.HCP_PROFILE_LOAD_COMPLETE, getHcpProfileHandler);
			localStoreController.getHcpProfile();
		}

		private function getHcpProfileHandler(e:LocalDataStoreEvent):void
		{
			localStoreController.removeEventListener(LocalDataStoreEvent.HCP_PROFILE_LOAD_COMPLETE, getHcpProfileHandler);

			var hcpProfile:Array = e.data.hcpProfile;

			this._hasHcpSignedUp = true;
			try
			{
				if(hcpProfile == null)
				{
					this._hasHcpSignedUp = false;
				}
			}
			catch(e:Error)
			{
				this._hasHcpSignedUp = false;
			}
			if (!this._hasHcpSignedUp)
			{
				this.owner.addScreen(HivivaScreens.HCP_EDIT_PROFILE, new ScreenNavigatorItem(HivivaHCPEditProfile, null, {applicationController:_applicationController}));
				forceSignUpPopup();
			}
		}

		private function forceSignUpPopup():void
		{

			// TODO: double call on init, so remove if popup already added
			if(PopUpManager.isPopUp(this._userSignupPopupContent)) PopUpManager.removePopUp(this._userSignupPopupContent);
			PopUpManager.addPopUp(this._userSignupPopupContent,true,true);
			this._userSignupPopupContent.validate();
			PopUpManager.centerPopUp(this._userSignupPopupContent);
			// draw close button post center so the centering works correctly
			this._userSignupPopupContent.drawCloseButton();
		}

		private function userSignupScreen(e:Event):void
		{
			this.owner.showScreen(HivivaScreens.HCP_EDIT_PROFILE);
			PopUpManager.removePopUp(this._userSignupPopupContent);
			trace("open HCP_EDIT_PROFILE");

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
