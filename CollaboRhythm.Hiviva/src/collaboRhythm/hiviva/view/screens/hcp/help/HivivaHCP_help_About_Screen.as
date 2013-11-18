package collaboRhythm.hiviva.view.screens.hcp.help
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HivivaHCP_help_About_Screen extends Screen
	{
		private var _header:HivivaHeader;
		private var _title:String;
		private var _scrollText:ScrollText;
		private var _backButton:Button;
		private var _scaledPadding:Number;
		private var _pageString:String = "INCHarge is an application for smartphones to help HIV patients track how they take their medication.  " +
				"Medication adherence is needed to protect the health of people living with HIV and prevent the spread of HIV. Medication is daily, " +
				"for life, and may have unpleasant side effects. This application connects patients and providers, focussing on education and " +
				"positive reinforcement to support adherence. \n \n INCHarge is built on the MIT Media Lab’s CollaboRhythm platform. Initial " +
				"development of the app was performed by a diverse group of HIV clinicians with technical support in the MIT Media Center, with " +
				"continuing development by participants from MIT, Healthcare for the Homeless in Boston, ViiV, PharmiWeb Solutions, Baltimore City " +
				"Health Department, and the East Africa AIDS Project.";

		public function HivivaHCP_help_About_Screen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._scaledPadding = (this.actualWidth * 0.04) * this.dpiScale;

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			this._scrollText.y = this._header.y + this._header.height;
			this._scrollText.x = this._scaledPadding;
			this._scrollText.width = this.actualWidth - (this._scaledPadding * 2);
			this._scrollText.height = this.actualHeight - this._scrollText.y - this._scaledPadding;
			this._scrollText.validate();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "About"//  this._title;
			addChild(this._header);
			this._scrollText = new ScrollText()
			this._scrollText.text = this._pageString;  //"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.\n\nNeque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?\n\nAt vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.";
			//	this._scrollText.text = "";
			this.addChild(this._scrollText);

			this._backButton = new Button();
			this._backButton.name = HivivaThemeConstants.BACK_BUTTON;
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backBtnHandler);

			this._header.leftItems = new <DisplayObject>[_backButton];
		}

		private function backBtnHandler(e:Event):void
		{
			trace("THIS IS BACK BUITTON ")
			this.owner.showScreen(HivivaScreens.HCP_HELP_SCREEN);
		}

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}
	}
}
