class Update {
  void collision() {
    double v = 1d - omega;
    for (int i = 0; i < row; i++) {
      for (int k = 0; k < column; k++) {
        for (int j = 0; j < 9; j++) {
          newN[i][k][j] = v*oldN[i][k][j] + omega*Neq[i][k][j];
        }
      }
    }
  }

  void stream() {
    for (int i = 0; i < row; i++) {
      for (int k = 0; k < column; k++) {
        if (boundary[i][k] || object[i][k]){
        }else if (boundaryNeighbor[i][k]) {
          if(periodic || windTunnel){
            if(periodic) periodicFlow(k);
            if(windTunnel) outlet(k);
          }else bounceBack(i, k);
        }else if(objectNeighbor[i][k]) {
          bounceBack(i, k);
        }else {
          for (int j = 0; j < 9; j++) {oldN[i][k][j] = newN[(int)(i + e[j].x*dt)][(int)(k + e[j].y*dt)][j];}
        }
      }
    }
  }
  
  void periodicFlow(int i){
    double temp;
    for(int j = 0; j < 9; j++){
      temp = oldN[1][i][j];
      oldN[1][i][j] = oldN[row - 2][i][j];
      oldN[row - 2][i][j] = temp;
      temp = oldN[0][i][j];
      oldN[0][i][j] = oldN[row - 1][i][j];
      oldN[row - 1][i][j] = temp;
    }
  }
  
  void bounceBack(int i, int k){
    if (object[i - 1][k] || boundary[i - 1][k]) {
      oldN[i - 1][k][1] = newN[i][k][3];// - 2*w[3]*rho[i][k]*innerProduct(e[3], initialFlow)*inC*inC;
      oldN[i - 1][k][5] = newN[i][k][6];// - 2*w[6]*rho[i][k]*innerProduct(e[6], initialFlow)*inC*inC;;
      oldN[i - 1][k][8] = newN[i][k][7];// - 2*w[7]*rho[i][k]*innerProduct(e[7], initialFlow)*inC*inC;;
      double n = (oldN[i - 1][k][1] + oldN[i - 1][k][5] + oldN[i - 1][k][8])*0.33333333333333;
      oldN[i - 1][k][0] = n;  oldN[i - 1][k][4] = n;  oldN[i - 1][k][2] = n;
      oldN[i - 1][k][3] = n;  oldN[i - 1][k][6] = n;  oldN[i - 1][k][7] = n;
    }else if (object[i + 1][k] || boundary[i + 1][k]) {
      oldN[i + 1][k][3] = newN[i][k][1];// - 2*w[1]*rho[i][k]*innerProduct(e[1], initialFlow)*inC*inC;;
      oldN[i + 1][k][6] = newN[i][k][5];// - 2*w[5]*rho[i][k]*innerProduct(e[5], initialFlow)*inC*inC;;
      oldN[i + 1][k][7] = newN[i][k][8];// - 2*w[8]*rho[i][k]*innerProduct(e[8], initialFlow)*inC*inC;;
      double n = (oldN[i + 1][k][3] + oldN[i + 1][k][6] + oldN[i + 1][k][7])*0.33333333333333;
      oldN[i + 1][k][0] = n;  oldN[i + 1][k][1] = n;  oldN[i + 1][k][2] = n;
      oldN[i + 1][k][4] = n;  oldN[i + 1][k][5] = n;  oldN[i + 1][k][8] = n;
    }else if (object[i][k - 1] || boundary[i][k - 1]) {
      oldN[i][k - 1][2] = newN[i][k][4];// - 2*w[4]*rho[i][k]*innerProduct(e[4], initialFlow)*inC*inC;;
      oldN[i][k - 1][5] = newN[i][k][8];// - 2*w[8]*rho[i][k]*innerProduct(e[8], initialFlow)*inC*inC;;
      oldN[i][k - 1][6] = newN[i][k][7];// - 2*w[7]*rho[i][k]*innerProduct(e[7], initialFlow)*inC*inC;;
      double n = (oldN[i][k - 1][2] + oldN[i][k - 1][5] + oldN[i][k - 1][6])*0.33333333333333;
      oldN[i][k - 1][0] = n;  oldN[i][k - 1][1] = n;  oldN[i][k - 1][3] = n;
      oldN[i][k - 1][4] = n;  oldN[i][k - 1][7] = n;  oldN[i][k - 1][8] = n;
      //for(int j = 0; j < 9; j++){oldN[i][k][j] = newN[i][k - 1][j];}
    }else if (object[i][k + 1] || boundary[i][k + 1]) {
      oldN[i][k + 1][4] = newN[i][k][2];// - 2*w[2]*rho[i][k]*innerProduct(e[2], initialFlow)*inC*inC;;
      oldN[i][k + 1][7] = newN[i][k][6];// - 2*w[6]*rho[i][k]*innerProduct(e[6], initialFlow)*inC*inC;;
      oldN[i][k + 1][8] = newN[i][k][5];// - 2*w[5]*rho[i][k]*innerProduct(e[5], initialFlow)*inC*inC;;
      double n = (oldN[i][k + 1][4] + oldN[i][k + 1][7] + oldN[i][k + 1][8])*0.33333333333333;
      oldN[i][k + 1][0] = n;  oldN[i][k + 1][1] = n;  oldN[i][k + 1][2] = n;
      oldN[i][k + 1][3] = n;  oldN[i][k + 1][5] = n;  oldN[i][k + 1][6] = n;
    }
  }
  
  void macroVal() {
    for (int i = 0; i < row; i++) {
      for (int k = 0; k < column; k++) {        
        rho[i][k] = 0;
        for (int j = 0; j < 9; j++) {
          rho[i][k] += oldN[i][k][j];
        }
        u[i][k] = new Vector(((oldN[i][k][1]+oldN[i][k][5]+oldN[i][k][8]) - (oldN[i][k][3]+oldN[i][k][6]+oldN[i][k][7]))/rho[i][k],
                             ((oldN[i][k][2]+oldN[i][k][5]+oldN[i][k][6]) - (oldN[i][k][4]+oldN[i][k][7]+oldN[i][k][8]))/rho[i][k]);
        
        for (int j = 0; j < 9; j++) {
          Neq[i][k][j] = neq(j, u[i][k], rho[i][k]);
        }
      }
    }
  }
  
  void windTunnel(){
    for (int i = 1; i < row/*/8*/; i++) {
      for (int j = 0; j < column; j++) {
        if(boundary[i][j] || boundaryNeighbor[i][j]){
          rho[i][j] = 1d;
          u[i][j] = tunnelFlow;
          for(int k = 0; k < 9; k++){oldN[i][j][k] = neq(k, u[i][j], rho[i][j]);}
        }
      }
    }
  }
  
  void outlet(int k){
    u[row - 2][k] = new Vector(-u[row - 3][k].x, -u[row - 3][k].y);
    rho[row - 2][k] = 1;
    for(int j = 0; j < 9; j++){oldN[row - 2][k][j] = neq(j, u[row - 2][k], rho[row - 2][k]);}
  }
}
