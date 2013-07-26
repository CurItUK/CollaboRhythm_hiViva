package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.view.*;


	import collaboRhythm.hiviva.global.HivivaScreens;

	import collaboRhythm.hiviva.view.screens.shared.BaseScreen;

	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ToggleSwitch;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;



	import starling.animation.Transitions;
	import starling.display.Image;

	import starling.events.Event;


	public class HivivaPatientViewMedicationScreen extends BaseScreen
	{
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

			this._clockPillboxToggle.x = this.actualWidth / 2 - this._clockPillboxToggle.width/2;

			if(this._clockIcon == null)
			{
				this._clockIcon = new Image(Main.assets.getTexture("clock_icon"));
				this._content.addChild(this._clockIcon);
			}

			if(this._pillboxIcon == null)
			{
				this._pillboxIcon = new Image(Main.assets.getTexture("pillbox_icon"));
				this._pillboxIcon.alpha = 0.5;
				this._content.addChild(this._pillboxIcon);
			}

			this._pillboxIcon.y = this._clockIcon.y = this._clockPillboxToggle.y + (this._clockPillboxToggle.height * 0.5)

			this._clockIcon.x = this._clockPillboxToggle.x - this._clockIcon.width;
			this._clockIcon.y -= this._clockIcon.height * 0.5;

			this._pillboxIcon.x = this._clockPillboxToggle.x + this._clockPillboxToggle.width;
			this._pillboxIcon.y -= this._pillboxIcon.height * 0.5;

			useableHeaderHeight = this._header.height +  this._clockPillboxToggle.height;

			initClockPillboxNav();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header.title = "Your Medication";

			this._clockPillboxToggle = new ToggleSwitch();
			this._clockPillboxToggle.isSelected = false;
			this._clockPillboxToggle.addEventListener( Event.CHANGE, toggleHandler );
			this._content.addChild(this._clockPillboxToggle);
		}

		private function initClockPillboxNav():void
		{
			this._clockPillboxNav = new ScreenNavigator();
			this.addChild(this._clockPillboxNav);

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
			this._clockPillboxNav.clearScreen();
			this._clockPillboxNav.removeScreen(HivivaScreens.PATIENT_CLOCK_SCREEN);
			this._clockPillboxNav.removeScreen(HivivaScreens.PATIENT_PILLBOX_SCREEN);
			this._clockPillboxNav.dispose();
			this._clockPillboxNav = null;
			super.dispose();
		}
	}
}


