class Obstacle {
  String type = "NULL";
  int airfoil4Digit;
  float angleOfAttack;
  int circleRadius;
  boolean needSpecification;
  boolean needsRadius;

  void checkRequirements() {
    switch(type) {
    case "circle":
    case "finned circle":
      needsRadius = true;
    case "airfoil":
      needSpecification = true;
      break;
    default:
      needsRadius = false;
      needSpecification = false;
      break;
    }
  }
}
