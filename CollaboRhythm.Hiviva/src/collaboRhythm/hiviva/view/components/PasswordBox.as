package collaboRhythm.hiviva.view.components
{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import collaboRhythm.hiviva.view.HivivaStartup;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;

	public class PasswordBox extends Sprite
	{
		private var _pwBox:Sprite;
		private var _submit:Sprite;
		private var passwordText:TextField;
		private var passwordField:TextField;
		private var textLabel:TextField;
		private var _sw:Number;
		private var _sh:Number;
		public var _pass : String ;
		private var _colorTransform : ColorTransform = new ColorTransform();


		public function PasswordBox(sw:Number, sh:Number)
		{
			super();

			_sw = sw;
			_sh = sh;

			drawPassword();
		}

		private function drawPassword():void
		{
			_pwBox = new Sprite();
			_pwBox.graphics.beginFill(0x000000, .9);
			_pwBox.graphics.lineStyle(1, 0x00CCFF);
			_pwBox.graphics.drawRect(0, 0, _sw, _sh);
			_pwBox.graphics.endFill();
			this.addChild(_pwBox);

			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 20;
		//	textFormat.align = TextFormatAlign.CENTER;

			passwordText = new TextField();
			passwordText.defaultTextFormat = textFormat;
			passwordText.text = 'Please enter your password';
			passwordText.width = 300;
			passwordText.x = _sw/2 - passwordText.width/2;
			passwordText.y = _sh/2 - passwordText.height;
			passwordText.textColor = 0xFFFFFF;
			_pwBox.addChild(passwordText);

			passwordField = new TextField();
			passwordField.defaultTextFormat = new TextFormat('Verdana',24,0xDEDEDE);
			passwordField.border = true;
			passwordField.width = 250;
			passwordField.height = 40;
			passwordField.x = passwordText.x;
			passwordField.y = passwordText.y - passwordField.height;
			passwordField.type = "input";
			passwordField.displayAsPassword = true;
			passwordField.background = true;
			_pwBox.addChild(passwordField);

			_submit = new Sprite();
			_submit.graphics.clear();
			_submit.graphics.beginFill(0xD4D4D4); // grey color
			_submit.graphics.drawRoundRect(0, 0, 80, 25, 10, 10); // x, y, width, height, ellipseW, ellipseH
			_submit.graphics.endFill();
			_submit.x = passwordField.x + passwordField.width/2 - 50;
			_submit.y = passwordText.y + passwordField.height;
			_submit.mouseEnabled = true;

			textLabel = new TextField();
			textLabel.text = "SUBMIT";
			textLabel.x = 12;
			textLabel.y = 3;
			textLabel.selectable = false;

			_submit.addChild(textLabel);
			_pwBox.addChild(_submit);

			_submit.useHandCursor = true;
			_submit.addEventListener(TouchEvent.TOUCH_TAP, tapHandler);
			_submit.addEventListener(MouseEvent.CLICK, clickHandler);


		}

		private function addSubmitBtn():void
		{


		}

		public function getPass():String{

			this._pass =  this.passwordField.text;
			return this._pass;
		};

		public function wrongPass(){
			_colorTransform.color=0xFF0000;

			passwordField.backgroundColor = _colorTransform.color;


		};



		private function tapHandler(e:TouchEvent):void
		{
			trace("SUBMIT BUTTON PRESSED")
		}

		private function clickHandler(e:MouseEvent):void
		{
			var ev:Event = new Event("SUBMIT_CLICKED");
			this.dispatchEvent(ev);

		}
	}
}
