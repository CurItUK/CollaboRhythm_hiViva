package collaboRhythm.hiviva.view
{

	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ToggleSwitch;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;

	import starling.animation.Transitions;

	import starling.events.Event;


	public class HivivaPatientClockScreen extends Screen
	{
		private const TRANSITION_DURATION:Number						= 0.4;

		private var _header:Header;
		private var _clockPillboxToggle:ToggleSwitch;
		private var _clockPillboxNav:ScreenNavigator;
		private var _transitionMgr:ScreenSlidingStackTransitionManager;

		public function HivivaPatientClockScreen()
		{

		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._clockPillboxToggle.x = (this.actualWidth / 2);
			this._clockPillboxToggle.y = 100;
		}

		override protected function initialize():void
		{

			this._header = new Header();
			this._header.title = "Your Medication";
			addChild(this._header);

			this._clockPillboxToggle = new ToggleSwitch();
			this._clockPillboxToggle.addEventListener( Event.CHANGE, toggleHandler );
			addChild(this._clockPillboxToggle);

			initClockPillboxNav();
		}

		private function initClockPillboxNav():void
		{
			this._clockPillboxNav = new ScreenNavigator();
			this.addChild(this._clockPillboxNav);

			this._transitionMgr = new ScreenSlidingStackTransitionManager(this._clockPillboxNav);
			this._transitionMgr.ease = Transitions.EASE_OUT;
			this._transitionMgr.duration = TRANSITION_DURATION;


		}

		private function toggleHandler(e:Event):void
		{

		}

	}
}
