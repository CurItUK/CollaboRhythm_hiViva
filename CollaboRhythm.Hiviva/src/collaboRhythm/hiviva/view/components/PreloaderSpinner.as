
package collaboRhythm.hiviva.view.components
{

	import collaboRhythm.hiviva.view.Main;

	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class PreloaderSpinner extends Sprite
	{

		private var _preloader:MovieClip;
		private var _textureAnim:TextureAtlas

		public function PreloaderSpinner()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);

		}

		private function init(event:Event):void
		{
			trace("PreloaderSpinner init")  ;
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this._textureAnim =  Main.assets.getTextureAtlas("ApplePreloader");
			this._preloader = new MovieClip(this._textureAnim.getTextures("preloader") , 60);
			this.addChild(this._preloader);
			Starling.juggler.add(this._preloader);

		}

		public function disposePreloader():void
		{
			trace("disposePreloader")  ;
			Starling.juggler.remove(this._preloader);
			this.removeChild(this._preloader);
			this._preloader = null;
		}
	}
}
