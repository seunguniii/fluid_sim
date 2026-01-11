class ObstacleBuilder{
  private final Simulation simulation;
  private final Obstacle obstacle;
  
  ObstacleBuilder(Simulation simulation, Obstacle obstacle) {
    this.simulation = simulation;
    this.obstacle = obstacle;
  }

  void build(){
    for(int i = 0; i < simulation.row; i++){
      for(int j = 0; j < simulation.column; j++){
        obstacle(i, j);
      }
    }
    println("Done initializing obstacle");
  }

  boolean obstacle(int i, int j){
    switch(obstacle.type){
      case "pipe":          return pipe(i, j);
      case "airfoil":       return NACA4(airFoil, -angleAttack, i, j);
      case "walls":         return walls(i, j);
      case "box":           return box(i, j);
      //case" circles":       return circles(i, j);
      case "circle":        return circle(i, j, obstacle.circleRadius);
      //case" nozzle":        return nozzle(i, j);
      case "wall":          return wall(i, j);
      case "finned circle": return finnedCircle(i, j, obstacle.circleRadius);
      default: return false;
    }
  }
  
  boolean obstacleNeighbor(int i, int j){
    return (obstacle(i - 1, j) || obstacle(i + 1, j) || obstacle(i, j - 1) || obstacle(i, j + 1) || obstacle(i - 1, j - 1) || obstacle(i - 1, j + 1) || obstacle(i + 1, j - 1) || obstacle(i + 1, j + 1));
  }

  boolean NACA4(double x, double theta, int a, int b) {
    double i, j;
    double m = (int)(x/1000d)/100d;
    double p = (x%1000 - x%100)/1000d;
    double t = x%100d/100d;
    double callibrate = (locateX*(Math.tan(Math.toRadians(-angleAttack) + Math.atan(simulation.column/2/locateX)) - simulation.column/2/locateX))/simulation.column*100;
    boolean temp;
    i = (a*Math.cos(Math.toRadians(theta)) - b*Math.sin(Math.toRadians(theta)))/simulation.column*100;
    j = (b*Math.cos(Math.toRadians(theta)) + a*Math.sin(Math.toRadians(theta)))/simulation.column*100;
    
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

  boolean pipe(int i, int j){
    return ((i < 65*simulation.column/100 && (j == 54*simulation.column/100 || j == 46*simulation.column/100))
            || ((i > 67*simulation.column/100 && i < 75*simulation.column/100) && (j == 54*simulation.column/100 || j == 46*simulation.column/100))
            || (i == 49*simulation.column/100 && j > 46*simulation.column/100 && j < 54*simulation.column/100));
  }
  
  boolean walls(int i, int j){
    return((i == 35*simulation.column/100 && j > 70*simulation.column/100) 
        || (i == 85*simulation.column/100 && j < 50*simulation.column/100)
        || (j == 60*simulation.column/100 && i > 240*simulation.column/100)
        || (i == 150*simulation.column/100 && j > 20*simulation.column/100 && j < 60*simulation.column/100)
        || (j == 80*simulation.column/100 && i > 100*simulation.column/100 && i < 170*simulation.column/100)
        || (i == 200*simulation.column/100 && j > 10*simulation.column/100 && j < 40*simulation.column/100));
  }

  boolean box(int i, int j){
    return(i == 49*simulation.column/100 || j == 9*simulation.column/100 || j == 91*simulation.column/100 || i == 131*simulation.column/100);
  }

  boolean circles(int i, int j){
    return((i - 50*simulation.column/100)*(i - 50*simulation.column/100) + (j - 10*simulation.column/100)*(j - 10*simulation.column/100) < 25*simulation.column/100*simulation.column/100
       || (i - 85*simulation.column/100)*(i - 85*simulation.column/100) + (j - 40*simulation.column/100)*(j - 40*simulation.column/100) < 25*simulation.column/100*simulation.column/100
       || (i - 40*simulation.column/100)*(i - 40*simulation.column/100) + (j - 50*simulation.column/100)*(j - 50*simulation.column/100) < 25*simulation.column/100*simulation.column/100
       || (i - 100*simulation.column/100)*(i - 100*simulation.column/100) + (j - 10*simulation.column/100)*(j - 10*simulation.column/100) < 25*simulation.column/100*simulation.column/100
       || (i - 110*simulation.column/100)*(i - 110*simulation.column/100) + (j - 55*simulation.column/100)*(j - 55*simulation.column/100) < 25*simulation.column/100*simulation.column/100
       || (i - 100*simulation.column/100)*(i - 100*simulation.column/100) + (j - 90*simulation.column/100)*(j - 90*simulation.column/100) < 25*simulation.column/100*simulation.column/100
       || (i - 125*simulation.column/100)*(i - 125*simulation.column/100) + (j - 30*simulation.column/100)*(j - 30*simulation.column/100) < 25*simulation.column/100*simulation.column/100
       || (i - 150*simulation.column/100)*(i - 150*simulation.column/100) + (j - 10*simulation.column/100)*(j - 10*simulation.column/100) < 25*simulation.column/100*simulation.column/100
       || (i - 175*simulation.column/100)*(i - 175*simulation.column/100) + (j - 70*simulation.column/100)*(j - 70*simulation.column/100) < 25*simulation.column/100*simulation.column/100);
  }

  
/*
  boolean nozzle(int i, int j){
    return (i < 65*simulation.column/100 && (j == 54*simulation.column/100 || j == 46*simulation.column/100))
        || (i == 49*simulation.column/100 && j > 46*simulation.column/100 && j < 54*simulation.column/100)
        || ((i > 64*simulation.column/100 && i < 76*simulation.column/100) && (Math.abs(j-54*simulation.column/100 - 5*simulation.column/100*Math.sin(Math.PI*(i - 65*simulation.column/100)/20*100/column)) <= 1
                                                      || Math.abs(j-46*simulation.column/100 + 5*simulation.column/100*Math.sin(Math.PI*(i - 65*simulation.column/100)/20*100/column)) <= 1))
        || (i > 75*simulation.column/100 && i < 85*simulation.column/100 && (j == 58*simulation.column/100 || j == 42*simulation.column/100));
  }
*/
  boolean circle(int i, int j, double r){
    return (i - r*simulation.column/100 - 25*simulation.column/100)*(i - r*simulation.column/100 - 25*simulation.column/100) + (j - 50*simulation.column/100)*(j - 50*simulation.column/100) < r*r*simulation.column*simulation.column/100/100;
  }

  boolean wall(int i, int j){
    return (i == 35*simulation.column/100 && j > 30*simulation.column/100 && j < 70*simulation.column/100);
  }
  
  boolean finnedCircle(int i, int j, int r){
    return ((i - r*simulation.column/100 - 25*simulation.column/100)*(i - r*simulation.column/100 - 25*simulation.column/100) + (j - r*simulation.column/100 - 25*simulation.column/100)*(j - r*simulation.column/100 - 25*simulation.column/100) < r*r*simulation.column*simulation.column/100/100)
            || (i > (25 + r)*simulation.column/100 && i < (25 + 5*r)*simulation.column/100 && j == 25*simulation.column/100 + r*simulation.column/100);
  }
}
