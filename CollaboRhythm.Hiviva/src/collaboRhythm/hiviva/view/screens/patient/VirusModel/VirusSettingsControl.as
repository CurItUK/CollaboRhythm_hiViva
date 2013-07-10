package collaboRhythm.hiviva.view.screens.patient.VirusModel
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.screens.shared.MainBackground;

	import feathers.controls.Button;

	import feathers.controls.Label;
	import feathers.controls.Slider;

	import feathers.core.FeathersControl;

	import flash.geom.Rectangle;

	import starling.display.Image;

	import starling.events.Event;
	import starling.textures.Texture;

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
		private var _seperator1:Image;
		private var _seperator2:Image;
		private var _seperator3:Image;

		private var _screenBackground:MainBackground;

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
			var innerWidth:Number = Constants.STAGE_WIDTH - Constants.PADDING_LEFT - Constants.PADDING_RIGHT;
			var sliderWidth:Number = innerWidth * 0.6;
			var labelWidth:Number = innerWidth * 0.25;
			var resultLabelWidth:Number = innerWidth * 0.15;

			this._adheranceSlider.validate();
			this._adheranceSlider.width = sliderWidth;
			this._adheranceSlider.x = Constants.STAGE_WIDTH - Constants.PADDING_RIGHT - this._adheranceSlider.width;
			this._adheranceSlider.y = 0;

			this._adheranceLabel.validate();
			this._adheranceLabel.width = labelWidth;
			this._adheranceLabel.x = Constants.PADDING_LEFT;
			this._adheranceLabel.y = this._adheranceSlider.y + (this._adheranceSlider.height * 0.5) - (this._adheranceLabel.height * 0.5);

			this._adheranceResultLabel.validate();
			this._adheranceResultLabel.width = resultLabelWidth;
			this._adheranceResultLabel.x = this._adheranceLabel.x + this._adheranceLabel.width;
			this._adheranceResultLabel.y = this._adheranceSlider.y + (this._adheranceSlider.height * 0.5) - (this._adheranceResultLabel.height * 0.5);

			this._seperator1.width = Constants.STAGE_WIDTH;
			this._seperator1.y = this._adheranceSlider.y + this._adheranceSlider.height;



			this._viralLoadSlider.validate();
			this._viralLoadSlider.width = sliderWidth;
			this._viralLoadSlider.x = Constants.STAGE_WIDTH - Constants.PADDING_RIGHT - this._viralLoadSlider.width;
			this._viralLoadSlider.y = this._seperator1.y;

			this._viralLoadLabel.validate();
			this._viralLoadLabel.width = labelWidth;
			this._viralLoadLabel.x = Constants.PADDING_LEFT;
			this._viralLoadLabel.y = this._viralLoadSlider.y + (this._viralLoadSlider.height * 0.5) - (this._viralLoadLabel.height * 0.5);

			this._viralLoadResultLabel.validate();
			this._viralLoadResultLabel.width = resultLabelWidth;
			this._viralLoadResultLabel.x = this._viralLoadLabel.x + this._viralLoadLabel.width;
			this._viralLoadResultLabel.y = this._viralLoadSlider.y + (this._viralLoadSlider.height * 0.5) - (this._viralLoadResultLabel.height * 0.5);

			this._seperator2.width = Constants.STAGE_WIDTH;
			this._seperator2.y = this._viralLoadSlider.y + this._viralLoadSlider.height;



			this._CD4CountSlider.validate();
			this._CD4CountSlider.width = sliderWidth;
			this._CD4CountSlider.x = Constants.STAGE_WIDTH - Constants.PADDING_RIGHT - this._CD4CountSlider.width;
			this._CD4CountSlider.y = this._seperator2.y;

			this._CD4CountLabel.validate();
			this._CD4CountLabel.width = labelWidth;
			this._CD4CountLabel.x = Constants.PADDING_LEFT;
			this._CD4CountLabel.y = this._CD4CountSlider.y + (this._CD4CountSlider.height * 0.5) - (this._CD4CountLabel.height * 0.5);

			this._CD4CountResultLabel.validate();
			this._CD4CountResultLabel.width = resultLabelWidth;
			this._CD4CountResultLabel.x = this._CD4CountLabel.x + this._CD4CountLabel.width;
			this._CD4CountResultLabel.y = this._CD4CountSlider.y + (this._CD4CountSlider.height * 0.5) - (this._CD4CountResultLabel.height * 0.5);

			this._seperator3.width = Constants.STAGE_WIDTH;
			this._seperator3.y = this._CD4CountSlider.y + this._CD4CountSlider.height;


			this._resteBtn.width = this._minimiseBtn.width = Constants.STAGE_WIDTH * 0.35;

			this._minimiseBtn.validate();
			this._resteBtn.validate();

			this._resteBtn.x = Constants.STAGE_WIDTH / 2 - ((this._resteBtn.width + Constants.PADDING_LEFT + this._minimiseBtn.width) / 2);
			this._resteBtn.y = this._seperator3.y + (Constants.PADDING_TOP / 2);

			this._minimiseBtn.x = this._resteBtn.x + this._resteBtn.width + Constants.PADDING_LEFT;
			this._minimiseBtn.y = this._seperator3.y + (Constants.PADDING_TOP / 2);

			setSizeInternal(Constants.STAGE_WIDTH, this._minimiseBtn.y + this._minimiseBtn.height + (Constants.PADDING_TOP / 2), true);

