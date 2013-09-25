package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.view.Main;

	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	public class MainBackground extends Sprite
	{

		private var _blueBgHolder:Sprite = new Sprite();

		public function MainBackground()
		{
		}

		public function draw():void
		{
			if(!contains(_blueBgHolder)) drawBlueBg();
			addChild(_blueBgHolder);
		}

		private function drawBlueBg():void
		{
			var bgTexture:Texture = Main.assets.getTexture("main_bg");

			var blueBase:Image = new Image(bgTexture);
			blueBase.width = Constants.STAGE_WIDTH;
			blueBase.height = Constants.STAGE_HEIGHT;
			blueBase.smoothing = TextureSmoothing.NONE;
			blueBase.touchable = false;
			_blueBgHolder.addChild(blueBase);

			var settingEffect:Image = new Image(Main.assets.getTexture("settings_above_effect"));
			settingEffect.touchable = false;
			settingEffect.height = Constants.STAGE_HEIGHT;
			settingEffect.x = 1 - settingEffect.width;
			settingEffect.smoothing = TextureSmoothing.NONE;
			settingEffect.blendMode = BlendMode.MULTIPLY;
			_blueBgHolder.addChild(settingEffect);
		}
	}
}
