class UIController {
  //TODO display error msg for a certain amount of time
  private final Simulation simulation;
  private final Obstacle obstacle;
  private final ObstacleBuilder obsBuilder;

  UIController(Simulation simulation, Obstacle obstacle, ObstacleBuilder obsBuilder) {
    this.simulation = simulation;
    this.obstacle = obstacle;
    this.obsBuilder = obsBuilder;
  }

  int typingDelay = 80;
  int enterDelay = 100;
  int goBackDelay = 100;
  String input = "";

  float valueFloat = 0;
  String valueString = "";

  boolean inputCommitted = false;
  Shade shade = new Shade();

  void update() {
    shade.gray(0);
    rect(h3 + 0.25*h, 0, 1.52*h, 0.6*h);
    if(state != UIState.SET_COLUMN) rightColumn1();

    switch (state) {
    case SET_COLUMN:
      fill(255);
      text("Input the number of lattices on a column: ", h3 + 0.25*h, 0.0625*h);
      text("100, 125, 250, 500 are recommended", h3 + 0.25*h, 0.1125*h);
      getValue(FLOAT, 0.05*h);
      if (inputCommitted) {
        if (valueFloat > 2) {
          state = UIState.SELECT_OBJECT;
          simulation.column = (int)valueFloat;
          simConfigurator.lattice();
          size = h/simulation.column;
        } else {
          fill(255, 0, 0);
          text("Column length should be larger than 2", h3 + 0.25*h, 0.1625*h);
        }
        inputCommitted = false;
      }
      break;
      
    case SELECT_OBJECT:
      fill(255);
      text("Select Object: ", h3 + 0.25*h, 0.0625*h);
      getValue(STRING, 0);
      if (inputCommitted) {
        obstacle.type = valueString;
        obstacle.checkRequirements();

        if (obstacle.needSpecification) state = UIState.SPECIFY_OBJECT;
        else {
          state = UIState.CONFIRM_OBJECT;
          obsBuilder.build();
          simConfigurator.boundary();
          simConfigurator.funcL();
        }
        inputCommitted = false;
      }
      goBack(UIState.SET_COLUMN);
      break;

    case SPECIFY_OBJECT:
      switch(obstacle.type) {
      case "airfoil":
        fill(255);
        text("Input 4-digit NACA airfoil: ", h3 + 0.25*h, 0.0625*h);
        getValue(FLOAT, 0);
        if (inputCommitted) {
          obstacle.airfoil4Digit = (int)valueFloat;
          //state = airfoilSize, AOA, x, y; //TODO//
          inputCommitted = false;
        }
        break;
      case "circle":
      case "finned circle":
        fill(255);
        text("Input radius: ", h3 + 0.25*h, 0.0625*h);
        getValue(FLOAT, 0);
        break;
      default:
        break;
      }
      if (inputCommitted) {
        if (obstacle.needsRadius) obstacle.circleRadius = (int)valueFloat;
        else //obstacle.Airfoil = input;
        obsBuilder.build();
        simConfigurator.boundary();
        simConfigurator.funcL();
        inputCommitted = false;
        state = UIState.CONFIRM_OBJECT;
      }
      goBack(UIState.SELECT_OBJECT);
      break;

    case CONFIRM_OBJECT:
      renderer.obstacle(0);
      fill(255);
      text("Press ENTER to confirm object.", h3 + 0.25*h, 0.0625*h);
      if (keyPressed && key == 10) state = UIState.SET_PERIODIC;
      
      if (obstacle.needSpecification) goBack(UIState.SPECIFY_OBJECT);
      else goBack(UIState.SELECT_OBJECT);
      break;

    //TODO
    case SET_PERIODIC:
      state = UIState.SET_WIND_TUNNEL;
      goBack(UIState.CONFIRM_OBJECT);
      delay(100);
      break;

    case SET_WIND_TUNNEL:
      fill(255);
      text("Set wind tunnel? y/n", h3 + 0.25*h, 0.0625*h);
      getValue(STRING, 0);
      if (inputCommitted) {
        if (valueString.equals("y") || valueString.equals("n")) {
          simulation.windTunnel = valueString.equals("y")? true:false;
          if (simulation.windTunnel) state = UIState.SET_WIND_VELOCITY;
          else state = UIState.READY;
        }
        else {
          fill(255, 0, 0);
          text("Enter either y or n.", h3 + 0.25*h, 0.1125*h);
        }
        inputCommitted = false;
      }
      //goBack(UIState.SET_PERIODIC);
      goBack(UIState.CONFIRM_OBJECT);
      break;

    //TODO: figure out why wind tunnel velocity has to be (-)
    case SET_WIND_VELOCITY:
      fill(255);
      text("Set wind tunnel's", h3 + 0.25*h, 0.0625*h);
      text("initial velocity.", h3 + 0.25*h, 0.1125*h);
      getValue(FLOAT, 0.05*h);
      if (inputCommitted) {
        simulation.tunnelFlow = new PVector(valueFloat, 0);
        state = UIState.READY;
        inputCommitted = false;
      }
      goBack(UIState.SET_WIND_TUNNEL);

      break;

    case READY:
      simConfigurator.f();
      simConfigurator.fEq();
      simConfigurator.liftDragPoints();
      for(int i = 0;  i < simulation.column*0.1; i++) {
        simSolver.collision();
        simSolver.stream();
        if(simulation.windTunnel) simSolver.windTunnel();
        simSolver.macroVal();
      }
      if(!simConfigurator.verify()) {
        state = UIState.SET_COLUMN;
        println("Reconfiguring simulation.");
        break;
      } else {
        simulate = true;
        state = UIState.RUNNING;
        break;
      }

    case RUNNING:
      ui.leftColumn1();
      ui.centerColumn1();
      if (keyPressed && key == 99) { // press "c" to abort sim
        fill(255, 0, 0);
        text("Simulation aborted by user.", h3 + 0.25*h, 0.1125*h);
        println("abort");
        simulate = !simulate;
        state = UIState.SET_COLUMN;
        delay(typingDelay);
      }
      break;
    }
  }

