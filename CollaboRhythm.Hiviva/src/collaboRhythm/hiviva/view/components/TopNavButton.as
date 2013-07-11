package collaboRhythm.hiviva.view.components
{
	import collaboRhythm.hiviva.view.Main;
	import collaboRhythm.hiviva.view.media.Assets;

	import feathers.controls.Button;

	import source.themes.HivivaTheme;

	import starling.display.Image;
	import starling.display.Quad;

	public class TopNavButton extends Button
	{
		private var _icon:Image;
		private var _hivivaImage:Image;
		private var _subScript:String = "";
		private var _subScriptCircle:SubscriptCircle;

		public function TopNavButton()
		{
			super();
		}

		override protected function draw():void
		{
			super.draw();

			this._subScriptCircle.validate();
			this._subScriptCircle.x = (this._icon.width * 0.5) - (this._subScriptCircle.width * 0.5);
			this._subScriptCircle.y = (this._icon.height * 0.5) - (this._subScriptCircle.height * 0.5);
		}

		override protected function initialize():void
		{

			super.initialize();

			this.name = HivivaTheme.NONE_THEMED;

			this._icon = this._hivivaImage;

			var icon:Quad = new Quad(this._icon.width,this._icon.height,0x000000);
			icon.alpha = 0;
			this.defaultIcon = icon;

			this.addChild(this._icon);

			this._subScriptCircle = new SubscriptCircle();
			this._subScriptCircle.text = this._subScript;
			this.addChild(this._subScriptCircle);
			this._subScriptCircle.visible = this._subScript.length > 0;
		}

		public function get hivivaImage():Image
		{
			return _hivivaImage;
		}

		public function set hivivaImage(value:Image):void
		{
			_hivivaImage = value;
		}

		public function get subScript():String
		{
			return _subScript;
		}

		public function set subScript(value:String):void
		{
			_subScript = value;
			if(this._subScriptCircle != null)
			{
				this._subScriptCircle.text = value;
				this._subScriptCircle.visible = this._subScript.length > 0;
				this._subScriptCircle.validate();
			}
		}
	}
}
