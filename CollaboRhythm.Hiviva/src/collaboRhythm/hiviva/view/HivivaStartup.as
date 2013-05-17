package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.view.media.Assets;

	import flash.display.Bitmap;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;

	import starling.core.Starling;
	import starling.events.Event;

	public class HivivaStartup extends Sprite
	{
		private var _starFW:Starling;
		private var _splashScreenBg:Bitmap;
		private var _logo:Bitmap;
		private var _sw:Number;
		private var _sh:Number;

		[Bindable]
		protected var _hivivaApplicationController:HivivaApplicationController;

		//[SWF(width="640",height="960",frameRate="60",backgroundColor="0x000000")]
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

			//addSplashScreen();
			initStarling();
		}

		protected function addSplashScreen():void
		{
			this._splashScreenBg = new Assets.SplashScreenBgJpg() as Bitmap;
			this._splashScreenBg.width = this._sw;
			this._splashScreenBg.height = this._sh;
			addChild(this._splashScreenBg);

			this._logo = new Assets.LogoPng() as Bitmap;
			this._logo.width = this._sw * 0.5;
			this._logo.scaleY = this._logo.scaleX;
			this._logo.x = (this._sw * 0.5) - (this._logo.width * 0.5);
			this._logo.y = (this._sh * 0.33) - (this._logo.height * 0.5);
			addChild(this._logo);
		}

		protected function removeSplashScreen():void
		{
			removeChild(this._splashScreenBg);
			this._splashScreenBg.bitmapData.dispose();
			this._splashScreenBg = null;

			removeChild(this._logo);
			this._logo.bitmapData.dispose();
			this._logo = null;
		}

		private function initStarling():void
		{
			var viewPort:Rectangle;
			trace("Starling Init");
			Starling.handleLostContext = true;
			// if this is a desktop air
			//viewPort = new Rectangle(0, 0, 640, 960);
			viewPort = new Rectangle(0, 0, this._sw, this._sh);
			_starFW = new Starling(Main, stage, viewPort);
			_starFW.addEventListener(starling.events.Event.ROOT_CREATED, starlingRootCreatedHandler);
			_starFW.enableErrorChecking = true;
			//_starFW.showStats = true;
			//_starFW.showStatsAt(HAlign.RIGHT, VAlign.TOP);
			_starFW.start();
			trace(_starFW.viewPort);
		}

		private function starlingRootCreatedHandler(e:starling.events.Event):void
		{
			var main:Main = Starling.current.root as Main;
			main.applicationController = _hivivaApplicationController as HivivaApplicationController;
			main.initMain();

			//removeSplashScreen();
		}
	}
}
