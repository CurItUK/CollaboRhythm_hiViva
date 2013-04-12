package collaboRhythm.hiviva.view
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Header;
	import feathers.data.ListCollection;

	import starling.events.Event;

	public class HivivaPatientHomepagePhotoScreen extends ScreenBase
	{
		private var _header:Header;
		private var _galleriesButtonGroup:ButtonGroup;

		public function HivivaPatientHomepagePhotoScreen()
		{

		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new Header();
			this._header.title = "Homepage Photo";
			addChild(this._header);

			this._galleriesButtonGroup = new ButtonGroup();
			this._galleriesButtonGroup.dataProvider = new ListCollection(
			[
				{ label: "Sport", triggered: onOpenGallery },
				{ label: "Music", triggered: onOpenGallery },
				{ label: "Cinema", triggered: onOpenGallery },
				{ label: "History", triggered: onOpenGallery },
				{ label: "Traveling", triggered: onOpenGallery },
				{ label: "Art", triggered: onOpenGallery }
			]);
			this.addChild(this._galleriesButtonGroup);
		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = this.actualWidth;
			this._header.validate();

			this._galleriesButtonGroup.validate();
			this._galleriesButtonGroup.x = (this.actualWidth - this._galleriesButtonGroup.width) / 2;
			this._galleriesButtonGroup.y = this._header.height + (this.actualHeight - this._header.height - this._galleriesButtonGroup.height) / 2;
		}

		static private function onOpenGallery(e:Event):void
		{
			const button:Button = Button(e.currentTarget);
			trace(button.label + " triggered.");
			switch(button.label)
			{
				case "Sport" :

					break;
				case "Music" :
					break;
				case "Cinema" :
					break;
				case "History" :
					break;
				case "Traveling" :
					break;
				case "Art" :
					break;
			}
		}
	}
}
