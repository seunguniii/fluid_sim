class SimulationSolver {
  private final Simulation simulation;

  SimulationSolver(Simulation simulation) {
    this.simulation = simulation;
  }
  
  void collision() {
    //float v = 1f - simulation.omega;
    for (int i = 0; i < simulation.row; i++) {
      for (int j = 0; j < simulation.column; j++) {
        for (int k = 0; k < simulation.q; k++) {
          simulation.fNext[i][j][k] = simulation.f[i][j][k] - simulation.omega*(simulation.f[i][j][k] - simulation.fEq[i][j][k]);
        } //end for q loop
      } //end for column loop
    } //end for row loop
  }
  
  void stream() {
    for (int i = 0; i < simulation.row; i++) {
      for (int j = 0; j < simulation.column; j++) {
        if(!simulation.notFluid(i, j)) {
          for (int k = 0; k < simulation.q; k++) {
            simulation.f[i][j][k] = simulation.fNext[(int)(i + simulation.e[k].x*simulation.dt)][(int)(j + simulation.e[k].y*simulation.dt)][k];
          }
        }
      }//end for column loop
    }//end for row loop
  }
  
  //TODO: accurate corner bounceback
  void bounceBack(){
    float n;
    
    for(int i = 0; i < simulation.row; i ++) {
      for(int j = 0; j < simulation.column; j++) {
        if(!simulation.notFluid(i, j)){
          if (simulation.obstacle[i - 1][j] || simulation.boundary[i - 1][j]) {
            simulation.f[i - 1][j][1] = simulation.fNext[i][j][3];// - 2*w[3]*rho[i][k]*innerProduct(e[3], initialFlow)*inC*inC;
            simulation.f[i - 1][j][5] = simulation.fNext[i][j][6];// - 2*w[6]*rho[i][k]*innerProduct(e[6], initialFlow)*inC*inC;;
            simulation.f[i - 1][j][8] = simulation.fNext[i][j][7];// - 2*w[7]*rho[i][k]*innerProduct(e[7], initialFlow)*inC*inC;;
      
            n = (simulation.f[i - 1][j][1] + simulation.f[i - 1][j][5] + simulation.f[i - 1][j][8])*1/3;

            simulation.f[i - 1][j][0] = n;  simulation.f[i - 1][j][4] = n;  simulation.f[i - 1][j][2] = n;
            simulation.f[i - 1][j][3] = n;  simulation.f[i - 1][j][6] = n;  simulation.f[i - 1][j][7] = n;
          }
          else if (simulation.obstacle[i + 1][j] || simulation.boundary[i + 1][j]) {
            simulation.f[i + 1][j][3] = simulation.fNext[i][j][1];// - 2*w[1]*rho[i][j]*innerProduct(e[1], initialFlow)*inC*inC;;
            simulation.f[i + 1][j][6] = simulation.fNext[i][j][5];// - 2*w[5]*rho[i][j]*innerProduct(e[5], initialFlow)*inC*inC;;
            simulation.f[i + 1][j][7] = simulation.fNext[i][j][8];// - 2*w[8]*rho[i][j]*innerProduct(e[8], initialFlow)*inC*inC;;

            n = (simulation.f[i + 1][j][3] + simulation.f[i + 1][j][6] + simulation.f[i + 1][j][7])*1/3;

            simulation.f[i + 1][j][0] = n;  simulation.f[i + 1][j][1] = n;  simulation.f[i + 1][j][2] = n;
            simulation.f[i + 1][j][4] = n;  simulation.f[i + 1][j][5] = n;  simulation.f[i + 1][j][8] = n;
          }
          
          else if (simulation.obstacle[i][j - 1] || simulation.boundary[i][j - 1]) {
            simulation.f[i][j - 1][2] = simulation.fNext[i][j][4];// - 2*w[4]*rho[i][j]*innerProduct(e[4], initialFlow)*inC*inC;;
            simulation.f[i][j - 1][5] = simulation.fNext[i][j][8];// - 2*w[8]*rho[i][j]*innerProduct(e[8], initialFlow)*inC*inC;;
            simulation.f[i][j - 1][6] = simulation.fNext[i][j][7];// - 2*w[7]*rho[i][j]*innerProduct(e[7], initialFlow)*inC*inC;;
            
            n = (simulation.f[i][j - 1][2] + simulation.f[i][j - 1][5] + simulation.f[i][j - 1][6])*1/3;

            simulation.f[i][j - 1][0] = n;  simulation.f[i][j - 1][1] = n;  simulation.f[i][j - 1][3] = n;
            simulation.f[i][j - 1][4] = n;  simulation.f[i][j - 1][7] = n;  simulation.f[i][j - 1][8] = n;
          }
          else if (simulation.obstacle[i][j + 1] || simulation.boundary[i][j + 1]) {
            simulation.f[i][j + 1][4] = simulation.fNext[i][j][2];// - 2*w[2]*rho[i][j]*innerProduct(e[2], initialFlow)*inC*inC;;
            simulation.f[i][j + 1][7] = simulation.fNext[i][j][6];// - 2*w[6]*rho[i][j]*innerProduct(e[6], initialFlow)*inC*inC;;
            simulation.f[i][j + 1][8] = simulation.fNext[i][j][5];// - 2*w[5]*rho[i][j]*innerProduct(e[5], initialFlow)*inC*inC;;

            n = (simulation.f[i][j + 1][4] + simulation.f[i][j + 1][7] + simulation.f[i][j + 1][8])*1/3;

            simulation.f[i][j + 1][0] = n;  simulation.f[i][j + 1][1] = n;  simulation.f[i][j + 1][2] = n;
            simulation.f[i][j + 1][3] = n;  simulation.f[i][j + 1][5] = n;  simulation.f[i][j + 1][6] = n;
          }
        }//if fluid
      }//end for column loop
    }//end for row loop
  }
  
  void macroVal() {
    for (int i = 0; i < simulation.row; i++) {
      for (int j = 0; j < simulation.column; j++) {
        if(!simulation.notFluid(i, j)) {
          simulation.rho[i][j] = 0;
          for (int k = 0; k < simulation.q; k++) {
            simulation.rho[i][j] += simulation.f[i][j][k];
          }
          simulation.u[i][j].set(((simulation.f[i][j][1]+simulation.f[i][j][5]+simulation.f[i][j][8]) - (simulation.f[i][j][3]+simulation.f[i][j][6]+simulation.f[i][j][7]))/simulation.rho[i][j],
                                 ((simulation.f[i][j][2]+simulation.f[i][j][5]+simulation.f[i][j][6]) - (simulation.f[i][j][4]+simulation.f[i][j][7]+simulation.f[i][j][8]))/simulation.rho[i][j]);
        
          for (int k = 0; k < simulation.q; k++) {simulation.fEq[i][j][k] = simulation.equilibrium(i, j, k);}
        }
      }
    }
  }
  
  int bufferLayer = 2;
  //TODO: only apply boundary condition to inlet
  void windTunnel(){
    for (int i = 0; i < bufferLayer; i++) {
      for (int j = bufferLayer*2; j < simulation.column - bufferLayer*2; j++) {
        if(simulation.notFluid(i, j)) { //simulation.boundary[i][j] || simulation.boundaryNeighbor[i][j]){
          simulation.rho[i][j] = 1;
          simulation.u[i][j] = simulation.tunnelFlow;
          for(int k = 0; k < simulation.q; k++){simulation.f[i][j][k] = simulation.equilibrium(i, j, k);}
        }
      }
    }
  }
  
  //TODO: resolve pressure cavity on corners
  void outlet(){
    for(int j = bufferLayer; j < simulation.column - bufferLayer; j ++) {
      for(int i = simulation.row - bufferLayer; i < simulation.row; i++) {
        if(!simulation.notFluid(i, j)){
          simulation.u[i][j] = simulation.u[simulation.row - bufferLayer+1][j];
          simulation.rho[i][j] = simulation.rho[simulation.row - bufferLayer+1][j];
          for(int k = 0; k < simulation.q; k++){simulation.f[i][j][k] = simulation.equilibrium(simulation.row - bufferLayer+1, j, k);}
        }
      }//end for row loop
    }//end for column loop
    
    for(int i = bufferLayer; i < simulation.row; i++) {
      for(int j = 0; j < bufferLayer; j++) {
        if(!simulation.notFluid(i, j)){
          simulation.u[i][j] = simulation.u[i][bufferLayer-1];
          simulation.u[i][simulation.column - bufferLayer + j] = simulation.u[i][simulation.column - bufferLayer+1];
          simulation.rho[i][j] = simulation.rho[i][bufferLayer-1];
          simulation.rho[i][simulation.column - bufferLayer + j] = simulation.rho[i][simulation.column - bufferLayer+1];
          for(int k = 0; k < simulation.q; k++){
            simulation.f[i][j][k] = simulation.equilibrium(i, bufferLayer-1, k);
            simulation.f[i][simulation.column - bufferLayer + j][k] = simulation.equilibrium(i, simulation.column - bufferLayer+1, k);
          }
        }
      }//end for column wrt bufferLayer loop
    }//end for row loop
  }
  
  float reynoldsN(int L, float u){
    return u*(float)L/simulation.viscosity;
  }
}
