class Vector {
  double x;
  double y;

  Vector(double x, double y) {
    this.x = x;
    this.y = y;
  }

  double vectorSize() {
    return Math.sqrt(x*x + y*y);
  }
  
  double vectorSizeSquare() {
    return x*x + y*y;
  }
}
