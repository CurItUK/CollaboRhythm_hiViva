package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.view.media.Assets;

	import flash.display.Bitmap;

	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.events.Event;

	public class HivivaStartup extends Sprite
	{
		private var _starFW:Starling;
		private var _splashScreenBg:Bitmap;
		private var _logo:Bitmap;

		[Bindable]
		protected var _hivivaApplicationController:HivivaApplicationController;

		public function HivivaStartup()
		{
			_hivivaApplicationController = new HivivaApplicationController();
			_hivivaApplicationController.main();
			//addSplashScreen();
			initStarling();
		}

		protected function addSplashScreen():void
		{
			this._splashScreenBg = new Assets.SplashScreenBgJpg() as Bitmap;
			this._splashScreenBg.width = stage.fullScreenWidth;
			this._splashScreenBg.height = stage.fullScreenHeight;
			addChild(this._splashScreenBg);

			this._logo = new Assets.LogoPng() as Bitmap;
			this._logo.width = stage.fullScreenWidth * 0.5;
			this._logo.scaleY = this._logo.scaleX;
			this._logo.x = (stage.fullScreenWidth * 0.5) - (this._logo.width * 0.5);
			this._logo.y = (stage.fullScreenHeight * 0.33) - (this._logo.height * 0.5);
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
			trace("Starling Init");
			Starling.handleLostContext = true;
			_starFW = new Starling(Main, stage, new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight));
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
