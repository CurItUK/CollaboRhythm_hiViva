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

		[Embed(source="/assets/images/temp/side_nav_base.png")]
		public static const SideNavBasePng:Class;

		[Embed(source="/assets/images/temp/side_nav_icon_01.png")]
		public static const SideNavIconProfilePng:Class;

		[Embed(source="/assets/images/temp/side_nav_icon_02.png")]
		public static const SideNavIconHelpPng:Class;

		[Embed(source="/assets/images/temp/side_nav_icon_03.png")]
		public static const SideNavIconMessagesPng:Class;

		[Embed(source="/assets/images/temp/side_nav_icon_04.png")]
		public static const SideNavIconBadgesPng:Class;

		[Embed(source="/assets/images/temp/top_nav_icon_01.png")]
		public static const SettingIconPng:Class;

		[Embed(source="/assets/images/temp/top_nav_icon_02.png")]
		public static const TopNavIconMessagesPng:Class;

		[Embed(source="/assets/images/temp/top_nav_icon_03.png")]
		public static const TopNavIconBadgesPng:Class;

		//front facing screen Items
		[Embed(source="/assets/images/temp/clockFace.png")]
		public static const ClockFacePng:Class;


		// TTF FONTS

		[Embed(source="/assets/fonts/exo-regular.ttf", fontName="ExoRegular", mimeType="application/x-font", embedAsCFF="false")]
		public static const ExoRegularFont:Class;

		[Embed(source="/assets/fonts/exo-bold.ttf", fontName="ExoBold", mimeType="application/x-font", embedAsCFF="false")]
		public static const ExoBoldFont:Class;

		[Embed(source="/assets/fonts/exo-light.ttf", fontName="ExoLight", mimeType="application/x-font", embedAsCFF="false")]
		public static const ExoLightFont:Class;

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
