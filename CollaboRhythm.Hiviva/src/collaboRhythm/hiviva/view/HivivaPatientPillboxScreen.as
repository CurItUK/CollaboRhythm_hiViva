package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.view.media.Assets;
	import collaboRhythm.hiviva.view.skins.CollaboRhythmHivivaApplicationSkin;

	import feathers.controls.Screen;
	import starling.display.Image;
	import starling.textures.Texture;


	public class HivivaPatientPillboxScreen extends Screen
	{

		private var _clockFace:Image;

		public function HivivaPatientPillboxScreen()
		{

		}

		override protected function draw():void
		{
			this._clockFace.x = this.actualWidth/2 - this._clockFace.width/2;
			this._clockFace.y = 180;
		}

		override protected function initialize():void
		{
			this._clockFace = new Image(Assets.getTexture("PillboxPng"));
			addChild(this._clockFace);



		}
	}
}
