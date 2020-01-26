int XY_XZ_YZ = 1;
int tracking = 1;

RadioButton trackingPlane, trackingMethod;

void setupControlsUI() {

  trackingMethod = cp5.addRadioButton("radiotrackingMethod").setPosition(30, 10).setSize(50, 30)
    .addItem("track3D", 1)
    .addItem("track2D", 2);

  trackingMethod.activate(0);

  trackingPlane = cp5.addRadioButton("radioButton")
    .setPosition(170, 30)
    .setSize(50, 30)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setItemsPerRow(5)
    .setSpacingColumn(50)
    .addItem("XY", 1)
    .addItem("XZ", 2)
    .addItem("YZ", 3);

  trackingPlane.activate(1);

  // add a horizontal sliders, the value of this slider will be linked
  // to variable 'sliderValue' 
  int y = 70;

  cp5.addSlider("trackingThreshold").setPosition(30, y+=20).setRange(1, 1000).setValue(30).setSize(400, 15);

  cp5.addSlider("minThreshold").setPosition(30, y+=20).setRange(10, 1000).setValue(930).setSize(400, 15);
  cp5.addSlider("maxThreshold").setPosition(30, y+=20).setRange(10, 2000).setValue(994).setSize(400, 15);

  cp5.addSlider("topCrop").setPosition(30, y+=20).setRange(0, 500).setValue(0).setSize(400, 15);
  cp5.addSlider("bottomCrop").setPosition(30, y+=20).setRange(0, 500).setValue(0).setSize(400, 15);
  cp5.addSlider("leftCrop").setPosition(30, y+=20).setRange(0, 480).setValue(0).setSize(400, 15);
  cp5.addSlider("rightCrop").setPosition(30, y+=20).setRange(0, 480).setValue(0).setSize(400, 15);

  cp5.getProperties().setFormat(ControlP5.SERIALIZED);
  //cp5.setAutoDraw(false);
}
