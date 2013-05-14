package collaboRhythm.hiviva.view
{

	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.ToggleSwitch;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;



	import starling.animation.Transitions;
	import starling.display.Image;

	import starling.events.Event;


	public class HivivaPatientViewMedicationScreen extends Screen
	{
		private const TRANSITION_DURATION:Number						= 0.4;
		
		private var _header:HivivaHeader;
		private var _clockPillboxToggle:ToggleSwitch;
		private var _clockPillboxNav:ScreenNavigator;
		private var _transitionMgr:ScreenSlidingStackTransitionManager;
		private var _clockIcon:Image;
		private var _pillboxIcon:Image;

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

			this._pillboxIcon.y = this._clockIcon.y = this._clockPillboxToggle.y + (this._clockPillboxToggle.height * 0.5)

			this._clockIcon.x = this._clockPillboxToggle.x - this._clockIcon.width;
			this._clockIcon.y -= this._clockIcon.height * 0.5;

			this._pillboxIcon.x = this._clockPillboxToggle.x + this._clockPillboxToggle.width;
			this._pillboxIcon.y -= this._pillboxIcon.height * 0.5;

			this._clockPillboxNav.showScreen(HivivaScreens.PATIENT_CLOCK_SCREEN);
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

			this._clockIcon = new Image(HivivaAssets.CLOCK_ICON);
			addChild(this._clockIcon);

			this._pillboxIcon = new Image(HivivaAssets.PILLBOX_ICON);
			this._pillboxIcon.alpha = 0.5;
			addChild(this._pillboxIcon);

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
			if(!toggle.isSelected)
			{
				this._clockPillboxNav.showScreen(HivivaScreens.PATIENT_CLOCK_SCREEN);

				this._clockIcon.alpha = 1;
				this._pillboxIcon.alpha = 0.5;
			} else
			{
				this._clockPillboxNav.showScreen(HivivaScreens.PATIENT_PILLBOX_SCREEN);

				this._clockIcon.alpha = 0.5;
				this._pillboxIcon.alpha = 1;
			}

		}

		override public function dispose():void
		{


			super.dispose();
		}
	}
}
