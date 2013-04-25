package collaboRhythm.hiviva.view.media
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	import starling.textures.Texture;

	public class Assets
	{
/*
		[Embed(source="/resources/grid.jpg")]
		public static const grid:Class;
*/
		// the following assets are individual image files but need to compiled into atlases

		// BACKGROUND ASSETS

		[Embed(source="/assets/images/temp/fixed_base.png")]
		public static const FixedBasePng:Class;

		[Embed(source="/assets/images/temp/settings_above_effect.png")]
		public static const SettingEffectPng:Class;


		[Embed(source="/assets/images/temp/screen_base.png")]
		public static const BasePng:Class;

		[Embed(source="/assets/images/temp/bottom_gradient.png")]
		public static const BaseBottomGradPng:Class;

		[Embed(source="/assets/images/temp/top_gradient.png")]
		public static const BaseTopGradPng:Class;
/*
		[Embed(source="/assets/images/temp/top_gradient_home.png")]
		public static const BaseTopGradHomePng:Class;
*/

		// ICONS AND BUTTONS

		[Embed(source="/assets/images/temp/footer_icon_base.png")]
		public static const FooterIconBasePng:Class;

		[Embed(source="/assets/images/temp/footer_icon_active.png")]
		public static const FooterIconActivePng:Class;

		[Embed(source="/assets/images/temp/footer_icon_1.png")]
		public static const FooterIconHomePng:Class;

		[Embed(source="/assets/images/temp/footer_icon_2.png")]
		public static const FooterIconClockPng:Class;

		[Embed(source="/assets/images/temp/footer_icon_3.png")]
		public static const FooterIconMedicPng:Class;

		[Embed(source="/assets/images/temp/footer_icon_4.png")]
		public static const FooterIconVirusPng:Class;

		[Embed(source="/assets/images/temp/footer_icon_5.png")]
		public static const FooterIconReportPng:Class;

		private static var applicationTextures:Dictionary = new Dictionary();

		public static function getTexture(name:String):Texture
		{
			if (applicationTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				applicationTextures[name] = Texture.fromBitmap(bitmap);
			}
			return applicationTextures[name];
		}
	}
}
