package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.model.vo.HCPConnectedPatientsVO;
	import collaboRhythm.hiviva.model.vo.PatientAdherenceVO;
	import collaboRhythm.hiviva.model.vo.ReportVO;
	import collaboRhythm.hiviva.model.vo.UserVO;

	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import flash.system.Capabilities;


	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;

	import starling.textures.Texture;



	[SWF(backgroundColor="0x000000" , frameRate="60")]

	public class HivivaStartup extends Sprite
	{
		[Embed(source="/assets/images/temp/splash_bg.jpg")]
		public static const _Background:Class;

		private var _starFW:Starling;
		private var _assets:AssetManager;

		private static var _hivivaAppController:HivivaAppController;

		public function HivivaStartup()
		{
			addEventListener(flash.events.Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(e:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAdded);

			_hivivaAppController = new HivivaAppController();

			initStarling();
		}

		private function initStarling():void
		{

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

		public static function get hcpConnectedPatientsVO():HCPConnectedPatientsVO
		{
			return hivivaAppController.hivivaLocalStoreController.service.hcpConnectedPatientsVO;
		}
	}
}
