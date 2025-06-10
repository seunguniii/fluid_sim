class Paint {
  Legend legend = new Legend();
  int shadeVar = 0;
  double max;
  double min;
  double gap;
  double gap02;
  double gap001;
  float xh;
  float iSize;
  
  void rho(int x) {
    max = Max.rho();
    min = Min.rho();
    gap = max - min;
    gap02 = gap*0.02;
    gap001 = gap*0.001;
    xh = x*h;
    shade.gray(0);
    rect(0, xh, h*3, h);
    for (int i = 0; i < row; i++) {
      iSize = i*size;
      for (int j = 0; j < column; j++) {
        if (boundary[i][j] || object[i][j]){
          shade.gray(255);
          square(iSize, xh + j*size, size);
        }else {
          if (max == min) shadeVar = 128;
          else shadeVar = (int)((rho[i][j] - min)/gap*255d);
          //shade.universal(shade.callibrate(shadeVar));
          //shade.redBlue(shade.callibrate(shadeVar));
          shade.gray(shade.callibrate(shadeVar));
          if(contour[x]){if((shade.callibrate(shadeVar) - min) % gap02 <= gap001 && !objectNeighbor[i][j]){shade.gray(255);}}
          square(iSize, xh + j*size, size);
        }
      }
    }
    if(vectorField[x]) vectorField(x);
    legend.rho(x, max, min);
  }
  
  void u(int x) {
    liftTemp = 0;
    dragTemp = 0;
    max = Max.u();
    min = Min.u();
    
    ui.crashDetect(max);
    meanU = (max + min)*0.5;
    
    gap = max - min;
    gap02 = gap*0.02;
    gap001 = gap*0.001;
    xh = x*h;
    shade.gray(0);
    rect(0, xh, h*3, h);
    for (int i = 0; i < row; i++) {
      iSize = i*size;
      for (int j = 0; j < column; j++) {
        if (boundary[i][j] || object[i][j]){
          shade.gray(255);
          //shade.gray(0);
          square(iSize, xh + j*size, size);
        }
        else {
          if(j > 2 && object[i][j - 2]) liftTemp += rho[i][j];
          else if(j < column - 2 && object[i][j + 2]) liftTemp -= rho[i][j];
          
          if(i > 2 && object[i - 2][j]) dragTemp -= rho[i][j];
          else if(i < row - 2 && object[i + 2][j]) dragTemp += rho[i][j];
          
          if (max == min) shadeVar = 128;
          else shadeVar = (int)((u[i][j].vectorSize() - min)/gap*255d);
          //shade.universal(shade.callibrate(shadeVar));
          //shade.redBlue(shade.callibrate(shadeVar));
          //shade.grayInvert(shade.callibrate(shadeVar));
          shade.gray(shade.callibrate(shadeVar));
          if(contour[x]){if((shade.callibrate(shadeVar) - min) % gap02 <= gap001 && shade.callibrate(shadeVar) != min && !objectNeighbor[i][j]){shade.gray(255);}}
          square(iSize, xh + j*size, size);
        }
      }
    }
    lift = liftTemp;
    drag = dragTemp;
    if(vectorField[x]) vectorField(x);
    legend.u(x, max, min);
  }
  
  void vectorField(int x) {
    xh = x*h;
    int step = column/25;
    float line = 50/(float)(max - min);
    shade.gray(255);
    //shade.green(128);
    for(int i = 1; i < column - 3; i += step){
      iSize = i*size;
      for(int j = 1; j < row - 6; j += step){
        line(j*size, xh + iSize, j*size + line*(float)(u[j][i].x + u[j + 1][i].x + u[j][i + 1].x + u[j + 1][i + 1].x)/4, xh + iSize + line*(float)(u[j][i].y + u[j + 1][i].y + u[j][i + 1].y + u[j + 1][i + 1].y)/4);
      }
    }
  }
  
  void liftGraph(){
    stroke(255); fill(0);  rect(3.195*h, 0.65*h, 1.5*h, 0.6*h);
    fill(255); text("Lift", 4.55*h, 0.7*h);
    liftPoint[0] = lift;
    liftMax = lift > liftMax? lift:liftMax;
    liftMin = lift < liftMin? lift:liftMin;
    liftScale = 0.6*h/(liftMax - liftMin);
   
    if(liftMax >= 0 && liftMin < -0.0001) {
      shade.gray(255);
      line(3.2*h, 1.25*h + (float)(liftMin*liftScale), 4.7*h, 1.25*h + (float)(liftMin*liftScale));
      text("0.0000", h3 + 0.02*h, 1.27*h + (float)(liftMin*liftScale));
    }
    for(int i = graphEnd; i > 0; i--) {
      stroke(0, 255, 0);
      line((4.7 - (graphEnd-i)*(float)graphStep)*h, (float)(1.25*h - (liftPoint[i] - liftMin)*liftScale), (4.7 - (graphEnd+1-i)*(float)graphStep)*h, (float)(1.25*h - (liftPoint[i - 1] - liftMin)*liftScale));
      liftPoint[i] = liftPoint[i - 1];
    }
    fill(0, 255, 0);  text("" + nf((float)lift, 0, 4), h3 + 0.02*h, (float)(1.3*h - (lift - liftMin)*liftScale));
    fill(255);        text("" + nf((float)liftMax, 0, 4), h3 + 0.02*h, 0.68*h);
                      text("" + nf((float)liftMin, 0, 4), h3 + 0.02*h, 1.25*h);
  }
  
  void dragGraph(){
    stroke(255); fill(0);  rect(3.2*h, 1.35*h, 1.5*h, 0.6*h);
    fill(255); text("Drag", 4.55*h, 1.4*h);
    dragPoint[0] = drag;
    
    dragMax = drag > dragMax? drag:dragMax;
    dragMin = drag < dragMin? drag:dragMin;
    dragScale = 0.6*h/(dragMax - dragMin);
    
    for(int i = graphEnd; i > 0; i--) {
      stroke(0, 255, 0);
      line((4.7 - (graphEnd-i)*(float)graphStep)*h, (float)(1.95*h - (dragPoint[i] - dragMin)*dragScale), (4.7 - (graphEnd+1-i)*(float)graphStep)*h, (float)(1.95*h - (dragPoint[i - 1] - dragMin)*dragScale));
      dragPoint[i] = dragPoint[i - 1];
    }
    fill(0, 255, 0);  text("" + nf((float)drag, 0, 4), h3 + 0.02*h, (float)(2*h - (drag - dragMin)*dragScale));
    fill(255);        text("" + nf((float)dragMax, 0, 4), h3 + 0.02*h, 1.38*h);
                      text("" + nf((float)dragMin, 0, 4), h3 + 0.02*h, 1.95*h);
  }
  
  void object(int x){
    xh = x*h;
    for(int i = 0; i < row; i++){
      iSize = i*size;
      for(int j = 0; j < column; j++){
        if(boundary[i][j] || object[i][j]){
          shade.gray(255);
          square(iSize, xh + j*size, size);
        }
      }
    }
  }
}
