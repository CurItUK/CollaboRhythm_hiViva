package collaboRhythm.hiviva.view.screens.patient.HelpScreens
{
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientHelpScreen;
	import feathers.controls.ScreenNavigator;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import feathers.controls.ScreenNavigatorItem;
	import starling.events.Event;
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	public class ScreenManager extends HivivaPatientHelpScreen
	{
		private var __screenName : String;
        private var __sNav : ScreenNavigator;
        private var __HivivaPatient_help_help_Screen:Object
		private var btn:Button
		public function ScreenManager(e:Event)
		{
			super();
			btn  =  e.target as Button;
		}

		public function init ( __HivivaPatient_help_help_Screen:Object =null ){
		    this.__HivivaPatient_help_help_Screen = __HivivaPatient_help_help_Screen;
		}

		public function set _sNav(s:ScreenNavigator){
			this.__sNav = s;
		};
				public function  __addScreen(__screen: String){
						var screenNavItem:ScreenNavigatorItem = new ScreenNavigatorItem(this.__HivivaPatient_help_help_Screen);
						this.__sNav.addScreen(__screen, screenNavItem);
					    this.__sNav.showScreen(__screen);
					trace("screen added  ::::: ")
					}

		public function getStatus(s:String):String{
				 var __s:String
				switch(s)
						{
					case "about" :
					__s = String(HivivaScreens.PATIENT_HELP_ABOUT_SCREEN);
						break;
					case "privacy" :
						__s = String(HivivaScreens.PATIENT_HELP_PRIVACY_SCREEN);
					break;
					case "gettingstarted" :
						__s = String(HivivaScreens.PATIENT_HELP_GETTINGSTARTED_SCREEN);
						break;
					case "whatcanIdowithhiviva" :
						__s = String(HivivaScreens.PATIENT_HELP_WCIDWH_SCREEN);
						break;

				}
				return __s
			}

		public function setStatus(_searchString:String):Boolean{
		 if(this.__sNav.hasScreen(this.getStatus(_searchString)))
	 				 	{
		 			 trace("this screen already exists ::::::::: ")
	 			     this.__sNav.showScreen(this.getStatus(_searchString));
              return true;
		 		  }else{
			 return false;
		 }
		}
	}
}
