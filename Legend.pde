class Legend {
  Shade shade = new Shade();

  void rho(int x, double max, double min) {
    //fill(0, 255, 0);
    shade.gray(255);
    textSize(0.05*h);

    text("Pressure", 10, 0.0625*h + h*x);

    textSize(15*h/400);
    text(nf((float)max, 0, 6), 31, 0.5*h - 113 + h*x);
    text(nf((float)min, 0, 6), 31, 0.5*h + 127 + h*x);
    text(nf((float)((max+min)*0.5), 0, 6), 31, 0.5*h + 7 + h*x);

    rect(10, 0.5*h - 128 + h*x, 22, 258);
    for (int i = 0; i < 256; i++) {
      //shade.grayInvert(i);
      //shade.universal(i);
      //shade.redBlue(i);
      shade.gray(shade.callibrate(i));
      rect(11, 0.5*h + 128 - i + h*x, 20, 1);
    }
  }

  void u(int x, double max, double min) {
    shade.gray(255);
    textSize(0.05*h);
    text("Flow Speed", 10, 0.0625*h + h*x);

    textSize(15*h/400);
    text(nf((float)max, 0, 6), 31, 0.5*h - 113 + h*x);
    text(nf((float)min, 0, 6), 31, 0.5*h + 127 + h*x);
    text(nf((float)((max+min)*0.5), 0, 6), 31, 0.5*h + 7 + h*x);

    rect(10, 0.5*h - 128 + h*x, 22, 258);
    for (int i = 0; i < 256; i++) {
      //shade.grayInvert(i);
      //shade.universal(i);
      //shade.redBlue(i);
      shade.gray(shade.callibrate(i));
      rect(11, 0.5*h + 128 - i + h*x, 20, 1);
    }
  }
}
