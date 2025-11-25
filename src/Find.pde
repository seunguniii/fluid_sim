class Find {
  double rho_max = -1000000;
  double rho_min = 1000000;
  double u_max = -1000000;
  double u_min = 1000000;
  
  {
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        if (boundary[i][j] || object[i][j]);
        else {
          rho_max = Math.max(rho_max, rho[i][j]);
          rho_min = Math.min(rho_min, rho[i][j]);
          u_max = Math.max(u_max, u[i][j].vectorSize());
          u_min = Math.min(u_min, u[i][j].vectorSize());
        }
      }
    }
  }
  
  double max(int x) {
    if (x == 0)      return rho_max;
    else if (x == 1) return u_max;
    else return 0;
  }
  
  double min(int x) {
    if (x == 0)      return rho_min;
    else if (x == 1) return u_min;
    else return 0;
  }
}
