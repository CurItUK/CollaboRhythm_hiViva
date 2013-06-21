package collaboRhythm.hiviva.view.screens.patient.VirusModel
{
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientVirusModelScreen;

	import feathers.controls.Screen;

	import flash.utils.Timer;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class TCellView extends Sprite
	{

		private var _tCellImage:Image;
		private var _virusSimulation:VirusSimulation;
		private var _virusScreen:Screen;
		private var _openvirusPos:Array = [
			[-24, 0],
			[24, 0],
			[-10, 24],
			[10, 24],
			[-10, -24],
			[10, -24]
		];
		private var _usedvirusPos:Array = [];
		private var _attachedViruses:Array = [];
		private var _attachedVirusesCopy:Array = [];

		private var _positions:Array = [
					[6, 0],
					[6, 1],
					[5, 2],
					[4, 3],
					[3, 4],
					[2, 5],
					[1, 5],
					[0, 5],
					[-1, 6],
					[-2, 6],
					[-3, 5],
					[-4, 5],
					[-5, 4],
					[-5, 3],
					[-5, 2],
					[-6, 1],
					[-6, 0],
					[-5, -1],
					[-4, -2],
					[-4, -3],
					[-5, -4],
					[-5, -5],
					[-4, -6],
					[-3, -6],
					[-2, -6],
					[-1, -6],
					[0, -5],
					[1, -5],
					[2, -5],
					[3, -4],
					[4, -3],
					[5, -2],
					[5, -1]
				];

		private var _currentposition:Number = Math.floor(Math.random() * _positions.length);

		private var alive:Boolean = true;

		private var _animationTimer:Timer;






		public function TCellView(cd4Texture:Texture)
		{
			this._tCellImage = new Image(cd4Texture);
			this.addChild(this._tCellImage);

		}

		public function init(virusSimulation:VirusSimulation , virusScreen:Screen):void
		{
			this._virusSimulation = virusSimulation;
			this._virusScreen = virusScreen;
			trace("tCell Init");

		}

		public function addVirus(virusNumber, tcellNumber):VirusView
		{
			var placenum:Number = Math.floor(Math.random() * this._openvirusPos.length);
			var virusPos:Array = this._openvirusPos[placenum];
			this._openvirusPos.splice(placenum, 1);
			this._usedvirusPos.push(virusPos);

			var virusView:VirusView = new VirusView();
			virusView.init(true);
			this.addChild(virusView);
			this._attachedViruses.push(virusView);
			this._attachedVirusesCopy.push(virusView);
			virusView.x = virusPos[0] * 3;
			virusView.y = virusPos[1] * 3;
			this.alive = false;
			this._tCellImage.alpha = 0.4;
			if (this._openvirusPos.length == 0)
			{
				//this._virusScreen.freeTcells.splice(tcellNumber, 1);
			}
			return virusView;
		}
	}
}
