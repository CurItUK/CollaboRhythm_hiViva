package collaboRhythm.hiviva.view
{

	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.ScrollText;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;

	import starling.display.DisplayObject;

	import starling.events.Event;

	public class HivivaPatientHelpScreen extends ScreenBase
	{
		private var _header:Header;
		private var _scrollText:ScrollText;

		public function HivivaPatientHelpScreen()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler)

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
		}

		override protected function initialize():void
		{
			trace("Override initialize call");
			super.initialize();
			this._header = new Header();
			this._header.title = "Help Screen";
			addChild(this._header);

			var homeBtn:Button = new Button();
			homeBtn.label = "Home";
			homeBtn.addEventListener(Event.TRIGGERED , homeBtnHandler);
			this._header.leftItems =  new <DisplayObject>[homeBtn];

		}

		private function initializeHandler():void
		{
			trace("initialize handler call from oninitialize");

			this._scrollText = new ScrollText();
			this._scrollText.text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.\n\nNeque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?\n\nAt vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.";
			//this._scrollText.layoutData = new AnchorLayoutData(300,100,100,100);
			this._scrollText.width = 600;
			this._scrollText.height = 700;
			this._scrollText.x = 20;
			this._scrollText.y = 100;

			this.addChild(this._scrollText);
		}

		private function homeBtnHandler():void
		{
			this.dispatchEventWith("navGoHome");
		}

	}
}
