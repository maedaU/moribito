//参考URL: http://qiita.com/miminashi/items/491ff1968725eec45d84
//参考URL: http://qiita.com/miminashi/items/72b7874ed729c51318f9

// シリアルライブラリを取り入れる
import processing.serial.*;

// myPort（任意名）というインスタンスを用意
Serial myPort;

// "COM4" の部分をArduinoの「ツール/シリアルポートを選択する」で選択したシリアルポートにあわせて書き換える
String serialport ="COM4";
int mode_flag=0;
int count_test=0; //テスト用

void setup() {
  size(300, 300);// 画面サイズ
  myPort = new Serial(this, serialport, 9600); // シリアルポートの設定
}

void draw() {
  // 背景色を白に設定
  background(255);

  run(mode_flag); //runに動作をかいた
  
}

void serialEvent(Serial p) { 
  //変数mode_flagにarduinoのシリアル通信で読み込んだ値を代入
  mode_flag = p.read();
}

void run(int flag) { //モードの選択
  int f=flag;
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
  ellipse(width/3, height/3, 50, 50);
}

void satellite() { //mode_flag==1 [1]人についていくときの処理
  //仮code
  ellipse(width*2/3, height/3, 50, 50);
  count_test=0;
}

void goHome() {  //mode_flag==2 [2]家に帰るときの処理
  //仮code
  ellipse(width/2, height*2/3, 50, 50);
  
  
  //家に着いたときの処理
  //仮code
  if (count_test>200) { 
    mode_flag=0;
    myPort.write(mode_flag);
    count_test=0;
  } else {
    count_test++;
  }
}
