unsigned long prev = 0;
bool osw = HIGH;
int mode_flag=0;

void setup(){
  pinMode(2,INPUT) ;    //スイッチに接続ピンをデジタル入力に設定
  pinMode(13, OUTPUT);  //ＬＥＤに接続ピンをデジタル出力に設定
  prev = millis();      //Arduinoボードがプログラムの実行を開始した時から現在までの時間をミリ秒単位で返します
}

void loop(){
  unsigned long cur = millis();

  if (cur - prev > 20) {
    bool sw = digitalRead(2);
    prev = cur;
    if (osw == LOW && sw == HIGH) { //スイッチを押して離したとき
      mode_flag=mode_flag+1;
      if(mode_flag>2)mode_flag=0; //最終的にmode_flagはついてくるか帰るかに変化
      //if(mode_flag==1){
      //  mode_flag=2;
      //}else{
      //  mode_flag=1;
      //}
      delay(20);
    }
    osw = sw;
  }
  mode(); //void mode()を実行

}

void mode(){//モードの選択
  if (mode_flag==0) {  //家にいるとき
    waiteHome();
  }
  else if(mode_flag==1){//人についていくとき
    satellite();
  }
  else if(mode_flag==2){//家に帰るとき
    goHome();
  }
}

void waiteHome(){ //家にいるときの動作 mode_flag==0;
  //仮code
  digitalWrite(13, LOW); //消灯
}

void satellite(){//人についていくときの動作 mode_flag==1;
  //仮code
  digitalWrite(13, HIGH); //点灯
}

void goHome(){//家に帰るときの動作 mode_flag==2;
  //仮code
  digitalWrite(13, HIGH); //点滅
  delay(100);
  digitalWrite(13, LOW);
  delay(100);
  
  //家に着いたら　
  //mode_flag=0;
}

