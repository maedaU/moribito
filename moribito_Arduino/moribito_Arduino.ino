//参考URL: http://qiita.com/miminashi/items/491ff1968725eec45d84
//参考URL: http://qiita.com/miminashi/items/72b7874ed729c51318f9

unsigned long prev = 0;
bool osw = HIGH;
int mode_flag=0;

void setup(){
  Serial.begin(9600);
  pinMode(2,INPUT) ;    //スイッチに接続ピンをデジタル入力に設定
  pinMode(13, OUTPUT);  //ＬＥＤに接続ピンをデジタル出力に設定
  prev = millis();      //Arduinoボードがプログラムの実行を開始した時から現在までの時間をミリ秒単位で返します
}

void loop(){
  unsigned long cur = millis();
  if(Serial.available() > 0) {
    mode_flag = Serial.read(); //Processingからのシリアルを読み込む，家に着いたかわかる
  }
  if (cur - prev > 20) {
    bool sw = digitalRead(2);
    prev = cur;
    if (osw == LOW && sw == HIGH) { //スイッチを押して離したとき
      if(mode_flag==1){ //[1]人についていくときにボタンが押されたとき，[2]家に帰るモードに変更
        mode_flag=2;
      }else{            //[0]家にいるとき[2]家に帰るときにボタンを押されたとき，[1]人についていくモードに変更
        mode_flag=1;
      }
      delay(20);
      Serial.write(mode_flag); //Serialに書き込みProcessingに送る. mode_flagが  [0]家にいるとき，[1]人についていくとき，[2]家に帰るとき
    }
    osw = sw;
  }
  mode(); //void mode()を実行 arduinoの状態がわかるテスト用
}

//以下テスト用
void mode(){//モードの選択
  if (mode_flag==0) {  //[0]家にいるとき
    waiteHome();
  }
  else if(mode_flag==1){//[1]人についていくとき
    satellite();
  }
  else if(mode_flag==2){//[2]家に帰るとき
    goHome();
  }
}

void waiteHome(){ //[0]家にいるときの動作
  //仮code
  Serial.write(0);
  digitalWrite(13, LOW);
}

void satellite(){//[1]人についていくときの動作
  //仮code
  Serial.write(1);
  digitalWrite(13, HIGH);
}

void goHome(){//[2]家に帰るときの動作
  //仮code
  Serial.write(2);
  digitalWrite(13, HIGH);
  delay(100);
  digitalWrite(13, LOW);
  delay(100);
}
