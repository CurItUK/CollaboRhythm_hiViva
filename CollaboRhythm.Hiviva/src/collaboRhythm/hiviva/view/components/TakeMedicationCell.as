package collaboRhythm.hiviva.view.components
{
	import feathers.controls.Check;
	import feathers.controls.Label;

	import starling.events.Event;

	public class TakeMedicationCell extends MedicationCell
	{
		private var _doseDetailsLabel:Label;
		private var _doseDetails:String;
		private var _checkBox:Check;
		private var _isChanged:Boolean;

		public function TakeMedicationCell()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._doseDetailsLabel.x = this._pillImageBg.x + this._pillImageBg.width + this._gap;
			this._doseDetailsLabel.y = this._genericNameLabel.y + this._genericNameLabel.height;
			this._doseDetailsLabel.width = this._bg.width - this._pillImageBg.x;

			this._checkBox.validate();
			this._checkBox.x = (this._bg.x + this._bg.width) - this._gap - this._checkBox.width;
			this._checkBox.y = this._bg.y + (this._bg.height * 0.5) - (this._checkBox.height * 0.5);
		}

		override protected function initialize():void
		{
			super.initialize();

			this._doseDetailsLabel = new Label();
			this._doseDetailsLabel.text = this._doseDetails;
			this.addChild(this._doseDetailsLabel);

			this._checkBox = new Check();
			this._checkBox.padding = 0;
			this.addChild(this._checkBox);

			this._isChanged = false;
		}

		public function get doseDetails():String
		{
			return _doseDetails;
		}

		public function set doseDetails(value:String):void
		{
			_doseDetails = value;
		}

		public function get isChanged():Boolean
		{
			return _isChanged;
		}

		public function set isChanged(value:Boolean):void
		{
			_isChanged = value;
		}

		public function get checkBox():Check
		{
			return _checkBox;
		}

		public function set checkBox(value:Check):void
		{
			_checkBox = value;
		}
	}
}
