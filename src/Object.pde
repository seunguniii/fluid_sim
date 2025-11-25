static class Object{
  static boolean boundary(int i, int j) {
    return (i == 0 || j == 0 || i == row - 1 || j == column - 1);
  }

  static boolean NACA4(double x, double theta, int a, int b) {
    double i, j;
    double m = (int)(x/1000d)/100d;
    double p = (x%1000 - x%100)/1000d;
    double t = x%100d/100d;
    double callibrate = (locateX*(Math.tan(Math.toRadians(-angleAttack) + Math.atan(column/2/locateX)) - column/2/locateX))/column*100;
    boolean temp;
    i = (a*Math.cos(Math.toRadians(theta)) - b*Math.sin(Math.toRadians(theta)))/column*100;
    j = (b*Math.cos(Math.toRadians(theta)) + a*Math.sin(Math.toRadians(theta)))/column*100;
    
    if(m == 0 || p == 0)
      temp = (i > locateX && i < locateX + airfoilSize
           && j - locateY <= airfoilSize*(5*t*(0.2969*Math.sqrt((i - locateX)/airfoilSize) - 0.126*((i - locateX)/airfoilSize)
                             - 0.3516*((i - locateX)/airfoilSize)*((i - locateX)/airfoilSize) + 0.2843*Math.pow((i - locateX)/airfoilSize, 3) - 0.1036*Math.pow((i - locateX)/airfoilSize, 4))) + 50
           && j - locateY >= airfoilSize*(-5*t*(0.2969*Math.sqrt((i - locateX)/airfoilSize) - 0.126*((i - locateX)/airfoilSize)
                             - 0.3516*((i - locateX)/airfoilSize)*((i - locateX)/airfoilSize) + 0.2843*Math.pow((i - locateX)/airfoilSize, 3) - 0.1036*Math.pow((i - locateX)/airfoilSize, 4))) + 50);
    else
      temp = (i > locateX && i < locateX + airfoilSize
           && j - locateY >= -airfoilSize*(5*t*(0.2969*Math.sqrt((i-locateX)/airfoilSize) - 0.126*((i-locateX)/airfoilSize) - 0.3516*((i-locateX)/airfoilSize)*((i-locateX)/airfoilSize) + 0.2843*Math.pow((i-locateX)/airfoilSize, 3) - 0.1036*Math.pow((i-locateX)/airfoilSize, 4))
                 + (i - locateX <= p*airfoilSize ? m/p/p*(2*p*(i - locateX)/airfoilSize - (i - locateX)/airfoilSize*(i - locateX)/airfoilSize) : m/(1 - p)/(1 - p)*((1 - 2*p) + 2*p*(i - locateX)/airfoilSize - (i - locateX)/airfoilSize*(i - locateX)/airfoilSize))) + 50 - callibrate
           && j - locateY <= -airfoilSize*(-5*t*(0.2969*Math.sqrt((i-locateX)/airfoilSize) - 0.126*((i-locateX)/airfoilSize) - 0.3516*((i-locateX)/airfoilSize)*((i-locateX)/airfoilSize) + 0.2843*Math.pow((i-locateX)/airfoilSize, 3) - 0.1036*Math.pow((i-locateX)/airfoilSize, 4))
                 + (i - locateX <= p*airfoilSize ? m/p/p*(2*p*(i - locateX)/airfoilSize - (i - locateX)/airfoilSize*(i - locateX)/airfoilSize) : m/(1 - p)/(1 - p)*((1 - 2*p) + 2*p*(i - locateX)/airfoilSize - (i - locateX)/airfoilSize*(i - locateX)/airfoilSize))) + 50 - callibrate);
       
    return temp;
  }

  static boolean pipe(int i, int j){
    return ((i < 65*column/100 && (j == 54*column/100 || j == 46*column/100)) || ((i > 67*column/100 && i < 75*column/100) && (j == 54*column/100 || j == 46*column/100)) || (i == 49*column/100 && j > 46*column/100 && j < 54*column/100));
  }
  
  static boolean walls(int i, int j){
    return((i == 35*column/100 && j > 70*column/100) 
        || (i == 85*column/100 && j < 50*column/100)
        || (j == 60*column/100 && i > 240*column/100)
        || (i == 150*column/100 && j > 20*column/100 && j < 60*column/100)
        || (j == 80*column/100 && i > 100*column/100 && i < 170*column/100)
        || (i == 200*column/100 && j > 10*column/100 && j < 40*column/100));
  }

  static boolean box(int i, int j){
    return(i == 49*column/100 || j == 9*column/100 || j == 91*column/100 || i == 131*column/100);
  }

  static boolean circles(int i, int j){
    return((i - 50*column/100)*(i - 50*column/100) + (j - 10*column/100)*(j - 10*column/100) < 25*column/100*column/100
       || (i - 85*column/100)*(i - 85*column/100) + (j - 40*column/100)*(j - 40*column/100) < 25*column/100*column/100
       || (i - 40*column/100)*(i - 40*column/100) + (j - 50*column/100)*(j - 50*column/100) < 25*column/100*column/100
       || (i - 100*column/100)*(i - 100*column/100) + (j - 10*column/100)*(j - 10*column/100) < 25*column/100*column/100
       || (i - 110*column/100)*(i - 110*column/100) + (j - 55*column/100)*(j - 55*column/100) < 25*column/100*column/100
       || (i - 100*column/100)*(i - 100*column/100) + (j - 90*column/100)*(j - 90*column/100) < 25*column/100*column/100
       || (i - 125*column/100)*(i - 125*column/100) + (j - 30*column/100)*(j - 30*column/100) < 25*column/100*column/100
       || (i - 150*column/100)*(i - 150*column/100) + (j - 10*column/100)*(j - 10*column/100) < 25*column/100*column/100
       || (i - 175*column/100)*(i - 175*column/100) + (j - 70*column/100)*(j - 70*column/100) < 25*column/100*column/100);
  }

  static boolean nozzle(int i, int j){
    return (i < 65*column/100 && (j == 54*column/100 || j == 46*column/100))
        || (i == 49*column/100 && j > 46*column/100 && j < 54*column/100)
        || ((i > 64*column/100 && i < 76*column/100) && (Math.abs(j-54*column/100 - 5*column/100*Math.sin(Math.PI*(i - 65*column/100)/20*100/column)) <= 1
                                                      || Math.abs(j-46*column/100 + 5*column/100*Math.sin(Math.PI*(i - 65*column/100)/20*100/column)) <= 1))
        || (i > 75*column/100 && i < 85*column/100 && (j == 58*column/100 || j == 42*column/100));
  }

  static boolean circle(int i, int j, double r){
    return (i - r*column/100 - 25*column/100)*(i - r*column/100 - 25*column/100) + (j - 50*column/100)*(j - 50*column/100) < r*r*column*column/100/100;
  }

  static boolean wall(int i, int j){
    return (i == 25*column/100 && j > 35*column/100 && j < 75*column/100);
  }
  
  static boolean finnedCircle(int i, int j, int r){
    return ((i - r*column/100 - 25*column/100)*(i - r*column/100 - 25*column/100) + (j - r*column/100 - 25*column/100)*(j - r*column/100 - 25*column/100) < r*r*column*column/100/100)
         || (i > (25 + r)*column/100 && i < (25 + 5*r)*column/100 && j == 25*column/100 + r*column/100);
  }

  static boolean object(int i, int j){
    switch(mode){
      case " pipe":          return pipe(i, j);
      case " airfoil":       return NACA4(airFoil, -angleAttack, i, j);
      case " walls":         return walls(i, j);
      case " box":           return box(i, j);
      case " circles":       return circles(i, j);
      case " circle":        return circle(i, j, circleRadius);
      case " nozzle":        return nozzle(i, j);
      case " wall":          return wall(i, j);
      case " finned circle": return finnedCircle(i, j, circleRadius);
      default: return false;
    }
  }

  static boolean objectNeighbor(int i, int j){
    return (object(i - 1, j) || object(i + 1, j) || object(i, j - 1) || object(i, j + 1) || object(i - 1, j - 1) || object(i - 1, j + 1) || object(i + 1, j - 1) || object(i + 1, j + 1));
  }

  static boolean boundaryNeighbor(int i, int j){
    return (boundary(i - 1, j) || boundary(i + 1, j) || boundary(i, j - 1) || boundary(i, j + 1));
  }
}
