static class Max {
  static double rho() {
    double max = -1000000;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        if (boundary[i][j] || object[i][j]);
        else max = Math.max(max, rho[i][j]);
      }
    }
    return max;
  }

  static double u() {
    double max = -1000000;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        if (boundary[i][j] || object[i][j]);
        else max = Math.max(max, u[i][j].vectorSize());
      }
    }
    return max;
  }

  static double p() {
    double max = -1000000;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        if (boundary[i][j] || object[i][j]);
        else max = Math.max(max, pressure(u[i][j], rho[i][j]));
      }
    }
    return max;
  }
}
