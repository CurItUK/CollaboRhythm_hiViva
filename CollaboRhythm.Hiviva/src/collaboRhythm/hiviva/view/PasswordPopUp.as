package collaboRhythm.hiviva.view
{



	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.geom.Rectangle;
	import starling.events.Event;
	import feathers.controls.Check;
    import flash.events.FocusEvent ;
    import collaboRhythm.hiviva.view.screens.shared.HivivaPasswordManager;
	public class PasswordPopUp extends FeathersControl
	{

		private var _scale:Number;
		private var _message:String;
		private var _confirmLabel:String;
		private var _bg:Scale9Image;
		private var _label:Label;
		private var _confirmButton:Button;
		private var _passwordInputField:LabelAndInput;
		private var _enterbutton:Button;
		private var _resetButton:Button;
		private var _saveSettings:Check;
		private var passController: HivivaPasswordManager;


		private const PADDING:Number = 40;
		private const GAP:Number = 20;

		public function PasswordPopUp()
		{
			super();

 		}
        [Inline]
		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this._scale;
			var scaledGap:Number = GAP * this._scale;
			var fullHeight:Number;
			super.draw();
			this._bg.width = this.actualWidth;

			this._confirmButton.validate();
			this._confirmButton.x = (this.actualWidth / 2) - (this._confirmButton.width / 2);
			this._confirmButton.y = this._label.y + this._label.height + scaledGap;

			fullHeight = this._confirmButton.y + this._confirmButton.height + scaledGap + scaledPadding;

			this._passwordInputField.validate();

			this._saveSettings.x =  this._label.x + this._saveSettings.width/2 - 165 ;
			this._saveSettings.y =  this._label.y + this._label.height - 110

			this._saveSettings.validate()

			this._enterbutton.y  = this._saveSettings.y  + 50
			this._enterbutton.x  = this._saveSettings.x

			this._enterbutton.validate();

			this._resetButton.y  = this._enterbutton.y  +  this._enterbutton.height
			this._resetButton.x  = this._enterbutton.x

			this._resetButton.validate();

			setSizeInternal(this.actualWidth, fullHeight, true);

		}

		override protected function initialize():void
		{
			super.initialize();
            trace(this  + "INITIALIZED ")
//			var bgTexture:Scale9Textures = new Scale9Textures(Main.assets.getTexture("popup_panel"), new Rectangle(60,60,344,229));
			var bgTexture:Scale9Textures = new Scale9Textures(Main.assets.getTexture("button_borderless"), new Rectangle(60,60,344,229));

		    this._bg = new Scale9Image(bgTexture, this._scale);
			addChild(this._bg);

		 	this._label = new Label();
	        this._label.name = "centered-label";
	     	this._label.text = this._message;
        	addChild(this._label);

			this._confirmButton = new Button();
			this._confirmButton.label = this._confirmLabel;
        	this._passwordInputField = new LabelAndInput();
	       //  this._passwordInputField.scale = this.dpiScale;
		 	this._passwordInputField.labelStructure = "left";
		    addChild(this._passwordInputField);
	 	    this._passwordInputField._input.isEnabled = true ;
			this._passwordInputField._input.setFocus()
			this._passwordInputField.isFocusEnabled = true ;
			this._passwordInputField.y -= 200
		    this._passwordInputField.x += 120
			this._saveSettings = new Check();
			this._saveSettings.padding = 0;
			this.addChild(this._saveSettings);
			this._saveSettings.visible = false
			this._saveSettings.validate();

			    this._enterbutton = new Button();

				this._enterbutton.label = "          Sign in          ";
				this._enterbutton.addEventListener(Event.TRIGGERED, confirmButtonHandler);
			    addChild(this._enterbutton);
				trace("this is Enter Button ::: " + this._enterbutton)

				this._resetButton = new Button();
				 this._resetButton.label = "Forgot Password?";

			    addChild(this._resetButton);
			    this._resetButton.visible = false;
				var padding:Number =  15    //  * this.dpiScale;
				this._enterbutton.validate();
				this._resetButton.validate();
				this._enterbutton.x = this.actualWidth * 0.5;
				this._enterbutton.x -= (this._enterbutton.width + this._resetButton.width + padding) * 0.5;
				this._resetButton.x = this._enterbutton.x + this._enterbutton.width + padding;

			    this._enterbutton.y  = this.actualHeight - padding - this._enterbutton.height + 200 ;
				this._resetButton.y  = this.actualHeight - padding + 200;

                this._passwordInputField.displayAsPassword = true;
			    this._passwordInputField._color = "0xFFFFFF"
			//    this._passwordInputField.addEventListener(FocusEvent.FOCUS_IN  , focusIn )


		}

        public function rememberMe( q : Boolean = false){



		}

		private  function focusIn(e:FocusEvent){
          trace("now in Focus ")
			this._passwordInputField._color = "0xFFFFFF"
			this._passwordInputField.validate();

		};



		private function confirmButtonHandler(e:Event):void
		{
			 dispatchEvent(new Event(Event.COMPLETE));
			 e.stopImmediatePropagation();
			this.passController= HivivaPasswordManager.getInstance();

		//	trace("THE PASSWORD IS :::::" + sample.)
         //ToDo :  A singleton class needs to be created for password connection and db connection
         if(  this._passwordInputField._input.text  !== passController.Pass){

            // trace("incorrect password")
			 this._passwordInputField._color = "0x000000"
			 this._passwordInputField.validate()
			 return
		 }


			 this._saveSettings.isSelected ? this.rememberSettings() : this.forgetSettings() ;

			this._saveSettings.invalidate();
			this.removeFromParent(true)
			this.dispose();



		}


	   private function rememberSettings(){

       trace("I CAN REMEMBER EVERYTHING")

		}

		private function forgetSettings(){

        trace("I FORGOT IT ALREADY ")

		}



		private function passwordReminder(){

			trace("this is remond password ")

		}

		public function set scale(value:Number):void
		{
			this._scale = value;
		}

		public function get scale():Number
		{
			return this._scale;
		}

		public function set message(value:String):void
		{
			this._message = value;
		}

		public function get message():String
		{
			return this._message;
		}

		public function set confirmLabel(value:String):void
		{
			this._confirmLabel = value;
		}

		public function get confirmLabel():String
		{
			return this._confirmLabel;
		}
	}
}
