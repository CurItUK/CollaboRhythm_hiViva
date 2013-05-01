package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;

	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class HivivaStartup extends Sprite
	{
		private var _starFW:Starling;

		[Bindable]
		protected var _hivivaApplicationController:HivivaApplicationController;

		public function HivivaStartup()
		{
			_hivivaApplicationController = new HivivaApplicationController();
			initStarling();
			_hivivaApplicationController.main();
		}

		private function initStarling():void
		{
			trace("Starling Init");
			_starFW = new Starling(Main, stage, new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight));
			_starFW.addEventListener(starling.events.Event.ROOT_CREATED, starlingRootCreatedHandler);
			_starFW.enableErrorChecking = true;
			_starFW.showStats = true;
			_starFW.showStatsAt(HAlign.RIGHT, VAlign.TOP);
			_starFW.start();
			trace(_starFW.viewPort);
		}

		private function starlingRootCreatedHandler(e:starling.events.Event):void
		{
			var main:Main = Starling.current.root as Main;
			main.applicationController = _hivivaApplicationController as HivivaApplicationController;
			main.initMain();
		}
	}
}
