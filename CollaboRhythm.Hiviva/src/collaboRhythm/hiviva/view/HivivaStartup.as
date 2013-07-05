package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.global.Constants;
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
		private var _starFW:Starling;

		private var _assets:AssetManager;
		private var _passwordBox:PasswordBox;
		private var _passwordActive:Boolean;


		protected var _sw:Number;
		protected var _sh:Number;

		private var bmp:Bitmap;

		[Embed(source="/assets/images/temp/logo_bg.png")]
		public static const LogoPng:Class;

		[Embed(source="/assets/images/Preloader_Bg.png")]
		public static const __Background:Class;



		public namespace online = "use server";
		public namespace offline = "use local" ;
		public namespace IOS    = "IOS Data";
		public namespace Android = "Android Data";
		public var mode: Namespace = online;


		private static var _hivivaAppController:HivivaAppController;

        private var ns :  Boolean


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
			_hivivaAppController.initRemoteStore();

 			checkNetworkStatus();

		}

		private function checkNetworkStatus():void
		{

			ns = new CheckNetworkStatus().status as Boolean;
			(ns== true )? mode = online: mode = offline;
			mode::loadData();




		}

		online function loadData(){

           trace("there you go on line data 	")


			drawBackground();
			initStarling();
	        }

	     	offline function loadData(){
             trace("you are offline")

			/* drawBackground();
			 initStarling();*/
			}

		     IOS function setData()
		{


		}

		Android function  setData()
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
			//_starFW.showStats = true ;
			_starFW.stage.stageWidth  = stageWidth;
			_starFW.stage.stageHeight = stageHeight;
			_starFW.addEventListener(starling.events.Event.ROOT_CREATED, starlingRootCreatedHandler);
			_starFW.start();

			this.stage.addEventListener(flash.events.Event.ACTIVATE, onIdle, false, 0, true);
			this.stage.addEventListener(flash.events.Event.DEACTIVATE, onBack, false, 0, true);

/*			NativeApplication.nativeApplication.addEventListener(
					flash.events.Event.ACTIVATE, function (e:*):void {
						//startApp();

					});

			NativeApplication.nativeApplication.addEventListener(
					flash.events.Event.DEACTIVATE, function (e:*):void {
						//stopApp();
					});*/

		}

		    //NativeApplication.nativeApplication.addEventListener(flash.events.Event.EXITING, onAppExit);
	 		//NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, startApp);
	 		//NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, stopApp);

        private function onIdle(e:flash.events.Event){

			//TODO: We need to decide how to create these functions

		};
		private function onBack(e:flash.events.Event){

			//TODO: We need to decide how to create these functions
		};

		private function drawBackground():void
		{
			bmp = new LogoPng();

			bmp.x = stage.fullScreenWidth/2 - bmp.width/2;
			bmp.y = stage.fullScreenHeight/2 - bmp.height/2;

			addChild(bmp);



           //  addChild(background);


		}

		private function disposeBg():void
		{
			removeChild(bmp);
			bmp = null;
		}

		private function drawPasswordBox():void
		{


		}



		private function doSubmit(e:flash.events.Event):void
		{
			if(_passwordBox.Pass !== "123456") {
				_passwordBox.wrongPass()
				trace("wrong password pleae try aghain!")
			return;
			}
			_passwordBox.removeEventListener("SUBMIT_CLICKED", doSubmit)
		//	removeChild(_passwordBox);
			_passwordActive = false;
		}


		private function starlingRootCreatedHandler(e:starling.events.Event):void
		{
			trace("renderMode " +  Starling.context.driverInfo);
			_starFW.removeEventListener(starling.events.Event.ROOT_CREATED, starlingRootCreatedHandler);
			this._assets = new AssetManager();
			var main:Main = Starling.current.root as Main;
			var background:Bitmap =  new __Background()
		//	__Background  = null; // no longer needed!
			background.smoothing = true;
			var bgTexture:Texture = Texture.fromBitmap(background,  false, false, 1);
			main.initTexture(bgTexture)
			main.initMain(this._assets );



			disposeBg();
		   // drawPasswordBox();
		}

		public static function get hivivaAppController():HivivaAppController
		{
			return _hivivaAppController;
		}

		public static function get userVO():UserVO
		{
			return hivivaAppController.hivivaLocalStoreController.service.userVO;
		}

		public function get thisStageW():Number
		{
			return _sw;
		}

		public function get thisStageH():Number
		{
			return _sh;
		}

	}
}
