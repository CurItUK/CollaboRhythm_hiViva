package collaboRhythm.hiviva.view.screens.shared
{
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.view.HivivaHeader;

	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.VerticalLayout;

	import flash.system.System;

	import starling.display.DisplayObject;

	import starling.display.Image;

	public class BaseScreen extends Screen
	{
		private var _applicationController:HivivaApplicationController;
		protected var _header:HivivaHeader;
		protected var _content:ScrollContainer;
		protected var _contentLayout:VerticalLayout;
		protected var _horizontalPadding:Number;
		protected var _verticalPadding:Number;
		protected var _componentGap:Number;
		protected var _innerWidth:Number;
		protected var _customHeight:Number = 0;
		protected var _contentHeight:Number;

		public function BaseScreen()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._horizontalPadding = (this.actualWidth * 0.04) * this.dpiScale;
			this._verticalPadding = (this.actualHeight * 0.02) * this.dpiScale;
			this._componentGap = (this.actualHeight * 0.04) * this.dpiScale;

			this._header.width = this.actualWidth;
			this._header.initTrueTitle();

			this._contentHeight = this._customHeight > 0 ? this._customHeight : this.actualHeight;
			this._contentHeight -= (this._header.y + this._header.height);

			this._content.y = this._header.y + this._header.height;
			this._content.width = this.actualWidth - this._horizontalPadding;
			this._content.height = this._contentHeight - this._verticalPadding;

			this._contentLayout.paddingLeft = this._contentLayout.paddingRight = this._horizontalPadding;
			this._contentLayout.paddingTop = this._contentLayout.paddingBottom = this._verticalPadding;
			this._contentLayout.gap = this._componentGap;

			this._innerWidth = this._content.width - this._horizontalPadding;

			//setChildrenHeights();
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

			this._content = new ScrollContainer();
			this._content.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
//			this._content.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			addChild(this._content);

			this._contentLayout = new VerticalLayout();
			this._content.layout = this._contentLayout;
		}

		protected function killContentScroll():void
		{
			this._content.verticalScrollPosition = 0;
			this._content.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
		}

		override public function dispose():void
		{
			super.dispose();
			System.gc();
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
