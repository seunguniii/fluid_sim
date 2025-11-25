Vector vectorSum(Vector a, Vector b) {
  return new Vector(a.x + b.x, a.y + b.y);
}

Vector vectorDiff(Vector a, Vector b) {
  return new Vector(a.x - b.x, a.y - b.y);
}

double innerProduct(Vector a, Vector b) {
  return a.x*b.x + a.y*b.y;
}

double neq(int i, Vector u, double rho) {
  return w[i]*rho*(1d + innerProduct(u, e[i])*3 + innerProduct(u, e[i])*innerProduct(u, e[i])*0.5*inCQuad - u.vectorSizeSquare()*0.5*inCSquare);
}

static double pressure(Vector u, double rho) {
  double uSize = u.vectorSize();
  return uSize*uSize*rho*0.714286;
}

static int funcL(boolean bool){
  if(mode.equals(" airfoil") && bool)
    return (int)(airfoilSize*column*0.01);
  else{
    int L = 0;
    int maxL = 0;
  
    for(int i = 0; i < row; i++){
      for(int j = 0; j < column; j++){
        if(object[i][j] == true) L++;
      }
      maxL = L > maxL? L:maxL;
      L = 0;
    }
  
    return maxL < 4? column:maxL;
  }
}

static double reynoldsN(int L, double u){
  return u*(double)L/viscosity;
}
