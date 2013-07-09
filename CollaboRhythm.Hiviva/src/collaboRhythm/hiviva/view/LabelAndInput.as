package collaboRhythm.hiviva.view
{
	import collaboRhythm.hiviva.global.HivivaThemeConstants;

	import feathers.controls.Label;
	import feathers.controls.TextInput;
	import feathers.core.FeathersControl;


	public class LabelAndInput extends  FeathersControl
	{

		private var _scale:Number = 1;
		private var _isPassword: Boolean  = false;
		private var __color : String

		public function set scale(value:Number):void
		{
			this._scale = value;
		}
		public function get scale():Number
		{
			return this._scale;
		}

		// "left", "right", "leftAndRight"
		private var _labelStructure:String;
		public function set labelStructure(value:String):void
		{
			this._labelStructure = value;
		}
		public function get labelStructure():String
		{
			return this._labelStructure;
		}




		public var _labelLeft:Label;
		public var _labelRight:Label;
		public var _input:TextInput;

		private const PADDING:Number = 32;

		public function LabelAndInput()
		{
			super();

		}

		//TODO: this part needs to be modified if new feathers is used
        /**
	     * Display as password added to be able to access properties directly.
		 * use accesors and modifiers to update the label field
		 * @see http://wiki.starling-framework.org/feathers/text-input
		 * @see feathers.core.ITextEditor
		**/
		public function set displayAsPassword( b: Boolean ):void
		{

			this._isPassword = b ;
		};

        //TODO: this part needs to be modified if new feathers is used
		/**
        * Display as password added to be able to access properties directly.
		 * use accesors and modifiers to update the label field
		 * @see http://wiki.starling-framework.org/feathers/text-input
         * @see feathers.core.ITextEditor
         **/
         public function get displayAsPassword():Boolean
         {
         return this._isPassword;
         };




		//TODO: this part needs to be modified if new feathers is used
		        /**
			     * Display as password added to be able to access properties directly.
				 * use accesors and modifiers to update the label field
				 * @see http://wiki.starling-framework.org/feathers/text-input
				 * @see feathers.core.ITextEditor
				**/
				public function set _color( b: String ):void
				{

					this.__color = b ;
				};

    //TODO: this part needs to be modified if new feathers is used
		/**
        * Display as password added to be able to access properties directly.
		 * use accesors and modifiers to update the label field
		 * @see http://wiki.starling-framework.org/feathers/text-input
         * @see feathers.core.ITextEditor
         **/
         public function get _color():String
         {
         return this.__color;
         };







		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this._scale;
			var fullHeight:Number;

			super.draw();

			this._input.textEditorProperties.displayAsPassword =  this._isPassword;
			if(this.__color != null )
			this._input.textEditorProperties.color =  this.__color

			this._input.validate();









			switch(this._labelStructure)
			{
				case "left" :
					this._input.x = this.actualWidth - this._input.width;
					this._labelLeft.validate();
					this._labelLeft.y = (this._input.y + this._input.height / 2) - (this._labelLeft.height / 2);
					fullHeight = this._input.height > this._labelLeft.height ? this._input.height : this._labelLeft.height;
					break;
				case "right" :
					this._labelRight.validate();
					this._labelRight.x = this.actualWidth - this._labelRight.width;
					this._labelRight.y = (this._input.y + this._input.height / 2) - (this._labelRight.height / 2);
					fullHeight = this._input.height > this._labelRight.height ? this._input.height : this._labelRight.height;
					break;
				default :
					//case "leftAndRight" : this._input.x needs to be set externally
					this._labelLeft.validate();
					this._labelLeft.x = this._input.x - this._labelLeft.width - scaledPadding;
					this._labelRight.validate();
					this._labelRight.x = this._input.x + this._input.width + scaledPadding;
					this._labelLeft.y = (this._input.y + this._input.height / 2) - (this._labelLeft.height / 2);
					this._labelRight.y = (this._input.y + this._input.height / 2) - (this._labelRight.height / 2);
					fullHeight = this._input.height > this._labelLeft.height ? this._input.height : this._labelLeft.height;
					break;
			}

			//fullHeight += (scaledPadding * 0.75);

			setSizeInternal(this.actualWidth, fullHeight, true);
		}

		override protected function initialize():void
		{
			super.initialize();

			this._input = new TextInput();

			addChild(this._input);

			createLabels();
		}

		private function createLabels():void
		{
			switch(this._labelStructure)
			{
				case "left" :
					this._labelLeft = new Label();
					this._labelLeft.name = HivivaThemeConstants.INPUT_LABEL_LEFT;
					addChild(this._labelLeft);
					break;
				case "right" :
					this._labelRight = new Label();
					this._labelRight.name = HivivaThemeConstants.INPUT_LABEL_RIGHT;
					addChild(this._labelRight);
					break;
				default :
					//case "leftAndRight" :
					this._labelLeft = new Label();
					this._labelRight = new Label();
					this._labelLeft.name = HivivaThemeConstants.INPUT_LABEL_LEFT;
					this._labelRight.name = HivivaThemeConstants.INPUT_LABEL_RIGHT;
					addChild(this._labelLeft);
					addChild(this._labelRight);
					break;
			}
		}
	}
}
