package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ToggleSwitch;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;



	import starling.animation.Transitions;

	import starling.events.Event;


	public class HivivaPatientViewMedicationScreen extends Screen
	{
		private const TRANSITION_DURATION:Number						= 0.4;
		
		private var _header:HivivaHeader;
		private var _clockPillboxToggle:ToggleSwitch;
		private var _clockPillboxNav:ScreenNavigator;
		private var _transitionMgr:ScreenSlidingStackTransitionManager;

		public function HivivaPatientViewMedicationScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;
			this._clockPillboxToggle.validate();
			this._clockPillboxToggle.x = this.actualWidth / 2 - this._clockPillboxToggle.width/2;
			this._clockPillboxToggle.y = 100;

			this._clockPillboxNav.showScreen(HivivaScreens.PATIENT_CLOCK_SCREEN);
		}

		override protected function initialize():void
		{

			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Your Medication";
			addChild(this._header);


			this._clockPillboxToggle = new ToggleSwitch();
			this._clockPillboxToggle.isSelected = true;
			this._clockPillboxToggle.addEventListener( Event.CHANGE, toggleHandler );
			addChild(this._clockPillboxToggle);

			initClockPillboxNav();

		}

		private function initClockPillboxNav():void
		{
			this._clockPillboxNav = new ScreenNavigator();
			this._clockPillboxNav.addScreen(HivivaScreens.PATIENT_CLOCK_SCREEN , new ScreenNavigatorItem(HivivaPatientClockScreen));
			this._clockPillboxNav.addScreen(HivivaScreens.PATIENT_PILLBOX_SCREEN , new ScreenNavigatorItem(HivivaPatientPillboxScreen));
			this.addChild(this._clockPillboxNav);

			this._transitionMgr = new ScreenSlidingStackTransitionManager(this._clockPillboxNav);
			this._transitionMgr.ease = Transitions.EASE_OUT;
			this._transitionMgr.duration = TRANSITION_DURATION;


		}

		private function toggleHandler(e:Event):void
		{
			var toggle:ToggleSwitch = ToggleSwitch( e.currentTarget );
			if(toggle.isSelected)
			{
				this._clockPillboxNav.showScreen(HivivaScreens.PATIENT_CLOCK_SCREEN);
			} else
			{
				this._clockPillboxNav.showScreen(HivivaScreens.PATIENT_PILLBOX_SCREEN);
			}

		}

	}
}
