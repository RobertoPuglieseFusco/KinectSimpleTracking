// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// The kinect stuff is happening in another class
KinectTracker tracker;
Kinect kinect;

PVector v2;
PVector com  = new PVector();

// Angle for rotation
float a = 0;

// We'll use a lookup table so that we don't have to repeat the math over and over
float[] depthLookUp = new float[2048];

void setupKinect() {

  kinect = new Kinect(this);
  kinect.initDepth();

  // Lookup table for all possible depth values (0 - 2047)
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
  tracker = new KinectTracker();
}

// These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

PVector depthToWorld(int x, int y, int depthValue) {

  final double fx_d = 1.0 / 5.9421434211923247e+02;
  final double fy_d = 1.0 / 5.9104053696870778e+02;
  final double cx_d = 3.3930780975300314e+02;
  final double cy_d = 2.4273913761751615e+02;

  PVector result = new PVector();
  double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}


void drawKinect() {

  //------------------------------------
  // CORRECT WAY STARTS HERE
  if (tracking == 1) {

    // Being overly cautious here
    if (depth == null) return;

    // We're just going to calculate and draw every 4th pixel (equivalent of 160x120)
    int skip = 6;

    float sumX = 0;
    float sumY = 0;
    float sumZ = 0;
    float count = 0;

    // Translate and rotate
    //translate(width/2, height/2, -50);
    //rotateY(a);

    for (int x = 0 + leftCrop; x < kinect.width - rightCrop; x += skip) {
      for (int y = 0 + topCrop; y < kinect.height - bottomCrop; y += skip) {
        int offset = x + y*kinect.width;

        // Convert kinect data to world xyz coordinate
        int rawDepth = depth[offset];

        PVector v = depthToWorld(x, y, rawDepth);

        // Testing against threshold
        if (minThreshold < rawDepth && rawDepth < maxThreshold) {
          sumX += v.x;
          sumY += v.y;
          sumZ += rawDepth;
          count++;
        }

        // As long as we found something
        if (count >= trackingThreshold) {
          com.set(sumX/count, sumY/count, sumZ/count);
        } else {
          com.set(0, 0, 0);
        }

        OscMessage myMessage = new OscMessage("/CoMCalibrated");

        myMessage.add(com.x); /* add an int to the osc message */
        myMessage.add(com.y); /* add an int to the osc message */
        myMessage.add(com.z); /* add an int to the osc message */
        /* send the message */
        oscP5.send(myMessage, myRemoteLocation); 

        //stroke(255);
        //pushMatrix();
        //// Scale up by 200
        //float factor = 200;
        //translate(v.x*factor, v.y*factor, factor-v.z*factor);
        //// Draw a point
        //point(0, 0);
        //popMatrix();
      }
    }

    // Rotate
    //  a += 0.015f;
  }

  //------------------------------------
  // APPROXIMATED WAY STARTS HERE

  // Run the tracking analysis
  else if (tracking == 2) {
    tracker.track2D();
  }

  // Show the image
  if (toggleGui) {
    tracker.display();
  }

  // Let's draw the raw location
  PVector v1 = tracker.getPos();

  OscMessage myMessage = new OscMessage("/CoM");

  myMessage.add(v1.x); /* add an int to the osc message */
  myMessage.add(v1.y); /* add an int to the osc message */
  myMessage.add(v1.z); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 

  fill(50, 100, 250, 200);
  noStroke();
  //ellipse(v1.x, v1.y, 20, 20);

  // Let's draw the "lerped" location
  v2 = tracker.getLerpedPos();
  fill(255, 0, 50, 200);
  noStroke();
  if (toggleGui) {
    ellipse(v2.x, v2.y, 10, 10);
  }
  if (debug) {
    println("v2 " + v2);
  }


  if (XY_XZ_YZ == 1) { 
    com.set(map(v2.x, 0, 640, 0, width), map(v2.y, 0, 480, 0, height), 0);
    if (debug) {
      println("tracking: XY");
    }
  } else if (XY_XZ_YZ == 2) {
    com.set(map(v2.x, 0, 640, 0, width), map(v2.z, minThreshold, maxThreshold, 0, height), 0);
    if (debug) {
      println("tracking: XZ");
    }
  } else if (XY_XZ_YZ == 3) {
    com.set( map(v2.y, 0, 480, 0, height), map(v2.z, minThreshold, maxThreshold, 0, height), 0);
    if (debug) {
      println("tracking: YZ");
    }
  }

  fill(100, 250, 50, 200);
  noStroke();
  if (toggleGui) {
    ellipse(com.x, com.y, 20, 20);

    int t = tracker.getmaxThreshold();
    fill(255);
    textSize(32);
    text("framerate: " + int(frameRate), 10, 400);
    println("framerate: " + int(frameRate));
  }
  if (debug) {
    println("com " + com);
  }
}
