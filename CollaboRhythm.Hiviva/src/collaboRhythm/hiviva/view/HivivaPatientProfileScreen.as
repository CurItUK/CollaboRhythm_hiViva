package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;

	import feathers.controls.ButtonGroup;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import feathers.display.TiledImage;
	import feathers.events.FeathersEventType;

	import starling.animation.Transitions;

	import starling.animation.Tween;
	import starling.core.Starling;

	import starling.display.DisplayObject;

	import starling.events.Event;



	public class HivivaPatientProfileScreen extends ScreenBase
	{
		private var _header:Header;
		private var _menuBtnGroup:ButtonGroup;

		private var _settingsOpen:Boolean = false;

		public function HivivaPatientProfileScreen()
		{
		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
		}

		override protected function initialize():void
		{

			super.initialize();
			this._header = new Header();
			this._header.title = "Patient Profile";

			var sideNavBtn:Button = new Button();
			sideNavBtn.label = "SNav";
			sideNavBtn.addEventListener(Event.TRIGGERED , sideNavBtnHandler);

			var homeBtn:Button = new Button();
			homeBtn.label = "Home";
			homeBtn.addEventListener(Event.TRIGGERED , homeBtnHandler);

			this._header.leftItems =  new <DisplayObject>[sideNavBtn];

			initProfileMenuButtons();
			addChild(this._header);

		}

		private function initProfileMenuButtons():void
		{
			this._menuBtnGroup = new ButtonGroup();
			this._menuBtnGroup.dataProvider = new ListCollection(
					[
						{label: "My details", triggered: myDetailsBtnHandler },
						{label: "Home page photo", triggered: homepagePhotoBtnHandler },
						{label: "Daily medicines", triggered: menuBtnHandler },
						{label: "Test results", triggered: menuBtnHandler },
						{label: "sign up to collaborate", triggered: menuBtnHandler },
						{label: "Connect to care provider", triggered: menuBtnHandler }
					]
			);
			this._menuBtnGroup.y = 200;
			this._menuBtnGroup.x = 50;
			this._menuBtnGroup.direction = ButtonGroup.DIRECTION_VERTICAL;

			this.addChild(this._menuBtnGroup);

		}

		private function homeBtnHandler():void
		{

		}

		private function menuBtnHandler():void
		{

		}

		private function sideNavBtnHandler():void
		{
			//TODO tide tween animation with correct widths.
			var xLoc:Number = _settingsOpen ? 0 : 200;

			var navTween:Tween = new Tween(this.owner , 0.2 , Transitions.EASE_OUT);
			navTween.animate("x" , xLoc);
			navTween.onComplete = function():void{_settingsOpen = !_settingsOpen;} ;
			Starling.juggler.add(navTween);

		}

		private function myDetailsBtnHandler():void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN);
		}

		private function homepagePhotoBtnHandler():void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_HOMEPAGE_PHOTO_SCREEN);
		}
	}
}
