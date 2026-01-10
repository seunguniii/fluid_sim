class SimulationConfigurator {
  void e_i() {
    e[0] = new Vector(0d, 0d);
    e[1] = new Vector(1d, 0d);
    e[2] = new Vector(0d, 1d);
    e[3] = new Vector(-1d, 0d);
    e[4] = new Vector(0d, -1d);
    e[5] = new Vector(1d, 1d);
    e[6] = new Vector(-1d, 1d);
    e[7] = new Vector(-1d, -1d);
    e[8] = new Vector(1d, -1d);
  }

  void w_i() {
    for (int i = 0; i < 9; i++) {
      if (i < 1) w[i] = 4d/9d;
      else if (i < 5) w[i] = 1d/9d;
      else w[i] = 1d/36d;
    }
  }

  void arrays(){
    rho = new double[row][column];
    u = new Vector[row][column];
    pressure = new double[row][column];
    oldN = new double[row][column][9];
    newN = new double[row][column][9];
    Neq = new double[row][column][9];
    boundary = new boolean[row][column];
    object = new boolean[row][column];
    objectNeighbor = new boolean[row][column];
    boundaryNeighbor = new boolean[row][column];
  }
  
  void liftDragPoints(){
    //liftPoint = new double[100];
    //dragPoint = new double[100];
    double temp = 0.05*reynoldsN(funcL(false), -tunnelFlowX);
    liftMax = 0; liftMin = 0;
    dragMax = temp + 0.5; dragMin = temp - 0.5;
    graphEnd = (int)(endLoop/lpf);
    graphStep = 1.5/graphEnd;
    liftPoint = new double[graphEnd + 1];
    dragPoint = new double[graphEnd + 1];
    for(int i = 0; i < graphEnd + 1; i++){
      liftPoint[i] = 0;
      dragPoint[i] = temp;
    }
  }

  void macroValue() {
    for (int i = 0; i < row; i++) {
      for (int k = 0; k < column; k++) {
        u[i][k] = initialFlow;
        rho[i][k] = initialRho;
      }
    }
  }
  
  void N(){
    for(int i = 1; i < row - 1; i++){
      for(int k = 1; k < column - 1; k++){
        for (int j = 0; j < 9; j++) {
          oldN[i][k][j] = neq(j, u[i][k], rho[i][k]);
        }
      }
    }
  }
  
  void Neq(){
    for(int i = 1; i < row - 1; i++){
      for(int k = 1; k < column - 1; k++){
        for (int j = 0; j < 9; j++) {
          Neq[i][k][j] = neq(j, u[i][k], rho[i][k]);
        }
      }
    }
  }
  
  void boundary(){
    for(int i = 0; i < row; i++){
      for(int j = 0; j < column; j++){
        boundary[i][j] = Object.boundary(i, j);
        object[i][j] = Object.object(i, j);
        objectNeighbor[i][j] = Object.objectNeighbor(i, j);
        boundaryNeighbor[i][j] = Object.boundaryNeighbor(i, j);
      }
    }
    for(int i = 0; i < row; i++){
      for(int j = 0; j < column; j++){
        if(object[i][j] || objectNeighbor[i][j]){
          u[i][j] = new Vector(0d, 0d);
          rho[i][j] = 1d;
          for(int k = 0; k < 9; k++){
            Neq[i][j][k] = neq(k, u[i][j], rho[i][j]);
          }
        }
      }
    }
  }
  
  void initialCondition(){
    rho[49*column/100][column/2] = 1.5d;
    rho[50*column/100][column/2] = 1.5d;
  }
}

