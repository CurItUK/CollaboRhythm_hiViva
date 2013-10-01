package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.Main;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;

	public class ValidationScreen extends BaseScreen
	{
//		private var _validationBg:Image;
		private var _validationBg:Scale3Image;
		private var _validationLabel:Label;
		private var _closeValidationButton:Button;
		protected var _isValidationActive:Boolean = false;
		protected var _contentHeight:Number;
		protected var _overlayBtn:Button;

		public function ValidationScreen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();
			if(isNaN(this._contentHeight)) this._contentHeight = this._content.height;
		}

		override protected function preValidateContent():void
		{
			this._validationBg.y = this._header.y + this._header.height;
			this._validationBg.width = this._header.width;
			this._validationBg.height = 1;

			this._validationLabel.y = this._header.y + this._header.height + this._verticalPadding;
			this._validationLabel.width = this._header.width;

			this._closeValidationButton.validate();
			this._closeValidationButton.x = this._header.width - this._closeValidationButton.width - this._horizontalPadding;
		}

		override protected function postValidateContent():void
		{
			// kill layout to prevent restore while animating
			this._content.layout = null;
		}

		override protected function initialize():void
		{
			super.initialize();

//			this._validationBg = new Image(Main.assets.getTexture("validation_bg"));
			this._validationBg = new Scale3Image(new Scale3Textures(Main.assets.getTexture("v2_top_bar"),1,3));
			this._validationBg.visible = false;
			addChild(this._validationBg);

			this._validationLabel = new Label();
			this._validationLabel.name = HivivaThemeConstants.VALIDATION_LABEL;
			this._validationLabel.visible = false;
			addChild(this._validationLabel);

			this._closeValidationButton = new Button();
			this._closeValidationButton.name = HivivaThemeConstants.CLOSE_BUTTON;
			this._closeValidationButton.visible = false;
//			this._closeValidationButton.addEventListener(Event.TRIGGERED, hideFormValidation);
			addChild(this._closeValidationButton);
		}

		public function showFormValidation(valStr:String):void
		{
			this._overlayBtn = new Button();
			this._overlayBtn.addEventListener(Event.TRIGGERED, hideFormValidation);
			this._overlayBtn.alpha = 0;
			addChild(this._overlayBtn);
			this._overlayBtn.width = actualWidth;
			this._overlayBtn.height = actualHeight;

			this._validationLabel.text = valStr;
			this._validationLabel.validate();

			const TIME:Number = 0.4;
			const EASE:String = Transitions.EASE_OUT;

			var valBgTween:Tween = new Tween(this._validationBg, TIME, EASE);
			var contentTween:Tween = new Tween(this._content, TIME, EASE);

			var targetNumber:Number = this._validationLabel.height + (this._verticalPadding * 2);
			this._closeValidationButton.y = this._validationLabel.y + (this._validationLabel.height * 0.5) - (this._closeValidationButton.height * 0.5);

			valBgTween.animate("height", targetNumber);
			contentTween.animate("y", this._header.y + this._header.height + targetNumber);
			contentTween.animate("height", this._contentHeight - targetNumber);

			contentTween.onComplete = onShowFormValidationComplete;

			Starling.juggler.add(valBgTween);
			Starling.juggler.add(contentTween);

			this._validationBg.visible = true;
			this._isValidationActive = true;
//			this._headerLine.visible = false;
		}

		private function onShowFormValidationComplete():void
		{
			Starling.juggler.removeTweens(this._validationBg);
			Starling.juggler.removeTweens(this._content);

			this._closeValidationButton.visible = true;
			this._validationLabel.visible = true;
		}

		public function hideFormValidation(e:Event = null):void
		{
			if(this._isValidationActive)
			{
				if(this._overlayBtn != null)
				{
					this._overlayBtn.removeEventListener(Event.TRIGGERED, hideFormValidation);
					removeChild(this._overlayBtn);
					this._overlayBtn = null;
				}
				onShowFormValidationComplete();

				const TIME:Number = 0.2;
				const EASE:String = Transitions.EASE_IN;

				var valBgTween:Tween = new Tween(this._validationBg, TIME, EASE);
				var contentTween:Tween = new Tween(this._content, TIME, EASE);

				valBgTween.animate("height", 1);
				contentTween.animate("y", this._header.y + this._header.height);
				contentTween.animate("height", this._contentHeight);

				contentTween.onComplete = onHideFormValidationComplete;

				Starling.juggler.add(valBgTween);
				Starling.juggler.add(contentTween);

				this._closeValidationButton.visible = false;
				this._validationLabel.visible = false;
			}
		}

		private function onHideFormValidationComplete():void
		{
			Starling.juggler.removeTweens(this._validationBg);
			Starling.juggler.removeTweens(this._content);

			this._isValidationActive = false;
			this._validationBg.visible = false;
		}

		public override function dispose():void
		{
			super.dispose();
		}
	}
}
