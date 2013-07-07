package collaboRhythm.hiviva.view.screens.patient.VirusModel
{
	public class VirusSimulation
	{
		private var _adherence:Number;
		private var _tcells:Array;
		private var _freeTcells:Array;
		private var _viruses:Array;
		private var _attachedViruses:Array;
		private var _looseViruses:Array;

		private var _cd4Count:Number;
		private var _viralLoad:Number;

		private var _numTCells:Number;
		private var _numViruses:Number;

		private var _openLooseVirusPos:Array = [];
		private var _opentcellPos:Array;
		private var _usedtcellPos:Array;


		public function VirusSimulation()
		{

		}

		public function updateSimulationData(adherence:Number , cd4Count:Number , viralLoad:Number):void
		{

			this._adherence = adherence;
			this._cd4Count = cd4Count;
			this._viralLoad = viralLoad;


			this._tcells = [];
			this._freeTcells = [];
			this._viruses = [];
			this._attachedViruses = [];
			this._looseViruses = [];
			this._openLooseVirusPos = [];

			this._opentcellPos = [
				[35, 51],
				[106, 23],
				[176, 77],
				[247, 31],
				[35, 123],
				[106, 164],
				[176, 161],
				[247, 151]
			];

			this._usedtcellPos = [];

			//calculate amount of tCells based on cd4 count by limit max to 8
			if (this._cd4Count == 0)
			{
				this._numTCells = 0;
			}
			else if (_cd4Count > 800)
			{
				this._numTCells = 8;
			}
			else
			{
				this._numTCells = Math.floor(this._cd4Count / 100);
			}

			//calculate amount of virus based on viral load
			if (this._viralLoad < 100)
			{
				this._numViruses = 1;
			}
			else
			{
				this._numViruses = Math.floor(this._viralLoad / 100);
			}

			//working under the basis we have 176 positons for virus on a grid of 16 columns
			var topHolderPadding:Number = 15;
			var leftHolderPadding:Number = 5;
			for (var looseposition:int = 0; looseposition < 176; looseposition++)
			{
				//this._openLooseVirusPos[looseposition] = [(looseposition % 16) * 20 + 10, (Math.floor(looseposition / 16)) * 20 + 10];
				this._openLooseVirusPos[looseposition] = [(looseposition % 16) * 14 + leftHolderPadding, (Math.floor(looseposition / 16)) * 18 + topHolderPadding];
			}


			for (var tcellnum:int = 1; tcellnum <= _numTCells; tcellnum++)
			{
				if (this._opentcellPos.length != 0)
				{
					var placenum:Number = Math.floor(Math.random() * this._opentcellPos.length);

					var tcellPos:Array = this._opentcellPos[placenum];
					var removepositions:Array = [];

					this._opentcellPos.splice(placenum, 1);
					this._usedtcellPos.push(tcellPos);

					trace(tcellPos[0] , tcellPos[1]);

					if (tcellPos[0] == 35 && tcellPos[1] == 51)
					{
						removepositions = [33, 34, 35, 36, 49, 50, 51, 52, 65, 66, 67, 68, 81, 82, 83, 84];
						removeLooseVirusPositions(removepositions);
					}
					else if (tcellPos[0] == 106 && tcellPos[1] == 23)
					{
						removepositions = [4, 5, 6, 7, 20, 21, 22, 23, 36, 37, 38, 39, 52, 53, 54, 55];
						removeLooseVirusPositions(removepositions);
					}
					else if (tcellPos[0] == 176 && tcellPos[1] == 77)
					{
						removepositions = [56, 57, 58, 59, 72, 73, 74, 75, 88, 89, 90, 91, 104, 105, 106, 107];
						removeLooseVirusPositions(removepositions);
					}
					else if (tcellPos[0] == 247 && tcellPos[1] == 31)
					{
						removepositions = [27, 28, 29, 30, 43, 44, 45, 46, 59, 60, 61, 62, 75, 76, 77, 78];
						removeLooseVirusPositions(removepositions);
					}
					else if (tcellPos[0] == 35 && tcellPos[1] == 123)
					{
						removepositions = [81, 82, 83, 84, 97, 98, 99, 100, 113, 114, 115, 116, 129, 130, 131, 132];
						removeLooseVirusPositions(removepositions);
					}
					else if (tcellPos[0] == 106 && tcellPos[1] == 164)
					{
						removepositions = [116, 117, 118, 119, 132, 133, 134, 135, 148, 149, 150, 151, 164, 165, 166, 167];
						removeLooseVirusPositions(removepositions);
					}
					else if (tcellPos[0] == 176 && tcellPos[1] == 161)
					{
						removepositions = [120, 121, 122, 123, 136, 137, 138, 139, 152, 153, 154, 155, 168, 169, 170, 171];
						removeLooseVirusPositions(removepositions);
					}
					else if (tcellPos[0] == 247 && tcellPos[1] == 151)
					{
						removepositions = [123, 124, 125, 126, 139, 140, 141, 142, 155, 156, 157, 158, 171, 172, 173, 174];
						removeLooseVirusPositions(removepositions);
					}

					this._tcells.push(tcellPos);
					this._freeTcells.push(tcellPos);
				}
			}

			for (looseposition = 175; looseposition >= 0; looseposition--)
			{
				if (this._openLooseVirusPos[looseposition] == 0)
				{
					this._openLooseVirusPos.splice(looseposition, 1)
				}
			}

		}

		private function removeLooseVirusPositions(removepositions:Array):void
		{
			for (var positiontoremove:uint = 0; positiontoremove < removepositions.length; positiontoremove++)
			{
				this._openLooseVirusPos[removepositions[positiontoremove]] = 0;
			}
		}

		public function get numTCells():Number
		{
			return this._numTCells;
		}

		public function get numViruses():Number
		{
			return this._numViruses;
		}

		public function get usedtcellPos():Array
		{
			return this._usedtcellPos;
		}

		public function get openLooseVirusPos():Array
		{
			return this._openLooseVirusPos;
		}
	}
}
