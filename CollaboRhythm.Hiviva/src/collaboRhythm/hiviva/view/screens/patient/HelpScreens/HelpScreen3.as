package collaboRhythm.hiviva.view.screens.patient.HelpScreens
{
	import collaboRhythm.hiviva.view.screens.patient.HivivaPatientHelpScreen;
	import feathers.controls.ScreenNavigator;
	import collaboRhythm.hiviva.global.HivivaScreens;
	import feathers.controls.ScreenNavigatorItem;
	public class HelpScreen3 extends HivivaPatientHelpScreen implements IhelpScreen
	{

	        	private var __screenName : String;
				private var __sNav : ScreenNavigator;
				private var __HivivaPatient_help_help_Screen:Object
		public function HelpScreen3(__sNav: ScreenNavigator   , __HivivaPatient_help_help_Screen:Object =null )
		{
			super();

			this.__sNav = __sNav;
		    this.__HivivaPatient_help_help_Screen = __HivivaPatient_help_help_Screen;
		}

		public function set__screenName(scr : String){

				this.__screenName = scr;

			}

			public function get__screenName():String{


	           return this.__screenName;
			}

		public function  __addScreen(){

				//temp = String(HivivaScreens.PATIENT_HELP_HELP1_SCREEN);
				var screenNavItem2:ScreenNavigatorItem = new ScreenNavigatorItem(this.__HivivaPatient_help_help_Screen);
				this.__sNav.addScreen(HivivaScreens.PATIENT_HELP_HELP2_SCREEN, screenNavItem2);



			}

			public function __showScreen(){

				this.__sNav.showScreen(HivivaScreens.PATIENT_HELP_HELP1_SCREEN);


			}



	}
}
