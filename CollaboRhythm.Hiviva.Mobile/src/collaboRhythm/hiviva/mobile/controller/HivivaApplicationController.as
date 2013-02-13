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
package collaboRhythm.hiviva.mobile.controller
{
	import collaboRhythm.core.controller.ApplicationControllerBase;
	import collaboRhythm.core.view.BusyView;
	import collaboRhythm.core.view.StatusView;
	import collaboRhythm.shared.model.settings.Settings;
	import collaboRhythm.shared.view.tablet.HivivaMobileViewBase;

	import flash.events.Event;


	public class HivivaApplicationController extends ApplicationControllerBase
	{
		private var _hiviviaApplication:CollaboRhythmHivivaMobileApplication;




		[Embed("/resources/settings.xml" , mimeType="application/octet-stream")]
		private var _applicationSettingsEmbeddedFile:Class;


		public function HivivaApplicationController(collaboRhythmHivivaMobileApplication:CollaboRhythmHivivaMobileApplication)
		{
			super(collaboRhythmHivivaMobileApplication);
			_hiviviaApplication = collaboRhythmHivivaMobileApplication;
			_busyView = collaboRhythmHivivaMobileApplication.busyView;
			//initializeConnectivityView();
		}

		override public function main():void
		{
			super.main();
			settings.modality = Settings.MODALITY_TABLET;

			//navigator.addEventListener(Event.COMPLETE , viewNavigator_transitionCompleteHandler)
			//navigator.addEventListener("viewChangeComplete", viewNavigator_transitionCompleteHandler);
			//navigator.addEventListener(Event.ADDED, viewNavigator_addedHandler);

			initializeActiveView();


		}



		private function viewNavigator_transitionCompleteHandler(event:Event):void
		{
			trace("viewNavigator_transitionCompleteHandler " + event.type);

		}

		private function viewNavigator_addedHandler(event:Event):void
		{
			trace("viewNavigator_addedHandler " + event.type);
		}

		public function initializeActiveView():void
		{

			var view:HivivaMobileViewBase = _hiviviaApplication.navigator.activeView as HivivaMobileViewBase;
			trace("initializeActiveView " + _hiviviaApplication.navigator.activeView);
			if(view)
			{
				trace("initializeView")
				initializeView(view);
			}
		}

		private function initializeView(view:HivivaMobileViewBase):void
		{
			view.activeAccount = activeAccount;
			view.activeRecordAccount = activeRecordAccount;
			view.hivivaApplicationController = this;
		}


		public override function get applicationSettingsEmbeddedFile():Class
		{
			return _applicationSettingsEmbeddedFile;
		}






	}
}
