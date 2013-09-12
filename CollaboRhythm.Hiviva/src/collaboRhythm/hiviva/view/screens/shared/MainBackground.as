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
//		public static const BG_GREY_TYPE:String = "grey";
//		public static const BG_BLUE_TYPE:String = "blue";

//		private var _greyBgHolder:Sprite = new Sprite();
		private var _blueBgHolder:Sprite = new Sprite();

		public function MainBackground()
		{
		}

		/*public function draw(width:Number, height:Number, bgType:String = BG_GREY_TYPE):void
		{
			switch(bgType)
			{
				case BG_GREY_TYPE :
					if(!contains(_greyBgHolder)) drawGreyBg(width, height);
					addChild(_greyBgHolder);
					if(contains(_blueBgHolder))
					{
						removeChild(_blueBgHolder);
					}
					break;

				case BG_BLUE_TYPE :
					if(!contains(_blueBgHolder)) drawBlueBg(width, height);
					addChild(_blueBgHolder);
					if(contains(_greyBgHolder))
					{
						removeChild(_greyBgHolder);
					}
					break;
			}
		}*/

		public function draw():void
		{
			if(!contains(_blueBgHolder)) drawBlueBg();
			addChild(_blueBgHolder);
		}

//		private function drawBlueBg(width:Number, height:Number):void
		private function drawBlueBg():void
		{
			var bgTexture:Texture = Main.assets.getTexture("main_bg");

			var blueBase:Image = new Image(bgTexture);
			blueBase.width = Constants.STAGE_WIDTH;
			blueBase.height = Constants.STAGE_HEIGHT;
			blueBase.smoothing = TextureSmoothing.NONE;
			blueBase.touchable = false;
			//screenBase.flatten();
			_blueBgHolder.addChild(blueBase);

			var settingEffect:Image = new Image(Main.assets.getTexture("settings_above_effect"));
			settingEffect.touchable = false;
			settingEffect.height = Constants.STAGE_HEIGHT;
			settingEffect.x = 1 - settingEffect.width;
			settingEffect.smoothing = TextureSmoothing.NONE;
			settingEffect.blendMode = BlendMode.MULTIPLY;
			_blueBgHolder.addChild(settingEffect);
		}

		/*private function drawGreyBg(width:Number, height:Number):void
		{
			var screenBase:TiledImage = new TiledImage(Main.assets.getTexture("screen_base"));
			screenBase.width = width;
			screenBase.height = height;
			screenBase.smoothing = TextureSmoothing.NONE;
			screenBase.touchable = false;
			//screenBase.flatten();
			_greyBgHolder.addChild(screenBase);

//			if(hasGradients)
			{
				var topGrad:TiledImage = new TiledImage(Main.assets.getTexture("top_gradient"));
				topGrad.touchable = false;
				topGrad.width = width;
				topGrad.smoothing = TextureSmoothing.NONE;
				topGrad.blendMode = BlendMode.MULTIPLY;
				//topGrad.flatten();
				_greyBgHolder.addChild(topGrad);

				var bottomGrad:TiledImage = new TiledImage(Main.assets.getTexture("bottom_gradient"));
				bottomGrad.touchable = false;
				bottomGrad.width = width;
				bottomGrad.y = height - bottomGrad.height;
				bottomGrad.smoothing = TextureSmoothing.NONE;
				bottomGrad.blendMode = BlendMode.MULTIPLY;
				//bottomGrad.flatten();
				_greyBgHolder.addChild(bottomGrad);

				var settingEffect:TiledImage = new TiledImage(Main.assets.getTexture("settings_above_effect"));
				settingEffect.touchable = false;
				settingEffect.name = "settingEffect";
				settingEffect.height = height;
				settingEffect.x = 1 - settingEffect.width;
				settingEffect.smoothing = TextureSmoothing.NONE;
				settingEffect.blendMode = BlendMode.MULTIPLY;
				_greyBgHolder.addChild(settingEffect);
			}

			_greyBgHolder.flatten();
//			holder.touchable = false; causes the touch event to propagate to the settings menu underneath!
		}*/
	}
}
