package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.Slider;

	import starling.display.DisplayObject;
	import starling.display.Image;


	import starling.events.Event;


	public class HivivaPatientVirusModelScreen extends Screen
	{

		private var _header:HivivaHeader;
		private var _adheranceLabel:Label;
		private var _adheranceResultLabel:Label;
		private var _adheranceSlider:Slider;
		private var _viralLoadLabel:Label;
		private var _viralLoadResultLabel:Label;
		private var _viralLoadSlider:Slider;
		private var _CD4CountLabel:Label;
		private var _CD4CountResultLabel:Label;
		private var _CD4CountSlider:Slider;
		private var _resteBtn:Button;
		private var _helpBtn:Button;


		private var _dump:ImageLoader;

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

			this._adheranceLabel.validate();
			this._adheranceLabel.width = innerWidth * 0.25;
			this._adheranceLabel.x = this._scaledPadding * 2;
			this._adheranceLabel.y = this._header.height + this._scaledPadding + this._adheranceSlider.height * 0.25;

			this._adheranceResultLabel.validate();
			this._adheranceResultLabel.width = innerWidth * 0.15;
			this._adheranceResultLabel.x = this._adheranceLabel.x + this._adheranceLabel.width;
			this._adheranceResultLabel.y = this._adheranceLabel.y;

			this._adheranceSlider.validate();
			this._adheranceSlider.width = innerWidth * 0.6;
			this._adheranceSlider.x = this._adheranceResultLabel.x + this._adheranceResultLabel.width;
			this._adheranceSlider.y = this._adheranceResultLabel.y + (this._adheranceResultLabel.height * 0.5) - (this._adheranceSlider.height * 0.5);


			this._viralLoadLabel.validate();
			this._viralLoadLabel.width = innerWidth * 0.25;
			this._viralLoadLabel.x = this._scaledPadding * 2;
			this._viralLoadLabel.y = this._adheranceSlider.y + this._adheranceSlider.height + this._scaledPadding;

			this._viralLoadResultLabel.validate();
			this._viralLoadResultLabel.width = innerWidth * 0.15;
			this._viralLoadResultLabel.x = this._viralLoadLabel.x + this._viralLoadLabel.width;
			this._viralLoadResultLabel.y = this._viralLoadLabel.y;

			this._viralLoadSlider.validate();
			this._viralLoadSlider.width = innerWidth * 0.6;
			this._viralLoadSlider.x = this._viralLoadResultLabel.x + this._viralLoadResultLabel.width;
			this._viralLoadSlider.y = this._viralLoadResultLabel.y + (this._viralLoadResultLabel.height * 0.5) - (this._viralLoadSlider.height * 0.5);


			this._CD4CountLabel.validate();
			this._CD4CountLabel.width = innerWidth * 0.25;
			this._CD4CountLabel.x = this._scaledPadding * 2;
			this._CD4CountLabel.y = this._viralLoadSlider.y + this._viralLoadSlider.height + this._scaledPadding;

			this._CD4CountResultLabel.validate();
			this._CD4CountResultLabel.width = innerWidth * 0.15;
			this._CD4CountResultLabel.x = this._CD4CountLabel.x + this._CD4CountLabel.width;
			this._CD4CountResultLabel.y = this._CD4CountLabel.y;

			this._CD4CountSlider.validate();
			this._CD4CountSlider.width = innerWidth * 0.6;
			this._CD4CountSlider.x = this._CD4CountResultLabel.x + this._CD4CountResultLabel.width;
			this._CD4CountSlider.y = this._CD4CountResultLabel.y + (this._CD4CountResultLabel.height * 0.5) - (this._CD4CountSlider.height * 0.5);


			//this._resteBtn.validate();
			//this._resteBtn.width = this.actualWidth / 3;
			//this._resteBtn.x = this.actualWidth / 2 - this._resteBtn.width / 2;
			//this._resteBtn.y = this._CD4CountSlider.y + this._CD4CountSlider.height;

			this._dump.y = this._CD4CountSlider.y + this._CD4CountSlider.height + this._scaledPadding;
			this._dump.maxHeight = this.actualHeight - Constants.FOOTER_BTNGROUP_HEIGHT - this._dump.y;

			getPatientData();
		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Virus Model";
			addChild(this._header);

			//TODO Skin Button based on photoshop deisgn
			//this._helpBtn = new Button();
			//this._helpBtn.label = "Help";
			//this._helpBtn.addEventListener(Event.TRIGGERED, helpBtnHandler);

			//this._header.rightItems = new <DisplayObject>[_helpBtn];


			this._adheranceLabel = new Label();
			this._adheranceLabel.text = "Adherence:";
			this.addChild(this._adheranceLabel);

			this._adheranceResultLabel = new Label();
			this._adheranceResultLabel.name = "centered-label";
			this._adheranceResultLabel.text = "95";//TODO dynamic population //forced for MKT Access
			this.addChild(this._adheranceResultLabel);

			this._adheranceSlider = new Slider();
			this._adheranceSlider.name = "feeling-slider";
			this._adheranceSlider.customThumbName = "feeling-slider";
			this._adheranceSlider.minimum = 0;
			this._adheranceSlider.maximum = 100;
			this._adheranceSlider.value = 95; //TODO dynamic population //forced for MKT Access
			this._adheranceSlider.step = 1;
			this._adheranceSlider.page = 10;
			this._adheranceSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._adheranceSlider.liveDragging = true;
			this._adheranceSlider.addEventListener(Event.CHANGE, adheranceSliderChangeHandler );
			this.addChild(this._adheranceSlider);

			this._viralLoadLabel = new Label();
			this._viralLoadLabel.text = "Viral Load:";
			this.addChild(this._viralLoadLabel);

			this._viralLoadResultLabel = new Label();
			this._viralLoadResultLabel.name = "centered-label";
			this._viralLoadResultLabel.text = "50000";
			this.addChild(this._viralLoadResultLabel);

			this._viralLoadSlider = new Slider();
			this._viralLoadSlider.name = "feeling-slider";
			this._viralLoadSlider.customThumbName = "feeling-slider";
			this._viralLoadSlider.minimum = 0;
			this._viralLoadSlider.maximum = 100000;
			this._viralLoadSlider.value = 50000;
			this._viralLoadSlider.step = 1;
			this._viralLoadSlider.page = 10;
			this._viralLoadSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._viralLoadSlider.liveDragging = true;
			this._viralLoadSlider.addEventListener(Event.CHANGE, viralLoadSliderChangeHandler );
			this.addChild(this._viralLoadSlider);

			this._CD4CountLabel = new Label();
			this._CD4CountLabel.text = "CD4 count:";
			this.addChild(this._CD4CountLabel);

			this._CD4CountResultLabel = new Label();
			this._CD4CountResultLabel.name = "centered-label";
			this._CD4CountResultLabel.text = "350";
			this.addChild(this._CD4CountResultLabel);

			this._CD4CountSlider = new Slider();
			this._CD4CountSlider.name = "feeling-slider";
			this._CD4CountSlider.customThumbName = "feeling-slider";
			this._CD4CountSlider.minimum = 0;
			this._CD4CountSlider.maximum = 1000;
			this._CD4CountSlider.value = 350;
			this._CD4CountSlider.step = 1;
			this._CD4CountSlider.page = 10;
			this._CD4CountSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._CD4CountSlider.liveDragging = true;
			this._CD4CountSlider.addEventListener(Event.CHANGE, CD4CountSliderChangeHandler );
			this.addChild(this._CD4CountSlider);

			this._dump = new ImageLoader();
			this._dump.textureScale	= this.dpiScale;
			this._dump.source = "media/virus_model_dummy.png";
			this.addChild(this._dump);

			//this._resteBtn = new Button();
			//this._resteBtn.label = "RESET";
			//this.addChild(this._resteBtn);
		}

		private function helpBtnHandler(e:Event):void
		{

		}

		private function adheranceSliderChangeHandler(e:Event):void
		{
			this._adheranceResultLabel.text = "<font face='ExoBold'>" + this._adheranceSlider.value + "</font>";
		}

		private function viralLoadSliderChangeHandler(e:Event):void
		{
			this._viralLoadResultLabel.text = "<font face='ExoBold'>" + this._viralLoadSlider.value + "</font>";
		}

		private function CD4CountSliderChangeHandler(e:Event):void
		{
			this._CD4CountResultLabel.text = "<font face='ExoBold'>" + this._CD4CountSlider.value + "</font>";
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

		}

		public override function dispose():void
		{
			trace("HivivaPatientVirusModelScreen dispose");
			super.dispose();
		}





	}
}
