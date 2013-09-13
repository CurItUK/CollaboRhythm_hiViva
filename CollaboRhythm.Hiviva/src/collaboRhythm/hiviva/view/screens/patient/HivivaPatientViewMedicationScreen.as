package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Screen;

	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ToggleSwitch;

	import starling.display.Image;
	import starling.events.Event;

	public class HivivaPatientViewMedicationScreen extends Screen
	{
		private var _header:HivivaHeader;
		private var _clockPillboxToggle:ToggleSwitch;
		private var _clockPillboxNav:ScreenNavigator;

		private var _clockIcon:Image;
		private var _pillboxIcon:Image;
		private var _usableHeaderHeight:Number;


		public function HivivaPatientViewMedicationScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			this._clockPillboxToggle.validate();
			this._clockPillboxToggle.y = Constants.HEADER_HEIGHT;
			this._clockPillboxToggle.x = (Constants.STAGE_WIDTH * 0.5) - (this._clockPillboxToggle.width * 0.5);

			this._clockIcon.x = this._clockPillboxToggle.x - this._clockIcon.width;
			this._clockIcon.y = this._clockPillboxToggle.y + (this._clockPillboxToggle.height * 0.5) - (this._clockIcon.height * 0.5);

			this._pillboxIcon.x = this._clockPillboxToggle.x + this._clockPillboxToggle.width;
			this._pillboxIcon.y = this._clockPillboxToggle.y + (this._clockPillboxToggle.height * 0.5) - (this._pillboxIcon.height * 0.5);

			useableHeaderHeight = this._clockPillboxToggle.y + this._clockPillboxToggle.height + Constants.PADDING_TOP;

			initClockPillboxNav();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.title = "Your Medication";
			addChild(this._header);

			this._clockPillboxToggle = new ToggleSwitch();
			this._clockPillboxToggle.isSelected = false;
			this._clockPillboxToggle.addEventListener( Event.CHANGE, toggleHandler );
			addChild(this._clockPillboxToggle);

//			this._clockIcon = new Image(Main.assets.getTexture("clock_icon"));
			this._clockIcon = new Image(Main.assets.getTexture("v2_clock_icon"));
			addChild(this._clockIcon);

//			this._pillboxIcon = new Image(Main.assets.getTexture("pillbox_icon"));
			this._pillboxIcon = new Image(Main.assets.getTexture("v2_pillbox_icon"));
			this._pillboxIcon.alpha = 0.5;
			addChild(this._pillboxIcon);
		}

		private function initClockPillboxNav():void
		{
			if(this._clockPillboxNav != null)
			{
				clearDownNav();
			}
			this._clockPillboxNav = new ScreenNavigator();
			addChild(this._clockPillboxNav);

			this._clockPillboxNav.addScreen(HivivaScreens.PATIENT_CLOCK_SCREEN , new ScreenNavigatorItem(HivivaPatientClockScreen , null , {headerHeight:useableHeaderHeight}));
			this._clockPillboxNav.addScreen(HivivaScreens.PATIENT_PILLBOX_SCREEN , new ScreenNavigatorItem(HivivaPatientPillboxScreen, null , {headerHeight:useableHeaderHeight}));
			this._clockPillboxNav.showScreen(HivivaScreens.PATIENT_CLOCK_SCREEN);
		}

		private function toggleHandler(e:Event):void
		{
			var toggle:ToggleSwitch = ToggleSwitch( e.currentTarget );
			if(!toggle.isSelected)
			{
				this._clockPillboxNav.showScreen(HivivaScreens.PATIENT_CLOCK_SCREEN);

				this._clockIcon.alpha = 1;
				this._pillboxIcon.alpha = 0.5;
			}
			else
			{
				this._clockPillboxNav.showScreen(HivivaScreens.PATIENT_PILLBOX_SCREEN);

				this._clockIcon.alpha = 0.5;
				this._pillboxIcon.alpha = 1;
			}

		}

		public function get useableHeaderHeight():Number
		{
			return _usableHeaderHeight;
		}

		public function set useableHeaderHeight(value:Number):void
		{
			_usableHeaderHeight = value;
		}

		override public function dispose():void
		{
			trace("HivivaPatientViewMedicationScreen dispose");
			clearDownNav();
			super.dispose();
		}

		private function clearDownNav():void
		{
			this._clockPillboxNav.clearScreen();
			this._clockPillboxNav.removeScreen(HivivaScreens.PATIENT_CLOCK_SCREEN);
			this._clockPillboxNav.removeScreen(HivivaScreens.PATIENT_PILLBOX_SCREEN);
			this._clockPillboxNav.dispose();
			this._clockPillboxNav = null;
		}
	}
}


