class Simulation {
  final float dx = 1;
  final float dt = 1;
  final float inDt = 1/dt;
  final float c = (float)Math.sqrt(dx*dx/dt/dt/3d);
  final float inC = 1/c;  //for faster calculations
  final float inCSquare = inC*inC;
  final float inCQuad = inC*inC*inC*inC;
  
  final float omega = 1.5; //equilibration constant
  final float viscosity = 1f/3f*(1f/omega - 0.5);
  
  final int q = 9; //D2Q9 -> q value = 9
  
  int row, column; //length of a row/column
  
  float[] w = new float[q];
  PVector [] e = new PVector[q];
  PVector [][] u;
  float [][] p, rho;
  float [][][] f, fNext, fEq;

  String obstacleShape;
  boolean [][] boundary, obstacle, boundaryNeighbor, obstacleNeighbor;
  
  boolean windTunnel;
  float tunnelFlowX = 0;
  float tunnelFlowY = 0;
  PVector tunnelFlow; //for simulating wind tunnel
  
  int L;
  float Re;
  
  float equilibrium(int i, int j, int k) {
    float uDotE = u[i][j].dot(e[k]);
    return w[k]*rho[i][j]*(1 + uDotE*3 + uDotE*uDotE*0.5*inCQuad - u[i][j].magSq()*0.5*inCSquare);
  }
  
  boolean notFluid(int i, int j) {
    return boundary[i][j] || obstacle[i][j] || boundaryNeighbor[i][j] || obstacleNeighbor[i][j];
  }
}
