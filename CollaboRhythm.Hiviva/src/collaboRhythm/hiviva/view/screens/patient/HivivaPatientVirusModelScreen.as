package collaboRhythm.hiviva.view.screens.patient
{

	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.view.*;
	import collaboRhythm.hiviva.view.screens.patient.VirusModel.TCellView;
	import collaboRhythm.hiviva.view.screens.patient.VirusModel.VirusSettingsControl;
	import collaboRhythm.hiviva.view.screens.patient.VirusModel.VirusSimulation;
	import collaboRhythm.hiviva.view.screens.patient.VirusModel.VirusView;
	import collaboRhythm.hiviva.view.screens.shared.MainBackground;

	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Screen;
	import feathers.display.TiledImage;

	import flash.geom.Point;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class HivivaPatientVirusModelScreen extends Screen
	{

		private var _header:HivivaHeader;

		private var _virusSettingsBtn:Button;
		private var _panelGradient:Quad;
		private var _virusBgShadow:Quad;
		private var _virusSettingsControl:VirusSettingsControl;

		private var _virusHolder:Sprite;
		private var _panelBackground:MainBackground;
		private var _pseudoBackgroundPos:Number;
		private var _topGrad:TiledImage;
//		private var _virusBg:ImageLoader;
		private var _virusBg:TiledImage;
		private var _hivSimulation:VirusSimulation;
		private var _tcells:Array = [];
		private var _freeTcells:Array = [];
		private var _viruses:Array = [];
		private var _attachedViruses:Array = [];
		private var _looseViruses:Array = [];
		private var _adherence:Number = 0;
		private var _cd4Count:Number = 0;
		private var _viralLoad:Number = 0;
		private var _virusTexture:Texture;
		private var _remoteCallMade:Boolean = false;
		private var _remoteCallCount:int = 0;

		private var _trueTestResults:Object = {};

		public function HivivaPatientVirusModelScreen()
		{

		}

		override protected function draw():void
		{
			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			this._virusSettingsBtn.validate();
			this._virusSettingsBtn.x = Constants.STAGE_WIDTH/2 - this._virusSettingsBtn.width/2;
			this._virusSettingsBtn.y = Constants.HEADER_HEIGHT + (Constants.PADDING_TOP / 2);

			this._virusHolder.y = this._virusSettingsBtn.y + this._virusSettingsBtn.height + (Constants.PADDING_TOP / 2);
			this._panelBackground.y = this._virusHolder.y - Constants.STAGE_HEIGHT;
			this._pseudoBackgroundPos = this._panelBackground.y;

			this._panelGradient.y = this._panelBackground.height - this._panelGradient.height;
			this._virusBgShadow.y = this._panelBackground.height;

			if(!this._remoteCallMade) getPatientAdherenceTestResults();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._virusHolder = new Sprite();
			this.addChild(this._virusHolder);

			this._panelBackground = new MainBackground();
//			this._panelBackground.draw(Constants.STAGE_WIDTH,Constants.STAGE_HEIGHT,MainBackground.BG_BLUE_TYPE);
			this._panelBackground.draw();
			addChild(this._panelBackground);

			/*var headerBackground:MainBackground = new MainBackground();
			headerBackground.draw(Constants.STAGE_WIDTH,Constants.HEADER_HEIGHT,MainBackground.BG_BLUE_TYPE);
			addChild(headerBackground);*/

			var clipRatio:Number = Constants.HEADER_HEIGHT / Constants.STAGE_HEIGHT;
			var headerBg:Image = new Image(Main.assets.getTexture("main_bg"));
			headerBg.setTexCoords(0,new Point(0,0));
			headerBg.setTexCoords(1,new Point(1,0));
			headerBg.setTexCoords(2,new Point(0,clipRatio));
			headerBg.setTexCoords(3,new Point(1,clipRatio));
			addChild(headerBg);
			headerBg.height = Constants.HEADER_HEIGHT;

			/*this._topGrad = new TiledImage(Main.assets.getTexture("top_gradient"));
			this._topGrad.touchable = false;
			this._topGrad.width = Constants.STAGE_WIDTH;
			this._topGrad.smoothing = TextureSmoothing.NONE;
			this._topGrad.blendMode = BlendMode.MULTIPLY;
			//topGrad.flatten();
			addChild(this._topGrad);*/

			this._header = new HivivaHeader();
			this._header.title = "Virus Model";
			addChild(this._header);

			this._panelGradient = new Quad(Constants.STAGE_WIDTH, 60, 0x2f455f);
			this._panelGradient.setVertexAlpha(0, 0);
			this._panelGradient.setVertexAlpha(1, 0);
			this._panelGradient.setVertexAlpha(2, 0.3);
			this._panelGradient.setVertexAlpha(3, 0.3);
//			this._panelGradient.alpha = 0.4;
			this._panelGradient.blendMode = BlendMode.MULTIPLY;
			_panelBackground.addChild(this._panelGradient);

			this._virusBgShadow = new Quad(Constants.STAGE_WIDTH,60,0x2e445e);
			this._virusBgShadow.setVertexAlpha(0, 0.3);
			this._virusBgShadow.setVertexAlpha(1, 0.3);
			this._virusBgShadow.setVertexAlpha(2, 0);
			this._virusBgShadow.setVertexAlpha(3, 0);
			this._virusBgShadow.blendMode = BlendMode.MULTIPLY;
			_panelBackground.addChild(this._virusBgShadow);

			this._virusSettingsBtn = new Button();
//			this._virusSettingsBtn.defaultIcon = new Image(Main.assets.getTexture("vs_slider_icon"));
			this._virusSettingsBtn.name = HivivaThemeConstants.VIRUS_SETTINGS_BUTTON;
			this._virusSettingsBtn.addEventListener(Event.TRIGGERED , virusSettingsBtnHandler);
			this.addChild(this._virusSettingsBtn);

		}

		private function getPatientAdherenceTestResults():void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE , adherenceLoadCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE , adherenceLoadCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.getAdherence();

			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.addEventListener(RemoteDataStoreEvent.GET_PATIENT_LATEST_RESULTS_COMPLETE, getPatientLatestTestResultsCompleteHandler);
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.getPatientLastTestResult(escape("Cd4 count,Viral load"));

			this._remoteCallMade = true;
		}

		private function adherenceLoadCompleteHandler(e:LocalDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaLocalStoreController.removeEventListener(LocalDataStoreEvent.ADHERENCE_LOAD_COMPLETE , adherenceLoadCompleteHandler);
			trace("Virus Simulation " + e.data.adherence);

			this._remoteCallCount++;
			allDataLoadedCheck();

		}

		private function getPatientLatestTestResultsCompleteHandler(e:RemoteDataStoreEvent):void
		{
			HivivaStartup.hivivaAppController.hivivaRemoteStoreController.removeEventListener(RemoteDataStoreEvent.GET_PATIENT_LATEST_RESULTS_COMPLETE, getPatientLatestTestResultsCompleteHandler);

			var testResults:XMLList = e.data.xmlResponse.Results.DCTestResult;



			if(testResults.children().length() > 0)
			{
				this._viralLoad = Number(Math.floor(testResults[0].Result));
				this._cd4Count = Number(Math.floor(testResults[1].Result));
			}
			else
			{
				this._cd4Count = 0;
				this._viralLoad = 0;
			}




			this._remoteCallCount++;
			allDataLoadedCheck();
		}

		private function allDataLoadedCheck():void
		{
			if(this._remoteCallCount == 2)
			{
				this._adherence = HivivaStartup.patientAdherenceVO.percentage;

				this._trueTestResults.cd4Count = this._cd4Count;
				this._trueTestResults.viralLoad = this._viralLoad;
				this._trueTestResults.adherence = this._adherence;

				initVirusModel();
			}
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
			this._virusSettingsControl = new VirusSettingsControl(this._adherence , this._cd4Count , this._viralLoad , this._trueTestResults);
			this._virusSettingsControl.addEventListener("VirusControllClose" , virusSettingsCloseHandler);
			this._panelBackground.addChild(this._virusSettingsControl);

			this._virusSettingsControl.width = Constants.STAGE_WIDTH;
//			this._virusSettingsControl.height = Constants.STAGE_HEIGHT;
			this._virusSettingsControl.validate();
			this._virusSettingsControl.y = this._panelBackground.height - this._virusBgShadow.height - this._virusSettingsControl.height;

			showSettingsPanel(true);
		}

		private function virusSettingsCloseHandler(e:Event):void
		{
			if(this._adherence != e.data.adherence || this._cd4Count !=  e.data.cd4Count || this._viralLoad != e.data.viralLoad)
			{
				this._adherence = e.data.adherence;
				this._cd4Count =  e.data.cd4Count;
				this._viralLoad = e.data.viralLoad;
				this._virusHolder.removeChildren(1,-1,true);
				this._tcells.splice(0);
				_hivSimulation = null;
				this._virusTexture.dispose();
				initVirusSimulation();
			}
			showSettingsPanel(false);
		}

		private function showSettingsPanel(show:Boolean):void
		{
			const animationTime:Number = 0.3;
			const transition:String = show ? Transitions.EASE_OUT : Transitions.EASE_IN;
			var pseudoBgDest:Number = show ? this._virusSettingsControl.height - _panelBackground.height + this._virusBgShadow.height + Constants.HEADER_HEIGHT : this._pseudoBackgroundPos;
			var pseudoBgTween:Tween = new Tween(this._panelBackground , animationTime , transition);
			pseudoBgTween.animate("y" , pseudoBgDest);

			if(show)
			{
				this._virusSettingsBtn.visible = false;
			}
			pseudoBgTween.onComplete = function():void
			{
				Starling.juggler.remove(pseudoBgTween);
				if(!show)
				{
					_virusSettingsBtn.visible = true;
					_panelBackground.removeChild(_virusSettingsControl);
				}
			};
			Starling.juggler.add(pseudoBgTween);
		}

		private function initVirusModel():void
		{
			drawVirusModelBg();
		}

		private function drawVirusModelBg():void
		{
			/*this._virusBg = new ImageLoader();
			this._virusBg.addEventListener( Event.COMPLETE, virusBgLoadComplete );
			this._virusBg.source = "/assets/images/temp/vs_background.png";*/

			this._virusBg = new TiledImage(Main.assets.getTexture("v2_fixed_base"));
			this._virusBg.width = Constants.STAGE_WIDTH;
			this._virusBg.height = 615;
			this._virusBg.flatten();

			this._virusHolder.addChild(this._virusBg);
			initVirusSimulation();
		}

		private function virusBgLoadComplete(e:Event):void
		{
			initVirusSimulation()
		}

		private function initVirusSimulation():void
		{
//			this._virusTexture = Main.assets.getTexture("vs_virus");
			this._virusTexture = Main.assets.getTexture("v2_vs_virus");
			this._hivSimulation = new VirusSimulation();
			this._hivSimulation.updateSimulationData(this._adherence , this._cd4Count ,  this._viralLoad);

			placeTCells();
			placeViruses();
			placeMedications();
		}

		private function placeTCells():void
		{
//			var tCellTexture:Texture = Main.assets.getTexture("vs_cd4");
			var tCellTexture:Texture = Main.assets.getTexture("v2_vs_cd4");
			for (var tcellnum:int = 1; tcellnum <= this._hivSimulation.numTCells; tcellnum++)
			{

				var tCellView:TCellView = new TCellView(tCellTexture);
				tCellView.x = this._hivSimulation.usedtcellPos[tcellnum - 1][0] * 2;
				tCellView.y = this._hivSimulation.usedtcellPos[tcellnum - 1][1] * 3;
				trace("Tcell posiiton " + tCellView.x + "," + tCellView.y);
				this._virusHolder.addChild(tCellView);
				tCellView.init(this._hivSimulation , this);

				this._tcells.push(tCellView);
				this._freeTcells.push(tCellView);
			}
		}

		private function placeViruses():void
		{
			for (var virusnum:int = 1; virusnum <= this._hivSimulation.numViruses; virusnum++)
			{
				if (this._freeTcells.length != 0)
				{
					var tcellNumber:Number = Math.floor(Math.random() * this._freeTcells.length);
					var tcellView:TCellView = this._freeTcells[tcellNumber];
					var virusView:VirusView = tcellView.addVirus(virusnum, tcellNumber , this._virusTexture);
					this._viruses.push(virusView);
					this._attachedViruses.push(virusView);
				}
				else
				{
					addLooseVirus();
				}
			}
		}


		public function addLooseVirus():void
		{

			if (this._hivSimulation.openLooseVirusPos.length != 0)
			{
				var looseVirusesLength:Number = this._looseViruses.length;
				var virusView:VirusView = new VirusView(this._virusTexture);
				virusView.init(false);
				this._virusHolder.addChild(virusView);

				virusView.alpha = 0.4;
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

		private function placeMedications():void
		{
//			var medTexture:Texture = Main.assets.getTexture("vs_brand_ring");
			var medTexture:Texture = Main.assets.getTexture("v2_vs_brand_ring");
			for (var tcellnum:int = 0; tcellnum < this._tcells.length; tcellnum++)
			{
				var tCellView:TCellView = this._tcells[tcellnum];
				tCellView.addMedication(this._adherence , medTexture);
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
