package collaboRhythm.hiviva.view
{
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.events.FeathersEventType;
	import starling.events.Event;

	public class HivivaFWHomeScreen extends Screen
	{

		public function HivivaFWHomeScreen()
		{
			this.addEventListener(FeathersEventType.INITIALIZE , initializeHandler)
		}

		protected function initializeHandler(e:Event):void
		{
			var label:Label = new Label();
			label.text = "Home Screen";
			label.x = 300;
			label.y = 500;
			addChild(label);

		}

		override protected function draw():void
		{

		}
	}
}
