package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.screens.patient.VirusModel.TCellView;
	import collaboRhythm.hiviva.view.screens.patient.VirusModel.TCellView;
	import collaboRhythm.hiviva.view.screens.patient.VirusModel.VirusSettingsControl;
	import collaboRhythm.hiviva.view.screens.patient.VirusModel.VirusSimulation;
	import collaboRhythm.hiviva.view.screens.patient.VirusModel.VirusView;

	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.Slider;
	import feathers.display.TiledImage;
	import feathers.events.FeathersEventType;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;


	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;


	public class HivivaPatientVirusModelScreen extends Screen
	{

		private var _header:HivivaHeader;

		private var _virusSettingsBtn:Button;
		private var _virusSettingsControl:VirusSettingsControl;

		private var _virusHolder:Sprite;
		private var _virusBg:ImageLoader;
		private var _hivSimulation:VirusSimulation;
		private var _tcells:Array = [];
		private var _freeTcells:Array = [];
		private var _viruses:Array = [];
		private var _attachedViruses:Array = [];
		private var _looseViruses:Array = [];

		private var _scaledPadding:Number;

		public function HivivaPatientVirusModelScreen()
		{

		}

		override protected function draw():void
		{

			this._scaledPadding = (this.actualWidth * 0.02) * this.dpiScale;
			var innerWidth:Number = this.actualWidth - (this._scaledPadding * 2);

			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			this._virusSettingsBtn.validate();
			this._virusSettingsBtn.x = this.actualWidth/2 - this._virusSettingsBtn.width/2;
			this._virusSettingsBtn.y = this._header.height + this._scaledPadding;

			this._virusHolder.y = this._virusSettingsBtn.y + this._virusSettingsBtn.height + this._scaledPadding;

			getPatientData();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Virus Model";
			addChild(this._header);

			this._virusHolder = new Sprite();
			this.addChild(this._virusHolder);

			this._virusSettingsBtn = new Button();
			this._virusSettingsBtn.defaultIcon = new Image(Main.assets.getTexture("vs_slider_icon"));
			this._virusSettingsBtn.addEventListener(Event.TRIGGERED , virusSettingsBtnHandler);
			this.addChild(this._virusSettingsBtn);

		}

		private function getPatientData():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE , adherenceLoadCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.getAdherence();
		}

		private function adherenceLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE , adherenceLoadCompleteHandler);
			trace("Virus Simulation " + e.data.adherence);

			initVirusModel();

		}

		private function virusSettingsBtnHandler(e:Event):void
		{
			if(_hivSimulation != null)
			{
				trace("Adjust Simulation");
				initSettingsControl();
			}
		}

		private function initSettingsControl():void
		{
			_virusSettingsControl = new VirusSettingsControl(95 , 350 , 50000);
			_virusSettingsControl.addEventListener("VirusControllClose" , virusSettingsCloseHandler);
			this.addChild(_virusSettingsControl);


			_virusSettingsControl.width = this.actualWidth;
			_virusSettingsControl.height = this.actualHeight;
			_virusSettingsControl.validate();

			_virusSettingsControl.y = this._header.height;
		}

		private function virusSettingsCloseHandler(e:Event):void
		{
			this.removeChild(_virusSettingsControl);
			this._virusHolder.removeChildren(1,-1,true);
			_hivSimulation = new VirusSimulation();
			_hivSimulation.updateSimulationData(e.data.adherence , e.data.cd4Count ,  e.data.viralLoad);

			placeTCells();
			placeViruses();

		}

		private function initVirusModel():void
		{
			drawVirusModelBg();
		}

		private function drawVirusModelBg():void
		{
			this._virusBg = new ImageLoader();
			this._virusBg.addEventListener( Event.COMPLETE, virusBgLoadComplete );
			this._virusBg.source = "/assets/images/temp/vs_background.png";
			this._virusHolder.addChild(this._virusBg);

		}

		private function virusBgLoadComplete(e:Event):void
		{

			_hivSimulation = new VirusSimulation();
			_hivSimulation.updateSimulationData(95 , 700 , 50000);

			placeTCells();
			placeViruses();
		}

		private function placeTCells():void
		{
			var tCellTexture:Texture = Main.assets.getTexture("vs_cd4");
			for (var tcellnum:int = 1; tcellnum <= this._hivSimulation.numTCells; tcellnum++)
			{

				var tCellView:TCellView = new TCellView(tCellTexture);
				tCellView.x = this._hivSimulation.usedtcellPos[tcellnum - 1][0] * 3;
				tCellView.y = this._hivSimulation.usedtcellPos[tcellnum - 1][1] * 3;
				this._virusHolder.addChild(tCellView);
				tCellView.init(this._hivSimulation , this);

				this._tcells.push(tCellView);
				this._freeTcells.push(tCellView);
			}
		}

		private function placeViruses():void
		{
			var virusTexture:Texture = Main.assets.getTexture("vs_virus");
			for (var virusnum:int = 1; virusnum <= this._hivSimulation.numViruses; virusnum++)
			{
				if (this._freeTcells.length != 0)
				{
					var tcellNumber:Number = Math.floor(Math.random() * this._freeTcells.length);
					var tcellView:TCellView = this._freeTcells[tcellNumber];
					var virusView:VirusView = tcellView.addVirus(virusnum, tcellNumber , virusTexture);
					this._viruses.push(virusView);
					this._attachedViruses.push(virusView);
				}
				else
				{
					addLooseVirus(virusTexture);
				}
			}
		}


		public function addLooseVirus(virusTexture:Texture):void
		{

			if (this._hivSimulation.openLooseVirusPos.length != 0)
			{
				var looseVirusesLength:Number = this._looseViruses.length;
				var virusView:VirusView = new VirusView(virusTexture);
				virusView.init(false);
				this._virusHolder.addChild(virusView);

				virusView.alpha = 0.6;
				var virusPosNumber:Number = Math.floor(Math.random() * this._hivSimulation.openLooseVirusPos.length);
				var virusPos:Array = this._hivSimulation.openLooseVirusPos[virusPosNumber];
				var xwiggle:Number = Math.floor(Math.random() * 5) - 2;
				var ywiggle:Number = Math.floor(Math.random() * 5) - 2;
				virusView.x = (virusPos[0] + xwiggle) * 3;
				virusView.y = (virusPos[1] + ywiggle) * 3;
				this._hivSimulation.openLooseVirusPos.splice(virusPosNumber, 1);
				this._viruses.push(virusView);
				this._looseViruses.push(virusView);
			}
		}

		public function get freeTcells():Array
		{
			return _freeTcells;
		}

		public override function dispose():void
		{
			trace("HivivaPatientVirusModelScreen dispose");
			super.dispose();
		}
	}
}
