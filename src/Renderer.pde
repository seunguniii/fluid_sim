///////////////////////////////////////
//      RENDER COORDINATE FRAME      //
//                                   //
//  +----------------------------> x //
//  |                            |   //
//  |                            |   //
//  |           SCREEN           |   //
//  |                            |   //
//  |                            |   //
//  V----------------------------+   //
//  y                                //
//                                   //
///////////////////////////////////////

class Renderer {
  private final Simulation simulation;
  private final Find find;
  
  Renderer(Simulation simulation, Find find) {
    this.simulation = simulation;
    this.find = find;
  }
  
  Legend legend = new Legend();
  int rho_shadeVar = 0;
  int u_shadeVar = 0;
  float iSize;
  
  float rho_max;  float rho_min;
  float rho_gap;  float rho_gap02;  float rho_gap001;
  
  float u_max;  float u_min;
  float u_gap;  float u_gap02;  float u_gap001;
  
  float liftTemp;  float dragTemp;
  
  float meanU;
  
  void canvas(int x, int y) { //xfor rho location y, y for u location
    rho_max = find.max(0);
    rho_min = find.min(0);
    u_max = find.max(1);
    u_min = find.min(1);
    
    meanU = (u_max + u_min)*0.5;
    
    rho_gap = rho_max - rho_min;
    rho_gap02 = rho_gap*0.02;
    rho_gap001 = rho_gap*0.001;
    u_gap = u_max - u_min;
    u_gap02 = u_gap*0.02;
    u_gap001 = u_gap*0.001;
    
    liftTemp = 0;
    dragTemp = 0;
    
    float xh = x*h;
    float yh = y*h;
    shade.gray(0);
    rect(0, xh, h*3, h);
    rect(0, yh, h*3, h);
    
    for (int i = 0; i < simulation.row; i++) {
      iSize = i*size;
      for (int j = 0; j < simulation.column; j++) {
        if (simulation.notFluid(i, j)){
          shade.gray(255);
          square(iSize, xh + j*size, size);
          square(iSize, yh + j*size, size);
        } else {
          if (rho_max == rho_min) rho_shadeVar = 128;
          else rho_shadeVar = (int)((simulation.rho[i][j] - rho_min)/rho_gap*255f);
          shade.universal(shade.callibrate(rho_shadeVar));
          if(contour[x]){if((shade.callibrate(rho_shadeVar) - rho_min) % rho_gap02 <= rho_gap001 && !simulation.obstacleNeighbor[i][j]){shade.gray(255);}}
          square(iSize, xh + j*size, size);

          if (u_max == u_min) u_shadeVar = 128;
          else u_shadeVar = (int)((simulation.u[i][j].mag() - u_min)/u_gap*255f);
          shade.universal(shade.callibrate(u_shadeVar));
          if(contour[y]){if((shade.callibrate(u_shadeVar) - u_min) % u_gap02 <= u_gap001 && !simulation.obstacleNeighbor[i][j]){shade.gray(255);}}
          square(iSize, yh + j*size, size);
          
          if(j > 2 && simulation.obstacle[i][j - 2]) liftTemp += simulation.rho[i][j];
          else if(j < simulation.column - 2 && simulation.obstacle[i][j + 2]) liftTemp -= simulation.rho[i][j];
          
          if(i > 2 && simulation.obstacle[i - 2][j]) dragTemp -= simulation.rho[i][j];
          else if(i < simulation.row - 2 && simulation.obstacle[i + 2][j]) dragTemp += simulation.rho[i][j];
        }
      }
    }
    if(vectorField[x]) vectorField(x);
    if(vectorField[y]) vectorField(y);
    legend.rho(x, rho_max, rho_min);
    legend.u(y, u_max, u_min);
    
    lift = liftTemp;
    drag = dragTemp;
    
    //if(ui.crashDetect(u_max)) simulate = false;
  }
  
  void vectorField(int z) {
    Find find = new Find(simulation);
    float zh = z*h;
    int step = simulation.column/25;
    float line = 50/(float)(find.max(1) - find.min(1));
    shade.gray(255);
    //shade.green(128);
    for(int i = 1; i < simulation.column - 3; i += step){
      iSize = i*size;
      for(int j = 1; j < simulation.row - 6; j += step){
        line(j*size, zh + iSize, j*size + line*(simulation.u[j][i].x + simulation.u[j + 1][i].x + simulation.u[j][i + 1].x + simulation.u[j + 1][i + 1].x)/4, 
                                 zh + iSize + line*(simulation.u[j][i].y + simulation.u[j + 1][i].y + simulation.u[j][i + 1].y + simulation.u[j + 1][i + 1].y)/4);
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
  
  void obstacle(int z){
    float zh = z*h;
    for(int i = 0; i < simulation.row; i++){
      iSize = i*size;
      for(int j = 0; j < simulation.column; j++){
        if(simulation.notFluid(i, j)) shade.gray(255);
        else shade.gray(0);
        square(iSize, zh + j*size, size);
      }
    }
  }
}
