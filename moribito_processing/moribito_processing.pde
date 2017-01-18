// シリアルライブラリを取り入れる
import processing.serial.*;

// myPort（任意名）というインスタンスを用意
Serial myPort;

String serialport ="COM4";  //
int mode_flag=0;
int count_test=0;

void setup() {
  // 画面サイズ
  size(300, 300);
  // シリアルポートの設定
  // "/dev/tty.usbmodem1411" の部分を前述の「シリアルポートを選択する」で選択したシリアルポートにあわせて書き換える
  myPort = new Serial(this, serialport, 9600);
}

void draw() {
  // 背景色を白に設定
  background(255);

  run(mode_flag);

  // XY座標を(x,100)に設定し、
  // 幅50、高さ50の円を描画
}

void serialEvent(Serial p) { 
  //変数xにシリアル通信で読み込んだ値を代入
  mode_flag = p.read();
  //println(mode_flag);
}

void run(int flag) {
  int f=flag;
  if (f==0) {
    waiteHome();
  } else if (f==1) {
    satellite();
  } else {
    goHome();
  }
}

void waiteHome() { //mode_flag==0
  ellipse(width/3, height/3, 50, 50);
}

void satellite() { //mode_flag==1
  ellipse(width*2/3, height/3, 50, 50);
  count_test=0;
}

void goHome() {  //mode_flag==2

  ellipse(width/2, height*2/3, 50, 50);
  
  if (count_test>200) {
    mode_flag=0;
    myPort.write(mode_flag);
    count_test=0;
  } else {
    count_test++;
  }
}