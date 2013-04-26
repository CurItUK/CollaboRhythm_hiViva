package source.themes
{
	import feathers.controls.Header;
	import feathers.controls.Label;

	public class HivivaHeader extends Header
	{
		private var _titleHolder1:Label;
		private var _titleHolder2:Label;

		public function HivivaHeader()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();
			drawTrueTitle();
		}

		override protected function initialize():void
		{
			super.initialize();
			initTrueTitle();
		}

		private function initTrueTitle():void
		{
			var splitText:Array = this.title.split(" ",2);
			this._titleHolder1 = new Label();
			this._titleHolder1.name = "header-light";
			this._titleHolder1.text = splitText[0];
			this._titleHolder2 = new Label();
			this._titleHolder2.name = "header-bold";
			this._titleHolder2.text = " " + splitText[1];
			addChild(this._titleHolder1);
			addChild(this._titleHolder2);
		}

		private function drawTrueTitle():void
		{
			if(this.title != "")
			{
				this._titleHolder1.validate();
				this._titleHolder2.validate();
				this.validate();
				var trueTitleHeight:Number = this._titleHolder1.height > this._titleHolder2.height ? this._titleHolder1.height : this._titleHolder2.height;
				var trueTitleWidth:Number = this._titleHolder1.width + this._titleHolder2.width;
				this._titleHolder1.x = (this.actualWidth / 2) - (trueTitleWidth / 2);
				this._titleHolder2.x = this._titleHolder1.x + this._titleHolder1.width;
				this._titleHolder1.y = this._titleHolder2.y = (this.actualHeight / 2) - (trueTitleHeight / 2);
				this.title = "";
			}
		}

		override public function set title(value:String):void
		{
			if(value === null)
			{
				value = "";
			}
			if(this._title == value)
			{
				return;
			}
			this._title = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
	}
}
