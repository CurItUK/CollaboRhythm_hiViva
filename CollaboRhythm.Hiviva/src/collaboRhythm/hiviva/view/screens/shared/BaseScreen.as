package collaboRhythm.hiviva.view.screens.shared
{

	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.view.HivivaHeader;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;

	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.VerticalLayout;

	import flash.system.System;

	import starling.display.DisplayObject;

	import starling.display.Image;

	public class BaseScreen extends Screen
	{
		protected var _header:HivivaHeader;
		protected var _content:ScrollContainer;
		protected var _contentLayout:VerticalLayout;
		protected var _horizontalPadding:Number;
		protected var _verticalPadding:Number;
		protected var _componentGap:Number;
		protected var _innerWidth:Number;
		protected var _customHeight:Number = 0;

		public function BaseScreen()
		{
			super();
		}
        [Inline]
		override protected function draw():void
		{
			super.draw();

			this._horizontalPadding = Constants.PADDING_LEFT;
			this._verticalPadding = Constants.PADDING_TOP;
			this._componentGap = Constants.PADDING_TOP;

			this._header.width = Constants.STAGE_WIDTH;
			this._header.height = Constants.HEADER_HEIGHT;
			this._header.initTrueTitle();

			var contentHeight:Number = this._customHeight > 0 ? this._customHeight : (Constants.STAGE_HEIGHT - Constants.PADDING_BOTTOM - this._verticalPadding);
			contentHeight -= Constants.HEADER_HEIGHT;

			this._content.y = Constants.HEADER_HEIGHT;
			this._content.width = Constants.STAGE_WIDTH;
			this._content.height = contentHeight;

			this._innerWidth = Constants.INNER_WIDTH;

			this._contentLayout.paddingLeft = this._contentLayout.paddingRight = this._horizontalPadding;
			this._contentLayout.paddingTop = this._contentLayout.paddingBottom = this._verticalPadding;
			this._contentLayout.gap = this._componentGap;

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
//			this._header.scale = this.dpiScale;
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
			return HivivaStartup.hivivaAppController.hivivaLocalStoreController;
		}


	}
}
