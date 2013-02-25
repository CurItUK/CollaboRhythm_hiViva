package collaboRhythm.plugins.hiviva.controller
{
	import collaboRhythm.plugins.hiviva.view.HivivaSimulationButtonWidgetView;
	import collaboRhythm.plugins.hiviva.view.HivivaSimulationView;
	import collaboRhythm.shared.controller.apps.AppControllerBase;
	import collaboRhythm.shared.controller.apps.AppControllerConstructorParams;
	import collaboRhythm.plugins.hiviva.model.HivivaSimulationModel;


	import mx.core.UIComponent;

	public class HivivaAppController extends AppControllerBase
	{
		public static const DEFAULT_NAME:String = "HIV";

		private var _widgetView:HivivaSimulationButtonWidgetView;
		private var _hivivaSimulationModel:HivivaSimulationModel;

		public function HivivaAppController(constructorParams:AppControllerConstructorParams)
		{
			super(constructorParams);
		}

		override public function initialize():void
		{
			super.initialize();
			initializeHivivaSimulationModel();

			updateWidgetViewModel();
		}

		private function initializeHivivaSimulationModel():void
		{
			if (_hivivaSimulationModel == null)
			{
				_hivivaSimulationModel = new HivivaSimulationModel(_activeRecordAccount);
			}
		}


		override protected function createWidgetView():UIComponent
		{
			initializeHivivaSimulationModel();

			_widgetView = new HivivaSimulationButtonWidgetView();
			return _widgetView
		}

		override protected function updateWidgetViewModel():void
		{
			super.updateWidgetViewModel();

			if (_widgetView && _activeRecordAccount)
			{
				_widgetView.init(this, _hivivaSimulationModel);
			}
		}

		public override function get defaultName():String
		{
			return DEFAULT_NAME;
		}

		override public function get widgetView():UIComponent
		{
			return _widgetView;
		}

		override public function set widgetView(value:UIComponent):void
		{
			_widgetView = value as HivivaSimulationButtonWidgetView;
		}

		override public function get isFullViewSupported():Boolean
		{
			return false;
		}

		override protected function get shouldShowFullViewOnWidgetClick():Boolean
		{
			return false;
		}

		override public function reloadUserData():void
		{
			removeUserData();
			super.reloadUserData();
		}

		override protected function removeUserData():void
		{
			_hivivaSimulationModel = null;
		}

		public function showHivivaSimulationView():void
		{
			if(_viewNavigator)
			{
				_viewNavigator.pushView(HivivaSimulationView);
			}

		}
	}
}
