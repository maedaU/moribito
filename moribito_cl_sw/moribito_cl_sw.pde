import processing.video.*;
import processing.serial.*;


Capture video;
Serial myPort;


int w = 640;
int h = 480;
int tolerance=20;
color targetColor=color(255, 0, 0);

float x;
float y;
int sumX, sumY;
int pixelNum;
float filterX, filterY;
boolean videoImage=true;
boolean detection=false;

// "COM4" の部分をArduinoの「ツール/シリアルポートを選択する」で選択したシリアルポートにあわせて書き換える
String serialport ="COM4";
int mode_flag=0;
int count_test=0; //テスト用


void setup() {
  size(640, 480);
  video = new Capture(this, width, height);
  video.start();
  noStroke();
  smooth();
  //Arduino serialport
  //myPort = new Serial(this, serialport, 9600); // シリアルポートの設定
}

void draw() {
  if (video.available()) {
    video.read();

    scale(-1.0, 1.0);
    if (videoImage) {
      image(video, -w, 0);
    } else {
      background(0);
    }

    detection = false;

    for (int i=0; i<w*h; i++) {
      float difRed=abs(red(targetColor)-red(video.pixels[i]));
      float difGreen=abs(green(targetColor)-green(video.pixels[i]));
      float difBlue=abs(blue(targetColor)-blue(video.pixels[i]));

      if (difRed<tolerance && difGreen<tolerance && difBlue<tolerance) {
        detection=true;

        sumX+=(i%w);
        sumY+=(i/w);
        pixelNum++;
      }
    }
    if (detection) {
      x=sumX/pixelNum;
      y=sumY/pixelNum;

      sumX=0;
      sumY=0;
      pixelNum=0;
      tolerance--;
      if (tolerance<2) {
        tolerance=2;
      }
    } else {
      tolerance++;
      if (tolerance>25) {
        tolerance=25;
      }
    }
  }
  scale(-1.0, 1.0);
  filterX+=(x-filterX)*0.3;
  filterY+=(y-filterY)*0.3;

  fill(255, 0, 0);
  ellipse(w-filterX, filterY, 20, 20);

  fill(targetColor);
  rect(0, 0, 10, 10);
  //text(tolerance,20,10);
  //String s;
  //if(detection){
  //  s="detected";
  //}else{
  //  s="none";
  //}
  //text(s,40,10);

  run(mode_flag); //runに動作をかいた
}

void mousePressed() {
  targetColor=video.pixels[w-mouseX+mouseY*w];
}

void keyPressed() {
  if (key=='c') {
    //video.settings();
  }



  if (key=='v') {//「v」キーを押して表示／非表示を切り替える
    if (videoImage) {
      videoImage=false;
    } else {
      videoImage=true;
    }
  }
  if (key == ENTER) {          // Enterキーに反応
    mode_flag++;
    if (mode_flag>2) {
      mode_flag=0;
    }
  } 



  /*許容値調整は自動なので以下は使わない
   if(key==CODED){
   if(keyCode==LEFT){
   tolerance-=1;
   }
   if(keyCode==RIGHT){
   tolerance+=1;
   }
   }
   */
}


void serialEvent(Serial p) { 
  //変数mode_flagにarduinoのシリアル通信で読み込んだ値を代入
  mode_flag = p.read();
}

void run(int flag) { //モードの選択
  int f=flag;
    //仮code
  //textSize(50);
  //fill(255);
  //textAlign(RIGHT);
  //text("mode:", width-100, 50);
  
  if (f==0) {  //[0]家にいるときの動作
    waiteHome();
  } else if (f==1) { //[1]人についていくときの動作
    satellite();
  } else {  //[2]家に帰るときの動作
    goHome();
  }
}

void waiteHome() { //mode_flag==0 [0]家にいるときの処理
  //仮code
  textSize(50);
  fill(255);
  textAlign(RIGHT);
  text("Home", width, 50);

  ellipse(width/3, height/3, 50, 50);
}

void satellite() { //mode_flag==1 [1]人についていくときの処理
  //仮code
  textSize(50);
  fill(255);
  textAlign(RIGHT);
  text("Chaser", width, 50);

  ellipse(width*2/3, height/3, 50, 50);
  count_test=0;
}

void goHome() {  //mode_flag==2 [2]家に帰るときの処理
  //仮code
  textSize(50);
  fill(255);
  textAlign(RIGHT);
  text("Gohome", width, 50);

  ellipse(width/2, height*2/3, 50, 50);


  //家に着いたときの処理
  //仮code
  if (count_test>200) { 
    mode_flag=0;
    //arduino serialport
    //myPort.write(mode_flag);
    count_test=0;
  } else {
    count_test++;
  }
}