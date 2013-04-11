package collaboRhythm.hiviva.view
{
	import feathers.controls.ButtonGroup;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;

	public class HivivaPatientSideNavScreen extends Screen
	{

		private var _sideBtnGroup:ButtonGroup;

		public function HivivaPatientSideNavScreen()
		{
		}

		override protected function draw():void
		{
			this._sideBtnGroup.y = 30;
			this._sideBtnGroup.x = 30;
			this._sideBtnGroup.width = 180;
		}

		override protected function initialize():void
		{

			this._sideBtnGroup = new ButtonGroup();
			this._sideBtnGroup.dataProvider = new ListCollection(
					[
						{label: "Profile", triggered: profileBtnHandler },
						{label: "Help", triggered: helpBtnHandler },
						{label: "Messages", triggered: messagesBtnHandler },
						{label: "Badges", triggered: badgesBtnHandler }
					]
			);
			this._sideBtnGroup.width = this.stage.width;
			this._sideBtnGroup.direction = ButtonGroup.DIRECTION_VERTICAL;

			this.addChild(this._sideBtnGroup);
		}

		private function profileBtnHandler():void
		{

		}

		private function helpBtnHandler():void
		{

		}

		private function badgesBtnHandler():void
		{

		}

		private function messagesBtnHandler():void
		{

		}
	}
}
