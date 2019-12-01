void controlEvent(ControlEvent theEvent) 
{
  
  if(theEvent.isGroup()) 
  {
      return;       
  } 
  else if(theEvent.isController())
  {
    switch(theEvent.controller().id()) 
    {
        case(0):
        particleCount = (int)theEvent.controller().value();
        break;
    
        case(1):
        tailLength = (int)theEvent.controller().value();
        break;  
    
        case(2):
        vlimit = theEvent.controller().value();
        break;
    
        case(3):
        radius = theEvent.controller().value();
        break;  

        case(4):
        sigma = theEvent.controller().value();
        break;  
    
        case(5):
        rho = theEvent.controller().value();
        break;
    
        case(6):
        beta = theEvent.controller().value();
        break;  

        case(7):
        saveFrame("Lormalized radius-" + radius +" sigma-" +sigma + " rho-" + rho + " beta-" + beta + "frame-####.png"); 
        return; 

        case(8):
        resetSystem(); 
        return; 
        
        default:
        break;
      }
  }
}

void resetSystem()
{  
  particleCount = 25000; 
  tailLength = 10; 
  vlimit = 250; 
  radius = 400; 
  sigma = 10.0;
  rho = 28;
  beta = 18.0/3.0;
  updateGUI();   
  cam.lookAt(0,0,0,1000, 0);
}

void updateGUI()
{
  controlP5.controller("PARTICLES").setValue(particleCount);
  controlP5.controller("TAIL-LENGTH").setValue(tailLength);
  controlP5.controller("VELOCITY LIMIT").setValue(vlimit);
  controlP5.controller("SPHERE RADIUS").setValue(radius);
  controlP5.controller("SIGMA").setValue(sigma);
  controlP5.controller("RHO").setValue(rho);
  controlP5.controller("BETA").setValue(beta);
}
