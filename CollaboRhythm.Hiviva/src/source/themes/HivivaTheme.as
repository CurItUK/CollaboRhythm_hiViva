/*

 Copyright (c) 2012 Josh Tynjala



 Permission is hereby granted, free of charge, to any person

 obtaining a copy of this software and associated documentation

 files (the "Software"), to deal in the Software without

 restriction, including without limitation the rights to use,

 copy, modify, merge, publish, distribute, sublicense, and/or sell

 copies of the Software, and to permit persons to whom the

 Software is furnished to do so, subject to the following

 conditions:



 The above copyright notice and this permission notice shall be

 included in all copies or substantial portions of the Software.



 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,

 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES

 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND

 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT

 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,

 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING

 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR

 OTHER DEALINGS IN THE SOFTWARE.

 */

package source.themes

{

	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;

	import feathers.controls.ButtonGroup;

	import feathers.controls.Callout;

	import feathers.controls.Check;

	import feathers.controls.GroupedList;

	import feathers.controls.Header;

	import feathers.controls.ImageLoader;

	import feathers.controls.Label;

	import feathers.controls.List;

	import feathers.controls.PageIndicator;

	import feathers.controls.PickerList;

	import feathers.controls.ProgressBar;

	import feathers.controls.Radio;

	import feathers.controls.Screen;

	import feathers.controls.ScrollText;

	import feathers.controls.Scroller;

	import feathers.controls.SimpleScrollBar;

	import feathers.controls.Slider;

	import feathers.controls.TabBar;

	import feathers.controls.TextInput;

	import feathers.controls.ToggleSwitch;

	import feathers.controls.popups.CalloutPopUpContentManager;

	import feathers.controls.popups.VerticalCenteredPopUpContentManager;

	import feathers.controls.renderers.BaseDefaultItemRenderer;

	import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;

	import feathers.controls.renderers.DefaultGroupedListItemRenderer;

	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.BitmapFontTextRenderer;

	import feathers.controls.text.StageTextTextEditor;

	import feathers.controls.text.TextFieldTextRenderer;

	import feathers.core.DisplayListWatcher;

	import feathers.core.FeathersControl;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;

	import feathers.core.PopUpManager;

	import feathers.display.Scale3Image;

	import feathers.display.Scale9Image;

	import feathers.display.TiledImage;

	import feathers.layout.VerticalLayout;

	import feathers.skins.ImageStateValueSelector;

	import feathers.skins.Scale9ImageStateValueSelector;

	import feathers.skins.StandardIcons;

	import feathers.system.DeviceCapabilities;
	import feathers.text.BitmapFontTextFormat;

	import feathers.textures.Scale3Textures;

	import feathers.textures.Scale9Textures;


	import flash.display.BitmapData;

	import flash.geom.Rectangle;
	import flash.text.Font;

	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;


	import starling.core.Starling;

	import starling.display.DisplayObject;

	import starling.display.DisplayObjectContainer;

	import starling.display.Image;

	import starling.display.Quad;

	import starling.events.Event;

	import starling.events.ResizeEvent;
	import starling.filters.BlurFilter;
	import starling.text.BitmapFont;
	import starling.text.BitmapFont;
	import starling.text.TextField;

	import starling.textures.Texture;

	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import starling.utils.Color;


	public class HivivaTheme extends DisplayListWatcher

	{

		[Embed(source="/../assets/images/metalworks.png")]

		protected static const ATLAS_IMAGE:Class;


		[Embed(source="/../assets/images/metalworks.xml", mimeType="application/octet-stream")]

		protected static const ATLAS_XML:Class;


		protected static const LIGHT_TEXT_COLOR:uint = 0xe5e5e5;

		protected static const DARK_TEXT_COLOR:uint = 0x1a1a1a;

		protected static const SELECTED_TEXT_COLOR:uint = 0xff9900;

		protected static const DISABLED_TEXT_COLOR:uint = 0x333333;


		protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;

		protected static const ORIGINAL_DPI_IPAD_RETINA:int = 264;


		protected static const DEFAULT_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 22, 22);

		protected static const BUTTON_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 50, 50);

		protected static const ITEM_RENDERER_SCALE9_GRID:Rectangle = new Rectangle(13, 0, 3, 82);

		protected static const INSET_ITEM_RENDERER_MIDDLE_SCALE9_GRID:Rectangle = new Rectangle(13, 0, 2, 82);

		protected static const INSET_ITEM_RENDERER_FIRST_SCALE9_GRID:Rectangle = new Rectangle(13, 13, 3, 70);

		protected static const INSET_ITEM_RENDERER_LAST_SCALE9_GRID:Rectangle = new Rectangle(13, 0, 3, 75);

		protected static const INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID:Rectangle = new Rectangle(13, 13, 3, 62);

		protected static const TAB_SCALE9_GRID:Rectangle = new Rectangle(19, 19, 50, 50);

		protected static const SCROLL_BAR_THUMB_REGION1:int = 5;

		protected static const SCROLL_BAR_THUMB_REGION2:int = 14;


		public static const COMPONENT_NAME_PICKER_LIST_ITEM_RENDERER:String = "feathers-mobile-picker-list-item-renderer";

		public static const NONE_THEMED:String = "non-themed";


