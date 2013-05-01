package collaboRhythm.hiviva.view
{
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	import feathers.core.FeathersControl;

	public class LabelAndInput extends FeathersControl
	{
		private var _scale:Number;
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

		private static const PADDING:Number = 20;
		private static const GAP:Number = 10;

		public function LabelAndInput()
		{
			super();
		}

		override protected function draw():void
		{
			var scaledPadding:Number = PADDING * this._scale;
			var scaledGap:Number = GAP * this._scale;
			var fullHeight:Number;

			super.draw();

			this._input.validate();

			switch(this._labelStructure)
			{
				case "left" :
					this._labelLeft.validate();
					this._labelLeft.x = scaledPadding;
					this._input.x = this._labelLeft.x + this._labelLeft.width + scaledGap;
					break;
				case "right" :
					this._input.x = scaledPadding;
					this._labelRight.validate();
					this._labelRight.x = this._labelLeft.x + this._labelLeft.width + scaledGap;
					break;
				default :
					//case "leftAndRight" :
					this._labelLeft.validate();
					this._labelRight.validate();
					break;
			}
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
					this._labelLeft.name = "input-label";
					addChild(this._labelLeft);
					break;
				case "right" :
					this._labelRight = new Label();
					this._labelRight.name = "input-label";
					addChild(this._labelRight);
					break;
				default :
					//case "leftAndRight" :
					this._labelLeft = new Label();
					this._labelRight = new Label();
					this._labelLeft.name = "input-label";
					this._labelRight.name = "input-label";
					addChild(this._labelLeft);
					addChild(this._labelRight);
					break;
			}
		}

		private function layoutLabels():void
		{
			switch(this._labelStructure)
			{
				case "left" :
					this._labelLeft.validate();
					this._input.x =
					break;
				case "right" :
					this._labelRight.validate();

					break;
				default :
					//case "leftAndRight" :
					this._labelLeft.validate();
					this._labelRight.validate();
					break;
			}
		}
	}
}
