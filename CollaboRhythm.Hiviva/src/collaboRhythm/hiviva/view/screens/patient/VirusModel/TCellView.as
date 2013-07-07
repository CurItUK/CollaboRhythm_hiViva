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
		private var _medShield:Image;
		private var _virusSimulation:VirusSimulation;
		private var _virusScreen:HivivaPatientVirusModelScreen;
		private var _holder:Sprite;

		private var _openvirusPos:Array = [
			[-14, 0],
			[24, 0],
			[-10, 12],
			[10, 12],
			[-10, -12],
			[10, -12]
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
			this._holder = new Sprite();

			this._tCellImage = new Image(cd4Texture);
			this._tCellImage.width = 84;
			this._tCellImage.height = 84;
			this._holder.addChild(this._tCellImage);
			this._tCellImage.x = -this._tCellImage.width >> 2;
			this._tCellImage.y = -this._tCellImage.height >> 2;
			this.addChild(this._holder);


		}

		public function init(virusSimulation:VirusSimulation , virusScreen:HivivaPatientVirusModelScreen):void
		{
			this._virusSimulation = virusSimulation;
			this._virusScreen = virusScreen;
		}

		public function addVirus(virusNumber:int, tcellNumber:Number , virusTexture:Texture):VirusView
		{
			var placenum:Number = Math.floor(Math.random() * this._openvirusPos.length);
			var virusPos:Array = this._openvirusPos[placenum];
			this._openvirusPos.splice(placenum, 1);
			this._usedvirusPos.push(virusPos);

			var virusView:VirusView = new VirusView(virusTexture);
			virusView.init(true);
			this.addChild(virusView);
			this._attachedViruses.push(virusView);
			this._attachedVirusesCopy.push(virusView);
			virusView.x = virusPos[0] * 2;
			virusView.y = virusPos[1] * 3;
			this.alive = false;
			this._tCellImage.alpha = 0.4;
			if (this._openvirusPos.length == 0)
			{
				this._virusScreen.freeTcells.splice(tcellNumber, 1);
			}
			return virusView;
		}

		private function removeVirusatPosition(virusPos:Array):void
		{

			for (var virusnum:int = 0; virusnum < this._attachedViruses.length; virusnum++)
			{
				if (this._usedvirusPos[virusnum][0] == virusPos[0] && this._usedvirusPos[virusnum][1] == virusPos[1])
				{

					var attachedVirus:VirusView = this._attachedViruses[virusnum];
					this._attachedViruses.splice(virusnum, 1);
					this._usedvirusPos.splice(virusnum, 1);
					this.removeChild(attachedVirus);
					this._virusScreen.addLooseVirus();
				}
			}
		}

		public function addMedication(adherence:Number , medTexture:Texture):void
		{
			this._medShield = new Image(medTexture);
			this._medShield.width = 90;
			this._medShield.height = 90;

			this._medShield.x = -this._medShield.width >>2;
			this._medShield.y = -this._medShield.height >>2;

			this._holder.addChild(this._medShield);

			if(adherence > 90)
			{
				removeVirusatPosition([-14, 0]);
				removeVirusatPosition([24, 0]);
				removeVirusatPosition([-10, 12]);
				removeVirusatPosition([10, 12]);
				removeVirusatPosition([-10, -12]);
				removeVirusatPosition([10, -12]);
			}
			else if (adherence <= 90 && adherence >= 85)
			{
				removeVirusatPosition([-14, 0]);
				removeVirusatPosition([24, 0]);
				removeVirusatPosition([-10, 12]);
				removeVirusatPosition([10, 12]);
				this._medShield.alpha = 0.8;
			}
			else
			{
				this._medShield.alpha = 0.3;
			}


			if (this._attachedViruses.length == 0)
			{
				this.alive = true;
				this._tCellImage..alpha = 1;
			}
		}
	}
}