//		protected static function textRendererFactory():TextFieldTextRenderer
		protected static function textRendererFactory():BitmapFontTextRenderer
		{

//			return new TextFieldTextRenderer();
			return new BitmapFontTextRenderer();

		}


		protected static function textEditorFactory():StageTextTextEditor
		{

			return new StageTextTextEditor();

		}


		protected static function popUpOverlayFactory():DisplayObject
		{

			const quad:Quad = new Quad(100, 100, 0x1a1a1a);

			quad.alpha = 0.85;

			return quad;

		}


		public function HivivaTheme(root:DisplayObjectContainer, scaleToDPI:Boolean = true)
		{

			super(root);

			this._scaleToDPI = scaleToDPI;

			this.initialize();

		}


		protected var _originalDPI:int;


		public function get originalDPI():int
		{

			return this._originalDPI;

		}


		protected var _scaleToDPI:Boolean;


		public function get scaleToDPI():Boolean
		{

			return this._scaleToDPI;

		}


		public var scale:Number = 1;


		protected var primaryBackground:TiledImage;

		// bitmap fonts
		protected var normalWhiteRegularBitmapFont:BitmapFont;
		protected var normalWhiteBoldBitmapFont:BitmapFont;
		protected var engravedDarkBoldBitmapFont:BitmapFont;
		protected var engravedMediumBoldBitmapFont:BitmapFont;
		protected var engravedLightBoldBitmapFont:BitmapFont;
		protected var engravedLighterRegularBitmapFont:BitmapFont;
		protected var engravedLighterBoldBitmapFont:BitmapFont;
		protected var engravedLightestBoldBitmapFont:BitmapFont;
		protected var raisedLighterBoldBitmapFont:BitmapFont;

		// bitmap font text formats

		protected var headerBoldBftf:BitmapFontTextFormat;
		protected var subHeaderBftf:BitmapFontTextFormat;
		protected var bodyBftf:BitmapFontTextFormat;
		protected var bodySmallerBftf:BitmapFontTextFormat;
		protected var bodySmallerBoldBftf:BitmapFontTextFormat;
		protected var bodyBoldBftf:BitmapFontTextFormat;
		protected var bodyCenteredBftf:BitmapFontTextFormat;
		protected var bodyBoldCenteredBftf:BitmapFontTextFormat;
		protected var inputLabelLeftBftf:BitmapFontTextFormat;
		protected var homeLensLabelBftf:BitmapFontTextFormat;
		protected var validationLabelBftf:BitmapFontTextFormat;
		protected var medicineBrandnameLabelBftf:BitmapFontTextFormat;
		protected var splashFooterLabelBftf:BitmapFontTextFormat;
		protected var calendarMonthLabelBftf:BitmapFontTextFormat;
		protected var feelingSliderLabelBftf:BitmapFontTextFormat;
		protected var appIdLabelBftf:BitmapFontTextFormat;
		protected var instructionsLabelBftf:BitmapFontTextFormat;
		protected var calendarDaysLabelBftf:BitmapFontTextFormat;
		protected var superscriptLabelBftf:BitmapFontTextFormat;
		protected var patientDataLighterLabelBftf:BitmapFontTextFormat;

		protected var defaultButtonLabelBftf:BitmapFontTextFormat;
		protected var sideNavGroupLabelBftf:BitmapFontTextFormat;
		protected var profileGroupLabelBftf:BitmapFontTextFormat;
		protected var galleryButtonLabelBftf:BitmapFontTextFormat;
		protected var backButtonLabelBftf:BitmapFontTextFormat;

		protected var atlas:TextureAtlas;

		protected var atlasBitmapData:BitmapData;

		protected var primaryBackgroundTexture:Texture;

		protected var backgroundSkinTextures:Scale9Textures;

		protected var backgroundDisabledSkinTextures:Scale9Textures;

		protected var backgroundFocusedSkinTextures:Scale9Textures;

		protected var buttonUpSkinTextures:Scale9Textures;
		protected var borderlessButtonUpSkinTextures:Scale9Textures;
		protected var buttonDownSkinTextures:Scale9Textures;
		protected var buttonDisabledSkinTextures:Scale9Textures;
		protected var buttonSelectedUpSkinTextures:Scale9Textures;
		protected var buttonSelectedDisabledSkinTextures:Scale9Textures;

		protected var buttonFooterTexture:Texture;
		protected var buttonFooterActiveTexture:Texture;

		protected var buttonSideNavTexture:Texture;

		protected var buttonPatientProfileNavTexture:Scale9Textures;

		protected var buttonHomeSkinTexture:Texture;

		protected var buttonBackSkinTexture:Texture;

		protected var buttonCloseSkinTexture:Texture;

		protected var buttonDeleteCellSkinTexture:Texture;

		protected var buttonEditCellSkinTexture:Texture;

		protected var buttonCalendarSkinTexture:Texture;

		protected var buttonCalendarDayCellSkinTexture:Texture;

		protected var buttonCalendarArrowsTexture:Texture;

		protected var toggleSwitchTexture:Texture;

		protected var toggleTrackTexture:Scale9Textures;

		protected var inputFieldSkinTexture:Scale9Textures;

		protected var feelingSliderTrackSkinTextures:Scale9Textures;
		protected var feelingSliderSwitchSkinTextures:Texture;

		protected var pickerListButtonIconTexture:Texture;

		protected var tabDownSkinTextures:Scale9Textures;

		protected var tabSelectedSkinTextures:Scale9Textures;

		protected var pickerListItemSelectedIconTexture:Texture;

		protected var radioUpIconTexture:Texture;

		protected var radioDownIconTexture:Texture;

		protected var radioDisabledIconTexture:Texture;

		protected var radioSelectedUpIconTexture:Texture;

		protected var radioSelectedDownIconTexture:Texture;

		protected var radioSelectedDisabledIconTexture:Texture;

		protected var checkUpIconTexture:Texture;

		protected var checkDownIconTexture:Texture;

		protected var checkDisabledIconTexture:Texture;

		protected var checkSelectedUpIconTexture:Texture;

		protected var checkSelectedDownIconTexture:Texture;

		protected var checkSelectedDisabledIconTexture:Texture;

		protected var pageIndicatorNormalSkinTexture:Texture;

		protected var pageIndicatorSelectedSkinTexture:Texture;

		protected var itemRendererUpSkinTextures:Scale9Textures;
		protected var hivivaItemRendererUpSkinTextures:Scale9Textures;

		protected var itemRendererSelectedSkinTextures:Scale9Textures;

		protected var insetItemRendererMiddleUpSkinTextures:Scale9Textures;

		protected var insetItemRendererMiddleSelectedSkinTextures:Scale9Textures;

		protected var insetItemRendererFirstUpSkinTextures:Scale9Textures;

		protected var insetItemRendererFirstSelectedSkinTextures:Scale9Textures;

		protected var insetItemRendererLastUpSkinTextures:Scale9Textures;

		protected var insetItemRendererLastSelectedSkinTextures:Scale9Textures;

		protected var insetItemRendererSingleUpSkinTextures:Scale9Textures;

		protected var insetItemRendererSingleSelectedSkinTextures:Scale9Textures;

		protected var calloutTopArrowSkinTexture:Texture;

		protected var calloutRightArrowSkinTexture:Texture;

		protected var calloutBottomArrowSkinTexture:Texture;

		protected var calloutLeftArrowSkinTexture:Texture;

		protected var verticalScrollBarThumbSkinTextures:Scale3Textures;

		protected var horizontalScrollBarThumbSkinTextures:Scale3Textures;

		protected var seperatorLineTexture:Scale9Textures;


		override public function dispose():void
		{

			if (this.root)
			{

				this.root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);

				if (this.primaryBackground)
				{

					this.root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

					this.root.removeEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);

					this.root.removeChild(this.primaryBackground, true);

					this.primaryBackground = null;

				}

			}

			if (this.atlas)
			{

				this.atlas.dispose();

				this.atlas = null;

			}

			if (this.atlasBitmapData)
			{

				this.atlasBitmapData.dispose();

				this.atlasBitmapData = null;

			}

			super.dispose();

		}


		protected function initializeRoot():void
		{

			this.primaryBackground = new TiledImage(this.primaryBackgroundTexture);

			this.primaryBackground.width = root.stage.stageWidth;

			this.primaryBackground.height = root.stage.stageHeight;

			this.root.addChildAt(this.primaryBackground, 0);

			this.root.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

			this.root.addEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);

		}


		protected function initialize():void
		{

			const scaledDPI:int = DeviceCapabilities.dpi / Starling.contentScaleFactor;

			this._originalDPI = scaledDPI;

			if (this._scaleToDPI)
			{

				if (DeviceCapabilities.isTablet(Starling.current.nativeStage))
				{

					this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;

				}
				else
				{

					this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;

				}

			}


			this.scale = scaledDPI / this._originalDPI;


			FeathersControl.defaultTextRendererFactory = textRendererFactory;

			FeathersControl.defaultTextEditorFactory = textEditorFactory;


			// Bitmap Fonts
			this.normalWhiteRegularBitmapFont = TextField.getBitmapFont("normal-white-regular");
			this.normalWhiteBoldBitmapFont = TextField.getBitmapFont("normal-white-bold");
			this.engravedDarkBoldBitmapFont = TextField.getBitmapFont("engraved-dark-bold");
			this.engravedMediumBoldBitmapFont = TextField.getBitmapFont("engraved-medium-bold");
			this.engravedLightBoldBitmapFont = TextField.getBitmapFont("engraved-light-bold");
			this.engravedLighterRegularBitmapFont = TextField.getBitmapFont("engraved-lighter-regular");
			this.engravedLighterBoldBitmapFont = TextField.getBitmapFont("engraved-lighter-bold");
			this.engravedLightestBoldBitmapFont = TextField.getBitmapFont("engraved-lightest-bold");
			this.raisedLighterBoldBitmapFont = TextField.getBitmapFont("raised-lighter-bold");

			// Bitmap Font TextFormats
			this.headerBoldBftf = new BitmapFontTextFormat(this.engravedDarkBoldBitmapFont,44 * this.scale,Color.WHITE);
			this.subHeaderBftf = new BitmapFontTextFormat(this.engravedMediumBoldBitmapFont,30 * this.scale,Color.WHITE);
			this.bodyBftf = new BitmapFontTextFormat(this.normalWhiteRegularBitmapFont, 24 * this.scale, HivivaThemeConstants.MEDIUM_FONT_COLOUR);
			this.bodySmallerBftf = new BitmapFontTextFormat(this.normalWhiteRegularBitmapFont, 18 * this.scale, HivivaThemeConstants.MEDIUM_FONT_COLOUR);
			this.bodySmallerBoldBftf = new BitmapFontTextFormat(this.engravedMediumBoldBitmapFont, 18 * this.scale, Color.WHITE);
			this.bodyBoldBftf = new BitmapFontTextFormat(this.engravedMediumBoldBitmapFont, 24 * this.scale, Color.WHITE);
			this.bodyCenteredBftf = new BitmapFontTextFormat(this.normalWhiteRegularBitmapFont, 24 * this.scale, HivivaThemeConstants.MEDIUM_FONT_COLOUR,TextFormatAlign.CENTER);
			this.bodyBoldCenteredBftf = new BitmapFontTextFormat(this.engravedMediumBoldBitmapFont, 24 * this.scale, Color.WHITE,TextFormatAlign.CENTER);
			this.inputLabelLeftBftf = new BitmapFontTextFormat(this.engravedMediumBoldBitmapFont,30 * this.scale,Color.WHITE);
			this.homeLensLabelBftf = new BitmapFontTextFormat(this.normalWhiteRegularBitmapFont, 30 * this.scale, HivivaThemeConstants.MEDIUM_FONT_COLOUR,TextFormatAlign.CENTER);
			this.validationLabelBftf = new BitmapFontTextFormat(this.engravedLighterRegularBitmapFont, 24 * this.scale, Color.WHITE,TextFormatAlign.CENTER);
			this.medicineBrandnameLabelBftf = new BitmapFontTextFormat(this.engravedMediumBoldBitmapFont, 30 * this.scale, Color.WHITE);
			this.splashFooterLabelBftf = new BitmapFontTextFormat(this.raisedLighterBoldBitmapFont, 24 * this.scale, Color.WHITE,TextFormatAlign.CENTER);
			this.calendarMonthLabelBftf = new BitmapFontTextFormat(this.normalWhiteRegularBitmapFont, 40 * this.scale, HivivaThemeConstants.LIGHTEST_FONT_COLOUR,TextFormatAlign.CENTER);
			this.feelingSliderLabelBftf = new BitmapFontTextFormat(this.engravedMediumBoldBitmapFont, 20 * this.scale, Color.WHITE,TextFormatAlign.CENTER);
			this.appIdLabelBftf = new BitmapFontTextFormat(this.normalWhiteRegularBitmapFont, 30 * this.scale, HivivaThemeConstants.LIGHT_FONT_COLOUR,TextFormatAlign.CENTER);
			this.instructionsLabelBftf = new BitmapFontTextFormat(this.normalWhiteRegularBitmapFont, 20 * this.scale, HivivaThemeConstants.LIGHT_FONT_COLOUR);
			this.calendarDaysLabelBftf = new BitmapFontTextFormat(this.normalWhiteRegularBitmapFont, 30 * this.scale, Color.WHITE,TextFormatAlign.CENTER);
			this.superscriptLabelBftf = new BitmapFontTextFormat(this.normalWhiteRegularBitmapFont, 14 * this.scale, Color.WHITE,TextFormatAlign.CENTER);
			this.patientDataLighterLabelBftf = new BitmapFontTextFormat(this.engravedLighterBoldBitmapFont, 24 * this.scale, Color.WHITE,TextFormatAlign.CENTER);
			// buttons label formats
			this.defaultButtonLabelBftf = new BitmapFontTextFormat(this.engravedLighterBoldBitmapFont, 24 * this.scale, Color.WHITE);
			this.sideNavGroupLabelBftf = new BitmapFontTextFormat(this.normalWhiteBoldBitmapFont, 18 * this.scale, HivivaThemeConstants.LIGHTEST_FONT_COLOUR);
			this.profileGroupLabelBftf = new BitmapFontTextFormat(this.normalWhiteRegularBitmapFont, 30 * this.scale, HivivaThemeConstants.MEDIUM_FONT_COLOUR);
			this.galleryButtonLabelBftf = new BitmapFontTextFormat(this.engravedLighterBoldBitmapFont, 24 * this.scale, Color.WHITE);
			this.backButtonLabelBftf = new BitmapFontTextFormat(this.engravedLightestBoldBitmapFont, 24 * this.scale, Color.WHITE);


			PopUpManager.overlayFactory = popUpOverlayFactory;

			Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =

					Callout.stagePaddingLeft = 16 * this.scale;


			const atlasBitmapData:BitmapData = (new ATLAS_IMAGE()).bitmapData;

			this.atlas = new TextureAtlas(Texture.fromBitmapData(atlasBitmapData, false), XML(new ATLAS_XML()));

			if (Starling.handleLostContext)
			{

				this.atlasBitmapData = atlasBitmapData;

			}

			else
			{

				atlasBitmapData.dispose();

			}


			//this.primaryBackgroundTexture = this.atlas.getTexture("primary-background");
			this.primaryBackgroundTexture = Main.assets.getTexture("fixed_base");


			const backgroundSkinTexture:Texture = this.atlas.getTexture("background-skin");

			const backgroundDownSkinTexture:Texture = this.atlas.getTexture("background-down-skin");

			const backgroundDisabledSkinTexture:Texture = this.atlas.getTexture("background-disabled-skin");

			const backgroundFocusedSkinTexture:Texture = this.atlas.getTexture("background-focused-skin");


			this.backgroundSkinTextures = new Scale9Textures(backgroundSkinTexture, DEFAULT_SCALE9_GRID);

			this.backgroundDisabledSkinTextures = new Scale9Textures(backgroundDisabledSkinTexture,	DEFAULT_SCALE9_GRID);

			this.backgroundFocusedSkinTextures = new Scale9Textures(backgroundFocusedSkinTexture, DEFAULT_SCALE9_GRID);


			this.buttonUpSkinTextures = new Scale9Textures(Main.assets.getTexture("button"), new Rectangle(22,22,158,30));
			this.borderlessButtonUpSkinTextures = new Scale9Textures(Main.assets.getTexture("button_borderless"), new Rectangle(25,25,242,31));
			this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("button-down-skin"), BUTTON_SCALE9_GRID);
			this.buttonDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-disabled-skin"), BUTTON_SCALE9_GRID);
			this.buttonSelectedUpSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-up-skin"), BUTTON_SCALE9_GRID);
			this.buttonSelectedDisabledSkinTextures = new Scale9Textures(this.atlas.getTexture("button-selected-disabled-skin"), BUTTON_SCALE9_GRID);



			this.buttonFooterTexture = Main.assets.getTexture("footer_icon_base");
			this.buttonFooterActiveTexture = Main.assets.getTexture("footer_icon_active");

			this.buttonSideNavTexture = Main.assets.getTexture("side_nav_base");

			this.buttonPatientProfileNavTexture = new Scale9Textures(Main.assets.getTexture("patient-profile-nav-button"), new Rectangle(0,0,72,72));

			this.buttonHomeSkinTexture = Main.assets.getTexture("footer_icon_1");

			this.buttonBackSkinTexture = Main.assets.getTexture("back-button");

			this.buttonCloseSkinTexture = Main.assets.getTexture("close_button");

			this.buttonDeleteCellSkinTexture = Main.assets.getTexture("delete_icon");

			this.buttonEditCellSkinTexture = Main.assets.getTexture("edit_icon");

			this.buttonCalendarSkinTexture = Main.assets.getTexture("calendar-button");

			this.buttonCalendarDayCellSkinTexture = Main.assets.getTexture("calendar_day_cell");

			this.buttonCalendarArrowsTexture = Assets.getTexture('ArrowPng');

			this.toggleSwitchTexture = Main.assets.getTexture("toggle_switch");

			this.toggleTrackTexture = new Scale9Textures(Main.assets.getTexture("toggle_track"), new Rectangle(27,27,55,3));

			this.inputFieldSkinTexture = new Scale9Textures(Main.assets.getTexture("input_field"), new Rectangle(11,11,32,32));

			this.feelingSliderTrackSkinTextures = new Scale9Textures(Main.assets.getTexture("feeling_slider_track"), new Rectangle(50,46,386,2));
			this.feelingSliderSwitchSkinTextures = Main.assets.getTexture("feeling_slider_switch");


			this.tabDownSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-down-skin"), TAB_SCALE9_GRID);

			this.tabSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("tab-selected-skin"),TAB_SCALE9_GRID);


			this.pickerListButtonIconTexture = this.atlas.getTexture("picker-list-icon");

			this.pickerListItemSelectedIconTexture = this.atlas.getTexture("picker-list-item-selected-icon");


			this.radioDisabledIconTexture = backgroundDisabledSkinTexture;

			this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon");

			this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon");

			this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon");

			this.seperatorLineTexture = new Scale9Textures(Main.assets.getTexture("header_line"), new Rectangle(0,2,10,3));

			this.radioUpIconTexture = Assets.getTexture("RadioBtnPng");
			this.radioDownIconTexture = Assets.getTexture("RadioCheckedBtnPng");

			this.checkUpIconTexture = Main.assets.getTexture("tick_box");
			this.checkDownIconTexture = Main.assets.getTexture("tick_box_active");

