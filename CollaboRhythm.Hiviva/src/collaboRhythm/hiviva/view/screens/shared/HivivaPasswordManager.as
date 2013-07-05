 package collaboRhythm.hiviva.view.screens.shared  {
	 import collaboRhythm.hiviva.global.Constants;

	 public class HivivaPasswordManager {

    private static var INSTANCE: HivivaPasswordManager = null;
	private var _pass : String = Constants.DEFAULT_PASSWORD_FOR_DEBUGGING;
	    /**
		 * Gets singleton instance of the password manager.
		 */
    public static function getInstance (): HivivaPasswordManager {
      if (INSTANCE == null)
        INSTANCE = new HivivaPasswordManager( new SingletonEnforcer() );
      return INSTANCE;
    }

    public function HivivaPasswordManager (enforcer:SingletonEnforcer) {
       // trace("new instance of HivivaPasswordManager created")
		if(!enforcer){
			throw new Error("Only one instance of Singleton Class allowed.")
		};
    }

	public function get Pass():String{

	          return _pass;
	}

		 /**
		  * Sets the new password in singleton class
		  * @param   newPass is the new password string
		  */
	   public function set Pass(newPass:String):void{
				  _pass =newPass;
	   }


  }
 }

 internal class SingletonEnforcer {

   public function SingletonEnforcer () {}

 }

