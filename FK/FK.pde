Bone bone = new Bone(5);

Bone draggedBone;

float time = 0; //how many sec. have passed since the app has began

void setup()
{

  size(600, 600);

  //bone.child = new Bone();
  //bone.child.parent = bone; //sets the childs bones parents property
}

// ticks every 1/60th of a second
void draw()
{
  background(128);

  time = millis()/1000.0;

  if (draggedBone != null) draggedBone.drag();

  bone.calc();
  bone.draw();
}

void mousePressed()
{


  Bone clickedBone = bone.OnClick();

  if (Keys.SHIFT())
  {
    if(clickedBone != null){
     clickedBone.AddBone(2); 
    }
    
  } else {
    draggedBone = clickedBone;
  }
}

void mouseReleased()
{
  draggedBone = null;
}
