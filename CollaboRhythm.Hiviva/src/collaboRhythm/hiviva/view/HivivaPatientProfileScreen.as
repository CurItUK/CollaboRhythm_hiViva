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

	import starling.display.DisplayObject;

	import starling.events.Event;



	public class HivivaPatientProfileScreen extends Screen
	{
		private var _header:Header;

		private var _tileImage:TiledImage;

		private var _menuBtnGroup:ButtonGroup;



		public function HivivaPatientProfileScreen()
		{
		}

		override protected function draw():void
		{
			this._header.width = this.actualWidth;

			_tileImage.width = this.actualWidth;
			_tileImage.height = this.actualHeight;





		}

		override protected function initialize():void
		{

			this._header = new Header();
			this._header.title = "Patient Profile";

			var sideNavBtn:Button = new Button();
			sideNavBtn.label = "SNav";
			sideNavBtn.addEventListener(Event.TRIGGERED , sideNavBtnHandler);

			this._header.leftItems =  new <DisplayObject>[sideNavBtn];

			drawBackground();
			initProfileMenuButtons();




			addChild(this._header);

		}

		private function drawBackground():void
		{
			_tileImage = new TiledImage(Assets.getTexture("grid"));
			addChild(_tileImage);
		}


		private function initProfileMenuButtons():void
		{
			this._menuBtnGroup = new ButtonGroup();
			this._menuBtnGroup.dataProvider = new ListCollection(
					[
						{label: "My details", triggered: myDetailsBtnHandler },
						{label: "Home page photo", triggered: homepagePhotoBtnHandler },
						{label: "Daily medicines", triggered: menuBtnHandler },
						{label: "Test results", triggered: homepageTestResultsHandler },
						{label: "sign up to collaborate", triggered: menuBtnHandler },
						{label: "Connect to care provider", triggered: menuBtnHandler }
					]
			);
			this._menuBtnGroup.y = 200;
			this._menuBtnGroup.x = 50;

			this._menuBtnGroup.direction = ButtonGroup.DIRECTION_VERTICAL;

			this.addChild(this._menuBtnGroup);

		}

		private function menuBtnHandler():void
		{

		}

		private function sideNavBtnHandler():void
		{

		}

		private function myDetailsBtnHandler():void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_MY_DETAILS_SCREEN);
		}

		private function homepagePhotoBtnHandler():void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_HOMEPAGE_PHOTO_SCREEN);
		}

		private function homepageTestResultsHandler():void
		{
			this.owner.showScreen(HivivaScreens.PATIENT_TEST_RESULTS_SCREEN);
		}

	}
}
