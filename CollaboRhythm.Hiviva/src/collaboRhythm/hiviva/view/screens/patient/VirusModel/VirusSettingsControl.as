package collaboRhythm.hiviva.view.screens.patient.VirusModel
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.screens.shared.MainBackground;

	import feathers.controls.Button;

	import feathers.controls.Label;
	import feathers.controls.Slider;

	import feathers.core.FeathersControl;

	import starling.display.Image;

	import starling.events.Event;

	public class VirusSettingsControl extends FeathersControl
	{

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
		private var _minimiseBtn:Button;

		private var stageWidth:int;
		private var stageHeight:int;
		private var _screenBackground:MainBackground;

		private var _scaledPadding:Number;

		private var _adherence:Number;
		private var _cd4Count:Number;
		private var _viralLoad:Number;

		public function VirusSettingsControl(adherence:Number , cd4Count:Number , viralLoad:Number)
		{
			this._adherence = adherence;
			this._cd4Count = cd4Count;
			this._viralLoad = viralLoad;
		}

		override protected function draw():void
		{

			this._scaledPadding = this.actualWidth * 0.02;
			var innerWidth:Number = this.actualWidth - (this._scaledPadding * 2);


			this._adheranceLabel.validate();
			this._adheranceLabel.width = innerWidth * 0.25;
			this._adheranceLabel.x = this._scaledPadding * 2;
			this._adheranceLabel.y = 30;


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


			this._resteBtn.validate();
			this._resteBtn.x = this.actualWidth / 2 - this._resteBtn.width - 30;
			this._resteBtn.y = this._CD4CountSlider.y + this._CD4CountSlider.height;

			this._minimiseBtn.validate();
			this._minimiseBtn.x = this.actualWidth / 2 + 30;
			this._minimiseBtn.y = this._CD4CountSlider.y + this._CD4CountSlider.height;


			drawBackground();

		}

		override protected function initialize():void
		{

			trace("initialize from virus control");
			this._adheranceLabel = new Label();
			this._adheranceLabel.text = "Adherence:";
			this.addChild(this._adheranceLabel);

			this._adheranceResultLabel = new Label();
			this._adheranceResultLabel.name = "centered-label";
			this._adheranceResultLabel.text = "0";

			this.addChild(this._adheranceResultLabel);

			this._adheranceSlider = new Slider();
			this._adheranceSlider.name = "feeling-slider";
			this._adheranceSlider.customThumbName = "feeling-slider";
			this._adheranceSlider.minimum = 0;
			this._adheranceSlider.maximum = 100;

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
			this._viralLoadResultLabel.text = "0";

			this.addChild(this._viralLoadResultLabel);

			this._viralLoadSlider = new Slider();
			this._viralLoadSlider.name = "feeling-slider";
			this._viralLoadSlider.customThumbName = "feeling-slider";
			this._viralLoadSlider.minimum = 0;
			this._viralLoadSlider.maximum = 100000;

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
			this._CD4CountResultLabel.text = "0";

			this.addChild(this._CD4CountResultLabel);

			this._CD4CountSlider = new Slider();
			this._CD4CountSlider.name = "feeling-slider";
			this._CD4CountSlider.customThumbName = "feeling-slider";
			this._CD4CountSlider.minimum = 0;
			this._CD4CountSlider.maximum = 1000;

			this._CD4CountSlider.step = 1;
			this._CD4CountSlider.page = 10;
			this._CD4CountSlider.direction = Slider.DIRECTION_HORIZONTAL;
			this._CD4CountSlider.liveDragging = true;
			this._CD4CountSlider.addEventListener(Event.CHANGE, CD4CountSliderChangeHandler );
			this.addChild(this._CD4CountSlider);

			this._resteBtn = new Button();
			this._resteBtn.label = "RESET";
			this._resteBtn.defaultIcon = new Image(Main.assets.getTexture("vs_reset_icon"));
			this._resteBtn.iconPosition = Button.ICON_POSITION_LEFT;
			this._resteBtn.addEventListener(Event.TRIGGERED , resetBtnHandler);
			this.addChild(this._resteBtn);

			this._minimiseBtn = new Button();
			this._minimiseBtn.label = "MINIMISE";
			this._minimiseBtn.defaultIcon = new Image(Main.assets.getTexture("vs_minimize_icon"));
			this._minimiseBtn.iconPosition = Button.ICON_POSITION_LEFT;
			this._minimiseBtn.addEventListener(Event.TRIGGERED , minimiseBtnHandler);
			this.addChild(this._minimiseBtn);

			setDefaultSliderValues();


		}

		private function drawBackground():void
		{
			this._screenBackground = new MainBackground();
			this._screenBackground.draw(this.actualWidth , 380);
			this.addChildAt(this._screenBackground , 0);
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

		private function resetBtnHandler(e:Event):void
		{
			setDefaultSliderValues();
		}

		private function minimiseBtnHandler():void
		{
			this.dispatchEventWith("VirusControllClose" , false , {adherence:this._adheranceSlider.value , cd4Count:this._CD4CountSlider.value , viralLoad:this._viralLoadSlider.value})
		}

		private function setDefaultSliderValues():void
		{
			this._adheranceResultLabel.text = "<font face='ExoBold'>" + String(this._adherence) + "</font>";
			this._adheranceSlider.value = this._adherence;


			this._viralLoadResultLabel.text = "<font face='ExoBold'>" + String(this._viralLoad) + "</font>";
			this._viralLoadSlider.value = this._viralLoad;

			this._CD4CountResultLabel.text = "<font face='ExoBold'>" + String(this._cd4Count) + "</font>";;
			this._CD4CountSlider.value = this._cd4Count
		}
	}
}
