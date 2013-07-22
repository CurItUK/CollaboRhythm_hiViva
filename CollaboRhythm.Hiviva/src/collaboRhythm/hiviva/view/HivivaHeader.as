package collaboRhythm.hiviva.view
{


	import feathers.controls.Header;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;

	import flash.text.TextFormat;



	import starling.display.Image;

	import starling.filters.BlurFilter;

	public class HivivaHeader extends Header
	{
		private var _headerLine:Image;
		private var _scale:Number = 1;
		private var _fontSize:Number = 44;
		private const VERTICAL_PADDING:Number = 20;
		private const HORIZONTOL_PADDING:Number = 10;
		public var bold : Boolean = false;

		public function HivivaHeader()
		{
			super();
			this.titleAlign = Header.TITLE_ALIGN_CENTER;
			this.verticalAlign = Header.VERTICAL_ALIGN_MIDDLE;
		}

		override protected function draw():void
		{
			super.draw();

			this._headerLine.width = this.actualWidth;
			this._headerLine.y = this.actualHeight - 1;
		}

		override protected function initialize():void
		{
			this.titleFactory = headerTitleFactory;
			super.initialize();
			this.paddingLeft = this.paddingRight = HORIZONTOL_PADDING * this._scale;
			this.paddingBottom = this.paddingTop = VERTICAL_PADDING * this._scale;

			this._headerLine = new Image(Main.assets.getTexture("header_line"));
			addChild(this._headerLine);
		}


		public function initTrueTitle():void
		{
			if(bold){
				this.boldHeader()
				return;
			}
			var splitText:Array,
				boldTextInd:int = this.title.indexOf("<font face='ExoBold'>");
			if(this.title.length > 0)
			{
				if (boldTextInd > -1)
				{
					splitText = this.title.split("</font>");
					this.title = splitText.shift() + "</font>" + splitText.toString();
				}
				else
				{
					splitText = this.title.split(" ");
					this.title = "<font face='ExoBold'>" + splitText.shift() + "</font> " + splitText.join(" ");
				}
				this.validate();
			}
		}

		public function boldHeader()
		{
			var splitText:Array,
	        boldTextInd:int = this.title.indexOf("<font face='ExoBold'>");
			if(this.title.length > 0)
					{
						this.title = "<font face='ExoBold'>" + this.title  + "</font> "
						this.validate();
					}

		}
		private function headerTitleFactory():ITextRenderer
		{
			var titleRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();

			//styles here
			titleRenderer.embedFonts = true;
			titleRenderer.isHTML = true;
			titleRenderer.textFormat = new TextFormat("ExoLight", Math.round(this._fontSize * this._scale), 0x293d54);
			titleRenderer.filter = BlurFilter.createDropShadow(1,1.5,0xFFFFFF,0.5,0);

			return titleRenderer;
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void

		{
			_scale = value;
		}

		public function get fontSize():Number
		{
			return _fontSize;
		}

		public function set fontSize(value:Number):void
		{
			_fontSize = value;
		}
	}
}
