package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.view.HivivaHeader;

	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.VerticalLayout;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;

	public class ValidationScreen extends Screen
	{
		private var _applicationController:HivivaApplicationController;
		protected var _header:HivivaHeader;
		private var _headerLine:Image;
		private var _validationBg:Image;
		private var _validationLabel:Label;
		private var _closeValidationButton:Button;
		protected var _content:ScrollContainer;
		private var _contentLayout:VerticalLayout;
		protected var _horizontalPadding:Number;
		protected var _verticalPadding:Number;
		protected var _componentGap:Number;
		protected var _innerWidth:Number;
		protected var _customHeight:Number = 0;
		protected var _contentHeight:Number;
		protected var _isValidationActive:Boolean = false;

		public function ValidationScreen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._horizontalPadding = this.actualWidth * 0.04;
			this._verticalPadding = this.actualHeight * 0.02;
			this._componentGap = this.actualHeight * 0.04;

			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			this._headerLine.width = this._header.width;
			this._headerLine.y = this._header.y + this._header.height - 1;

			this._validationBg.y = this._header.y + this._header.height;
			this._validationBg.width = this._header.width;
			this._validationBg.height = 1;

			this._validationLabel.y = this._header.y + this._header.height + this._verticalPadding;
			this._validationLabel.width = this._header.width;

			this._closeValidationButton.validate();
			this._closeValidationButton.x = this._header.width - this._closeValidationButton.width - this._horizontalPadding;

			this._contentHeight = this._customHeight > 0 ? this._customHeight : this.actualHeight;
			this._contentHeight -= (this._header.y + this._header.height);

			this._content.y = this._header.y + this._header.height;
			this._content.width = this.actualWidth - this._horizontalPadding;
			this._content.height = this._contentHeight - this._verticalPadding;

			this._contentLayout.paddingLeft = this._contentLayout.paddingRight = this._horizontalPadding;
			this._contentLayout.paddingTop = this._contentLayout.paddingBottom = this._verticalPadding;
			this._contentLayout.gap = this._componentGap;

			this._innerWidth = this._content.width - this._horizontalPadding;

			preValidateContent();
			this._content.validate();
			postValidateContent();

			this._content.layout = null;
		}

		protected function preValidateContent():void
		{
			// to be overridden by sub classes
		}

		protected function postValidateContent():void
		{
			// to be overridden by sub classes
		}

		override protected function initialize():void
		{
			super.initialize();

			this._header = new HivivaHeader();
			this._header.scale = this.dpiScale;
			addChild(this._header);

			this._headerLine = new Image(HivivaAssets.HEADER_LINE);
			addChild(this._headerLine);

			//var validationBg:Scale9Textures = new Scale9Textures(HivivaAssets.VALIDATION_BG, new Rectangle(20,20,10,10));
			this._validationBg = new Image(HivivaAssets.VALIDATION_BG);
			this._validationBg.visible = false;
			addChild(this._validationBg);

			this._validationLabel = new Label();
			this._validationLabel.name = "validation-label";
			this._validationLabel.visible = false;
			addChild(this._validationLabel);

			this._closeValidationButton = new Button();
			this._closeValidationButton.name = "close-button";
			this._closeValidationButton.visible = false;
			this._closeValidationButton.addEventListener(Event.TRIGGERED, hideFormValidation);
			addChild(this._closeValidationButton);

			this._content = new ScrollContainer();
			this._content.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
//			this._content.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			addChild(this._content);

			this._contentLayout = new VerticalLayout();
			this._content.layout = this._contentLayout;
		}

		public function showFormValidation(valStr:String):void
		{
			this._validationLabel.text = valStr;
			this._validationLabel.validate();

			//if(!this._isValidationActive)
			{
				const TIME:Number = 0.4;
				const EASE:String = Transitions.EASE_OUT;

				var valBgTween:Tween = new Tween(this._validationBg, TIME, EASE);
				var contentTween:Tween = new Tween(this._content, TIME, EASE);

				this._headerLine.visible = false;
				this._validationLabel.visible = true;
				this._validationBg.visible = true;

				var targetNumber:Number = this._validationLabel.height + (this._verticalPadding * 2);
				this._closeValidationButton.y = this._validationLabel.y + (this._validationLabel.height * 0.5) - (this._closeValidationButton.height * 0.5);

				valBgTween.animate("height", targetNumber);
				contentTween.animate("y", this._header.y + this._header.height + targetNumber);
				contentTween.animate("height", this._contentHeight - targetNumber);

				contentTween.onComplete = onShowFormValidationComplete;

				Starling.juggler.add(valBgTween);
				Starling.juggler.add(contentTween);

				this._isValidationActive = true;
			}
		}

		private function onShowFormValidationComplete():void
		{
			Starling.juggler.removeTweens(this._validationBg);
			Starling.juggler.removeTweens(this._validationLabel);
			Starling.juggler.removeTweens(this._content);
			this._closeValidationButton.visible = true;
		}

		public function hideFormValidation(e:Event = null):void
		{
			if(this._isValidationActive)
			{
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
			}
		}

		private function onHideFormValidationComplete():void
		{
			Starling.juggler.removeTweens(this._validationBg);
			Starling.juggler.removeTweens(this._validationLabel);
			Starling.juggler.removeTweens(this._content);

			this._headerLine.visible = true;
			this._validationLabel.visible = false;
			this._validationBg.visible = false;
			this._isValidationActive = false;
		}

		public function get localStoreController():HivivaLocalStoreController
		{
			return applicationController.hivivaLocalStoreController;
		}

		public function get applicationController():HivivaApplicationController
		{
			return _applicationController;
		}

		public function set applicationController(value:HivivaApplicationController):void
		{
			_applicationController = value;
		}
	}
}
