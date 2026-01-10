////////////////////////////////////////////////////////
//SeungUn Jin                                         // 
//Yonsei Univ. Mechanical Engineering                 //
//2023/03                                             //
//Fluid simulator based on lattice-Boltzmann algorithm//
//seungun@yonsei.ac.kr                                //
////////////////////////////////////////////////////////

//find START_FROM_HERE tag

import java.lang.Math;

PFont font;

Simulation simulation = new Simulation();
SimulationSolver simSolver = new SimulationSolver(simulation);
SimulationConfigurator simConfigurator = new SimulationConfigurator(simulation);

Obstacle obstacle = new Obstacle();
ObstacleBuilder obsBuilder = new ObstacleBuilder(simulation, obstacle);

UIController ui = new UIController(simulation, obstacle, obsBuilder);
Find find = new Find(simulation);
Renderer renderer = new Renderer(simulation, find);
Legend legend = new Legend();
Shade shade = new Shade();

void setup()
{
  vectorField[0] = true; vectorField[1] = false;
  
  font = createFont("Consolas", 15, true);
  size(2375, 1000); //3*h + 1.75(=7/4)*h, 2*h
  background(0);
  stroke(0, 255, 0);
  textFont(font);
  textSize(0.05*h);
  
  simConfigurator.e_i();
  println("Done setting e_i vectors.");
  simConfigurator.w_i();
  println("Done setting w_i vectors.");
}

int iteration = 0;
boolean simulate = false;

void draw()
{
  ui.update();
  rhoLocate = 1;
  uLocate = 0;
  if(simulate){
    if(iteration % lpf == 0){
      if(rhoLocate < 2 && uLocate < 2) renderer.canvas(rhoLocate, uLocate);
    
      if(iteration > simulation.row){
        textSize(0.05*h);
        shade.gray(0);
        rect(h3 + 1, 0.65*h - 7, 1.75*h, 1.4*h);
        
        graphEnd = (int)(iteration/lpf);
        graphStep = 1.5/graphEnd;
        renderer.liftGraph();
        renderer.dragGraph();
      }
    }
  
    simSolver.collision();
    simSolver.stream();
    simSolver.bounceBack();
    if(simulation.windTunnel) {
      simSolver.windTunnel();
      simSolver.outlet();
    }
    simSolver.macroVal();
    
    iteration++;
    /*
    if(loop > endLoop || (keyPressed && key == 10)){
      //TODO ui.success();
      loop = 0;
      delay(100);
    }*/
  }
}
