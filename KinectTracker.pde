// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

// Depth threshold
int maxThreshold ;
int minThreshold ;
int topCrop ;
int bottomCrop ;
int leftCrop ;
int rightCrop ;
int trackingThreshold;



class KinectTracker {

  // Raw location
  PVector loc;

  // Interpolated location
  PVector lerpedLoc;

  // What we'll show the user
  PImage display;

  KinectTracker() {
    // This is an awkard use of a global variable here
    // But doing it this way for simplicity
    kinect.enableMirror(true);
    // Make a blank image
    display = createImage(kinect.width, kinect.height, RGB);
    // Set up the vectors
    loc = new PVector(0, 0);
    lerpedLoc = new PVector(0, 0);
  }

  void track2D() {

    // Being overly cautious here
    if (depth == null) return;

    float sumX = 0;
    float sumY = 0;
    float sumZ = 0;
    float count = 0;

    for (int x = leftCrop; x < kinect.width - rightCrop; x++) {
      for (int y = 0 + topCrop; y < kinect.height - bottomCrop; y++) {

        int offset =  x + y*kinect.width;
        // Grabbing the raw depth
        int rawDepth = depth[offset];

        // Testing against threshold
        if (minThreshold < rawDepth && rawDepth < maxThreshold) {
          sumX += x;
          sumY += y;
          sumZ += rawDepth;
          count++;
        }
      }
    }
    // As long as we found something
    if (count >= trackingThreshold) {
      loc.set(sumX/count, sumY/count, sumZ/count);
    } else {

      loc.set(0, 0, 0);
    }

    // Interpolating the location, doing it arbitrarily for now
    lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0.3f);
    lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0.3f);
    lerpedLoc.z = PApplet.lerp(lerpedLoc.z, loc.z, 0.3f);
  }

  PVector getLerpedPos() {
    return lerpedLoc;
  }

  PVector getPos() {
    return loc;
  }

  void display() {
    PImage img = kinect.getDepthImage();

    // Being overly cautious here
    if (depth == null || img == null) return;

    // Going to rewrite the depth image to show which pixels are in threshold
    // A lot of this is redundant, but this is just for demonstration purposes
    display.loadPixels();
    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {

        int offset = x + y * kinect.width;
        // Raw depth
        int rawDepth = depth[offset];
        int pix = x + y * display.width;
        if (minThreshold < rawDepth && rawDepth < maxThreshold &&
          y > topCrop && y < (kinect.height - bottomCrop) && x > leftCrop && x < (kinect.width - rightCrop)) {
          // A red color instead
          display.pixels[pix] = color(150, 50, 50);
        } else {
          display.pixels[pix] = img.pixels[offset];
        }
      }
    }
    display.updatePixels();

    // Draw the image
    image(display, 0, 0);
  }

  int getmaxThreshold() {
    return maxThreshold;
  }

  int getminThreshold() {
    return minThreshold;
  }

  void setmaxThreshold(int t) {
    maxThreshold =  t;
  }
}
