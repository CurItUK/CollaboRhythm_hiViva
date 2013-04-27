package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Screen;

	import starling.display.Image;

	public class HivivaPatientClockScreen extends Screen
	{

		private var _clockFace:Image;

		public function HivivaPatientClockScreen()
		{

		}

		override protected function draw():void
		{

			this._clockFace.x = this.actualWidth/2 - this._clockFace.width/2;
			this._clockFace.y = 180;

		}

		override protected function initialize():void
		{
			this._clockFace = new Image(Assets.getTexture("ClockFacePng"));
			addChild(this._clockFace);



		}
	}
}
