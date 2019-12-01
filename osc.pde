void oscHandShake() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/cue");
  myMessage.add(0.0); /* add an int to the osc message */
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {

  if(theOscMessage.checkAddrPattern("/BEAT")==true) {       
      randomizeSystem();  
      randomize = false; 
      return; 
  }  

 if(theOscMessage.checkAddrPattern("/TRIG")==true) {       
      randomize = !randomize; 
      return; 
  }  

 if(theOscMessage.checkAddrPattern("/PLOT")==true) {       
     radius=random(1000);
     return; 
  }  

 if(theOscMessage.checkAddrPattern("/MODE")==true) {       
   cam.lookAt(0,0,0, random(1000),10);
   return; 
 }
 if(theOscMessage.checkAddrPattern("/CUT")==true) {       
     randomizeLorenz(); 
     return; 
  }  

  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}
