package collaboRhythm.hiviva.view.skins
{
	import collaboRhythm.hiviva.view.skins.skins160.TransparentNavigationButton_down;
	import collaboRhythm.hiviva.view.skins.skins160.TransparentNavigationButton_up;
	import collaboRhythm.hiviva.view.skins.skins320.TransparentNavigationButton_down;
	import collaboRhythm.hiviva.view.skins.skins320.TransparentNavigationButton_up;

	import mx.core.DPIClassification;

	import spark.skins.mobile.TransparentNavigationButtonSkin;

	public class HivivaTransparentNavigationButtonSkin extends TransparentNavigationButtonSkin
	{
		public function HivivaTransparentNavigationButtonSkin()
		{
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					upBorderSkin = collaboRhythm.hiviva.view.skins.skins320.TransparentNavigationButton_up;
					downBorderSkin = collaboRhythm.hiviva.view.skins.skins320.TransparentNavigationButton_down;

					break;
				}
				default:
				{
					upBorderSkin = collaboRhythm.hiviva.view.skins.skins160.TransparentNavigationButton_up;
					downBorderSkin = collaboRhythm.hiviva.view.skins.skins160.TransparentNavigationButton_down;

					break;
				}
			}
		}
	}
}
