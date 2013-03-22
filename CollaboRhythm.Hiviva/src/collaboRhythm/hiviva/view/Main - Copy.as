package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.global.HivivaScreens;
	import feathers.controls.ButtonGroup;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.data.ListCollection;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{

		protected var _feathersTheme:MetalWorksMobileTheme;
		protected var _feathersNav:ScreenNavigator;
		protected var _transitionManager:ScreenSlidingStackTransitionManager;

		private var _topNavGroup:ButtonGroup;
		private var _bottomNavGroup:ButtonGroup;

		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler)
		}

		private function addedToStageHandler(e:Event):void
		{
			trace("starling sprite added to stage");
			_feathersTheme = new MetalWorksMobileTheme(this.stage);

			_feathersNav = new ScreenNavigator();

			addChild(_feathersNav);

			_feathersNav.addScreen(HivivaScreens.HOME_SCREEN , new ScreenNavigatorItem(HivivaFWHomeScreen));
			_feathersNav.addScreen(HivivaScreens.CLOCK_SCREEN  , new ScreenNavigatorItem(HivivaFWClockScreen , {complete: HivivaScreens.HOME_SCREEN}));
			_feathersNav.addScreen(HivivaScreens.PILL_BOX_SCREEN , new ScreenNavigatorItem(HivivaFWPillBoxScreen , {complete: HivivaScreens.HOME_SCREEN}));

			//_transitionManager = new ScreenSlidingStackTransitionManager(_feathersNav);

			this._topNavGroup = new ButtonGroup();
			this._topNavGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			this._topNavGroup.dataProvider = new ListCollection(
					[
						{label: "nav1", triggered: messagesButtonHandler},
						{label: "nav2", triggered: badgesButtonHandler},
						{label: "nav3", triggered: profileButtonHandler},
						{label: "nav4", triggered: helpButtonHandler}
					]
			);
			//this._topNavGroup.buttonProperties = {width:25};
			this._topNavGroup.x = 40;
			this._topNavGroup.y = 10;
			this.addChild(this._topNavGroup);

			this._bottomNavGroup = new ButtonGroup();
			this._bottomNavGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			this._bottomNavGroup.dataProvider = new ListCollection(
					[
						{label: "nav5", triggered: messagesButtonHandler},
						{label: "nav6", triggered: clockButtonHandler},
						{label: "nav7", triggered: profileButtonHandler},
						{label: "nav8", triggered: helpButtonHandler},
						{label: "nav9", triggered: reportsButtonHandler}
					]
			);
			//this._bottomNavGroup.buttonProperties = {width:30};
			this._bottomNavGroup.x = 20;
			this._bottomNavGroup.y = 850;
			this.addChild(this._bottomNavGroup);

			_feathersNav.showScreen(HivivaScreens.HOME_SCREEN);

		}

		protected function clockButtonHandler(e:Event):void
		{
			_feathersNav.showScreen(HivivaScreens.CLOCK_SCREEN);
		}

		protected function profileButtonHandler(e:Event):void
		{

		}

		protected function reportsButtonHandler(e:Event):void
		{

		}

		protected function badgesButtonHandler(e:Event):void
		{

		}

		protected function messagesButtonHandler(e:Event):void
		{

		}

		protected function helpButtonHandler(e:Event):void
		{

		}
	}
}
