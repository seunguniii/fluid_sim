class SimulationConfigurator{
  private final Simulation simulation;
  
  SimulationConfigurator(Simulation simulation) {
    this.simulation = simulation;
  }
  
  final float initialRho = 1f;
  final PVector initialFlow = new PVector(0f, 0f);
  
  void lattice() {
    simulation.row = 3*simulation.column;
    println("Total number of lattice: " + simulation.column*simulation.row);
    arrays();
    macroValue();
  }
  
  boolean verify(){
    int errCount = 0;
    for(int l = 0; l < simulation.q; l++){
      if(Float.isNaN(simulation.e[l].mag())) {
        println("Bad e vector at [" + l + "]"); errCount ++;
      }
      if(Float.isNaN(simulation.w[l])) {
        println("Bad w value at [" + l + "]"); errCount ++;
      }
    }
    for(int i = 0; i < simulation.row; i++){
      for(int j = 0; j < simulation.column; j++){
        if(Float.isNaN(simulation.u[i][j].mag())) println("Bad u at [" + i + "][" + j + "]"); errCount ++;
        if(Float.isNaN(simulation.rho[i][j])) println("Bad rho at [" + i + "][" + j + "]"); errCount ++;
        
        for(int k = 0; k < simulation.q; k ++){
          if(Float.isNaN(simulation.f[i][j][k])) println("Bad f at f[" + i + "][" + j + "][" + k + "]"); errCount ++;
          if(Float.isNaN(simulation.fNext[i][j][k])) println("Bad fNext[i][j][k] at f[" + i + "][" + j + "][" + k + "]"); errCount ++;
          if(Float.isNaN(simulation.fEq[i][j][k])) println("Bad fEq[i][j][k] at f[" + i + "][" + j + "][" + k + "]"); errCount ++;
        } //end for all q loop
      } //end for all column loop
    } //end for all row loop
    if(errCount == 0) {
      println("Validation complete. Simulation ready.");
      return true;
    } else {
      println("Faulty initialization. Simulation not ready. Needs reconfiguration.");
      return false;
    }
  }
  
  void e_i() {
    simulation.e[0] = new PVector(0f, 0f);
    simulation.e[1] = new PVector(1f, 0f);
    simulation.e[2] = new PVector(0f, 1f);
    simulation.e[3] = new PVector(-1f, 0f);
    simulation.e[4] = new PVector(0f, -1f);
    simulation.e[5] = new PVector(1f, 1f);
    simulation.e[6] = new PVector(-1f, 1f);
    simulation.e[7] = new PVector(-1f, -1f);
    simulation.e[8] = new PVector(1f, -1f);
  }

  void w_i() {
    for (int i = 0; i < simulation.q; i++) {
      if (i < 1) simulation.w[i] = 4f/9f;
      else if (i < 5) simulation.w[i] = 1f/9f;
      else simulation.w[i] = 1f/36f;
    }
  }

  void arrays() {
    simulation.rho = new float[simulation.row][simulation.column];
    simulation.u = new PVector[simulation.row][simulation.column];
    simulation.p = new float[simulation.row][simulation.column];
    
    simulation.f = new float[simulation.row][simulation.column][9];
    simulation.fNext = new float[simulation.row][simulation.column][9];
    simulation.fEq = new float[simulation.row][simulation.column][9];
    
    simulation.boundary = new boolean[simulation.row][simulation.column];
    simulation.obstacle = new boolean[simulation.row][simulation.column];
    simulation.obstacleNeighbor = new boolean[simulation.row][simulation.column];
    simulation.boundaryNeighbor = new boolean[simulation.row][simulation.column];
    
    println("Done initializing arrays.");
  }

  void macroValue() {
    for (int i = 0; i < simulation.row; i++) {
      for (int j = 0; j < simulation.column; j++) {
        simulation.u[i][j] = new PVector(initialFlow.x, initialFlow.y);
        simulation.rho[i][j] = initialRho;
      }
    }
    println("Done setting macro values.");
  }

  void f() {
    for (int i = 1; i < simulation.row - 1; i++) {
      for (int j = 1; j < simulation.column - 1; j++) {
        for (int k = 0; k < simulation.q; k++) {
          simulation.f[i][j][k] = simulation.equilibrium(i, j, k);
        }
      }
    }
    
    println("Done initializing lattices.");
  }

  void fEq() {
    for (int i = 1; i < simulation.row - 1; i++) {
      for (int j = 1; j < simulation.column - 1; j++) {
        for (int k = 0; k < simulation.q; k++) {
          simulation.fEq[i][j][k] = simulation.equilibrium(i, j, k);
        }
      }
    }
    println("Done calculating equilibrium.");
  }

  void boundary() {
    for (int i = 0; i < simulation.row; i++) {
      for (int j = 0; j < simulation.column; j++) {
        simulation.boundary[i][j] = boundaryCheck(i, j);
        simulation.boundaryNeighbor[i][j] = boundaryNeighbor(i, j);
        
        simulation.obstacle[i][j] = obsBuilder.obstacle(i, j);
        simulation.obstacleNeighbor[i][j] = obsBuilder.obstacleNeighbor(i, j);
      }
    }
    for (int i = 0; i < simulation.row; i++) {
      for (int j = 0; j < simulation.column; j++) {
        if (simulation.obstacle[i][j] || simulation.obstacleNeighbor[i][j]) {
          simulation.u[i][j].set(0f, 0f);
          simulation.rho[i][j] = initialRho;
        }
      }
    }
    println("Done setting boundary.");
  }
  
  boolean boundaryCheck(int i, int j) {
    return (i == 0 || j == 0 || i == simulation.row - 1 || j == simulation.column - 1);
  }
  
  boolean boundaryNeighbor(int i, int j){
    return (boundaryCheck(i - 1, j) || boundaryCheck(i + 1, j) || boundaryCheck(i, j - 1) || boundaryCheck(i, j + 1));
  }

  /*
  void setInitialFlow(float x, float y){
    initialFlow.x = x;
    initialFlow.y = y;
  }

  void initialCondition() {
    simulation.rho[49*simulation.column/100][simulation.column/2] = 5f;
    simulation.rho[50*simulation.column/100][simulation.column/2] = 5f;
  }
  */
  
  void funcL(){
    if(obstacle.type.equals("airfoil"))
      simulation.L = (int)(airfoilSize*simulation.column*0.01);
    else{
      int L = 0;
      int maxL = 0;
  
      for(int i = 0; i < simulation.row; i++){
        for(int j = 0; j < simulation.column; j++){
          if(simulation.obstacle[i][j] == true) L++;
        }
        maxL = L > maxL? L:maxL;
          L = 0;
      }
  
      simulation.L = maxL < 4? simulation.column:maxL;
    }
  }

  void liftDragPoints() {
    double temp = 0.05*simSolver.reynoldsN(simulation.L, -simulation.tunnelFlowX);
    liftMax = 0;
    liftMin = 0;
    dragMax = temp + 0.5;
    dragMin = temp - 0.5;
    graphEnd = (int)(endLoop/lpf);
    graphStep = 1.5/graphEnd;
    liftPoint = new double[graphEnd + 1];
    dragPoint = new double[graphEnd + 1];
    for (int i = 0; i < graphEnd + 1; i++) {
      liftPoint[i] = 0;
      dragPoint[i] = temp;
    }
  }
}
