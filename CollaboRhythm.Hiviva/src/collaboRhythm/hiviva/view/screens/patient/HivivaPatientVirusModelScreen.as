package collaboRhythm.hiviva.view.screens.patient
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.global.LocalDataStoreEvent;
	import collaboRhythm.hiviva.view.*;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.Slider;

	import starling.display.DisplayObject;


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
		private var _footerHeight:Number;
		private var _headerHeight:Number;
		private var _applicationController:HivivaApplicationController;

		public function HivivaPatientVirusModelScreen()
		{

		}

		override protected function draw():void
		{
			super.draw();
			this._header.width = this.actualWidth;
			this._header.height = 110 * this.dpiScale;



			this._adheranceLabel.validate();
			this._adheranceLabel.width = 200;
			this._adheranceLabel.x = 10;
			this._adheranceLabel.y = this._header.height + 10;

			this._adheranceResultLabel.validate();
			this._adheranceResultLabel.width = 100;
			this._adheranceResultLabel.x = this.actualWidth / 3;
			this._adheranceResultLabel.y = this._adheranceLabel.y;

			this._adheranceSlider.validate();
			this._adheranceSlider.width = this.actualWidth / 2;
			this._adheranceSlider.x = this.actualWidth / 2;
			this._adheranceSlider.y = this._adheranceLabel.y;

			this._viralLoadLabel.validate();
			this._viralLoadLabel.width = 200;
			this._viralLoadLabel.x = 10;
			this._viralLoadLabel.y = this._adheranceSlider.y + this._adheranceSlider.height;

			this._viralLoadResultLabel.validate();
			this._viralLoadResultLabel.width = 100;
			this._viralLoadResultLabel.x = this.actualWidth / 3;
			this._viralLoadResultLabel.y = this._viralLoadLabel.y;

			this._viralLoadSlider.validate();
			this._viralLoadSlider.width = this.actualWidth / 2;
			this._viralLoadSlider.x = this.actualWidth / 2;
			this._viralLoadSlider.y = this._viralLoadResultLabel.y;

			this._CD4CountLabel.validate();
			this._CD4CountLabel.width = 200;
			this._CD4CountLabel.x = 10;
			this._CD4CountLabel.y = this._viralLoadSlider.y + this._viralLoadSlider.height;

			this._CD4CountResultLabel.validate();
			this._CD4CountResultLabel.width = 100;
			this._CD4CountResultLabel.x = this.actualWidth / 3;
			this._CD4CountResultLabel.y = this._CD4CountLabel.y;

			this._CD4CountSlider.validate();
			this._CD4CountSlider.width = this.actualWidth / 2;
			this._CD4CountSlider.x = this.actualWidth / 2;
			this._CD4CountSlider.y = this._CD4CountLabel.y;

			this._resteBtn.validate();
			this._resteBtn.width = this.actualWidth / 3;
			this._resteBtn.x = this.actualWidth / 2 - this._resteBtn.width / 2;
			this._resteBtn.y = this._CD4CountSlider.y + this._CD4CountSlider.height + 20;

			getMedicationResults();

		}

		override protected function initialize():void
		{
			super.initialize();
			this._header = new HivivaHeader();
			this._header.title = "Virus Model";
			addChild(this._header);

			//TODO Skin Button based on photoshop deisgn
			this._helpBtn = new Button();
			this._helpBtn.label = "Help";
			this._helpBtn.addEventListener(Event.TRIGGERED, helpBtnHandler);

			this._header.rightItems = new <DisplayObject>[_helpBtn];


			this._adheranceLabel = new Label();
			this._adheranceLabel.text = "Adherance:";
			this.addChild(this._adheranceLabel);

			this._adheranceResultLabel = new Label();
			this._adheranceResultLabel.text = "";
			this.addChild(this._adheranceResultLabel);

			this._adheranceSlider = new Slider();
			this._adheranceSlider.name = "feeling-slider";
			this._adheranceSlider.customThumbName = "feeling-slider";
			this._adheranceSlider.minimum = 0;
			this._adheranceSlider.maximum = 100;
			this._adheranceSlider.value = 50;
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
			this._viralLoadResultLabel.text = "";
			this.addChild(this._viralLoadResultLabel);

			this._viralLoadSlider = new Slider();
			this._viralLoadSlider.name = "feeling-slider";
			this._viralLoadSlider.customThumbName = "feeling-slider";
			this._viralLoadSlider.minimum = 0;
			this._viralLoadSlider.maximum = 100;
			this._viralLoadSlider.value = 50;
			this._viralLoadSlider.step = 1;
			this._viralLoadSlider.page = 10;
			this._viralLoadSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._viralLoadSlider.liveDragging = true;
			this._viralLoadSlider.addEventListener(Event.CHANGE, viralLoadSliderChangeHandler );
			this.addChild(this._viralLoadSlider);

			this._CD4CountLabel = new Label();
			this._CD4CountLabel.text = "CD4 count";
			this.addChild(this._CD4CountLabel);

			this._CD4CountResultLabel = new Label();
			this._CD4CountResultLabel.text = "";
			this.addChild(this._CD4CountResultLabel);

			this._CD4CountSlider = new Slider();
			this._CD4CountSlider.name = "feeling-slider";
			this._CD4CountSlider.customThumbName = "feeling-slider";
			this._CD4CountSlider.minimum = 0;
			this._CD4CountSlider.maximum = 100;
			this._CD4CountSlider.value = 50;
			this._CD4CountSlider.step = 1;
			this._CD4CountSlider.page = 10;
			this._CD4CountSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._CD4CountSlider.liveDragging = true;
			this._CD4CountSlider.addEventListener(Event.CHANGE, CD4CountSliderChangeHandler );
			this.addChild(this._CD4CountSlider);

			this._resteBtn = new Button();
			this._resteBtn.label = "RESET";
			this.addChild(this._resteBtn);

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

		private function getMedicationResults():void
		{
			//applicationController.hivivaLocalStoreController.addEventListener(LocalDataStoreEvent.)
			//applicationController.hivivaLocalStoreController.getAdherence();
		}

		public function get applicationController():HivivaApplicationController
		{
			return _applicationController;
		}

		public function set applicationController(value:HivivaApplicationController):void
		{
			_applicationController = value;
		}

		public function get footerHeight():Number
		{
			return _footerHeight;
		}

		public function set footerHeight(value:Number):void
		{
			_footerHeight = value;
		}

		public function get headerHeight():Number
		{
			return _headerHeight;
		}

		public function set headerHeight(value:Number):void
		{
			_headerHeight = value;
		}
	}
}
