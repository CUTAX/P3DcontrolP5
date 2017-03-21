import controlP5.*;

XyzVector xyz;

ControlP5 cp5;
Toggle[] toggleM;
Toggle[][] toggleN;

Button buttonHome;

Slider sliderTheta;
Slider sliderPhi;
Slider sliderZoom;

Slider2D pan;

float zoomRatio;
float camEyeX, camEyeY, camEyeZ;
float camCenterX=0, camCenterY=0, camCenterZ=0;
float camUpX=0, camUpY=0, camUpZ=-1;
float camTheta, camPhi;
float panX, panY;

int ctrlW, ctrlH, ctrlBarW, ctrlMargin, ctrlClearance;

boolean[] defaultToggles = {true, true, true, false, true, true, true, false, true, true, true, true, true, true, true, false};

void setup() {
  size(800, 500, P3D);

  xyz=new XyzVector(100);

  cp5 = new ControlP5(this);
  toggleM = new Toggle[9];
  toggleN = new Toggle[16][];
  PVector toggleSize = new PVector(20, 20);

  for (int i = 0; i < 9; i++) { 
    toggleM[i] = cp5.addToggle("toggle" + i)
      .setLabel("m="+i)
      .setValue(defaultToggles[i])
      .setPosition(50, 50*(i+1))
      .setSize(int(toggleSize.x), int(toggleSize.y));
  }

  ctrlW=120;
  ctrlH=80;
  ctrlBarW=10;
  ctrlMargin=30;
  ctrlClearance=10;

  sliderTheta = cp5.addSlider("slider")
    .setLabel("Theta")
    .setSize(ctrlBarW, ctrlH)
    .setRange(0, 180)
    .setValue(90)
    .setPosition(width-ctrlW-ctrlMargin-ctrlBarW*2-ctrlClearance*2
    , height-ctrlH-ctrlMargin-ctrlBarW-ctrlClearance)
    .setSliderMode(Slider.FLEXIBLE)
    ;

  sliderPhi = cp5.addSlider("slider"+1)
    .setLabel("Phi")
    .setSize(ctrlW, ctrlBarW)
    .setRange(-90, 270)
    .setValue(90)
    .setPosition(width-ctrlW-ctrlMargin-ctrlClearance-ctrlBarW
    , height-ctrlMargin-ctrlBarW)
    .setSliderMode(Slider.FLEXIBLE)
    ;

  sliderZoom = cp5.addSlider("slider"+2)
    .setLabel("zoom")
    .setSize(ctrlBarW, ctrlH)
    .setRange(0, 3)
    .setValue(1)
    .setPosition(width-ctrlMargin-ctrlBarW
    , height-ctrlH-ctrlMargin-ctrlBarW-ctrlClearance)
    .setSliderMode(Slider.FLEXIBLE)
    ;

  buttonHome=cp5.addButton("home")
    .setValue(0)
    .setPosition(width-ctrlW-ctrlMargin-ctrlClearance-ctrlBarW
    , height-ctrlH-ctrlMargin-ctrlClearance*2-ctrlBarW-20)
    .setSize(40, 20)
    .setLabel("Home")
    ;

  pan = cp5.addSlider2D("pan")
    .setLabel("pan")
    .setPosition(width-ctrlW-ctrlMargin-ctrlClearance-ctrlBarW, 
    height-ctrlH-ctrlMargin-ctrlBarW-ctrlClearance)
    .setSize(ctrlW, ctrlH)
    .setMinMax(-1, -1, 1, 1)
    .setValue(0, 0)
    ;
}

void draw() {
  background(10);

  /*コントローラの値を読み込み*/
  camTheta=sliderTheta.getValue();
  camPhi=sliderPhi.getValue();
  zoomRatio=sliderZoom.getValue();
  panX=pan.getArrayValue()[0];
  panY=pan.getArrayValue()[1];

  if (buttonHome.isPressed()) {  //HOMEボタンが押されるとリセット
    sliderTheta.setValue(90);
    sliderPhi.setValue(90);
    sliderZoom.setValue(1);
    pan.setArrayValue(0, 0);
    pan.setArrayValue(1, 0);
  } 

  camEyeX = 100.0*sin(radians(camTheta))*cos(radians(camPhi)); 
  camEyeY = 100.0*sin(radians(camTheta))*sin(radians(camPhi));
  camEyeZ = 100.0*cos(radians(camTheta));

  pushMatrix();
  camera(camEyeX, camEyeY, camEyeZ, 
    camCenterX, camCenterY, camCenterZ, 
    camUpX, camUpY, camUpZ);
  ortho(-width*(1+panX) / 2/zoomRatio, width*(1-panX) / 2/zoomRatio
    , -height*(1-panY) / 2/zoomRatio, height*(1+panY) / 2/zoomRatio
    , 0, 1000);

  /*Lightの設定*/
  ambientLight(128, 128, 128);
  directionalLight(128, 128, 128, -0.25, -0.5, -1);
  directionalLight(128, 128, 128, 0.25, 0.5, 1);
  lightFalloff(1, 0, 0);
  specular(128, 0, 0);

  /*配列の描写*/
  for (int i=0; i<9; i++) {
    if (toggleM[i].getBooleanValue()) {  //toggleButtonがONの場合描写
      stroke(0);
      fill(200, 200, 0);
      rect(20*(i+1), 60, 10, 10);
    }
  }
  /*ボックスの描写*/
  strokeWeight(1);
  fill(255);
  box(100, 100, 100);

  /*XYZフレームの描写*/
  xyz.display();
  popMatrix();

  /*controlP5を使った3Dコントローラの描写*/
  pushMatrix();
  camera(0, 0, 100, 0, 0, 0, 0, 1, 0);  //カメラ固定
  noLights();
  cp5.draw();
  ortho(-width/2, width/2, -height/2, height/2, 0, 1000);
  popMatrix();
}