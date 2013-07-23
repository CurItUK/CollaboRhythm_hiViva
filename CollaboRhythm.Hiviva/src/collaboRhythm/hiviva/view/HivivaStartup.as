package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.model.vo.PatientAdherenceVO;
	import collaboRhythm.hiviva.model.vo.ReportVO;
	import collaboRhythm.hiviva.model.vo.UserVO;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoaderDataFormat;
	import flash.system.Capabilities;
	import flash.text.TextField;

	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import flash.display.Shape;
	import collaboRhythm.hiviva.view.components.PasswordBox;
	import flash.desktop.NativeApplication;
	import starling.textures.Texture;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import collaboRhythm.hiviva.global.CheckNetworkStatus;

	[SWF(backgroundColor="0x000000" , frameRate="60")]

	public class HivivaStartup extends Sprite
	{
		[Embed(source="/assets/images/temp/splash_bg.jpg")]
		public static const _Background:Class;

		private var _starFW:Starling;
		private var _assets:AssetManager;
		private var _networkStatus:Boolean;

		protected var _sw:Number;
		protected var _sh:Number;

		public namespace online = "use server";
		public namespace offline = "use local" ;
		public namespace iOS    = "iOS Data";
		public namespace otherOS = "other OS Data";
		public var mode: Namespace = online;

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

 			//checkNetworkStatus();
			initStarling();
		}

		private function checkNetworkStatus():void
		{
			_networkStatus = new CheckNetworkStatus().status as Boolean;
			(_networkStatus == true ) ? mode = online: mode = offline;
			mode::loadData();
		}

		online function loadData():void
		{
			trace("there you go on line data");
			initStarling();
		}

		offline function loadData():void
		{
			initStarling();
			trace("you are offline");
		}

		iOS function setData():void
		{

		}

		otherOS function  setData():void
		{

		}

		private function initStarling():void
		{
			//var viewPort:Rectangle;
			//viewPort = new Rectangle(0, 0, 640, 960);
			//viewPort = new Rectangle(0, 0, this._sw, this._sh);

			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = !iOS;

			var stageWidth:int   = Constants.STAGE_WIDTH;
			var stageHeight:int  = Constants.STAGE_HEIGHT;

			var viewPort:Rectangle = RectangleUtil.fit(
					new Rectangle(0, 0, stageWidth, stageHeight),
					new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight),
					ScaleMode.SHOW_ALL);

			_starFW = new Starling(Main, stage, viewPort);
			_starFW.stage.stageWidth  = stageWidth;
			_starFW.stage.stageHeight = stageHeight;
			_starFW.addEventListener(starling.events.Event.ROOT_CREATED, starlingRootCreatedHandler);
			_starFW.start();

		}

		private function starlingRootCreatedHandler(e:starling.events.Event):void
		{
			_starFW.removeEventListener(starling.events.Event.ROOT_CREATED, starlingRootCreatedHandler);

			this._assets = new AssetManager();

			var background:Bitmap =  new _Background();
			background.smoothing = true;
			var bgTexture:Texture = Texture.fromBitmap(background,  false, false, 1);

			var main:Main = Starling.current.root as Main;
			main.initMain(this._assets , bgTexture);
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
	}
}
