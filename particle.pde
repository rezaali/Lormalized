class particle
{
  PVector loc; 
  PVector vec; 
  PVector[] tail;

  particle()
  {
    loc = new PVector(random(-radius,radius),random(-radius,radius),random(-radius,radius));
    loc.normalize(); 
    loc.mult(radius);

    vec = new PVector(0,0,0); 
    tail = new PVector[100];

    for(int i = 0; i < 100; i++)
    {
      tail[i] = new PVector();
    }    

  }

  void run()
  {
    if(up)
    { 
      for(int i = tailLength-1; i >= 0; i--)
      {
        if(i-1 == -1)
        {
          tail[i].set(loc); 
        }
        else
        {    
          tail[i].set(tail[i-1]); 
        }
      }
      this.update();
    }
  }

  void draw()
  {    
  gl.glBegin(gl.GL_LINE_STRIP);    
    gl.glColor4f(0,0,0,.1);
    gl.glVertex3f(loc.x,loc.y,loc.z); 
    for(int i = 1; i < tailLength; i++)
    {
      gl.glColor4f(0,0,0,.1);
      gl.glVertex3f(tail[i].x,tail[i].y,tail[i].z);
    }
  gl.glEnd();       
  }

  void update()
  {    

    vec.set(sigma*(loc.y-loc.x), loc.x*(rho-loc.z)-loc.y, loc.x*loc.y-beta*loc.z);   
    vec.limit(vlimit); 
    loc.add(vec);

    loc.normalize(); 
    loc.mult(radius); 

    if(keyPressed)
    {
      if(key == 'r' || key == 'R')
      {
         randomizeParticleLocation(); 
      }
    }
    if(randomize)
    {
      randomizeParticleLocation();
    }    
  }
  void randomizeParticleLocation()
  {
       loc.set(random(-radius,radius),random(-radius,radius),random(-radius,radius));
        loc.normalize(); 
        loc.mult(radius);  
  }
}

