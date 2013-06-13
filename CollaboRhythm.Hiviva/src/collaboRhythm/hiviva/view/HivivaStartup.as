package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;

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



		[Bindable]
		protected var _hivivaApplicationController:HivivaApplicationController;


		public function HivivaStartup()
		{
			addEventListener(flash.events.Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAdded);

			this._sw = stage.fullScreenWidth;
			this._sh = stage.fullScreenHeight;

			_hivivaApplicationController = new HivivaApplicationController();
			_hivivaApplicationController.main();
			initStarling();
		}

		private function initStarling():void
		{
			var viewPort:Rectangle;
			//trace("Starling Init");
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = !iOS;
			trace("handleLostContext " + Starling.handleLostContext + " iOS " + iOS );
//			viewPort = new Rectangle(0, 0, 640, 960);
			viewPort = new Rectangle(0, 0, this._sw, this._sh);
			_starFW = new Starling(Main, stage, viewPort);

			_starFW.showStats = true;
			_starFW.addEventListener(starling.events.Event.ROOT_CREATED, starlingRootCreatedHandler);
			//_starFW.enableErrorChecking = true;
			_starFW.start();
			trace(_starFW.viewPort);
		}

		private function starlingRootCreatedHandler(e:starling.events.Event):void
		{
			this._assets = new AssetManager();
			var main:Main = Starling.current.root as Main;
			main.applicationController = _hivivaApplicationController as HivivaApplicationController;
			main.initMain(this._assets);
		}
	}
}
