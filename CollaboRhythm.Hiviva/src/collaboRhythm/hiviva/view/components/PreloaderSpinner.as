
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

		public function PreloaderSpinner()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event:Event):void
		{

			var textureAnim:TextureAtlas =  Main.assets.getTextureAtlas("ApplePreloader");
			this._preloader = new MovieClip(textureAnim.getTextures("preloader") , 60);
			this.addChild(this._preloader);

			Starling.juggler.add(this._preloader);
		}
	}
}