  void goBack(UIState prevState) {
    if (keyPressed && key == 9) { //press TAB to go back
      state = prevState;
      inputCommitted = false;
      input = "";
      delay(goBackDelay);
    }
  }


  final boolean FLOAT = true;
  final boolean STRING = false;
  
  void getValue(boolean mode, float y) { //true: get float | false: get string. used boolean so erroneous value can't be input
    if (keyPressed) {
      switch(key) {
      case 10: //ENTER pressed
        try {
          if (mode) valueFloat = (float)Double.parseDouble(input);
          else valueString = input;
          input = "";
        }
        catch(Exception e) {
          fill(255, 0, 0);
          text("Empty string. Enter valid value", h3 + 0.25*h, 0.1125*h + y);
          return;
        }
        inputCommitted = true;
        delay(enterDelay);
        break;
      case 8: //BACKSPACE pressed
        if (input.length() > 0) input = input.substring(0, input.length() - 1);
        delay(typingDelay);
        break;
      default:
        input += key;
        delay(typingDelay);
      }
    }
    fill(0, 255, 0);
    text(input, h3 + 0.25*h, 0.1125*h + y);  //0.025h : one letter width 0.05: one letter height
  }

  //TODO
  void configureAirfoil() {
    println("airfoil");
  }

  void configureCircle() {
  }


