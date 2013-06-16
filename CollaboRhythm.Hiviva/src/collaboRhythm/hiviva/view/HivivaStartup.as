package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.controller.HivivaAppController;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;

	[SWF(backgroundColor="0x000000" , frameRate="60")]

	public class HivivaStartup extends Sprite
	{
		private var _starFW:Starling;
		private var _sw:Number;
		private var _sh:Number;
		private var _assets:AssetManager;

		private static var _hivivaAppController:HivivaAppController;


		public function HivivaStartup()
		{
			addEventListener(flash.events.Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAdded);

			this._sw = stage.fullScreenWidth;
			this._sh = stage.fullScreenHeight;

			_hivivaAppController = new HivivaAppController();
			_hivivaAppController.initLocalStore();

			initStarling();
		}

		private function initStarling():void
		{
			var viewPort:Rectangle;
			//viewPort = new Rectangle(0, 0, 640, 960);
			viewPort = new Rectangle(0, 0, this._sw, this._sh);

			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = !iOS;

			_starFW = new Starling(Main, stage, viewPort);
			_starFW.addEventListener(starling.events.Event.ROOT_CREATED, starlingRootCreatedHandler);
			_starFW.start();
		}

		private function starlingRootCreatedHandler(e:starling.events.Event):void
		{
			trace("renderMode " +  Starling.context.driverInfo);
			_starFW.removeEventListener(starling.events.Event.ROOT_CREATED, starlingRootCreatedHandler);
			this._assets = new AssetManager();
			var main:Main = Starling.current.root as Main;
			main.initMain(this._assets);
		}

		public static function get hivivaAppController():HivivaAppController
		{
			return _hivivaAppController;
		}


	}
}
