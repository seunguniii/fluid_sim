static double pressure(PVector u, double rho) {
  double uSize = u.mag();
  return uSize*uSize*rho*0.714286;
}
