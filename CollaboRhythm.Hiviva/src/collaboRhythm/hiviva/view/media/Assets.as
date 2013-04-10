package collaboRhythm.hiviva.view.media
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	import starling.textures.Texture;

	public class Assets
	{

		[Embed(source="/resources/grid.jpg")]
		public static const grid:Class;






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
