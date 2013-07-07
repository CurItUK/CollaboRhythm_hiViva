package collaboRhythm.hiviva.view
{


	import feathers.core.FeathersControl;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.events.Event;

	import collaboRhythm.hiviva.global.FeathersScreenEvent;

	public class HivivaPreloaderWithBackground extends FeathersControl
	{

		private var progressBar:Quad;
		private var mBackground:Image;
		private var _preloaderColor:uint;
		private var __width:Number = 0;
		private var __height:Number = 0;
		private var __scaleFactor:int;
		private var bgTexture:Texture;
		private var ratio:Number;


		/*	private var cos:Function					= Math.cos;
		 private var sin:Function 					= Math.sin;
		 private var  mcPreloader  					:Shape;
		 public static const pi: Number  		    = Math.PI;
		 public static const d_r: Number  			= pi/180;
		 public static const r_d :Number   			= 180/pi;
		 public static const midPoint:Object			= {_x:Constants.STAGE_WIDTH /2,_y:Constants.STAGE_HEIGHT/2};
		 public static const r:Number 				= 11;*/

		public function HivivaPreloaderWithBackground(col:uint = 0xFFFFFFF, _w:Number = 100, _h:Number = 5, _t:Texture = null)
		{
			super();
			this._preloaderColor = col;
			this.__width = _w;
			this.__height = _h;
			this.bgTexture = _t;
			/*this.mcPreloader = new Shape();
			 this.mcPreloader.x =  midPoint.x
			 this.mcPreloader.y =  midPoint.y;*/
		}


		/**
		 *Initializes the preloader Class
		 * Adds parameters needed, adds event listeners.
		 */
		public function init():void
		{
			this.mBackground = new Image(this.bgTexture)
			this.progressBar = new Quad(this.__width, this.__height, this._preloaderColor);
			this.progressBar.y = 0;
			this.addChild(this.mBackground);
			this.addChild(this.progressBar)
//		this.addChild(this.mcPreloader);


			this.addEventListener(FeathersScreenEvent.PRELOADER_ONPOGRESS, _onProgress);
		}

		/**
		 *Gets the current width of the preloader class
		 * This way we  could easily convert to sine and cosine functions in case
		 * we use a a circular preloader.
		 */
		public function get _width():Number
		{

			var _nNum:Number = this.__width; // this.progressBar.width;

			return _nNum;

		}

		/**
		 *Sets the current width of the preloader class
		 * This way we  could easily convert to sine and cosine functions in case
		 * we use a a circular preloader.
		 */
		public function set _width(n:Number):void
		{
			this.__width = n;
		}

		/**
		 *Gets the current width of the preloader class
		 * This way we  could easily convert to sine and cosine functions in case
		 * we use a a circular preloader.
		 **/
		public function get _heigth():Number
		{

			var _nNum:Number = this.__height; // this.progressBar.width;

			return _nNum;

		}

		/**
		 *Sets the current width of the preloader class
		 * This way we  could easily convert to sine and cosine functions in case
		 * we use a a circular preloader.
		 */
		public function set _heigth(n:Number):void
		{
			this.__height = n;
		}


		/**
		 *Gets the ratio of the preloader class
		 * we use a a circular preloader.
		 */
		public function get _ratio():Number
		{

			var _nNum:Number = this.ratio; // this.progressBar.width;

			return _nNum;

		}


		/**
		 *Sets the current width of the preloader class
		 * This way we  could easily convert to sine and cosine functions in case
		 * we use a a circular preloader.
		 */
		public function set _ratio(n:Number):void
		{
			this.ratio = n;
		}

		override public function dispose():void
		{
			trace("Preloder disposed");
			super.dispose();
			this.removeEventListener(FeathersScreenEvent.PRELOADER_ONPOGRESS, _onProgress);
			this.bgTexture.dispose();
			this.mBackground.removeFromParent(true);
			this.bgTexture = null;
			this.progressBar.dispose();
			this.progressBar.removeFromParent(true);
			this.progressBar = null;
		}

		private function _onProgress(event:Event):void
		{
			this.progressBar.width = this.__width;
			this.progressBar.height = this.__height;
			/*trace("my Color is " + 	this.mcPreloader.x)

			 var pLoaded=Math.round(this.ratio * 100);

			 this.mcPreloader.graphics.clear();
			 this.mcPreloader.graphics.lineStyle(3 , 0xFFFFFF , 1);
			 this.mcPreloader.graphics.moveTo( Constants.STAGE_WIDTH /2 , Constants.STAGE_HEIGHT/2);

			 for (var z = 0; z<=pLoaded*3.6; z++) {
			 this.mcPreloader.graphics.lineTo((cos(z*d_r)*r), (sin(z*d_r)*r));
			 trace("my Color stage " + 	(cos(z*d_r)*r), (sin(z*d_r)*r) )
			 }*/
		}
	}
}
