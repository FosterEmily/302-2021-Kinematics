class Bone
{

  //properties??

  //relative direction the bone points, radian
  //if 0, then this bone points the same way as parent
  float dir = random( -1, 1);

  //length of the bone, in pixels
  float mag = random(50, 150);

  //refrences to parent and child bones:
  //(implementing linked lists)
  Bone parent;
  ArrayList<Bone> children = new ArrayList<Bone>();


  boolean isRevolute = true;
  boolean isPrismatic = true;
  
  float wiggleOffset = random(0,6.28);
  float wiggleAmp = random(.5f, 2);
  float wiggleTimeScale = random(.25, 1);


  //cached / derived values:
  PVector worldStart; // start of bone in world space
  PVector worldEnd;// end of bone in world space
  float worldDir = 0; // world space angle of the bone
  
  //how deep in the armature(tree structure) this bone is
  int boneDepth = 0;

  Bone(Bone parent)
  {
      this.parent = parent;
      
      int num = 0;
      Bone p = parent;
      while(p != null)
      {
        num++;
      p = p.parent;
      }
      boneDepth = num;
  }



  Bone( int chainLenght) {
    if (chainLenght > 1 ) {
        AddBone(chainLenght -1);
    }
  }

  void AddBone(int chainLenght)
  {
    if (chainLenght < 1) chainLenght = 1;
    
    int numOfChildren = (int)random(1,4);
    
    for(int i = 0; i < numOfChildren; i++){
    Bone newBone = new Bone(this);
    children.add(newBone);
    //newBone.parent = this;

    if (chainLenght > 1) {
      newBone.AddBone(chainLenght - 1);
    }
    }
    
  }

  void draw()
  {

    text(boneDepth, worldStart.x, worldStart.y - 30);
    
    //TODO: draw line (bone start) to (bone end)
    line(worldStart.x, worldStart.y, worldEnd.x, worldEnd.y);

    fill(100, 100, 100);
    ellipse(worldStart.x, worldStart.y, 20, 20);

    for (Bone child : children) child.draw();


    fill(150, 150, 150);
    ellipse(worldEnd.x, worldEnd.y, 10, 10);
  }

  void calc()
  {
    //calc (bone start)

    //if parent, then "worldStart" = "parent.worldEnd"
    if (parent != null) 
    {
      worldStart = parent.worldEnd;
      worldDir = parent.worldDir + dir;
    }
     else// if we dont have a parent set to default
    {
      worldStart = new PVector(100, 100);
      worldDir = dir;
    }
    
    //worldDir += sin(time) * (boneDepth +1 ) / 5.0;
    worldDir += sin((time + wiggleOffset)* wiggleTimeScale) * wiggleAmp;

    //Calc (bone End) 
    PVector localEnd = PVector.fromAngle(worldDir); //new PVector(mag * cos(worldDir), mag * sin(worldDir));
    localEnd.mult(mag);

    worldEnd = PVector.add(worldStart, localEnd);

    for (Bone child : children) child.calc();
  }

  Bone OnClick()
  {

    PVector mouse = new PVector(mouseX, mouseY);
    PVector vToMouse = PVector.sub(mouse, worldEnd);
    if (vToMouse.magSq() < 20 * 20 ) return this;// if did to mouse is < 2px return this

    for (Bone child : children)
    {

      Bone b = child.OnClick();

      if (b != null) return b;
    }

    return null;
  }

  void drag()
  {

    PVector mouse = new PVector(mouseX, mouseY);
    PVector vToMouse = PVector.sub(mouse, worldStart);

    if (isRevolute) {
      if (parent!= null)
      {
        dir =  vToMouse.heading() - parent.worldDir; //atan2(vToMouse.y, vToMouse
      } 
      else
      {
        dir = vToMouse.heading();
      }
    }

    if (isPrismatic) mag = vToMouse.mag();
  }
}
