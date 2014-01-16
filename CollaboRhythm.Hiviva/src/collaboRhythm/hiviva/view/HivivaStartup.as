package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.NotificationsEvent;
	import collaboRhythm.hiviva.model.vo.ConnectionsVO;
	import collaboRhythm.hiviva.model.vo.GalleryDataVO;
	import collaboRhythm.hiviva.model.vo.PatientAdherenceVO;
	import collaboRhythm.hiviva.model.vo.ReportVO;
	import collaboRhythm.hiviva.model.vo.UserVO;

	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;

	[SWF(backgroundColor="0x000000" , frameRate="60" , height="960" , width="640")]
	public class HivivaStartup extends Sprite
	{
		[Embed(source="/assets/images/temp/splash_bg.jpg")]
		public static const _Background:Class;

		private var _background:Bitmap;
		private var _starFW:Starling;
		private var _assets:AssetManager;

		private static var _hivivaStartup:HivivaStartup;
		private static var _hivivaAppController:HivivaAppController;

		public function HivivaStartup()
		{
			addEventListener(flash.events.Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAdded);

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode	 = StageScaleMode.NO_SCALE;

			_background =  new _Background();
			_background.smoothing = true;
			addChild(_background);

			_hivivaStartup = this;
			_hivivaAppController = new HivivaAppController();

			initStarling();
		}

		private function activate(e:flash.events.Event):void
		{
			_starFW.start();
			this.dispatchEvent(new NotificationsEvent(NotificationsEvent.APPLICATION_ACTIVATE));
		}

		private function deActivate(e:flash.events.Event):void
		{
			_starFW.stop();
			this.dispatchEvent(new NotificationsEvent(NotificationsEvent.APPLICATION_DEACTIVATE));
		}

		private function initStarling():void
		{
			_background.width = Constants.IS_DESKTOP ? stage.stageWidth : stage.fullScreenWidth;
			_background.height = Constants.IS_DESKTOP ? stage.stageHeight : stage.fullScreenHeight;

			//var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = true;


			var origStageWidth:int   = Constants.STAGE_WIDTH;
			var origStageHeight:int  = Constants.STAGE_HEIGHT;

			var viewPort:Rectangle = RectangleUtil.fit(
					new Rectangle(0, 0, origStageWidth, origStageHeight),
					new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight),
					ScaleMode.SHOW_ALL);

//			Constants.STAGE_WIDTH = viewPort.width;
//			Constants.STAGE_HEIGHT = viewPort.height;                     n

			_starFW = new Starling(Main, stage , viewPort);
			_starFW.makeCurrent();
			_starFW.stage.stageWidth  = origStageWidth;
			_starFW.stage.stageHeight = origStageHeight;
			_starFW.addEventListener(starling.events.Event.ROOT_CREATED, starlingRootCreatedHandler);
			_starFW.start();
		}

		private function starlingRootCreatedHandler(e:starling.events.Event):void
		{
			trace("driverInfo " + _starFW.context.driverInfo);
			_starFW.removeEventListener(starling.events.Event.ROOT_CREATED, starlingRootCreatedHandler);

			this._assets = new AssetManager(1);
			this._assets.verbose = true;

			this._assets.addEventListener(starling.events.Event.TEXTURES_RESTORED , texturesRestored);


			var bgTexture:Texture = Texture.fromBitmap(_background,  false, false, 1);
			var main:Main = Starling.current.root as Main;
			main.initMain(this._assets , bgTexture);

			removeChild(_background);
			_background.bitmapData.dispose();
			_background = null;

			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, activate);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, deActivate);
		}

		public function texturesRestored(e:starling.events.Event):void
		{
			trace("starling.events.Event.TEXTURES_RESTORED");
		}

		public static function get hivivaStartup():HivivaStartup
		{
			return _hivivaStartup;
		}

		public static function get hivivaAppController():HivivaAppController
		{
			return _hivivaAppController;
		}

		public static function get userVO():UserVO
		{
			return hivivaAppController.hivivaLocalStoreController.service.userVO;
		}

		public static function get reportVO():ReportVO
		{
			return hivivaAppController.hivivaLocalStoreController.service.reportVO;
		}

		public static function get patientAdherenceVO():PatientAdherenceVO
		{
			return hivivaAppController.hivivaLocalStoreController.service.patientAdherenceVO;
		}

		public static function get connectionsVO():ConnectionsVO
		{
			return hivivaAppController.hivivaLocalStoreController.service.connectionsVO;
		}

		public static function get galleryDataVO():GalleryDataVO
		{
			return hivivaAppController.hivivaLocalStoreController.service.galleryDataVO;
		}

		public function get starFW():Starling
		{
			return _starFW;
		}

		public function set starFW(value:Starling):void
		{
			_starFW = value;
		}
	}
}