//			this.checkDisabledIconTexture = backgroundDisabledSkinTexture;
//			this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon");
//			this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon");
//			this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon");


			this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-skin");

			this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-skin");


			this.itemRendererUpSkinTextures = new Scale9Textures(this.atlas.getTexture("list-item-up-skin"),
					ITEM_RENDERER_SCALE9_GRID);

			this.hivivaItemRendererUpSkinTextures = new Scale9Textures(Main.assets.getTexture("screen_base"), new Rectangle(0,0,200,200));

			this.itemRendererSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("list-item-selected-skin"),
					ITEM_RENDERER_SCALE9_GRID);

			this.insetItemRendererMiddleUpSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-middle-up-skin"),
					INSET_ITEM_RENDERER_MIDDLE_SCALE9_GRID);

			this.insetItemRendererMiddleSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-middle-selected-skin"),
					INSET_ITEM_RENDERER_MIDDLE_SCALE9_GRID);

			this.insetItemRendererFirstUpSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-first-up-skin"),
					INSET_ITEM_RENDERER_FIRST_SCALE9_GRID);

			this.insetItemRendererFirstSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-first-selected-skin"),
					INSET_ITEM_RENDERER_FIRST_SCALE9_GRID);

			this.insetItemRendererLastUpSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-last-up-skin"),
					INSET_ITEM_RENDERER_LAST_SCALE9_GRID);

			this.insetItemRendererLastSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-last-selected-skin"),
					INSET_ITEM_RENDERER_LAST_SCALE9_GRID);

			this.insetItemRendererSingleUpSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-single-up-skin"),
					INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID);

			this.insetItemRendererSingleSelectedSkinTextures = new Scale9Textures(this.atlas.getTexture("list-inset-item-single-selected-skin"),
					INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID);


			this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-arrow-top-skin");

			this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-arrow-right-skin");

			this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-arrow-bottom-skin");

			this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-arrow-left-skin");


			this.horizontalScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("horizontal-scroll-bar-thumb-skin"),
					SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_HORIZONTAL);

			this.verticalScrollBarThumbSkinTextures = new Scale3Textures(this.atlas.getTexture("vertical-scroll-bar-thumb-skin"),
					SCROLL_BAR_THUMB_REGION1, SCROLL_BAR_THUMB_REGION2, Scale3Textures.DIRECTION_VERTICAL);


			StandardIcons.listDrillDownAccessoryTexture = this.atlas.getTexture("list-accessory-drill-down-icon");


			if (this.root.stage)
			{

				this.initializeRoot();

			}

			else
			{

				this.root.addEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);

			}

			this.setInitializerForClass(Button, nothingInitializer, NONE_THEMED);

			this.setInitializerForClassAndSubclasses(Screen, screenInitializer);

			this.setInitializerForClass(Label, labelInitializer);
			this.setInitializerForClass(Label, subHeaderLabelInitializer, HivivaThemeConstants.SUBHEADER_LABEL);
			this.setInitializerForClass(Label, bodyBoldLabelInitializer, HivivaThemeConstants.BODY_BOLD_LABEL);
			this.setInitializerForClass(Label, bodyCenteredLabelInitializer, HivivaThemeConstants.BODY_CENTERED_LABEL);
			this.setInitializerForClass(Label, bodyBoldCenteredLabelInitializer, HivivaThemeConstants.BODY_BOLD_CENTERED_LABEL);
			this.setInitializerForClass(Label, inputLabelLeftInitializer, HivivaThemeConstants.INPUT_LABEL_LEFT);
			this.setInitializerForClass(Label, inputLabelRightInitializer, HivivaThemeConstants.INPUT_LABEL_RIGHT);
			this.setInitializerForClass(Label, homeLensLabelInitializer, HivivaThemeConstants.HOME_LENS_LABEL);
			this.setInitializerForClass(Label, validationLabelInitializer, HivivaThemeConstants.VALIDATION_LABEL);
			this.setInitializerForClass(Label, medicineBrandnameLabelInitializer, HivivaThemeConstants.MEDICINE_BRANDNAME_LABEL);
			this.setInitializerForClass(Label, splashFooterLabelInitializer, HivivaThemeConstants.SPLASH_FOOTER_LABEL);
			this.setInitializerForClass(Label, calenderMonthLabelInitializer, HivivaThemeConstants.CALENDAR_MONTH_LABEL);
			this.setInitializerForClass(Label, feelingSliderLabelInitializer, HivivaThemeConstants.FEELING_SLIDER_LABEL);
			this.setInitializerForClass(Label, appIdLabelInitializer, HivivaThemeConstants.APPID_LABEL);
			this.setInitializerForClass(Label, instructionsLabelInitializer, HivivaThemeConstants.INSTRUCTIONS_LABEL);
			this.setInitializerForClass(Label, calendarDaysLabelInitializer, HivivaThemeConstants.CALENDAR_DAYS_LABEL);
			this.setInitializerForClass(Label, superscriptLabelInitializer, HivivaThemeConstants.SUPERSCRIPT_LABEL);
			this.setInitializerForClass(Label, cellSmallLabelInitializer, HivivaThemeConstants.CELL_SMALL_LABEL);
			this.setInitializerForClass(Label, cellSmallBoldLabelInitializer, HivivaThemeConstants.CELL_SMALL_BOLD_LABEL);
			this.setInitializerForClass(Label, patientDataLightLabelInitializer, HivivaThemeConstants.PATIENT_DATA_LIGHTER_LABEL);

			this.setInitializerForClass(TextFieldTextRenderer, itemRendererAccessoryLabelInitializer,
					BaseDefaultItemRenderer.DEFAULT_CHILD_NAME_ACCESSORY_LABEL);

			this.setInitializerForClass(ScrollText, scrollTextInitializer);

			this.setInitializerForClass(Button, nothingInitializer, NONE_THEMED);
			this.setInitializerForClass(Button, buttonInitializer);
			this.setInitializerForClass(Button, borderButtonInitializer, HivivaThemeConstants.BORDER_BUTTON);
			this.setInitializerForClass(Button, homeButtonInitializer, HivivaThemeConstants.HOME_BUTTON);

			this.setInitializerForClass(Button, backButtonInitializer, "back-button");
			this.setInitializerForClass(Button, closeButtonInitializer, "close-button");
			this.setInitializerForClass(Button, deleteCellButtonInitializer, "delete-cell-button");
			this.setInitializerForClass(Button, editCellButtonInitializer, "edit-cell-button");
			this.setInitializerForClass(Button, calendarButtonInitializer, "calendar-button");
			this.setInitializerForClass(Button, calendarDayCellButtonInitializer, "calendar-day-cell");
			this.setInitializerForClass(Button, calendarArrowsButtonInitializer, "calendar-arrows");

			this.setInitializerForClass(Button, buttonGroupButtonInitializer, ButtonGroup.DEFAULT_CHILD_NAME_BUTTON);
			this.setInitializerForClass(Button, homeFooterGroupInitializer, "home-footer-buttons");
			this.setInitializerForClass(Button, sideNavGroupInitializer, "side-nav-buttons");
			this.setInitializerForClass(Button, patientProfileNavGroupInitializer, "patient-profile-nav-buttons");
