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
        private var __Hiviva_help_help_Screen:Object
		private var btn:Button
		public function ScreenManager(e:Event)
		{
			super();
			btn  =  e.target as Button;
		}

		public function init ( __Hiviva_help_help_Screen:Object =null ){
		    this.__Hiviva_help_help_Screen = __Hiviva_help_help_Screen;
		}

		public function set _sNav(s:ScreenNavigator){
			this.__sNav = s;
		};
				public function  __addScreen(__screen: String){
					trace("MY SCREEN NAME IS  :::: " +  __screen)
					if(setStatus(__screen)){

						return
					}

						var screenNavItem:ScreenNavigatorItem = new ScreenNavigatorItem(this.__Hiviva_help_help_Screen);
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
					case "dailyMedicines" :
						__s = String(HivivaScreens.PATIENT_HELP_DAILY_MEDICINES_SCREEN);
						break;
					case "homepagephoto" :
					    __s = String(HivivaScreens.PATIENT_HELP_HOMEPAGE_PHOTO_SCREEN);
			            break;
					case "connecttocareprovider" :
						__s = String(HivivaScreens.PATIENT_HELP_CONNECT_TO_CARE_PROVIDER_SCREEN);
					    break;

					case "testResults" :
						__s = String(HivivaScreens.PATIENT_HELP_TEST_RESULTS_SCREEN);
					    break;
					case "takeMedicine" :
			            __s = String(HivivaScreens.PATIENT_HELP_TAKE_MEDICINE_SCREEN);
					    break;
					case "seeAdherence" :
					    __s = String(HivivaScreens.PATIENT_HELP_SEE_ADHERENCE_SCREEN);
				       break;
					case "rewards" :
					    __s = String(HivivaScreens.PATIENT_HELP_REWARDS_SCREEN);
					     break;
					case "messages" :
						__s = String(HivivaScreens.PATIENT_HELP_MESSAGES_SCREEN);
					     break;
					case "registerTolerability" :
						__s = String(HivivaScreens.PATIENT_HELP_REGISTER_TOLERABILITY_SCREEN);
						 break;
					case "testResults1" :
					     __s = String(HivivaScreens.PATIENT_HELP_TEST_RESULTS_SCREEN);
						 break;
					case "virusModel" :
						 __s = String(HivivaScreens.PATIENT_HELP_VIRUS_MODEL_SCREEN);
						 break;
					case "pullReports" :
						__s = String(HivivaScreens.PATIENT_HELP_PULL_REPORTS_SCREEN);
						break;
					case "hcpabout" :
						__s = String(HivivaScreens.HCP_HELP_ABOUT_SCREEN);
						break;
					case "hcpprivacy" :
						__s = String(HivivaScreens.HCP_HELP_PRIVACY_SCREEN);
						break;
					case "hcpgettingstarted" :
				    __s = String(HivivaScreens.HCP_HELP_GETTINGSTARTED_SCREEN);

					 break;
					case "hcpwhatcanIdowithhiviva" :
				     __s = String(HivivaScreens.HCP_HELP_WCIDWH_SCREEN);
                    break;
					case "hcphelpdisplaySettings":
						__s = String(HivivaScreens.HCP_HELP_DISPLAY_SETTINGS);
				}
				return __s
			}

		public function setStatus(_searchString:String):Boolean{
		 if(this.__sNav.hasScreen(this.getStatus(_searchString)))
	 				 	{
		 			 trace("this screen already exists ::::::::: " + _searchString )
	 			     this.__sNav.showScreen(this.getStatus(_searchString));
              return true;
		 		  }else{
			 return false;
		 }
		}
	}
}
