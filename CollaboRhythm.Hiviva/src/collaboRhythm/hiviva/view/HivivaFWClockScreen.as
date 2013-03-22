package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;

	import flash.display.Bitmap;

	import flash.display.Loader;

	import flash.events.Event;
	import flash.net.URLRequest;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class HivivaFWClockScreen extends Screen
	{
		private var header:Header;
		private var label:Label
		//private var clockImage:Image;

		public function HivivaFWClockScreen()
		{


		}

		override protected function draw():void
		{
			header.width = actualWidth;
			label.y = header.y + 100;
			label.x = 20;
		}

		override protected function initialize():void
		{

			header = new Header();
			header.title = "Clock Screen";


			var backButton:Button = new Button();
			backButton.label = "Back";
			backButton.addEventListener(starling.events.Event.TRIGGERED , onBackHandler)

			var pillBoxButton:Button = new Button();
			pillBoxButton.label = "Pill Box";

			header.leftItems = new <DisplayObject>[backButton];
			header.rightItems = new <DisplayObject>[pillBoxButton];
			addChild(header);

			label = new Label();
			label.text = "Clock Goes here";
			addChild(label);

			/*
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE , onLoaderCompleteHandler)
			loader.load(new URLRequest("assets/images/tempClockFace.png"))
			*/

		}

		private function onBackHandler(e:starling.events.Event):void
		{
			owner.showScreen(HivivaScreens.HOME_SCREEN);
		}

		private function onLoaderCompleteHandler(e:flash.events.Event):void
		{
			/*
			var bmp:Bitmap = e.currentTarget.loader.content as Bitmap;
			clockImage = new Image(Texture.fromBitmap(bmp));
			clockImage.touchable = false;
			clockImage.x = actualWidth/2 - clockImage.width/2;
			clockImage.y = actualHeight/2 - clockImage.height/2;
			addChild(clockImage);
			*/
		}

	}
}