  void leftColumn1() {
    shade.gray(0);
    rect(h3, 0, 0.3*h, 0.5*h);
    fill(255);
    text("Iteration", h3 + 0.02*h, 0.0625*h);
    text("Reynolds", h3 + 0.02*h, 0.2125*h);
    text("Number", h3 + 0.02*h, 0.2625*h);
    text("Cl/Cd", h3 + 0.02*h, 0.4125*h);

    fill(0, 255, 0);
    text("" + iteration, h3 + 0.022*h, 0.1125*h);
    text("" + (int)simSolver.reynoldsN(simulation.L, renderer.meanU), h3 + 0.02*h, 0.3125*h); //TODO simSolver is currently static
    text("" + nf((float)(lift/drag), 0, 4), h3 + 0.02*h, 0.4625*h);
  }

  void rightColumn1() {
    fill(255);
    text(" Object", h3 + 1.05*h, 0.0625*h);
    fill((obstacle.type.equals("pipe")) ? 255:0, 255, (obstacle.type.equals("pipe")) ? 255:0);
    text(" pipe", h3 + 1.05*h, 0.1125*h);
    fill((obstacle.type.equals("airfoil")) ? 255:0, 255, (obstacle.type.equals("airfoil")) ? 255:0);
    text(" airfoil", h3 + 1.05*h, 0.1625*h);
    text("  NACA " + (airFoil < 1000 ? (airFoil == 0? "0000":"00"+airFoil) : airFoil) + ", AOA = " + angleAttack, h3 + 1.05*h, 0.2125*h);
    fill((obstacle.type.equals("wall")) ? 255:0, 255, (obstacle.type.equals("wall")) ? 255:0);
    text(" wall", h3 + 1.05*h, h*0.2625);
    fill((obstacle.type.equals("walls")) ? 255:0, 255, (obstacle.type.equals("walls")) ? 255:0);
    text(" walls", h3 + 1.05*h, 0.3125*h);
    fill((obstacle.type.equals("box")) ? 255:0, 255, (obstacle.type.equals("box")) ? 255:0);
    text(" box", h3 + 1.05*h, 0.3625*h);
    fill((obstacle.type.equals("finned circle")) ? 255:0, 255, (obstacle.type.equals("finned circle")) ? 255:0);
    text(" finned circle", h3 + 1.05*h, h*0.4125);
    fill((obstacle.type.equals("circles")) ? 255:0, 255, (obstacle.type.equals("circles")) ? 255:0);
    text(" circles", h3 + 1.05*h, h*0.4625);
    fill((obstacle.type.equals("circle")) ? 255:0, 255, (obstacle.type.equals("circle")) ? 255:0);
    text(" circle", h3 + 1.05*h, h*0.5125);
  }

  void centerColumn1() {
    fill(255);
    text(" Contour", h3 + 0.25*h, 0.0625*h);
    text(" Vector Field", h3 + 0.25*h, 0.2625*h);
    fill(0, 255, 0);
    text(" UP  : " + contour[0], h3 + 0.25*h, 0.1125*h);
    text(" DOWN: " + contour[1], h3 + 0.25*h, 0.1625*h);
    text(" UP  : " + vectorField[0], h3 + 0.25*h, 0.3125*h);
    text(" DOWN: " + vectorField[1], h3 + 0.25*h, 0.3625*h);

    fill(255);
    text(" End loop", h3 + 0.25*h, 0.4625*h);
    text(" Loops per frame", h3 + 0.55*h, 0.4625*h);
    fill(0, 255, 0);
    text(" " + endLoop, h3 + 0.25*h, 0.5125*h);
    text(" " + lpf, h3 + 0.55*h, 0.5125*h);

    fill(255);
    text(" Wind Tunnel", h3 + 0.645*h, 0.0625*h);
    text(" Periodic", h3 + 0.645*h, 0.2625*h);
    text(" Boundary", h3 + 0.645*h, 0.3125*h);
    fill(0, 255, 0);
    text(" " + simulation.windTunnel, h3 + 0.645*h, 0.1125*h);
    if(simulation.windTunnel) text(" Speed: " + simulation.tunnelFlow.x, h3 + 0.645*h, 0.1625*h);
    text(" " + periodic, h3 + 0.645*h, 0.3625*h);
  }
}
