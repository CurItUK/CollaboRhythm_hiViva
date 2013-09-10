package collaboRhythm.hiviva.view.screens
{
	import collaboRhythm.hiviva.global.Constants;
	import collaboRhythm.hiviva.global.FeathersScreenEvent;
	import collaboRhythm.hiviva.global.HivivaAssets;
	import collaboRhythm.hiviva.global.HivivaThemeConstants;
	import collaboRhythm.hiviva.global.RemoteDataStoreEvent;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.utils.HivivaModifier;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.Label;
	import feathers.controls.Radio;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.textures.Scale9Textures;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;

	public class MessageInboxResultCell extends FeathersControl
	{
		private var _scale:Number = 1;
		private var _bg:Quad;
		private var _seperator:Image;
		private var _icon:Image;
		private var _viewMessageBtn:Button;
		private var _primaryLabel:Label;
		private var _primaryText:String = "";
		private var _secondaryLabel:Label;
		private var _secondaryText:String = "";
		private var _dateLabel:Label;
		private var _dateText:String = "";
		private var _check:Check;
		private var _guid:String;
		private var _selected:Boolean;
		private var _messageType:String;
		private var _read:Boolean;
		private var _isSent:Boolean = false;

		// message types
		public static const CONNECTION_REQUEST_TYPE:String = 	"connectionRequestType";
		public static const STATUS_ALERT_TYPE:String = 			"statusAlertType";
		public static const COMPOSED_MESSAGE_TYPE:String = 		"composedMessageType";

		public function MessageInboxResultCell()
		{
			super();
		}

		override protected function draw():void
		{
			var fullHeight:Number;

			super.draw();

			this._seperator.width = Constants.STAGE_WIDTH;

			this._check.validate();
			this._check.x = Constants.PADDING_LEFT;

			this._primaryLabel.x = this._check.x + this._check.width + Constants.PADDING_LEFT;

			this._primaryLabel.y = Constants.PADDING_TOP;
			this._primaryLabel.width = Constants.STAGE_WIDTH - this._primaryLabel.x - Constants.PADDING_RIGHT - this._dateLabel.width - Constants.PADDING_LEFT - this._icon.width;
			this._primaryLabel.validate();

			this._secondaryLabel.validate();
			this._secondaryLabel.y = this._primaryLabel.y + this._primaryLabel.height;
			this._secondaryLabel.x = this._primaryLabel.x;
			this._secondaryLabel.width = this._primaryLabel.width;
			fullHeight = this._secondaryLabel.y + this._secondaryLabel.height + Constants.PADDING_BOTTOM;

			this._dateLabel.validate();
			this._dateLabel.x = Constants.STAGE_WIDTH - Constants.PADDING_RIGHT - this._dateLabel.width;

			this._icon.x = this._primaryLabel.x + this._primaryLabel.width;
			this._icon.y = (fullHeight * 0.5) - (this._icon.height * 0.5);

			this._bg.height = fullHeight;

			this._check.y = (fullHeight * 0.5) - (this._check.height * 0.5);
			this._dateLabel.y = (fullHeight * 0.5) - (this._dateLabel.height * 0.5);

			this._viewMessageBtn.x =  this._primaryLabel.x;
			this._viewMessageBtn.width = Constants.STAGE_WIDTH - this._viewMessageBtn.x;
			this._viewMessageBtn.height = fullHeight;

			setSizeInternal(Constants.STAGE_WIDTH, fullHeight, true);
		}

		override protected function initialize():void
		{
			super.initialize();
			this._seperator = new Image(Main.assets.getTexture("header_line"));

			this._bg = new Quad(Constants.STAGE_WIDTH,100,0xFFFFFF);
			this._bg.alpha = 0.2;

			this._primaryLabel = new Label();
			this._primaryLabel.nameList.add(HivivaThemeConstants.BODY_BOLD_LABEL);
			this._primaryLabel.text = _primaryText;

			this._secondaryLabel = new Label();
			this._secondaryLabel.name = HivivaThemeConstants.CELL_SMALL_LABEL;
			this._secondaryLabel.text = _secondaryText;

			this._icon = new Image(Texture.empty());

			this._dateLabel = new Label();
			this._dateLabel.name = HivivaThemeConstants.CELL_SMALL_LABEL;
			this._dateLabel.text = _dateText;

			this._check = new Check();
			this._check.addEventListener(Event.TRIGGERED , checkBoxSelectHandler);

			this._viewMessageBtn = new Button();
			this._viewMessageBtn.label = "";
			this._viewMessageBtn.alpha = 0;
			this._viewMessageBtn.addEventListener(Event.TRIGGERED , messageCellSelectHandler);

			initializeMessageType();

			addChild(this._seperator);
			addChild(this._bg);
			addChild(this._primaryLabel);
			addChild(this._secondaryLabel);
			addChild(this._icon);
			addChild(this._dateLabel);
			addChild(this._check);
			addChild(this._viewMessageBtn);
		}

		private function initializeMessageType():void
		{
			if(this._messageType == COMPOSED_MESSAGE_TYPE)
			{

			}
			if(this._messageType == CONNECTION_REQUEST_TYPE)
			{
				this._icon = new Image(Main.assets.getTexture("message_icon_req"));
				this._bg.visible = false;
				this._primaryLabel.nameList.remove(HivivaThemeConstants.BODY_BOLD_LABEL);
			}
			if(this._messageType == STATUS_ALERT_TYPE)
			{
				this._icon = new Image(Main.assets.getTexture("message_icon_alert"));
			}
			if(this._isSent)
			{
				this._check.visible = false;
				this._bg.visible = false;
				this._primaryLabel.nameList.remove(HivivaThemeConstants.BODY_BOLD_LABEL);
			}
			if(this._read)
			{
				this._bg.visible = false;
				this._primaryLabel.nameList.remove(HivivaThemeConstants.BODY_BOLD_LABEL);
			}
		}

		private function messageCellSelectHandler(e:Event):void
		{
			var evt:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.MESSAGE_READ);
			this.dispatchEvent(evt);
		}

		private function checkBoxSelectHandler(e:Event):void
		{
			this._selected = !this._selected;
			trace("SELECTED VALUE " + _selected);
			var evt:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.MESSAGE_SELECT);
			this.dispatchEvent(evt);
		}

		override public function dispose():void
		{
			this._viewMessageBtn.removeEventListener(Event.TRIGGERED , messageCellSelectHandler);
			super.dispose();
		}

		public function set scale(value:Number):void
		{
			this._scale = value;
		}

		public function get scale():Number
		{
			return this._scale;
		}

		public function get primaryText():String
		{
			return _primaryText;
		}

		public function set primaryText(value:String):void
		{
			_primaryText = value;
		}

		public function get secondaryText():String
		{
			return _secondaryText;
		}

		public function set secondaryText(value:String):void
		{
			_secondaryText = value;
		}

		public function get dateText():String
		{
			return _dateText;
		}

		public function set dateText(value:String):void
		{
			_dateText = HivivaModifier.getPrettyStringFromIsoString(value,true);
		}

		public function get check():Check
		{
			return _check;
		}

		public function get guid():String
		{
			return _guid;
		}

		public function set guid(value:String):void
		{
			_guid = value;
		}

		public function get isSelected():Boolean
		{
			return _selected
		}

		public function set isSelected(selected:Boolean):void
		{
			_selected = selected;
		}

		public function get messageType():String
		{
			return _messageType;
		}

		public function set messageType(value:String):void
		{
			_messageType = value;
		}

		public function get read():Boolean
		{
			return _read;
		}

		public function set read(value:Boolean):void
		{
			_read = value;
		}

		public function get isSent():Boolean
		{
			return _isSent;
		}

		public function set isSent(value:Boolean):void
		{
			_isSent = value;
			if(value) read = true;
		}
	}

}