//			this.setInitializerForClass(Button, galleryThumbInitializer, "gallery-thumb-buttons");

			//this.setInitializerForClass(Button, simpleButtonInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, toggleSwitchSwitchInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_THUMB);

			this.setInitializerForClass(Button, simpleButtonInitializer, Slider.DEFAULT_CHILD_NAME_THUMB);
			this.setInitializerForClass(Button, feelingSwitchInitializer, "feeling-slider");

			this.setInitializerForClass(Button, pickerListButtonInitializer, PickerList.DEFAULT_CHILD_NAME_BUTTON);

			this.setInitializerForClass(Button, tabInitializer, TabBar.DEFAULT_CHILD_NAME_TAB);

			this.setInitializerForClass(Button, nothingInitializer, Slider.DEFAULT_CHILD_NAME_MINIMUM_TRACK);

			this.setInitializerForClass(Button, nothingInitializer, Slider.DEFAULT_CHILD_NAME_MAXIMUM_TRACK);

			this.setInitializerForClass(Button, toggleSwitchTrackInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_ON_TRACK);

			this.setInitializerForClass(Button, nothingInitializer, SimpleScrollBar.DEFAULT_CHILD_NAME_THUMB);

			//this.setInitializerForClass(ButtonGroup, buttonGroupInitializer);

			this.setInitializerForClass(DefaultListItemRenderer, itemRendererInitializer);

			this.setInitializerForClass(DefaultListItemRenderer, pickerListItemRendererInitializer,
					COMPONENT_NAME_PICKER_LIST_ITEM_RENDERER);

			this.setInitializerForClass(DefaultGroupedListItemRenderer, itemRendererInitializer);

			this.setInitializerForClass(DefaultGroupedListItemRenderer, insetMiddleItemRendererInitializer,
					GroupedList.ALTERNATE_CHILD_NAME_INSET_ITEM_RENDERER);

			this.setInitializerForClass(DefaultGroupedListItemRenderer, insetFirstItemRendererInitializer,
					GroupedList.ALTERNATE_CHILD_NAME_INSET_FIRST_ITEM_RENDERER);

			this.setInitializerForClass(DefaultGroupedListItemRenderer, insetLastItemRendererInitializer,
					GroupedList.ALTERNATE_CHILD_NAME_INSET_LAST_ITEM_RENDERER);

			this.setInitializerForClass(DefaultGroupedListItemRenderer, insetSingleItemRendererInitializer,
					GroupedList.ALTERNATE_CHILD_NAME_INSET_SINGLE_ITEM_RENDERER);

			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, headerRendererInitializer);

			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, footerRendererInitializer,
					GroupedList.DEFAULT_CHILD_NAME_FOOTER_RENDERER);

			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, insetHeaderRendererInitializer,
					GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER);

			this.setInitializerForClass(DefaultGroupedListHeaderOrFooterRenderer, insetFooterRendererInitializer,
					GroupedList.ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER);

			this.setInitializerForClass(Radio, radioInitializer);

			this.setInitializerForClass(Check, checkInitializer);

			this.setInitializerForClass(Slider, sliderInitializer);
			this.setInitializerForClass(Slider, feelingSliderInitializer, "feeling-slider");

			this.setInitializerForClass(ToggleSwitch, toggleSwitchInitializer);

			this.setInitializerForClass(TextInput, textInputInitializer);

			this.setInitializerForClass(PageIndicator, pageIndicatorInitializer);

			this.setInitializerForClass(ProgressBar, progressBarInitializer);

			this.setInitializerForClass(PickerList, pickerListInitializer);

			this.setInitializerForClass(Header, headerInitializer);

			this.setInitializerForClass(Callout, calloutInitializer);

			this.setInitializerForClass(Scroller, scrollerInitializer);

