
import oscP5.*;
import netP5.*;


OscP5 oscP5;
NetAddress myRemoteLocation;

void setupOSC() {
 
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,8000);
  
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
}
