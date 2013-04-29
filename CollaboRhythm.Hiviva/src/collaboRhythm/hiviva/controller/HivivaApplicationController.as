/**
 * Copyright 2011 John Moore, Scott Gilroy
 *
 * This file is part of CollaboRhythm.
 *
 * CollaboRhythm is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later
 * version.
 *
 * CollaboRhythm is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with CollaboRhythm.  If not, see
 * <http://www.gnu.org/licenses/>.
 */
package collaboRhythm.hiviva.controller
{

	import collaboRhythm.core.controller.ApplicationControllerBase;
	import collaboRhythm.core.controller.apps.AppControllersMediatorBase;
	import collaboRhythm.hiviva.model.ViewNavigatorExtended;
	import collaboRhythm.shared.controller.apps.AppControllerBase;
	import collaboRhythm.shared.controller.apps.AppControllerConstructorParams;
	import collaboRhythm.shared.model.Account;
	import collaboRhythm.shared.model.settings.Settings;
	import collaboRhythm.shared.view.hiviva.HivivaViewBase;

	import flash.utils.Timer;

	import mx.core.IVisualElementContainer;
	import mx.events.FlexEvent;

	public class HivivaApplicationController extends ApplicationControllerBase
	{
		private static const SESSION_IDLE_TIMEOUT:int = 60 * 5;
		private static const ACCOUNT_ID_SUFFIX:String = "@records.media.mit.edu";

		private var _hivivaAppControllersMediator:HivivaAppControllersMediator;
		private var _hivivaLocalStoreController:HivivaLocalStoreController;

		[Embed("/resources/settings.xml", mimeType="application/octet-stream")]
		private var _applicationSettingsEmbeddedFile:Class;
		private var _openingRecordAccount:Boolean = false;


		private var _sessionIdleTimer:Timer;

		public function HivivaApplicationController()
		{
			super(null);

			initLocalStore();
			initializeConnectivityView();
		}

		override public function main():void
		{
			super.main();

			settings.modality = Settings.MODALITY_HIVIVA;

			// TODO: the collaboration controller could potentially be left uninitialized (always for Hiviva
			// conditionally based on a user setting) but this will require more work because some other parts of the
			// application currently assume that there is a non-null collaboration controller
			initCollaborationController();

			// Unlike TabletApplicationController, we will avoid creating an Indivo session here; connecting to the server is done later
		}

		private function initLocalStore():void
		{
			_hivivaLocalStoreController = new HivivaLocalStoreController();
			_hivivaLocalStoreController.initStoreService();
		}

		private function initializeView(view:HivivaViewBase):void
		{
			view.activeAccount = activeAccount;
			view.activeRecordAccount = activeRecordAccount;
			view.hivivaApplicationController = this;
		}

		override protected function activateTracking():void
		{
			if (settings.useGoogleAnalytics)
			{
				_sessionIdleTimer.start();
				trackActiveView();
			}
		}

		override protected function deactivateTracking():void
		{
			if (settings.useGoogleAnalytics)
			{
				_sessionIdleTimer.reset();
				trackActiveView("deactivated");
				_analyticsTracker.resetSession();
			}
		}

		override protected function exitTracking():void
		{
			if (settings.useGoogleAnalytics)
			{
				trackActiveView("exited");
				_analyticsTracker.resetSession();
			}
		}

		private function trackActiveView(applicationState:String = null):void
		{
			//TODO Barry Gearing PWS add local tracking analytics
		}

		override public function showSelectRecordView():void
		{
//			_hivivaApplication.navigator.pushView(SelectRecordView);
		}

		override public function openRecordAccount(recordAccount:Account):void
		{
			if (activeRecordAccount)
			{
				closeRecordAccount(activeRecordAccount);
			}
			super.openRecordAccount(recordAccount);

			_openingRecordAccount = true;
			// TODO: switch to the correct screen

			trackActiveView();
		}

		override public function sendCollaborationInvitation():void
		{
			super.sendCollaborationInvitation();
		}

		override public function navigateHome():void
		{
			navigator.popToFirstView()
		}

		override public function synchronizeBack():void
		{
			(navigator as ViewNavigatorExtended).popViewRemote();
		}

		// the apps are not actually loaded immediately when a record is opened
		// only after the active record view has been made visible are they loaded, this makes the UI more responsive
		public function showWidgets(recordAccount:Account):void
		{
			if (_hivivaAppControllersMediator == null)
			{
				var appControllerConstructorParams:AppControllerConstructorParams = new AppControllerConstructorParams();
				appControllerConstructorParams.collaborationLobbyNetConnectionServiceProxy = _collaborationLobbyNetConnectionServiceProxy;
				appControllerConstructorParams.navigationProxy = _navigationProxy;
				_hivivaAppControllersMediator = new HivivaAppControllersMediator(null,
						null, _componentContainer, settings, appControllerConstructorParams, this);
			}
			_hivivaAppControllersMediator.createAndStartApps(activeAccount, recordAccount);
		}

		public override function get fullContainer():IVisualElementContainer
		{
			return null;
		}

		public override function get applicationSettingsEmbeddedFile():Class
		{
			return _applicationSettingsEmbeddedFile;
		}

		public override function get appControllersMediator():AppControllersMediatorBase
		{
			return _hivivaAppControllersMediator;
		}

		public override function get currentFullView():String
		{
			return _hivivaAppControllersMediator.currentFullView;
		}

		// when a record is closed, all of the apps need to be closed and the documents cleared from the record
		public override function closeRecordAccount(recordAccount:Account):void
		{
			super.closeRecordAccount(recordAccount);
			_hivivaAppControllersMediator.closeApps();
			if (recordAccount)
				recordAccount.primaryRecord.clearDocuments();
			activeRecordAccount = null;
		}

		protected override function changeDemoDate():void
		{
			reloadData();

			if (activeRecordAccount && activeRecordAccount.primaryRecord &&
					activeRecordAccount.primaryRecord.demographics)
				activeRecordAccount.primaryRecord.demographics.dispatchAgeChangeEvent();
		}

		public function pushFullView(appController:AppControllerBase):void
		{
			if (appController.fullView)
			{
				backgroundProcessModel.updateProcess("fullViewUpdate", "Updating...", true);
				appController.fullView.addEventListener(FlexEvent.UPDATE_COMPLETE, fullView_updateCompleteHandler,
						false, 0, true);
			}
		}

		private function fullView_updateCompleteHandler(event:FlexEvent):void
		{
			event.target.removeEventListener(FlexEvent.UPDATE_COMPLETE, fullView_updateCompleteHandler);
			backgroundProcessModel.updateProcess("fullViewUpdate", "Updating...", false);
		}

		public function get hivivaAppControllersMediator():HivivaAppControllersMediator
		{
			return _hivivaAppControllersMediator;
		}

		public function get hivivaLocalStoreController():HivivaLocalStoreController
		{
			return _hivivaLocalStoreController;
		}

		override protected function prepareToExit():void
		{

		}
	}
}
