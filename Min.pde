static class Min {
  static double rho() {
    double min = 1000000;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        if (boundary[i][j] || object[i][j]);
        else min = Math.min(min, rho[i][j]);
      }
    }
    return min;
  }

  static double u() {
    double min = 1000000;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        if (boundary[i][j] || object[i][j]);
        else min = Math.min(min, u[i][j].vectorSize());
      }
    }
    return min;
  }

  static double ux() {
    double min = 1000000;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        if (boundary[i][j] || object[i][j]);
        else min = Math.min(min, Math.abs(u[i][j].x));
      }
    }
    return min;
  }

  static double p() {
    double min = 1000000;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        if (boundary[i][j] || object[i][j]);
        else min = Math.min(min, pressure(u[i][j], rho[i][j]));
      }
    }
    return min;
  }
}
