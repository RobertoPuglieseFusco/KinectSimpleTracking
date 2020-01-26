// need to fix the depthToWorld Transformation of the Points

// NOW IT IS JUST AN APPROXIMATION !!!


import controlP5.*;

ControlP5 cp5;

boolean toggleGui = true;

boolean debug = false;

int[] depth;

PFont font;

void setup() {
  size(640, 360, P3D);

  setupKinect();

  cp5 = new ControlP5(this);
  setupControlsUI();

  com = new PVector(0, 0);

  cp5.loadProperties(dataPath("") + "/default.ser");

  setupOSC();

  font = createFont("ArialMT", 32);
  textFont(font);
}

void draw() {

  background(0);
  // Get the raw depth as array of integers
  depth = kinect.getRawDepth();

  drawKinect();
}

// Adjust the maxThreshold with key presses
void keyPressed() {
  int t = tracker.getmaxThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setmaxThreshold(t);
    } else if (keyCode == DOWN) {
      t-=5;
      tracker.setmaxThreshold(t);
    }
  }
  switch(key) {
  case 'l':
    // loads the saved layout

    cp5.loadProperties(dataPath("") + "/default.ser");
    println("loaded preset");
    break;

  case 's':
    // saves the layout

    cp5.saveProperties(dataPath("") + "/default", "default");
    println("saved preset");
    break;
  case 'g':
    toggleGui=!toggleGui;
    break;
  case 'd':

    debug=!debug;
    break;
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(trackingPlane)) {
    print("got an event from "+theEvent.getName()+"\t");
    for (int i=0; i<theEvent.getGroup().getArrayValue().length; i++) {
      print(int(theEvent.getGroup().getArrayValue()[i]));
    }
    println("\t "+theEvent.getValue());
    XY_XZ_YZ = int(theEvent.getGroup().getValue());
  }
  if (theEvent.isFrom(trackingMethod)) {
    print("got an event from "+theEvent.getName()+"\t");
    for (int i=0; i<theEvent.getGroup().getArrayValue().length; i++) {
      print(int(theEvent.getGroup().getArrayValue()[i]));
    }
    println("\t "+theEvent.getValue());
    tracking = int(theEvent.getGroup().getValue());
  }
}
