////////////////////////////////////////////////////////
//SeungUn Jin                                         // 
//Yonsei Univ. Mechanical Engineering                 //
//2023/03                                             //
//Fluid simulator based on lattice-Boltzmann algorithm//
//seungun@yonsei.ac.kr                                //
////////////////////////////////////////////////////////

import java.lang.Math;

PFont font;
Paint paint = new Paint();
Legend legend = new Legend();
Shade shade = new Shade();
Set set = new Set();
Update update = new Update();
UI ui = new UI();

static int loop = 0;

void setup()
{
  font = createFont("Consolas", 15, true);
  size(2375, 1000); //3*h + 1.75(=7/4)*h, 2*h
  background(0);
  stroke(0, 255, 0);
  
  initialFlow = new Vector(0, 0);
  
  println("c: " + c);
  set.e_i();
  println("Done setting e_i vectors.");
  set.w_i();
  println("Done setting w_i vectors.");
}

double maxRho, minRho;
double maxU, minU;
int lpfCheck = 0;
boolean simulate = false;

void draw()
{
  textFont(font);
  textSize(0.05*h);
  shade.gray(0);
  rect(h3 + 0.022*h, 0, 0.23*h, 0.62*h);
  
  if(simulate){
    ui.leftColumn1();
    if(lpfCheck == lpf){
      if(rhoLocate < 2 && uLocate < 2) paint.canvas(rhoLocate, uLocate);
    
      if(loop > row){
        textSize(0.05*h);
        shade.gray(0);    rect(h3 + 1, 0.65*h - 7, 1.75*h, 1.4*h);
        graphEnd = (int)(loop/lpf);
        graphStep = 1.5/graphEnd;
        paint.liftGraph();
        paint.dragGraph();
      }
      
      //saveFrame(mode + "-####.png");
      lpfCheck = 0;
    }
  
    update.collision();
    update.stream();
    if(windTunnel) update.windTunnel();
    update.macroVal();
    lpfCheck++;
    loop++;
    //if(loop == endLoop/2) saveFrame("####.png");
    if(loop > endLoop){ //or if user stops simulation
      ui.success();
     loop = 0;
    }
  }
  
  else{
    if(setColumn)               {ui.setColumn();}
    
    else if(selectObject)       {ui.selectObject();}
    else if(selectAirfoil)      {ui.selectAirfoil();}
    else if(selectAirfoilSize)  {ui.selectAirfoilSize();}
    else if(selectAOA)          {ui.selectAOA();}
    else if(callibrateX)        {ui.callibrateX();}
    else if(callibrateY)        {ui.callibrateY();}
    else if(confirmAirfoil)     {ui.confirmAirfoil();}
    else if(selectRadius)       {ui.selectRadius();}
    else if(confirmCircle)      {ui.confirmCircle();}
    else if(confirmObject)      {ui.confirmObject();}
    
    else if(condPeri)           {ui.condPeri();}
    else if(condWind)           {ui.condWind();}
    else if(setWindVel)         {ui.setWindVel();}
    
    else if(setLpf)             {ui.setLpf();}
    else if(setEndLoop)         {ui.setEndLoop();}
    
    else if(selectPaint)        {ui.selectPaint();}
    else if(setContour)         {ui.setContour();}
    else if(setVF)              {ui.setVF();}
    //selectColorScheme()
    
    else{
      shade.gray(0);
      rect(h3 + 0.022*h, 0, 1.75*h, h);
      ui.centerColumn1();
      ui.rightColumn1();
      
      set.Neq();
      println("Done initializing density equilibrium");
      set.liftDragPoints();
      println("Done initializing arrays for plotting graphs");
      println("Simulation mode:" + mode);
      println("Starting simulation.");
      simulate = true;
      shade.gray(0); rect(h3, h, 1.75*h, h);
    }
  }
}
