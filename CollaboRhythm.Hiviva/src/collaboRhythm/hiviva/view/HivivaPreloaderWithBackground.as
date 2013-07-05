package collaboRhythm.hiviva.view
{


	import feathers.core.FeathersControl;
    import starling.display.Image;
    import starling.display.Quad;
	import collaboRhythm.hiviva.global.Constants;
    import starling.textures.Texture;
	import starling.events.Event;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	public class HivivaPreloaderWithBackground extends FeathersControl
	{

		private var  progressBar					:Quad;
        private var  mBackground					:Image;
		private var _preloaderColor 				:uint;
		private var __width 						:Number  = 0;
		private var __height 						:Number  = 0 ;
		private var __scaleFactor 					:int;
		private var  bgTexture 						:Texture;



		public function HivivaPreloaderWithBackground(col : uint =  0xFFFFFFF  , _w: Number = 100 , _h:Number = 5 , _t: Texture = null  )
		{
			super();
			this._preloaderColor  = col ;
			this.__width  = _w;
			this.__height =_h;
			this.bgTexture = _t;



		}


      /**
       *Initializes the preloader Class
       * Adds parameters needed, adds event listeners.
       */
		public function init():void

	   {
		this.mBackground = new Image(this.bgTexture)
        this.progressBar = new Quad(this.__width , this.__height , this._preloaderColor);
		this.progressBar.y =   (Constants.STAGE_HEIGHT - this.progressBar.height ) / 2 ;
		this.addChild(mBackground);
		this.addChild(this.progressBar)
		this.addEventListener(FeathersScreenEvent.PRELOADER_ONPOGRESS, _onProgress);
	    };

         /**
		   *Gets the current width of the preloader class
		   * This way we  could easily convert to sine and cosine functions in case
           * we use a a circular preloader.
           */
	   public function get _width():Number{

		   var _nNum : Number  =   this.__width; // this.progressBar.width;

		   return _nNum;

	   } ;

	    /**
		    *Sets the current width of the preloader class
		    * This way we  could easily convert to sine and cosine functions in case
		    * we use a a circular preloader.
		    */
         public function set _width(n: Number)

	  {
         this.__width  = n;

 	  };

		/**
       *Gets the current width of the preloader class
       * This way we  could easily convert to sine and cosine functions in case
       * we use a a circular preloader.
        **/
      public function get _heigth():Number{

      var _nNum : Number  =   this.__height; // this.progressBar.width;

      return _nNum;

      } ;

      /**
      *Sets the current width of the preloader class
      * This way we  could easily convert to sine and cosine functions in case
      * we use a a circular preloader.
      */
      public function set _heigth(n: Number)

      {
      this.__height  = n;

      };



		public function  _dispose(){
			this.removeEventListener(FeathersScreenEvent.PRELOADER_ONPOGRESS, _onProgress);
			this.bgTexture.dispose();
			this.mBackground.removeFromParent(true);
			this.bgTexture = null;
			this.progressBar.dispose();
			this.progressBar.removeFromParent(true);
			this.progressBar = null;


		};

		private function _onProgress(event:Event):void
		{
			this.progressBar.width  =   this.__width ;
			this.progressBar.height =   this.__height;
			trace("my Color is " + 	this._preloaderColor)
		}
	}
}
