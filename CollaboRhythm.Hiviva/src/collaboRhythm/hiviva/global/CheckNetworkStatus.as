package collaboRhythm.hiviva.global
{

	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;

	public class CheckNetworkStatus
	{

		private var con : Boolean  = false ;
		var results:Vector.<NetworkInterface> =  NetworkInfo.networkInfo.findInterfaces();
      /**
	 * Returns network connection status as a Boolean
	 * true if connected and false if not
	 */
        public function get status():Boolean{
		        this.results =  NetworkInfo.networkInfo.findInterfaces();
				var network:NetworkInfo = NetworkInfo.networkInfo;

		/*  for (var i:int=0; i<results.length; i++)
		     {
				 trace("connection results is  :::: " +  results[i].active )
				 if(Boolean(results[int(i)].active)){

					 this.con = true
			         trace("con is " + this.con)
				 }else {

					 this.con  = false;

				 }
			 }*/
		  for each (var interfaceObj:NetworkInterface in results)
		  {

		      // Access interfaceObj.name, interfaceObj.displayName, interfaceObj.active,
		      // interfaceObj.hardwareAddress, and interfaceObj.mtu
			  if(Boolean(interfaceObj.active)){

								 this.con = true
						         trace("con is " + this.con)
							 }else {

								 this.con  = false;

							 }
		   /*   for each(var address:InterfaceAddress in interfaceObj.addresses)
		      {
		          // Access address.address, address.broadcast, address.ipVersion, and address.prefixLength
		      }*/
		  }


//		 		for each (var object:NetworkInterface in network.findInterfaces())
//				{
//		 		 trace(this ,  "NETWORK DETAILS ARE  :::::  " , object.name, object.active);
//				if(object.active){
//
//					this.con = true
//                  trace("con is " + this.con)
//
//				}else{
//
//                    this.con  = false;
//				}
//
//		          }

		   return this.con;


		}









	}
}
