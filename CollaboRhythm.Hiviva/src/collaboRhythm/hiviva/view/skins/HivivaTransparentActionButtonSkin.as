package collaboRhythm.hiviva.view.skins
{
	import collaboRhythm.hiviva.view.skins.skins160.TransparentActionButton_down;
	import collaboRhythm.hiviva.view.skins.skins160.TransparentActionButton_up;
	import collaboRhythm.hiviva.view.skins.skins320.TransparentActionButton_down;
	import collaboRhythm.hiviva.view.skins.skins320.TransparentActionButton_up;

	import mx.core.DPIClassification;

	import spark.skins.mobile.TransparentNavigationButtonSkin;

	public class HivivaTransparentActionButtonSkin extends TransparentNavigationButtonSkin
	{
		public function HivivaTransparentActionButtonSkin()
		{
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					upBorderSkin = collaboRhythm.hiviva.view.skins.skins320.TransparentActionButton_up;
					downBorderSkin = collaboRhythm.hiviva.view.skins.skins320.TransparentActionButton_down;

					break;
				}
				default:
				{
					upBorderSkin = collaboRhythm.hiviva.view.skins.skins160.TransparentActionButton_up;
					downBorderSkin = collaboRhythm.hiviva.view.skins.skins160.TransparentActionButton_down;

					break;
				}
			}
		}
	}
}