//			drawBackground();

		}

		override protected function initialize():void
		{
			super.initialize();

			var lineTexture:Texture = Main.assets.getTexture("header_line");

			this._adheranceLabel = new Label();
			this._adheranceLabel.text = "Adherence:";
			this.addChild(this._adheranceLabel);

			this._adheranceResultLabel = new Label();
			this._adheranceResultLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
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

			_seperator1 = new Image(lineTexture);
			this.addChild(_seperator1);

			this._viralLoadLabel = new Label();
			this._viralLoadLabel.text = "Viral Load:";
			this.addChild(this._viralLoadLabel);

			this._viralLoadResultLabel = new Label();
			this._viralLoadResultLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
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

			_seperator2 = new Image(lineTexture);
			this.addChild(_seperator2);

			this._CD4CountLabel = new Label();
			this._CD4CountLabel.text = "CD4 count:";
			this.addChild(this._CD4CountLabel);

			this._CD4CountResultLabel = new Label();
			this._CD4CountResultLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
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

			_seperator3 = new Image(lineTexture);
			this.addChild(_seperator3);

			this._resteBtn = new Button();
			this._resteBtn.name = HivivaThemeConstants.BORDER_BUTTON;
			this._resteBtn.label = "RESET";
			this._resteBtn.defaultIcon = new Image(Main.assets.getTexture("vs_reset_icon"));
			this._resteBtn.iconPosition = Button.ICON_POSITION_LEFT;
			this._resteBtn.addEventListener(Event.TRIGGERED , resetBtnHandler);
			this.addChild(this._resteBtn);

			this._minimiseBtn = new Button();
			this._minimiseBtn.name = HivivaThemeConstants.BORDER_BUTTON;
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
			this._screenBackground.draw(Constants.STAGE_WIDTH, this.actualHeight, false);
			this.addChildAt(this._screenBackground, 0);
		}

		private function adheranceSliderChangeHandler(e:Event):void
		{
			this._adheranceResultLabel.text = this._adheranceSlider.value.toString();
		}

		private function viralLoadSliderChangeHandler(e:Event):void
		{
			this._viralLoadResultLabel.text = this._viralLoadSlider.value.toString();
		}

		private function CD4CountSliderChangeHandler(e:Event):void
		{
			this._CD4CountResultLabel.text = this._CD4CountSlider.value.toString();
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
			this._adheranceResultLabel.text = String(this._adherence);
			this._adheranceSlider.value = this._adherence;


			this._viralLoadResultLabel.text = String(this._viralLoad);
			this._viralLoadSlider.value = this._viralLoad;

			this._CD4CountResultLabel.text = String(this._cd4Count);
			this._CD4CountSlider.value = this._cd4Count
		}
	}
}
