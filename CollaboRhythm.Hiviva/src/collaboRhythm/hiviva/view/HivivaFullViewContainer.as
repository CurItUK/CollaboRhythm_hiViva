package collaboRhythm.hiviva.view
{

	import collaboRhythm.shared.controller.apps.AppControllerBase;
	import collaboRhythm.shared.view.hiviva.HivivaViewBase;


	public class HivivaFullViewContainer extends HivivaViewBase
	{
		public function HivivaFullViewContainer()
		{

		}

		override protected function createChildren():void
		{
			super.createChildren();

			if (app)
			{
				app.fullContainer = this;
				app.showFullView(null);
			}
		}

		override public function initialize():void
		{
			super.initialize();

			title = app.fullViewTitle;
		}

		public function get app():AppControllerBase
		{
			return data as AppControllerBase;
		}

		override protected function removedFromStageHandler():void
		{
			super.removedFromStageHandler();

			if (app)
			{
				app.closeFullView();
				while (this.numElements > 0)
				{
					this.removeElementAt(0);
				}
			}
		}
	}
}
