package collaboRhythm.hiviva.view.screens.hcp.messages
{
	import collaboRhythm.hiviva.global.HivivaScreens;

	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;

	import starling.events.Event;

	public class HivivaHCPMessages extends Screen
	{

		private var _messageNav:ScreenNavigator;

		public function HivivaHCPMessages()
		{

		}

		override protected function draw():void
		{
			super.draw();
			initMessageNav();
		}

		override protected function initialize():void
		{
			super.initialize();
		}

		private function initMessageNav():void
		{
			this._messageNav = new ScreenNavigator();
			this._messageNav.addScreen(HivivaScreens.HCP_MESSAGE_INBOX_SCREEN, new ScreenNavigatorItem(HivivaHCPMessageInbox, {messageNavGoDetails:messageNavGoDetails}));
			this._messageNav.addScreen(HivivaScreens.HCP_MESSAGE_SENT_SCREEN, new ScreenNavigatorItem(HivivaHCPMessageSent));
			this._messageNav.addScreen(HivivaScreens.HCP_MESSAGE_COMPOSE_SCREEN, new ScreenNavigatorItem(HivivaHCPMessageCompose));
			this.addChild(this._messageNav);

			this._messageNav.showScreen(HivivaScreens.HCP_MESSAGE_INBOX_SCREEN);
		}

		private function messageNavGoDetails(e:Event):void
		{
			var screenNavProperties:Object = { messageData:e.data};
			if(this._messageNav.hasScreen(HivivaScreens.HCP_MESSAGE_DETAIL_SCREEN))
			{
				this._messageNav.removeScreen(HivivaScreens.HCP_MESSAGE_DETAIL_SCREEN);
			}
			this._messageNav.addScreen(HivivaScreens.HCP_MESSAGE_DETAIL_SCREEN, new ScreenNavigatorItem(HivivaHCPMessageDetail, null, screenNavProperties));
			this._messageNav.showScreen(HivivaScreens.HCP_MESSAGE_DETAIL_SCREEN);
		}
	}
}
