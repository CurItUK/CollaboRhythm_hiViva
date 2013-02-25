package collaboRhythm.hiviva.view.skins
{

	import collaboRhythm.hiviva.view.skins.skins160.ActionBarBackground;
	import collaboRhythm.hiviva.view.skins.skins240.ActionBarBackground;
	import collaboRhythm.hiviva.view.skins.skins320.ActionBarBackground;

	import mx.core.DPIClassification;

	import spark.skins.mobile.ActionBarSkin;

	public class HivivaActionBarSkin extends ActionBarSkin
	{
		public function HivivaActionBarSkin()
		{
			layoutShadowHeight = 0;

			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					layoutContentGroupHeight = 86;
					layoutTitleGroupHorizontalPadding = 26;

					borderClass = collaboRhythm.hiviva.view.skins.skins320.ActionBarBackground;

					break;
				}
				case DPIClassification.DPI_240:
				{
					layoutContentGroupHeight = 65;
					layoutTitleGroupHorizontalPadding = 20;

					borderClass = collaboRhythm.hiviva.view.skins.skins240.ActionBarBackground;

					break;
				}
				default:
				{
					// default DPI_160
					layoutContentGroupHeight = 30;
					layoutTitleGroupHorizontalPadding = 13;

					borderClass = collaboRhythm.hiviva.view.skins.skins160.ActionBarBackground;

					break;
				}
			}
		}
	}
}
