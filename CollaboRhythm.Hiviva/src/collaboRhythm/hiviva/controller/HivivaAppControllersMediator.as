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
	import collaboRhythm.core.controller.apps.AppControllersMediatorBase;
	import collaboRhythm.shared.controller.apps.AppControllerBase;
	import collaboRhythm.shared.controller.apps.AppControllerConstructorParams;
	import collaboRhythm.shared.model.Account;
	import collaboRhythm.shared.model.services.IComponentContainer;
	import collaboRhythm.shared.model.settings.Settings;
	import collaboRhythm.hiviva.view.HivivaFullViewContainer;

	import mx.core.IVisualElementContainer;

	public class HivivaAppControllersMediator extends AppControllersMediatorBase
	{
		private var _hivivaApplicationController:HivivaApplicationController;

		public function HivivaAppControllersMediator(widgetContainers:Vector.<IVisualElementContainer>,
													 fullParentContainer:IVisualElementContainer,
													 componentContainer:IComponentContainer, settings:Settings,
													 appControllerConstructorParams:AppControllerConstructorParams,
													 hivivaApplicationController:HivivaApplicationController)
		{
			super(widgetContainers, fullParentContainer, componentContainer, settings, appControllerConstructorParams);
			_hivivaApplicationController = hivivaApplicationController;
		}

		override protected function showFullViewResolved(appController:AppControllerBase):AppControllerBase
		{
			// destroy all full views and widget views

			var appInstance:AppControllerBase;

			// TODO: use app id instead of name
			currentFullView = appController.name;

			_hivivaApplicationController.pushFullView(appController);
			appInstance = appController;

			return appInstance;
		}

		public function destroyWidgetViews():void
		{
			for each (var app:AppControllerBase in apps.values())
			{
				app.destroyWidgetView();
			}
		}

		override protected function initializeForAccount(activeAccount:Account, activeRecordAccount:Account):void
		{
			super.initializeForAccount(activeAccount, activeRecordAccount);
			factory.viewNavigator = _hivivaApplicationController.navigator;
		}

		override public function hideFullView(appController:AppControllerBase):void
		{
			var view:HivivaFullViewContainer = _appControllerConstructorParams.viewNavigator.activeView as
					HivivaFullViewContainer;
			if (_appControllerConstructorParams.viewNavigator.length > 1 && view && view.app == appController)
				_appControllerConstructorParams.viewNavigator.popView();
		}
	}
}