//			this.setInitializerForClass(List, nothingInitializer, PickerList.DEFAULT_CHILD_NAME_LIST);

			this.setInitializerForClass(GroupedList, insetGroupedListInitializer,
					GroupedList.ALTERNATE_NAME_INSET_GROUPED_LIST);
		}


		protected function pageIndicatorNormalSymbolFactory():DisplayObject
		{

			const symbol:ImageLoader = new ImageLoader();

			symbol.source = this.pageIndicatorNormalSkinTexture;

			symbol.textureScale = this.scale;

			return symbol;

		}


		protected function pageIndicatorSelectedSymbolFactory():DisplayObject
		{

			const symbol:ImageLoader = new ImageLoader();

			symbol.source = this.pageIndicatorSelectedSkinTexture;

			symbol.textureScale = this.scale;

			return symbol;

		}


		protected function imageLoaderFactory():ImageLoader
		{

			const image:ImageLoader = new ImageLoader();

			image.textureScale = this.scale;

			return image;

		}


		protected function horizontalScrollBarFactory():SimpleScrollBar
		{

			const scrollBar:SimpleScrollBar = new SimpleScrollBar();

			scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;

			const defaultSkin:Scale3Image = new Scale3Image(this.horizontalScrollBarThumbSkinTextures, this.scale);

			defaultSkin.width = 10 * this.scale;

			scrollBar.thumbProperties.defaultSkin = defaultSkin;

			scrollBar.paddingRight = scrollBar.paddingBottom = scrollBar.paddingLeft = 4 * this.scale;

			return scrollBar;

		}


		protected function verticalScrollBarFactory():SimpleScrollBar
		{

			const scrollBar:SimpleScrollBar = new SimpleScrollBar();

			scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;

			const defaultSkin:Scale3Image = new Scale3Image(this.verticalScrollBarThumbSkinTextures, this.scale);

			defaultSkin.height = 10 * this.scale;

			scrollBar.thumbProperties.defaultSkin = defaultSkin;

			scrollBar.paddingTop = scrollBar.paddingRight = scrollBar.paddingBottom = 4 * this.scale;

			return scrollBar;

		}


		protected function nothingInitializer(target:DisplayObject):void
		{
		}


		protected function screenInitializer(screen:Screen):void
		{

			screen.originalDPI = this._originalDPI;

		}


		protected function simpleButtonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
			{
				width: 60 * this.scale,
				height: 60 * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = button.minHeight = 60 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}

		protected function feelingSwitchInitializer(button:Button):void
		{
			var skinHeight:Number = this.feelingSliderSwitchSkinTextures.height;
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.feelingSliderSwitchSkinTextures;
			skinSelector.imageProperties =
			{
				width: skinHeight * this.scale,
				height: skinHeight * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = skinHeight * this.scale;
			button.minHeight = skinHeight * this.scale;
			button.minTouchWidth = skinHeight * this.scale;
			button.minTouchHeight = skinHeight * this.scale;
		}

		protected function toggleSwitchSwitchInitializer(button:Button):void
		{
			var skinSize:Number = this.toggleSwitchTexture.height;
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.toggleSwitchTexture;
			//skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			//skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
			{
				width: skinSize * this.scale,
				height: skinSize * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = skinSize * this.scale;
			button.minHeight = skinSize * this.scale;
			button.minTouchWidth = skinSize * this.scale;
			button.minTouchHeight = skinSize * this.scale;
		}

/*
		protected function headerLabelInitializer(label:Label):void
		{
			label.textRendererProperties.embedFonts = true;
			label.textRendererProperties.isHTML = true;
			label.textRendererProperties.wordWrap = true;
			label.textRendererProperties.textFormat = new TextFormat("ExoLight", 44 * this.scale, 0x293d54);
			label.textRendererProperties.filter = BlurFilter.createDropShadow(1,1.5,0xFFFFFF,0.5,0);
		}*/

		protected function labelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.bodyBftf;
			label.textRendererProperties.wordWrap = true;
		}

		protected function subHeaderLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.subHeaderBftf;
		}

		protected function bodyBoldLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.bodyBoldBftf;
			label.textRendererProperties.wordWrap = true;
		}

		protected function bodyCenteredLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.bodyCenteredBftf;
			label.textRendererProperties.wordWrap = true;
		}

		protected function bodyBoldCenteredLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.bodyBoldCenteredBftf;
		}

		protected function inputLabelLeftInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.inputLabelLeftBftf;
			label.textRendererProperties.wordWrap = true;
		}

		protected function inputLabelRightInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.bodyBftf;
		}

		protected function homeLensLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.homeLensLabelBftf;
			label.textRendererProperties.wordWrap = true;
		}

		protected function validationLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.validationLabelBftf;
			label.textRendererProperties.wordWrap = true;
		}

		protected function medicineBrandnameLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.medicineBrandnameLabelBftf;
		}

		protected function splashFooterLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.splashFooterLabelBftf;
			label.textRendererProperties.wordWrap = true;
		}

		protected  function calenderMonthLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.calendarMonthLabelBftf;
		}

		protected function feelingSliderLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.feelingSliderLabelBftf;
		}

		protected function appIdLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.appIdLabelBftf
		}

		protected function instructionsLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.instructionsLabelBftf;
			label.textRendererProperties.wordWrap = true;
		}

		protected function calendarDaysLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.calendarDaysLabelBftf;
		}

		protected function superscriptLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.superscriptLabelBftf;
		}
		protected function cellSmallLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.bodySmallerBftf;
			label.textRendererProperties.wordWrap = true;
		}
		protected function cellSmallBoldLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.bodySmallerBoldBftf;
			label.textRendererProperties.wordWrap = true;
		}

		protected function patientDataLightLabelInitializer(label:Label):void
		{
			label.textRendererProperties.textFormat = this.patientDataLighterLabelBftf;
		}

















		protected function itemRendererAccessoryLabelInitializer(renderer:TextFieldTextRenderer):void
		{

//			renderer.textFormat = this.smallLightTextFormat;

		}


		protected function scrollTextInitializer(text:ScrollText):void
		{
			text.embedFonts = true;
			text.textFormat = new TextFormat("ExoRegular", 24 * this.scale, 0x2d435c);
			text.filter = BlurFilter.createDropShadow(1,1.5,0xFFFFFF,0.5,0);
			text.paddingTop = text.paddingBottom = text.paddingLeft = 32 * this.scale;
			text.paddingRight = 36 * this.scale;
		}

		protected function borderButtonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
//			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
//			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
//			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
//			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.imageProperties =
			{
				width: 76 * this.scale,
				height: 76 * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultLabelProperties.textFormat = this.defaultButtonLabelBftf;

			button.paddingTop = button.paddingBottom = 8 * this.scale;
			button.paddingLeft = button.paddingRight = 16 * this.scale;
			button.gap = 12 * this.scale;
			button.minWidth = button.minHeight = 88 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}

		protected function buttonInitializer(button:Button):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.borderlessButtonUpSkinTextures;
