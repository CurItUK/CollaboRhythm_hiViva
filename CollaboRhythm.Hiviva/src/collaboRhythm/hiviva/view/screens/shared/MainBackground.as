package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.view.Main;

	import feathers.display.TiledImage;

	import starling.display.BlendMode;
	import starling.display.Sprite;
	import starling.textures.TextureSmoothing;

	public class MainBackground extends Sprite
	{
		public function MainBackground()
		{


		}

		public function draw(width:Number, height:Number):void
		{
			var holder:Sprite = new Sprite();

			var screenBase:TiledImage = new TiledImage(Main.assets.getTexture("screen_base"));//new TiledImage(hivivaAtlas.getTexture("screen_base"));

			screenBase.width = width;
			screenBase.height = height;
			screenBase.smoothing = TextureSmoothing.NONE;
			screenBase.touchable = false;
			//screenBase.flatten();
			holder.addChild(screenBase);

			var topGrad:TiledImage = new TiledImage(Main.assets.getTexture("top_gradient"));
			topGrad.touchable = false;
			topGrad.width = width;
			topGrad.smoothing = TextureSmoothing.NONE;
			topGrad.blendMode = BlendMode.MULTIPLY;
			//topGrad.flatten();
			holder.addChild(topGrad);

			var bottomGrad:TiledImage = new TiledImage(Main.assets.getTexture("bottom_gradient"));
			bottomGrad.touchable = false;
			bottomGrad.width = width;
			bottomGrad.y = height - bottomGrad.height;
			bottomGrad.smoothing = TextureSmoothing.NONE;
			bottomGrad.blendMode = BlendMode.MULTIPLY;
			//bottomGrad.flatten();
			holder.addChild(bottomGrad);

			var settingEffect:TiledImage = new TiledImage(Main.assets.getTexture("settings_above_effect"));
			settingEffect.touchable = false;
			settingEffect.name = "settingEffect";
			settingEffect.height = height;
			settingEffect.x = 1 - settingEffect.width;
			settingEffect.smoothing = TextureSmoothing.NONE;
			settingEffect.blendMode = BlendMode.MULTIPLY;
			holder.addChild(settingEffect);

			holder.flatten();
//			holder.touchable = false; causes the touch event to propagate to the settings menu underneath!
			this.addChild(holder);
		}
	}
}
