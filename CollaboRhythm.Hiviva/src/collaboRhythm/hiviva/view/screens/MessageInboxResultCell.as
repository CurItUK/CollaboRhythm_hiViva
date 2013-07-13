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

			_selected = false;
			trace("drawing");
			super.draw();

			this._seperator.width = Constants.STAGE_WIDTH;

			this._primaryLabel.validate();
			if(!this._isSent)
			{
				this._check.validate();
				this._check.x = Constants.PADDING_LEFT;

				this._primaryLabel.x = this._check.x + this._check.width + Constants.PADDING_LEFT;
			}
			else
			{
				this._primaryLabel.x = Constants.PADDING_LEFT;
			}
			this._primaryLabel.y = Constants.PADDING_TOP;
			this._primaryLabel.width = Constants.STAGE_WIDTH - this._primaryLabel.x - Constants.PADDING_RIGHT - this._dateLabel.width - Constants.PADDING_LEFT;
			fullHeight = this._primaryLabel.y + this._primaryLabel.height + Constants.PADDING_BOTTOM;

			this._dateLabel.validate();
			this._dateLabel.x = Constants.STAGE_WIDTH - Constants.PADDING_RIGHT - this._dateLabel.width;

			switch(this._messageType)
			{
				case COMPOSED_MESSAGE_TYPE :
					this._secondaryLabel.validate();
					this._secondaryLabel.y = this._primaryLabel.y + this._primaryLabel.height;
					this._secondaryLabel.x = this._primaryLabel.x;
					this._secondaryLabel.width = this._primaryLabel.width;
					fullHeight += this._secondaryLabel.height;
					if(!this._read) this._bg.height = fullHeight;
					break;
				case CONNECTION_REQUEST_TYPE :
				case STATUS_ALERT_TYPE :
					this._primaryLabel.width -= this._icon.width;
					this._icon.x = this._primaryLabel.x + this._primaryLabel.width;
					this._icon.y = (fullHeight * 0.5) - (this._icon.height * 0.5);
					break;
			}

			if(!this._isSent) this._check.y = (fullHeight * 0.5) - (this._check.height * 0.5);
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
			addChild(this._seperator);

			if(this._messageType == COMPOSED_MESSAGE_TYPE && !this._read)
			{
				this._bg = new Quad(Constants.STAGE_WIDTH,100,0xFFFFFF);
				this._bg.alpha = 0.2;
				addChild(this._bg);
			}

			this._primaryLabel = new Label();
			if(this._messageType == CONNECTION_REQUEST_TYPE || (this._messageType == COMPOSED_MESSAGE_TYPE && !this._read)) this._primaryLabel.name = HivivaThemeConstants.BODY_BOLD_LABEL;
			this._primaryLabel.text = _primaryText;
			this.addChild(this._primaryLabel);

			switch(this._messageType)
			{
				case COMPOSED_MESSAGE_TYPE :
					this._secondaryLabel = new Label();
					this._secondaryLabel.name = HivivaThemeConstants.MESSAGE_DATE_LABEL;
					this._secondaryLabel.text = _secondaryText;
					this.addChild(this._secondaryLabel);
					break;
				case CONNECTION_REQUEST_TYPE :
					this._icon = new Image(Assets.getTexture("MessageIconReqPng"));
					this.addChild(this._icon);
					break;
				case STATUS_ALERT_TYPE :
					this._icon = new Image(Assets.getTexture("MessageIconAlertPng"));
					this.addChild(this._icon);
					break;
			}

			this._dateLabel = new Label();
			this._dateLabel.name = HivivaThemeConstants.MESSAGE_DATE_LABEL;
			this._dateLabel.text = _dateText;
			this.addChild(this._dateLabel);

			if(!this._isSent)
			{
				this._check = new Check();
				this.addChild(this._check);
				this._check.addEventListener(Event.TRIGGERED , checkBoxSelectHandler);
			}

			this._viewMessageBtn = new Button();
			this._viewMessageBtn.label = "";
			this._viewMessageBtn.alpha = 0;
			this._viewMessageBtn.addEventListener(Event.TRIGGERED , messageCellSelectHandler);
			addChild(this._viewMessageBtn);
		}

		private function messageCellSelectHandler(e:Event):void
		{
			var evt:FeathersScreenEvent = new FeathersScreenEvent(FeathersScreenEvent.MESSAGE_SELECT);
			this.dispatchEvent(evt);
		}

		private function checkBoxSelectHandler(e:Event):void
		{
		//	_selected ? !_selected : _selected;
			if(_selected)
			{
				_selected = false;
			}
			else
			{

				_selected = true;
			}
			trace("SELECTED VALUE " + _selected)
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
			_dateText = HivivaModifier.isoDateToPrettyString(value);
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