//			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
//			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
//			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
//			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.imageProperties =
			{
				width: 76 * this.scale,
				height: 76 * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			

			button.defaultLabelProperties.textFormat = this.defaultButtonLabelBftf;

			button.paddingTop = button.paddingBottom = 8 * this.scale;
			button.paddingLeft = button.paddingRight = 30 * this.scale;
			button.gap = 12 * this.scale;
			button.minWidth = button.minHeight = 88 * this.scale;
			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}

		protected function homeButtonInitializer(button:Button):void
		{
			var skinWidth:Number = this.buttonHomeSkinTexture.width;
			var skinHeight:Number = this.buttonHomeSkinTexture.height;
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonHomeSkinTexture;
			skinSelector.imageProperties =
			{
				width: skinWidth * this.scale,
				height: skinHeight * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = skinWidth * this.scale;
			button.minHeight = skinHeight * this.scale;
			button.minTouchWidth = 88 * this.scale;
			button.minTouchHeight = 88 * this.scale;
		}

		protected function backButtonInitializer(button:Button):void
		{
			var skinWidth:Number = this.buttonBackSkinTexture.width;
			var skinHeight:Number = this.buttonBackSkinTexture.height;
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonBackSkinTexture;
			skinSelector.imageProperties =
			{
				width: skinWidth * this.scale,
				height: skinHeight * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.defaultLabelProperties.textFormat = this.backButtonLabelBftf;

			button.labelOffsetX = 8 * this.scale;
			button.labelOffsetY = -5 * this.scale;

			button.minWidth = skinWidth * this.scale;
			button.minHeight = skinHeight * this.scale;
			button.minTouchWidth = 88 * this.scale;
			button.minTouchHeight = 88 * this.scale;
		}

		protected function closeButtonInitializer(button:Button):void
		{
			var skinWidth:Number = this.buttonCloseSkinTexture.width;
			var skinHeight:Number = this.buttonCloseSkinTexture.height;
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonCloseSkinTexture;
			skinSelector.imageProperties =
			{
				width: skinWidth * this.scale,
				height: skinHeight * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = skinWidth * this.scale;
			button.minHeight = skinHeight * this.scale;
			button.minTouchWidth = 88 * this.scale;
			button.minTouchHeight = 88 * this.scale;
		}

		protected function deleteCellButtonInitializer(button:Button):void
		{
			var skinWidth:Number = this.buttonDeleteCellSkinTexture.width;
			var skinHeight:Number = this.buttonDeleteCellSkinTexture.height;
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonDeleteCellSkinTexture;
			skinSelector.imageProperties =
			{
				width: skinWidth * this.scale,
				height: skinHeight * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = skinWidth * this.scale;
			button.minHeight = skinHeight * this.scale;
			button.minTouchWidth = 88 * this.scale;
			button.minTouchHeight = 88 * this.scale;
		}

		protected function editCellButtonInitializer(button:Button):void
		{
			var skinWidth:Number = this.buttonEditCellSkinTexture.width;
			var skinHeight:Number = this.buttonEditCellSkinTexture.height;
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonEditCellSkinTexture;
			skinSelector.imageProperties =
			{
				width: skinWidth * this.scale,
				height: skinHeight * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = skinWidth * this.scale;
			button.minHeight = skinHeight * this.scale;
			button.minTouchWidth = 88 * this.scale;
			button.minTouchHeight = 88 * this.scale;
		}

		protected function calendarButtonInitializer(button:Button):void
		{
			var skinWidth:Number = this.buttonCalendarSkinTexture.width;
			var skinHeight:Number = this.buttonCalendarSkinTexture.height;
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonCalendarSkinTexture;
			skinSelector.imageProperties =
			{
				width: skinWidth * this.scale,
				height: skinHeight * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = 88 * this.scale;
			button.minHeight = 88 * this.scale;
			button.minTouchWidth = 88 * this.scale;
			button.minTouchHeight = 88 * this.scale;
		}

		protected function calendarDayCellButtonInitializer(button:Button):void
		{
			var skinWidth:Number = this.buttonCalendarDayCellSkinTexture.width;
			var skinHeight:Number = this.buttonCalendarDayCellSkinTexture.height;
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonCalendarDayCellSkinTexture;
			skinSelector.imageProperties =
			{
				width: skinWidth * this.scale,
				height: skinHeight * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;
/*

			button.defaultLabelProperties.embedFonts = true;
			button.defaultLabelProperties.textFormat = new TextFormat("ExoBold", 30 * this.scale, 0x454545);
			button.defaultLabelProperties.filter = BlurFilter.createDropShadow(1,-1.5,0xFFFFFF,0.5,0);

			button.disabledLabelProperties.embedFonts = true;
			button.disabledLabelProperties.textFormat = new TextFormat("ExoBold", 30 * this.scale, 0xaeaeae);
			button.disabledLabelProperties.filter = BlurFilter.createDropShadow(1,-1.5,0xFFFFFF,0.5,0);
*/
			

			button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(this.normalWhiteRegularBitmapFont,30, 0x454545);
			button.disabledLabelProperties.textFormat = new BitmapFontTextFormat(this.normalWhiteRegularBitmapFont,30, 0xaeaeae);

			button.minWidth = skinWidth * this.scale;
			button.minHeight = skinHeight * this.scale;
			button.minTouchWidth = 88 * this.scale;
			button.minTouchHeight = 88 * this.scale;
		}

		protected function calendarArrowsButtonInitializer(button:Button):void
		{
			var skinWidth:Number = this.buttonCalendarArrowsTexture.width;
			var skinHeight:Number = this.buttonCalendarArrowsTexture.height;
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonCalendarArrowsTexture;
			skinSelector.imageProperties =
			{
				width: skinWidth * this.scale,
				height: skinHeight * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = skinWidth * this.scale;
			button.minHeight = skinHeight * this.scale;
			button.minTouchWidth = 88 * this.scale;
			button.minTouchHeight = 88 * this.scale;
		}



		protected function homeFooterGroupInitializer(button:Button):void
		{
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonFooterTexture;
			skinSelector.defaultSelectedValue = this.buttonFooterActiveTexture;
			skinSelector.setValueForState(this.buttonFooterActiveTexture, Button.STATE_DOWN, false);
			skinSelector.imageProperties =
			{
				width: 128 * this.scale,
				height: 135 * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = 128 * this.scale;
			button.minHeight = 135 * this.scale;
			button.minTouchWidth = 128 * this.scale;
			button.minTouchHeight = 135 * this.scale;
		}
/*

		protected function galleryThumbInitializer(button:Button):void
		{
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonFooterTexture;
			skinSelector.defaultSelectedValue = this.buttonFooterActiveTexture;
			skinSelector.setValueForState(this.buttonFooterActiveTexture, Button.STATE_DOWN, false);
			skinSelector.imageProperties =
			{
				width: 128 * this.scale,
				height: 135 * this.scale,
				textureScale: this.scale
			};

			button.stateToSkinFunction = skinSelector.updateValue;

			button.minWidth = 128 * this.scale;
			button.minHeight = 135 * this.scale;
			button.minTouchWidth = 128 * this.scale;
			button.minTouchHeight = 135 * this.scale;
		}
*/

		protected function sideNavGroupInitializer(button:Button):void
		{
			const skinSelector:ImageStateValueSelector = new ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonSideNavTexture;
			skinSelector.imageProperties =
			{
				width: 177 * this.scale,
				height: 132 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			

			button.defaultLabelProperties.textFormat = this.sideNavGroupLabelBftf;

			button.verticalAlign = Button.VERTICAL_ALIGN_BOTTOM;
			button.paddingBottom = 33 * this.scale;

			button.minWidth = 177 * this.scale;
			button.minHeight = 132 * this.scale;
			button.minTouchWidth = 177 * this.scale;
			button.minTouchHeight = 132 * this.scale;
		}

		protected function patientProfileNavGroupInitializer(button:Button):void
		{
			const assetHeight:Number = 88;
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.buttonPatientProfileNavTexture;
			skinSelector.imageProperties =
			{
				height: assetHeight * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;

			

			button.defaultLabelProperties.textFormat = this.profileGroupLabelBftf;

			button.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;

			button.paddingLeft = 44 * this.scale;

			button.minWidth = assetHeight * this.scale;
			button.minHeight = assetHeight * this.scale;
			button.minTouchWidth = assetHeight * this.scale;
			button.minTouchHeight = assetHeight * this.scale;
		}

		protected function buttonGroupButtonInitializer(button:Button):void
		{

			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();

			skinSelector.defaultValue = this.buttonUpSkinTextures;

			skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;

			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);

			skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);

			skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);

			skinSelector.imageProperties =

			{

				width: 76 * this.scale,

				height: 76 * this.scale,

				textureScale: this.scale

			};

			button.stateToSkinFunction = skinSelector.updateValue;

/*

			button.defaultLabelProperties.textFormat = this.largeUIDarkTextFormat;

			button.disabledLabelProperties.textFormat = this.largeUIDisabledTextFormat;

			button.selectedDisabledLabelProperties.textFormat = this.largeUIDisabledTextFormat;

*/

			button.paddingTop = button.paddingBottom = 8 * this.scale;

			button.paddingLeft = button.paddingRight = 16 * this.scale;

			button.gap = 12 * this.scale;

			button.minWidth = button.minHeight = 76 * this.scale;

			button.minTouchWidth = button.minTouchHeight = 88 * this.scale;

		}


		protected function pickerListButtonInitializer(button:Button):void
		{

			this.buttonInitializer(button);


			const defaultIcon:Image = new Image(this.pickerListButtonIconTexture);

			defaultIcon.scaleX = defaultIcon.scaleY = this.scale;

			button.defaultIcon = defaultIcon;


			button.gap = Number.POSITIVE_INFINITY;

			button.iconPosition = Button.ICON_POSITION_RIGHT;

		}


		protected function toggleSwitchTrackInitializer(track:Button):void
		{
			var skinWidth:Number = this.toggleTrackTexture.texture.width;
			var skinHeight:Number = this.toggleTrackTexture.texture.height;
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.toggleTrackTexture;
			//skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);

			skinSelector.imageProperties =
			{

				width: skinWidth * this.scale,
				height: skinHeight * this.scale,
				textureScale: this.scale
			};

			track.stateToSkinFunction = skinSelector.updateValue;
		}


		protected function tabInitializer(tab:Button):void
		{

			const defaultSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, 0x1a1a1a);

			tab.defaultSkin = defaultSkin;


			const downSkin:Scale9Image = new Scale9Image(this.tabDownSkinTextures, this.scale);

			tab.downSkin = downSkin;


			const defaultSelectedSkin:Scale9Image = new Scale9Image(this.tabSelectedSkinTextures, this.scale);

			tab.defaultSelectedSkin = defaultSelectedSkin;

/*

			tab.defaultLabelProperties.textFormat = this.smallUILightTextFormat;

			tab.defaultSelectedLabelProperties.textFormat = this.smallUIDarkTextFormat;

			tab.disabledLabelProperties.textFormat = this.smallUIDisabledTextFormat;

			tab.selectedDisabledLabelProperties.textFormat = this.smallUIDisabledTextFormat;
*/


			tab.paddingTop = tab.paddingBottom = 8 * this.scale;

			tab.paddingLeft = tab.paddingRight = 16 * this.scale;

			tab.gap = 12 * this.scale;

			tab.minWidth = tab.minHeight = 88 * this.scale;

			tab.minTouchWidth = tab.minTouchHeight = 88 * this.scale;

		}

/*
		protected function buttonGroupInitializer(group:ButtonGroup):void
		{

			group.minWidth = 560 * this.scale;

			group.gap = 18 * this.scale;

		}
*/

		protected function itemRendererInitializer(renderer:BaseDefaultItemRenderer):void
		{

			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.seperatorLineTexture;
			//skinSelector.defaultSelectedValue = this.itemRendererSelectedSkinTextures;
			//skinSelector.setValueForState(this.itemRendererSelectedSkinTextures, Button.STATE_DOWN, false);
			skinSelector.imageProperties =
			{
				width: 88 * this.scale,
				//height: 88 * this.scale,
				textureScale: this.scale
			};

			renderer.stateToSkinFunction = skinSelector.updateValue;

			renderer.defaultLabelProperties.textFormat = this.bodyBftf;
			//renderer.downLabelProperties.textFormat = this.largeDarkTextFormat;
			//renderer.defaultSelectedLabelProperties.textFormat = this.largeDarkTextFormat;

			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			renderer.paddingTop = renderer.paddingBottom = 8 * this.scale;
			renderer.paddingLeft = 32 * this.scale;
			renderer.paddingRight = 24 * this.scale;
			renderer.gap = 20 * this.scale;
			renderer.iconPosition = Button.ICON_POSITION_LEFT;
			renderer.accessoryGap = Number.POSITIVE_INFINITY;
			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;

			renderer.minWidth = renderer.minHeight = 88 * this.scale;
			renderer.minTouchWidth = renderer.minTouchHeight = 88 * this.scale;

			renderer.accessoryLoaderFactory = this.imageLoaderFactory;
			renderer.iconLoaderFactory = this.imageLoaderFactory;
		}


		protected function pickerListItemRendererInitializer(renderer:BaseDefaultItemRenderer):void
		{
			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.seperatorLineTexture;
			skinSelector.imageProperties =
			{
				width: 88 * this.scale,
				height: 88 * this.scale,
				textureScale: this.scale
			};
			renderer.stateToSkinFunction = skinSelector.updateValue;

/*
			const defaultSelectedIcon:Image = new Image(this.pickerListItemSelectedIconTexture);

			defaultSelectedIcon.scaleX = defaultSelectedIcon.scaleY = this.scale;

			renderer.defaultSelectedIcon = defaultSelectedIcon;



			const defaultIcon:Quad = new Quad(defaultSelectedIcon.width, defaultSelectedIcon.height, 0xff00ff);

			defaultIcon.alpha = 0;

			renderer.defaultIcon = defaultIcon;
*/


			renderer.defaultLabelProperties.textFormat = this.bodyBftf;

//			renderer.downLabelProperties.textFormat = this.largeDarkTextFormat;


			renderer.itemHasIcon = false;

			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;

			renderer.paddingTop = renderer.paddingBottom = 8 * this.scale;

			renderer.paddingLeft = 32 * this.scale;

			renderer.paddingRight = 24 * this.scale;

			renderer.gap = 12 * this.scale;

			renderer.iconPosition = Button.ICON_POSITION_LEFT;

			renderer.accessoryGap = Number.POSITIVE_INFINITY;

			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;

			renderer.minWidth = renderer.minHeight = 88 * this.scale;

			renderer.minTouchWidth = renderer.minTouchHeight = 88 * this.scale;

		}


		protected function insetItemRendererInitializer(renderer:DefaultGroupedListItemRenderer,
														defaultSkinTextures:Scale9Textures,
														selectedAndDownSkinTextures:Scale9Textures):void
		{

			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();

			skinSelector.defaultValue = defaultSkinTextures;

			skinSelector.defaultSelectedValue = selectedAndDownSkinTextures;

			skinSelector.setValueForState(selectedAndDownSkinTextures, Button.STATE_DOWN, false);

			skinSelector.imageProperties =

			{

				width: 88 * this.scale,

				height: 88 * this.scale,

				textureScale: this.scale

			};

			renderer.stateToSkinFunction = skinSelector.updateValue;

/*

			renderer.defaultLabelProperties.textFormat = this.largeLightTextFormat;

			renderer.downLabelProperties.textFormat = this.largeDarkTextFormat;

			renderer.defaultSelectedLabelProperties.textFormat = this.largeDarkTextFormat;
*/


			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;

			renderer.paddingTop = renderer.paddingBottom = 8 * this.scale;

			renderer.paddingLeft = 32 * this.scale;

			renderer.paddingRight = 24 * this.scale;

			renderer.gap = 20 * this.scale;

			renderer.iconPosition = Button.ICON_POSITION_LEFT;

			renderer.accessoryGap = Number.POSITIVE_INFINITY;

			renderer.accessoryPosition = BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT;

			renderer.minWidth = renderer.minHeight = 88 * this.scale;

			renderer.minTouchWidth = renderer.minTouchHeight = 88 * this.scale;

		}


		protected function insetMiddleItemRendererInitializer(renderer:DefaultGroupedListItemRenderer):void
		{

			this.insetItemRendererInitializer(renderer, this.insetItemRendererMiddleUpSkinTextures,
					this.insetItemRendererMiddleSelectedSkinTextures);

		}


		protected function insetFirstItemRendererInitializer(renderer:DefaultGroupedListItemRenderer):void
		{

			this.insetItemRendererInitializer(renderer, this.insetItemRendererFirstUpSkinTextures,
					this.insetItemRendererFirstSelectedSkinTextures);

		}


		protected function insetLastItemRendererInitializer(renderer:DefaultGroupedListItemRenderer):void
		{

			this.insetItemRendererInitializer(renderer, this.insetItemRendererLastUpSkinTextures,
					this.insetItemRendererLastSelectedSkinTextures);

		}


		protected function insetSingleItemRendererInitializer(renderer:DefaultGroupedListItemRenderer):void
		{

			this.insetItemRendererInitializer(renderer, this.insetItemRendererSingleUpSkinTextures,
					this.insetItemRendererSingleSelectedSkinTextures);

		}


		protected function headerRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{

			const defaultSkin:Quad = new Quad(44 * this.scale, 44 * this.scale, 0x242424);

			renderer.backgroundSkin = defaultSkin;


			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;

//			renderer.contentLabelProperties.textFormat = this.smallUILightTextFormat;

			renderer.paddingTop = renderer.paddingBottom = 4 * this.scale;

			renderer.paddingLeft = renderer.paddingRight = 16 * this.scale;

			renderer.minWidth = renderer.minHeight = 44 * this.scale;

			renderer.minTouchWidth = renderer.minTouchHeight = 44 * this.scale;


			renderer.contentLoaderFactory = this.imageLoaderFactory;

		}


		protected function footerRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{

			const defaultSkin:Quad = new Quad(44 * this.scale, 44 * this.scale, 0x242424);

			renderer.backgroundSkin = defaultSkin;


			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;

//			renderer.contentLabelProperties.textFormat = this.smallLightTextFormat;

			renderer.paddingTop = renderer.paddingBottom = 4 * this.scale;

			renderer.paddingLeft = renderer.paddingRight = 16 * this.scale;

			renderer.minWidth = renderer.minHeight = 44 * this.scale;

			renderer.minTouchWidth = renderer.minTouchHeight = 44 * this.scale;


			renderer.contentLoaderFactory = this.imageLoaderFactory;

		}


		protected function insetHeaderRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{

			const defaultSkin:Quad = new Quad(66 * this.scale, 66 * this.scale, 0xff00ff);

			defaultSkin.alpha = 0;

			renderer.backgroundSkin = defaultSkin;


			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_LEFT;

//			renderer.contentLabelProperties.textFormat = this.smallUILightTextFormat;

			renderer.paddingTop = renderer.paddingBottom = 4 * this.scale;

			renderer.paddingLeft = renderer.paddingRight = 32 * this.scale;

			renderer.minWidth = renderer.minHeight = 66 * this.scale;

			renderer.minTouchWidth = renderer.minTouchHeight = 44 * this.scale;


			renderer.contentLoaderFactory = this.imageLoaderFactory;

		}


		protected function insetFooterRendererInitializer(renderer:DefaultGroupedListHeaderOrFooterRenderer):void
		{

			const defaultSkin:Quad = new Quad(66 * this.scale, 66 * this.scale, 0xff00ff);

			defaultSkin.alpha = 0;

			renderer.backgroundSkin = defaultSkin;


			renderer.horizontalAlign = DefaultGroupedListHeaderOrFooterRenderer.HORIZONTAL_ALIGN_CENTER;

//			renderer.contentLabelProperties.textFormat = this.smallLightTextFormat;

			renderer.paddingTop = renderer.paddingBottom = 4 * this.scale;

			renderer.paddingLeft = renderer.paddingRight = 32 * this.scale;

			renderer.minWidth = renderer.minHeight = 66 * this.scale;

			renderer.minTouchWidth = renderer.minTouchHeight = 44 * this.scale;


			renderer.contentLoaderFactory = this.imageLoaderFactory;

		}


		protected function radioInitializer(radio:Radio):void
		{
			const iconSelector:ImageStateValueSelector = new ImageStateValueSelector();
			iconSelector.defaultValue = this.radioUpIconTexture;
			iconSelector.defaultSelectedValue = this.radioDownIconTexture;
			iconSelector.setValueForState(this.radioDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.radioUpIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.radioUpIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.radioDownIconTexture, Button.STATE_DISABLED, true);
			iconSelector.imageProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};

			radio.stateToIconFunction = iconSelector.updateValue;

			radio.defaultLabelProperties.textFormat = this.bodyBftf;
			radio.defaultLabelProperties.wordWrap = true;
			radio.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			radio.gap = 12 * this.scale;
			/*radio.padding = 32 * this.scale;
			radio.paddingTop = this.scale;*/
			radio.minTouchWidth = radio.minTouchHeight = 88 * this.scale;

			/*
			const iconSelector:ImageStateValueSelector = new ImageStateValueSelector();
			iconSelector.defaultValue = this.radioUpIconTexture;
			iconSelector.defaultSelectedValue = this.radioSelectedUpIconTexture;
			iconSelector.setValueForState(this.radioDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.radioDisabledIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.radioSelectedDownIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.radioSelectedDisabledIconTexture, Button.STATE_DISABLED, true);
			iconSelector.imageProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};
			radio.stateToIconFunction = iconSelector.updateValue;

			radio.defaultLabelProperties.textFormat = this.smallUILightTextFormat;
			radio.disabledLabelProperties.textFormat = this.smallUIDisabledTextFormat;
			radio.selectedDisabledLabelProperties.textFormat = this.smallUIDisabledTextFormat;

			radio.gap = 12 * this.scale;
			radio.minTouchWidth = radio.minTouchHeight = 88 * this.scale;
*/
		}


		protected function checkInitializer(check:Check):void
		{
			const iconSelector:ImageStateValueSelector = new ImageStateValueSelector();
			iconSelector.defaultValue = this.checkUpIconTexture;
			iconSelector.defaultSelectedValue = this.checkDownIconTexture;
			iconSelector.setValueForState(this.checkDownIconTexture, Button.STATE_DOWN, false);
			iconSelector.setValueForState(this.checkUpIconTexture, Button.STATE_DISABLED, false);
			iconSelector.setValueForState(this.checkUpIconTexture, Button.STATE_DOWN, true);
			iconSelector.setValueForState(this.checkDownIconTexture, Button.STATE_DISABLED, true);
			iconSelector.imageProperties =
			{
				scaleX: this.scale,
				scaleY: this.scale
			};

			check.stateToIconFunction = iconSelector.updateValue;
			check.defaultLabelProperties.textFormat = this.bodyBftf;
			check.defaultLabelProperties.wordWrap = true;

			check.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
			check.gap = 12 * this.scale;
//			check.padding = 32 * this.scale;
//			check.paddingTop = this.scale;
			check.minTouchWidth = check.minTouchHeight = 88 * this.scale;
		}

		protected function sliderInitializer(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_MIN_MAX;

			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.backgroundSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			skinSelector.setValueForState(this.backgroundDisabledSkinTextures, Button.STATE_DISABLED, false);
			skinSelector.imageProperties =
			{
				textureScale: this.scale
			};
			if (slider.direction == Slider.DIRECTION_VERTICAL)
			{
				skinSelector.imageProperties.width = 60 * this.scale;
				skinSelector.imageProperties.height = 210 * this.scale;
			}
			else
			{
				skinSelector.imageProperties.width = 210 * this.scale;
				skinSelector.imageProperties.height = 60 * this.scale;
			}
			slider.minimumTrackProperties.stateToSkinFunction = skinSelector.updateValue;
			slider.maximumTrackProperties.stateToSkinFunction = skinSelector.updateValue;
		}

		protected function feelingSliderInitializer(slider:Slider):void
		{
			slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_SINGLE;

			const skinSelector:Scale9ImageStateValueSelector = new Scale9ImageStateValueSelector();
			skinSelector.defaultValue = this.feelingSliderTrackSkinTextures;
			skinSelector.imageProperties =
			{
				textureScale: this.scale
			};
			/*if (slider.direction == Slider.DIRECTION_VERTICAL)
			{
				skinSelector.imageProperties.width = 60 * this.scale;
				skinSelector.imageProperties.height = 210 * this.scale;
			}
			else*/
			{
				skinSelector.imageProperties.width = 486 * this.scale;
				skinSelector.imageProperties.height = 92 * this.scale;
			}
			slider.minimumTrackProperties.stateToSkinFunction = skinSelector.updateValue;
			slider.maximumTrackProperties.stateToSkinFunction = skinSelector.updateValue;
			slider.maximumTrackProperties.padding = 0;
		}


		protected function toggleSwitchInitializer(toggle:ToggleSwitch):void
		{
			toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE;
			toggle.defaultLabelProperties.alpha = 0;

			//toggle.defaultLabelProperties.textFormat = this.smallUILightTextFormat;
			//toggle.onLabelProperties.textFormat = this.smallUISelectedTextFormat;
		}


		protected function textInputInitializer(input:TextInput):void
		{

			const backgroundSkin:Scale9Image = new Scale9Image(this.inputFieldSkinTexture, this.scale);
			backgroundSkin.width = 264 * this.scale;
			backgroundSkin.height = 60 * this.scale;
			input.backgroundSkin = backgroundSkin;

/*
			const backgroundDisabledSkin:Scale9Image = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);

			backgroundDisabledSkin.width = 264 * this.scale;

			backgroundDisabledSkin.height = 60 * this.scale;

			input.backgroundDisabledSkin = backgroundDisabledSkin;


			const backgroundFocusedSkin:Scale9Image = new Scale9Image(this.backgroundFocusedSkinTextures, this.scale);

			backgroundFocusedSkin.width = 264 * this.scale;

			backgroundFocusedSkin.height = 60 * this.scale;

			input.backgroundFocusedSkin = backgroundFocusedSkin;
*/


			input.minWidth = input.minHeight = 88 * this.scale;
			input.minTouchWidth = input.minTouchHeight = 88 * this.scale;
			input.padding = 25 * this.scale;
			input.textEditorFactory = function():ITextEditor
			{
			    var editor:StageTextTextEditor = new StageTextTextEditor();
			    editor.fontFamily = "Helvetica Neue,Helvetica";
			    editor.fontSize = 25 * scale;
			    editor.color = 0x283c53;
			    return editor;
			};
			/*
			input.textEditorProperties.fontName = "ExoLight";
			input.textEditorProperties.fontSize = 25 * this.scale;
			input.textEditorProperties.color = 0x283c53;
			*/
		}


		protected function pageIndicatorInitializer(pageIndicator:PageIndicator):void
		{

			pageIndicator.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;

			pageIndicator.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;

			pageIndicator.gap = 10 * this.scale;

			pageIndicator.paddingTop = pageIndicator.paddingRight = pageIndicator.paddingBottom =

					pageIndicator.paddingLeft = 6 * this.scale;

			pageIndicator.minTouchWidth = pageIndicator.minTouchHeight = 44 * this.scale;

		}


		protected function progressBarInitializer(progress:ProgressBar):void
		{

			const backgroundSkin:Scale9Image = new Scale9Image(this.backgroundSkinTextures, this.scale);

			backgroundSkin.width = 240 * this.scale;

			backgroundSkin.height = 22 * this.scale;

			progress.backgroundSkin = backgroundSkin;


			const backgroundDisabledSkin:Scale9Image = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);

			backgroundDisabledSkin.width = 240 * this.scale;

			backgroundDisabledSkin.height = 22 * this.scale;

			progress.backgroundDisabledSkin = backgroundDisabledSkin;


			const fillSkin:Scale9Image = new Scale9Image(this.buttonUpSkinTextures, this.scale);

			fillSkin.width = 8 * this.scale;

			fillSkin.height = 22 * this.scale;

			progress.fillSkin = fillSkin;


			const fillDisabledSkin:Scale9Image = new Scale9Image(this.buttonDisabledSkinTextures, this.scale);

			fillDisabledSkin.width = 8 * this.scale;

			fillDisabledSkin.height = 22 * this.scale;

			progress.fillDisabledSkin = fillDisabledSkin;

		}


		protected function headerInitializer(header:Header):void
		{

			header.minWidth = 88 * this.scale;

			header.minHeight = 88 * this.scale;

			header.paddingTop = header.paddingRight = header.paddingBottom =

					header.paddingLeft = 14 * this.scale;

			//header.titleProperties.textFormat = this.headerTextFormat;
/*
			header.titleProperties.embedFonts = true;
			header.titleProperties.isHTML = true;
			header.titleProperties.wordWrap = true;
			header.titleProperties.textFormat = new TextFormat("ExoLight", 44 * this.scale, 0x293d54);
			header.titleProperties.filter = BlurFilter.createDropShadow(1,1.5,0xFFFFFF,0.5,0);*/
			//label.textRendererProperties.filter = BlurFilter.createDropShadow(1,1.5,0xFFFFFF,0.5,0);
		}


		protected function pickerListInitializer(list:PickerList):void
		{

			if (DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{

				list.popUpContentManager = new CalloutPopUpContentManager();

			}

			else
			{

				const centerStage:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();

				centerStage.marginTop = centerStage.marginRight = centerStage.marginBottom =

						centerStage.marginLeft = 24 * this.scale;

				list.popUpContentManager = centerStage;

			}


			const layout:VerticalLayout = new VerticalLayout();

			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;

			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;

			layout.useVirtualLayout = true;

			layout.gap = 0;

			layout.paddingTop = layout.paddingRight = layout.paddingBottom =

					layout.paddingLeft = 0;

			list.listProperties.layout = layout;

			list.listProperties.@scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;


			if (DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{

				list.listProperties.minWidth = 560 * this.scale;

				list.listProperties.maxHeight = 528 * this.scale;

			}

			else
			{

				const backgroundSkin:TiledImage = new TiledImage(Main.assets.getTexture("screen_base"));

				backgroundSkin.width = 20 * this.scale;

				backgroundSkin.height = 20 * this.scale;

				list.listProperties.backgroundSkin = backgroundSkin;

				/*list.listProperties.paddingTop = list.listProperties.paddingRight =

						list.listProperties.paddingBottom = list.listProperties.paddingLeft = 8 * this.scale;*/

			}


			list.listProperties.itemRendererName = COMPONENT_NAME_PICKER_LIST_ITEM_RENDERER;

		}


		protected function calloutInitializer(callout:Callout):void
		{

			const backgroundSkin:Scale9Image = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);

			callout.backgroundSkin = backgroundSkin;


			const topArrowSkin:Image = new Image(this.calloutTopArrowSkinTexture);

			topArrowSkin.scaleX = topArrowSkin.scaleY = this.scale;

			callout.topArrowSkin = topArrowSkin;


			const rightArrowSkin:Image = new Image(this.calloutRightArrowSkinTexture);

			rightArrowSkin.scaleX = rightArrowSkin.scaleY = this.scale;

			callout.rightArrowSkin = rightArrowSkin;


			const bottomArrowSkin:Image = new Image(this.calloutBottomArrowSkinTexture);

			bottomArrowSkin.scaleX = bottomArrowSkin.scaleY = this.scale;

			callout.bottomArrowSkin = bottomArrowSkin;


			const leftArrowSkin:Image = new Image(this.calloutLeftArrowSkinTexture);

			leftArrowSkin.scaleX = leftArrowSkin.scaleY = this.scale;

			callout.leftArrowSkin = leftArrowSkin;


			callout.paddingTop = callout.paddingRight = callout.paddingBottom =

					callout.paddingLeft = 8 * this.scale;

		}


		protected function scrollerInitializer(scroller:Scroller):void
		{

			scroller.verticalScrollBarFactory = this.verticalScrollBarFactory;

			scroller.horizontalScrollBarFactory = this.horizontalScrollBarFactory;

		}


		protected function insetGroupedListInitializer(list:GroupedList):void
		{

			list.itemRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_ITEM_RENDERER;

			list.firstItemRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_FIRST_ITEM_RENDERER;

			list.lastItemRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_LAST_ITEM_RENDERER;

			list.singleItemRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_SINGLE_ITEM_RENDERER;

			list.headerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER;

			list.footerRendererName = GroupedList.ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER;


			const layout:VerticalLayout = new VerticalLayout();

			layout.useVirtualLayout = true;

			layout.paddingTop = layout.paddingRight = layout.paddingBottom =

					layout.paddingLeft = 18 * this.scale;

			layout.gap = 0;

			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;

			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;

			list.layout = layout;

		}




		protected function stage_resizeHandler(event:ResizeEvent):void
		{

			this.primaryBackground.width = event.width;

			this.primaryBackground.height = event.height;

		}


		protected function root_addedToStageHandler(event:Event):void
		{

			this.root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);

			this.initializeRoot();

		}


		protected function root_removedFromStageHandler(event:Event):void
		{

			this.root.removeEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);

			this.root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

			this.root.removeChild(this.primaryBackground, true);

			this.primaryBackground = null;

		}


	}

}

