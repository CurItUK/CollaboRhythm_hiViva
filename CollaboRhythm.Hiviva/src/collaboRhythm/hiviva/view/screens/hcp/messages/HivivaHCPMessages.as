package collaboRhythm.hiviva.view.screens.hcp.messages
{
	import collaboRhythm.hiviva.controller.HivivaAppController;
	import collaboRhythm.hiviva.controller.HivivaApplicationController;
	import collaboRhythm.hiviva.controller.HivivaLocalStoreController;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import collaboRhythm.hiviva.view.screens.hcp.messages.HivivaHCPMessageCompose;
	import collaboRhythm.hiviva.view.screens.hcp.messages.HivivaHCPMessageDetail;
	import collaboRhythm.hiviva.view.screens.hcp.messages.HivivaHCPMessageInbox;
	import collaboRhythm.hiviva.view.screens.hcp.messages.HivivaHCPMessageSent;

	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;

	import starling.animation.Transitions;
	import starling.events.Event;


	public class HivivaHCPMessages extends Screen
	{
		private var _footerHeight:Number;
		private var _messageNav:ScreenNavigator;

		public function HivivaHCPMessages()
		{

		}

		override protected function draw():void
		{
			super.draw();
		}

		override protected function initialize():void
		{
			super.initialize();

			initMessageNav();
		}

		private function initMessageNav():void
		{

			this._messageNav = new ScreenNavigator();
			this._messageNav.addScreen(HivivaScreens.HCP_MESSAGE_INBOX_SCREEN, new ScreenNavigatorItem(HivivaHCPMessageInbox, {messageNavGoDetails:messageNavGoDetails}));
			this._messageNav.addScreen(HivivaScreens.HCP_MESSAGE_SENT_SCREEN, new ScreenNavigatorItem(HivivaHCPMessageSent));
			this._messageNav.addScreen(HivivaScreens.HCP_MESSAGE_COMPOSE_SCREEN, new ScreenNavigatorItem(HivivaHCPMessageCompose));
			this.addChild(this._messageNav);

			var transitionMgr:ScreenSlidingStackTransitionManager = new ScreenSlidingStackTransitionManager(this._messageNav);
			transitionMgr.ease = Transitions.EASE_OUT;
			transitionMgr.duration = 0.4;

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
