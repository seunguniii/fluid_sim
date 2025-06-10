class Shade {
  void red(int shade) {
    if (shade < 128) {
      stroke(2*shade, 0, 0);
      fill(2*shade, 0, 0);
    } else {
      stroke(255, 2*(shade - 128), 2*(shade - 128));
      fill(255, 2*(shade - 128), 2*(shade - 128));
    }
  }

  void blue(int shade) {
    if (shade < 128) {
      stroke(0, 0, 2*shade);
      fill(0, 0, 2*shade);
    } else {
      stroke(2*(shade - 128), 2*(shade - 128), 255);
      fill(2*(shade - 128), 2*(shade - 128), 255);
    }
  }
  
  void green(int shade) {
    if (shade < 128) {
      stroke(0, 2*shade, 0);
      fill(0, 2*shade, 0);
    } else {
      stroke(2*(shade - 128), 255, 2*(shade - 128));
      fill(2*(shade - 128), 255, 2*(shade - 128));
    }
  }

  void yellow(int shade) {
    if (shade < 128) {
      stroke(2*shade, 2*shade, 0);
      fill(2*shade, 2*shade, 0);
    } else {
      stroke(255, 255, 2*(shade - 128));
      fill(255, 255, 2*(shade - 128));
    }
  }

  void gray(int shade) {
    stroke(shade);
    fill(shade);
  }
  
  void grayInvert(int shade) {
    stroke(255 - shade);
    fill(255 - shade);
  }
  
  void universal(int shade) {
    if(shade < 85) {
      stroke(0, 3*shade, 255);
      fill(0, 3*shade, 255);
    } else if(shade < 128) {
      stroke(0, 255, 256 - 5.9*(shade - 85));
      fill(0, 255, 256 - 5.9*(shade - 85));
    } else if(shade < 170) {
      stroke(6.1*(shade - 128), 255, 0);
      fill(6.1*(shade - 128), 255, 0);
    } else {
      stroke(255, 255 - 3*(shade - 170), 0);
      fill(255, 255 - 3*(shade - 170), 0);
    }
  }
  
  void redBlue(int shade) {
    if(shade < 128) {
      stroke(1.5625*shade, 1.5625*shade, -0.4296875*shade + 255);
      fill(1.5625*shade, 1.5625*shade, -0.4296875*shade + 255);
    } else {
      stroke(0.4296875*shade + 145, -1.5745*shade + 400, -1.5745*shade + 400);
      fill(0.4296875*shade + 145, -1.5745*shade + 400, -1.5745*shade + 400);
    }
  }

  int callibrate(int shade) {
    if (shade < 0) shade = 0;
    else if (shade > 255) shade = 255;
    else;
    return shade;
  }
}
