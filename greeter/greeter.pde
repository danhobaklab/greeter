/*

greeter by Dahye Park
http://www.dahyepark.com/

Gesture-based Interactive Greeter for a Department Device Checkout

*/

import KinectPV2.*;
KinectPV2 kinect;
Skeleton [] skeleton;

/*

Thanks to Thomas Sanchez Lengeling for KinectPV2 Library
http://codigogenerativo.com/

*/

int greeter_num = 8;
int question_num = 3;
int response_num = 5;

PImage [] greeter = new PImage[greeter_num];
PImage [] question = new PImage[question_num];
PImage [] response = new PImage[response_num];
PImage wanna;
PImage noone;
PImage closed;
PImage shift;
PImage goodday;

int state = 0;
int stateIndex = 0;
int stateFrameCount = 0;
boolean userDetected = false;

boolean swipeRecognitionStarted = false;
int startFrame = -1;
int startFrame_left = -1;
int endFrame = -1;

boolean raiseHandsRecognitionStarted = false;
boolean raiseRightHandRecognitionStarted = false;
boolean raiseLeftHandRecognitionStarted = false;

boolean sketchFullScreen() {
  return true;
} 

PImage recording;

void setup() {
  size(1920, 1080, P3D);
  frameRate(30);

  kinect = new KinectPV2(this);

  kinect.enableSkeleton(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.enableBodyTrackImg(true);
  
  kinect.enableColorImg(true);


  kinect.init();

  for (int i = 0; i < greeter_num; i++) {
    greeter[i] = loadImage("greeter_"+i+".png");
  }

  for (int i = 0; i < question_num; i++) {
    question[i] = loadImage("question_"+i+".png");
  }

  for (int i = 0; i < response_num; i++) {
    response[i] = loadImage("response_"+i+".png");
  }

  wanna = loadImage("wanna.png");

  noone = loadImage("noone_0.png");
  closed = loadImage("closed.png");
  shift = loadImage("shift.png");
  
  goodday = loadImage("goodday.png");
  
  recording = createImage(1920, 1080, RGB);
}

void draw() {
  background(0);

  skeleton = kinect.getSkeletonDepthMap();

  for (int i = 0; i < skeleton.length; i++) {
    userDetected = false;

    if (skeleton[i].isTracked()) {
      userDetected = true;
      KJoint[] joints = skeleton[i].getJoints();
      drawBody(joints);
      gestureRecognizer(joints);

      if (state == 0) {
        state = 1;
        stateFrameCount = 0;
        recording = kinect.getColorImage();
        recording.save("./data/recording/recording_"+day()+"_"+hour()+"_"+minute()+"_"+second()+"detected.jpg");
      } else if (state == 2){
        if ((stateFrameCount%100) == 0 && (stateFrameCount != 0)) {
          state = 3;
          stateFrameCount = 0;
          recording = kinect.getColorImage();
          recording.save("./data/recording/recording_"+day()+"_"+hour()+"_"+minute()+"_"+second()+"wait.jpg");
        }
      }

      break;
    }
  }

  if (!userDetected)
    state = 0;

  switch(state) {
  case 0:
    if ((stateFrameCount%300) == 0)
      stateIndex = int(random(greeter.length));
    image(greeter[stateIndex], 0, 0);
    break;
  case 1:
    if ((stateFrameCount) == 0)
      stateIndex = int(random(question.length));
    image(question[stateIndex], 0, 0);
    break;
  case 2:
    if ((stateFrameCount) == 0)
      stateIndex = int(random(response.length));  
    image(response[stateIndex], 0, 0);
    break;
  case 3:
    image(wanna, 0, 0);
    break;
  case 4:
    if ((hour() >= 10) && (hour() <= 16)) {
      image(shift, 0, 0);
    } else {
      image(closed, 0, 0);
    }
    break;
  case 5:
    image(goodday, 0, 0);
    break;
  default:
    break;
  }

  stateFrameCount++;

  //  image(kinect.getBodyTrackImage(), 0, 0, 200, 200);

  //  println(state);
}

void gestureRecognizer(KJoint[] joints)
{
  switch(state) {
  case 0:
    break;
  case 1:
    raiseHandsRecognizer(joints);
    break;
  case 3:
    raiseRightHandRecognizer(joints);
    raiseLeftHandRecognizer(joints);
    break;
  default:
    break;
  }
}

void swipeRecognizer(KJoint[] joints)
{
  KJoint handRight = joints[KinectPV2.JointType_HandRight];
  KJoint spineShoulder = joints[KinectPV2.JointType_SpineShoulder];
  KJoint spineMid = joints[KinectPV2.JointType_SpineMid];
  KJoint shoulderRight = joints[KinectPV2.JointType_ShoulderRight];

  if (!swipeRecognitionStarted) {
    if ((handRight.getY() <= spineMid.getY()) && (handRight.getX() >= shoulderRight.getX())) {
      swipeRecognitionStarted = true;
      startFrame = frameCount;
      println("Recognition Started");
    }
  } else {
    if ((frameCount >= (startFrame + 15)) && (frameCount <= (startFrame + 30))) {
      if ((handRight.getY() <= spineMid.getY()) && (handRight.getX() <= spineMid.getX())) {
        println("Recognition Ended");
        state = (state+1)%5;
        stateFrameCount = 0;
        swipeRecognitionStarted = false;
      }
    } else if (frameCount >= (startFrame + 30))
    {
      println("Recognition canceled");
      swipeRecognitionStarted = false;
    }
  }
}

void raiseHandsRecognizer(KJoint[] joints)
{
  KJoint handRight = joints[KinectPV2.JointType_HandRight];
  KJoint handLeft = joints[KinectPV2.JointType_HandLeft];
  KJoint shoulderRight = joints[KinectPV2.JointType_ShoulderRight];
  KJoint shoulderLeft = joints[KinectPV2.JointType_ShoulderLeft];
  KJoint spineMid = joints[KinectPV2.JointType_SpineMid];

  //  if ((handRight.getY() >= spineMid.getY()) && (handLeft.getY() >= spineMid.getY())) {
  //    println("Recognition started");
  //    raiseHandsRecognitionStarted = true;
  //    startFrame = frameCount;
  //  } else {
  //    if ((frameCount >= (startFrame + 60)) && (frameCount <= (startFrame + 75))) {
  if ((handRight.getY() <= shoulderRight.getY()) && (handLeft.getY() <= shoulderLeft.getY())) {
    println("Recognition ended");
    raiseHandsRecognitionStarted = false;
    state = 2;
    stateFrameCount = 0;
    recording = kinect.getColorImage();
    recording.save("./data/recording/recording_"+day()+"_"+hour()+"_"+minute()+"_"+second()+"raise_hand.jpg");
    println(state);
  }
  //    }
  //  }
}

void raiseRightHandRecognizer(KJoint[] joints)
{
  KJoint handRight = joints[KinectPV2.JointType_HandRight];
  KJoint elbowRight = joints[KinectPV2.JointType_ElbowRight];

  if (!raiseRightHandRecognitionStarted) { 
    if ((handRight.getY() >= elbowRight.getY()) && (handRight.getX() >= elbowRight.getX())) {
      raiseRightHandRecognitionStarted = true;
      startFrame = frameCount;
      println("Recognition Started");
    }
  } else {
    if ((frameCount >= (startFrame + 15)) && (frameCount <= (startFrame + 30))) {
      if ((handRight.getY() <= elbowRight.getY()) && (handRight.getX() >= elbowRight.getX())) {
        println("Recognition Ended");
        state++;
        stateFrameCount = 0;
        raiseRightHandRecognitionStarted = false;
        recording.save("./data/recording/recording_"+day()+"_"+hour()+"_"+minute()+"_"+second()+"raise_right_hand.jpg");

      } else if (frameCount >= (startFrame + 30))
      {
        println("Recognition canceled");
        raiseRightHandRecognitionStarted = false;
      }
    }
  }
}

void raiseLeftHandRecognizer(KJoint[] joints)
{
  KJoint handLeft = joints[KinectPV2.JointType_HandLeft];
  KJoint elbowLeft = joints[KinectPV2.JointType_ElbowLeft];

  if (!raiseLeftHandRecognitionStarted) { 
    if ((handLeft.getY() >= elbowLeft.getY()) && (handLeft.getX() <= elbowLeft.getX())) {
      raiseLeftHandRecognitionStarted = true;
      startFrame_left = frameCount;
      println("Recognition Started");
    }
  } else {
    if ((frameCount >= (startFrame_left + 15)) && (frameCount <= (startFrame_left + 30))) {
      if ((handLeft.getY() <= elbowLeft.getY()) && (handLeft.getX() <= elbowLeft.getX())) {
        println("Recognition Ended");
        state = 5;
        stateFrameCount = 0;
        raiseLeftHandRecognitionStarted = false;
/////        recording.save("./data/recording/recording_"+day()+"_"+hour()+"_"+minute()+"_"+second()+"raise_left_hand.jpg");

      } else if (frameCount >= (startFrame_left + 30))
      {
        println("Recognition canceled");
        raiseLeftHandRecognitionStarted = false;
      }
    }
  }
}

void drawBody(KJoint[] joints) {

  drawPointJoint(joints, KinectPV2.JointType_SpineShoulder);
  drawPointJoint(joints, KinectPV2.JointType_SpineMid);
  drawPointJoint(joints, KinectPV2.JointType_HandRight);
  drawPointJoint(joints, KinectPV2.JointType_ShoulderRight);
  drawPointJoint(joints, KinectPV2.JointType_ElbowRight);
}

void drawPointJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  noStroke();
  fill(255, 0, 0);
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
}

