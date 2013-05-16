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
		private var _isTaken:Boolean;

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
			this._checkBox.x = (this._bg.x + this._bg.width) - this._gap;
			this._checkBox.y = (this._bg.height * 0.5) - (this._checkBox.height * 0.5);
		}

		override protected function initialize():void
		{
			super.initialize();

			this._doseDetailsLabel = new Label();
			this._doseDetailsLabel.text = this._doseDetails;
			this.addChild(this._doseDetailsLabel);

			this._checkBox = new Check();
			this._checkBox.isSelected = false;
			this._checkBox.addEventListener(Event.CHANGE, checkBoxChangeHandler);
			this.addChild(this._checkBox);
		}

		private function checkBoxChangeHandler(e:Event = null):void
		{
			this._checkBox.removeEventListener(Event.CHANGE, checkBoxChangeHandler);

			var evt:Event = new Event(Event.CHANGE);
			dispatchEvent(evt);
		}

		public function get doseDetails():String
		{
			return _doseDetails;
		}

		public function set doseDetails(value:String):void
		{
			_doseDetails = value;
		}

		public function get isTaken():Boolean
		{
			_isTaken = this._checkBox.isSelected;
			return _isTaken;
		}

		public function set isTaken(value:Boolean):void
		{
			_isTaken = this._checkBox.isSelected = value;
			if(_isTaken)
			{
				checkBoxChangeHandler();
			}
		}
	}
}
