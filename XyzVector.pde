class XyzVector {
  float l;

  //初期化用メソッド(コンストラクタ)
  XyzVector(float _l) {
    l=_l;
  }

  void display() {
    strokeWeight(1);
    stroke(255, 0, 0);  //x
    line(0, 0, 0, l, 0, 0);
    stroke(0, 255, 0);  //y
    line(0, 0, 0, 0, l, 0);
    stroke(0, 0, 255);  //z
    line(0, 0, 0, 0, 0, l);
  }
}