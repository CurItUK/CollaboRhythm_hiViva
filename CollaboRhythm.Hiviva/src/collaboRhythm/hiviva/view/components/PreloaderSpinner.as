
package collaboRhythm.hiviva.view.components
{

	import collaboRhythm.hiviva.view.Main;

	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;

	public class PreloaderSpinner extends Sprite
	{

		private var _preloader:MovieClip;

		public function PreloaderSpinner()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event:Event):void
		{
			this._preloader = MovieClip(Main.assets.getTextures("ApplePreloader"));
			this.addChild(this._preloader);

			Starling.juggler.add(this._preloader);
		}
	}
}
