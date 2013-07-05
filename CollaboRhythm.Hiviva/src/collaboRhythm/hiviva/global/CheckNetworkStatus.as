package collaboRhythm.hiviva.global
{

	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;

	public class CheckNetworkStatus
	{

		private var con : Boolean  = false ;
      /**
	 * Returns network connection status as a Boolean
	 * true if connected and false if not
	 */
        public function get status():Boolean{
			var network:NetworkInfo = NetworkInfo.networkInfo;
		 		for each (var object:NetworkInterface in network.findInterfaces())
				{
		 		 trace(this ,  "NETWORK DETAILS ARE  :::::  " , object.name, object.active);
				if(object.active){

					this.con = true
                  trace("con is " + this.con)

				}else{

                    this.con  = false;
				}

		          }

		   return this.con;


		}









	}
}
