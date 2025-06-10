class UI{
  void leftColumn1(){
    fill(255);       text("Loop", h3 + 0.02*h, 0.0625*h);
                     text("Reynolds", h3 + 0.02*h, 0.2125*h);
                     text("Number", h3 + 0.02*h, 0.2625*h);
                     text("Cl/Cd", h3 + 0.02*h, 0.4125*h);
    
    fill(0, 255, 0); text("" + loop, h3 + 0.022*h, 0.1125*h);
                     text("" + (int)reynoldsN(L, meanU), h3 + 0.02*h, 0.3125*h);
                     text("" + nf((float)(lift/drag), 0, 4), h3 + 0.02*h, 0.4625*h);
  }
  
  void rightColumn1(){
    fill(255);                                                                                   text(" Object", h3 + 1.05*h, 0.0625*h);
    fill((mode.equals(" pipe")) ? 255:0, 255, (mode.equals(" pipe")) ? 255:0);                   text(" pipe", h3 + 1.05*h, 0.1125*h);
    fill((mode.equals(" airfoil")) ? 255:0, 255, (mode.equals(" airfoil")) ? 255:0);             text(" airfoil", h3 + 1.05*h, 0.1625*h);
                                                                                                 text("  NACA " + (airFoil < 1000 ? (airFoil == 0? "0000":"00"+airFoil) : airFoil) + ", AOA = " + angleAttack, h3 + 1.05*h, 0.2125*h);
    fill((mode.equals(" wall")) ? 255:0, 255, (mode.equals(" wall")) ? 255:0);                   text(" wall", h3 + 1.05*h, h*0.2625);
    fill((mode.equals(" walls")) ? 255:0, 255, (mode.equals(" walls")) ? 255:0);                 text(" walls", h3 + 1.05*h, 0.3125*h);
    fill((mode.equals(" box")) ? 255:0, 255, (mode.equals(" box")) ? 255:0);                     text(" box", h3 + 1.05*h, 0.3625*h);
    fill((mode.equals(" finned circle")) ? 255:0, 255, (mode.equals(" finned circle")) ? 255:0); text(" finned circle", h3 + 1.05*h, h*0.4125);
    fill((mode.equals(" circles")) ? 255:0, 255, (mode.equals(" circles")) ? 255:0);             text(" circles", h3 + 1.05*h, h*0.4625);
    fill((mode.equals(" circle")) ? 255:0, 255, (mode.equals(" circle")) ? 255:0);               text(" circle", h3 + 1.05*h, h*0.5125);
  }
  
  void centerColumn1(){
    fill(255);       text(" Contour", h3 + 0.25*h, 0.0625*h);
    fill(0, 255, 0); text(" UP  : " + contour[0], h3 + 0.25*h, 0.1125*h);
    fill(0, 255, 0); text(" DOWN: " + contour[1], h3 + 0.25*h, 0.1625*h);
    fill(255);       text(" Vector Field", h3 + 0.25*h, 0.2625*h);
    fill(0, 255, 0); text(" UP  : " + vectorField[0], h3 + 0.25*h, 0.3125*h);
    fill(0, 255, 0); text(" DOWN: " + vectorField[1], h3 + 0.25*h, 0.3625*h);
  
    fill(255);       text(" End loop", h3 + 0.25*h, 0.4625*h);
    fill(0, 255, 0); text(" " + endLoop, h3 + 0.25*h, 0.5125*h);
    fill(255);       text(" Loops per frame", h3 + 0.55*h, 0.4625*h);
    fill(0, 255, 0); text(" " + lpf, h3 + 0.55*h, 0.5125*h);
    
    fill(255);       text(" Wind Tunnel", h3 + 0.645*h, 0.0625*h);
    fill(0, 255, 0); text(" " + windTunnel, h3 + 0.645*h, 0.1125*h);
                     text(" Speed: " + -tunnelFlowX, h3 + 0.645*h, 0.1625*h);
    fill(255);       text(" Periodic", h3 + 0.645*h, 0.2625*h);
                     text(" Boundary", h3 + 0.645*h, 0.3125*h);
    fill(0, 255, 0); text(" " + periodic, h3 + 0.645*h, 0.3625*h);
  }
  
  void setColumn(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0, 1.52*h, 0.6*h);
    fill(255); text("Input the number of lattices on a column: ", h3 + 0.25*h, 0.0625*h);
               text("100, 125, 250, 500 are recommended", h3 + 0.25*h, 0.1125*h);
    if(keyPressed){
      if(key == 10) {
        col = col.substring(1);
        column = Integer.valueOf(col);
        col = " "+col;
        row = 3*column;
        println("Total number of lattice: " + row*column);
        set.arrays();
        set.macroValue();
        println("Done setting macro-values.");
        set.N();
        println("Done initializing lattice.");
        size = (float)h / (float)column;
        println("Size of a lattice in pixels: " + size);
        setColumn = false;
        selectObject = true;
      }
      else if(key == 8) col = col.substring(0, col.length() - 1);
      else col += key;
      delay(100);
    }
    fill(0, 255, 0); text(col, h3 + 0.222*h, 0.1625*h);
  }
  
  void selectObject(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0, 1.52*h, 0.62*h);
    ui.rightColumn1();
    fill(255); text("Select Object: ", h3 + 0.25*h, 0.0625*h);
    if(keyPressed){
      if(key == 10) {
        if(mode.equals(" airfoil")) {selectAirfoil = true; delay(70);}
        else if(mode.equals(" circle") || mode.equals(" finned circle")) {selectRadius = true; delay(70);}
        else {
          confirmObject = true;
          shade.gray(0);
          rect(0, 0, h3, h);
          set.boundary();
          println("Done setting boundary");
          L = funcL(true);
          println("Charateristic length of the obstacle: " + L);
          paint.object(0);
        }
        selectObject = false;
      }
      else if(key == 9) {
        selectObject = false;
        setColumn = true;
        col = " ";
        delay(70);
      }
      else if(key == 8) mode = mode.substring(0, mode.length() - 1);
      else mode += key;
      delay(100);
    }
    fill(0, 255, 0); text(mode, h3 + 0.222*h, 0.1125*h);
  }
  
  void selectAirfoil(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0.1125*h, 1.52*h, h); rect(h3 + 1.05*h, 0, 1.4075*h, h);
    ui.rightColumn1();
    fill(255); text("Input 4-digit NACA airfoil: ", h3 + 0.25*h, 0.2125*h);
    if(keyPressed){
      if(key == 10) {
        airfoil = airfoil.substring(1);
        airFoil = Integer.valueOf(airfoil);
        airfoil = " "+airfoil;
        selectAirfoil = false;
        selectAirfoilSize = true;
      }
      else if(key == 8) airfoil = airfoil.substring(0, airfoil.length() - 1);
      else if(key == 9) {
        selectAirfoil = false;
        selectObject = true;
        mode = " ";
        delay(70);
      }
      else airfoil += key;
      delay(100);
    }
    fill(0, 255, 0); text(airfoil, h3 + 0.222*h, 0.2625*h);
  }
  
  void selectAirfoilSize(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0.2625*h, 1.52*h, h); rect(h3 + 1.05*h, 0, 1.4075*h, h);
    ui.rightColumn1();
    fill(255); text("Input relative airfoil size: ", h3 + 0.25*h, 0.3625*h);
    if(keyPressed){
      if(key == 10) {
        afSize = afSize.substring(1);
        airfoilSize = Double.parseDouble(afSize);
        afSize = " "+afSize;
        selectAirfoilSize = false;
        selectAOA = true;
      }
      else if(key == 8) afSize = afSize.substring(0, afSize.length() - 1);
      else if(key == 9) {
        selectAirfoilSize = false;
        selectAirfoil = true;
        airfoil = " ";
        delay(70);
      }
      else afSize += key;
      delay(100);
    }
    fill(0, 255, 0); text(afSize, h3 + 0.222*h, 0.4125*h);
  }
  
  void selectAOA(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0.4125*h, 1.52*h, 0.5*h); rect(h3 + 1.05*h, 0, 1.4075*h, 0.5*h);
    ui.rightColumn1();
    fill(255); text("Input angle of attack:", h3 + 0.25*h, 0.5125*h);
    if(keyPressed){
      if(key == 10) {
        aoa = aoa.substring(1);
        angleAttack = Double.parseDouble(aoa);
        aoa = " "+aoa;
        selectAOA = false;
        callibrateX = true;
      }
      else if(key == 8) aoa = aoa.substring(0, aoa.length() - 1);
      else if(key == 9) {
        selectAOA = false;
        selectAirfoilSize = true;
        afSize = " ";
        delay(70);
      }
      else aoa += key;
      delay(100);
    }
    fill(0, 255, 0); text(aoa, h3 + 0.222*h, 0.5525*h);
  }
  
  void callibrateX(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0.5625*h, 1.52*h, 0.5*h); rect(h3 + 1.05*h, 0, 1.4075*h, 0.6*h);
    ui.rightColumn1();
    fill(255); text("Callibrate x coordinate: ", h3 + 0.25*h, 0.6525*h);
    if(keyPressed){
      if(key == 10) {
        loX = loX.substring(1);
        locateX = Double.parseDouble(loX);
        loX = " "+loX;
        callibrateX = false;
        callibrateY = true;
      }
      else if(key == 8) loX = loX.substring(0, loX.length() - 1);
      else if(key == 9) {
        callibrateX = false;
        selectAOA = true;
        aoa = " ";
        delay(70);
      }
      else loX += key;
      delay(100);
    }
    fill(0, 255, 0); text(loX, h3 + 0.222*h, 0.7025*h);
  }
  
  void callibrateY(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0.7125*h, 1.52*h, 0.5*h); rect(h3 + 1.05*h, 0, 1.4075*h, 0.6*h);
    ui.rightColumn1();
    fill(255); text("Callibrate y coordinate: ", h3 + 0.25*h, 0.8025*h);
    if(keyPressed){
      if(key == 10) {
        loY = loY.substring(1);
        locateY = -Double.parseDouble(loY);
        loY = " "+loY;
        callibrateY = false;
        confirmAirfoil = true;
        shade.gray(0);
        rect(0, 0, h3, h);
        set.boundary();
        println("Done setting boundary");
        L = funcL(true);
        println("Charateristic length of the obstacle: " + L);
        paint.object(0);
      }
      else if(key == 8) loY = loY.substring(0, loY.length() - 1);
      else if(key == 9) {
        callibrateY = false;
        callibrateX = true;
        loX = " ";
        delay(70);
      }
      else loY += key;
      delay(100);
    }
    fill(0, 255, 0); text(loY, h3 + 0.222*h, 0.8525*h);
  }
  
  void confirmAirfoil(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0.8625*h, 1.52*h, 0.4*h); rect(h3 + 1.05*h, 0, 1.4075*h, 0.6*h);
    ui.rightColumn1();
    fill(255); text("Press enter to confirm object.", h3 + 0.25*h, 0.9525*h);
    if(keyPressed){
      if(key == 10) {
        confirmAirfoil = false;
        condPeri = true;
      }
      else if(key == 9) {
        confirmAirfoil = false;
        callibrateY = true;
        loY = " ";
        delay(70);
      }
    }
  }
  
  void selectRadius(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0.1125*h, 1.52*h, h); rect(h3 + 1.05*h, 0, 1.4075*h, h);
    ui.rightColumn1();
    fill(255); text("Input relative radius: ", h3 + 0.25*h, 0.2125*h);
    if(keyPressed){
      if(key == 10) {
        radius = radius.substring(1);
        circleRadius = Integer.valueOf(radius);
        radius = " "+radius;
        selectRadius = false;
        confirmCircle = true;
        shade.gray(0);
        rect(0, 0, h3, h);
        set.boundary();
        println("Done setting boundary");
        L = funcL(true);
        println("Charateristic length of the obstacle: " + L);
        paint.object(0);
      }
      else if(key == 8) radius = radius.substring(0, radius.length() - 1);
      else if(key == 9) {
        selectRadius = false;
        selectObject = true;
        mode = " ";
        delay(70);
      }
      else radius += key;
      delay(100);
    }
    fill(0, 255, 0); text(radius, h3 + 0.222*h, 0.2625*h);
  }
  
  void confirmCircle(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0.2625*h, 1.52*h, h); rect(h3 + 1.05*h, 0, 1.4075*h, h);
    ui.rightColumn1();
    fill(255); text("Press enter to confirm object.", h3 + 0.25*h, 0.3625*h);
    if(keyPressed){
      if(key == 10) {
        confirmCircle = false;
        condPeri = true;
      }
      else if(key == 9) {
        confirmCircle = false;
        selectRadius = true;
        radius = " ";
        delay(70);
      }
    }
  }
  
  void confirmObject(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0.1625*h, 1.52*h, h); rect(h3 + 1.05*h, 0, 1.4075*h, h);
    ui.rightColumn1();
    fill(255); text("Press enter to confirm object.", h3 + 0.25*h, 0.2125*h);
    if(keyPressed){
      if(key == 10) {
        confirmObject = false;
        condPeri = true;
      }
      else if(key == 9) {
        confirmObject = false;
        selectObject = true;
        mode = " ";
        delay(70);
      }
      delay(100);
    }
    fill(0, 255, 0); text(airfoil, h3 + 0.222*h, 0.2625*h);
  }
  
  void condPeri(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0, 1.52*h, h); rect(h3 + 1.05*h, 0, 1.4075*h, h);
    ui.rightColumn1();
    fill(255); text("Periodic boundaries? y/n", h3 + 0.25*h, 0.0625*h);
    if(keyPressed){
      if(key == 10) {
        if(cP.equals(" y")) {
          periodic = true;
          condPeri = false;
          condWind = true;
        } else if(cP.equals(" n")) {
          periodic = false;
          condPeri = false;
          condWind = true;
        } else {
          text("Please input y or n", h3 + 0.25*h, 0.1125*h);
          cP = " ";
        }
      }
      else if(key == 8) cP = cP.substring(0, cP.length() - 1);
      else cP += key;
      delay(100);
    }
    fill(0, 255, 0); text(cP, h3 + 0.222*h, 0.1125*h);
  }
  
  void condWind(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0.1625*h, 1.52*h, h); rect(h3 + 1.05*h, 0, 1.4075*h, h);
    ui.rightColumn1();
    fill(255); text("Set wind tunnel? y/n", h3 + 0.25*h, 0.2125*h);
    if(keyPressed){
      if(key == 10) {
        if(cW.equals(" y")) {
          windTunnel = true;
          condWind = false;
          setWindVel = true;
        } else if(cW.equals(" n")) {
          windTunnel = false;
          condWind = false;
          setLpf = true;
          set.initialCondition();
          println("Done setting initial condition");
        } else {
          text("Please input y or n", h3 + 0.25*h, 0.2625*h);
          cW = " ";
        }
      }
      else if(key == 9) {
        condWind = false;
        condPeri = true;
        cP = " ";
        delay(70);
      }
      else if(key == 8) cW = cW.substring(0, cW.length() - 1);
      else cW += key;
      delay(100);
    }
    fill(0, 255, 0); text(cW, h3 + 0.222*h, 0.2625*h);
  }
  
  void setWindVel(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0.3125*h, 1.52*h, h); rect(h3 + 1.05*h, 0, 1.4075*h, h);
    ui.rightColumn1();
    fill(255); text("Input wind tunnel's", h3 + 0.25*h, 0.3625*h);
               text("initial velocity:", h3 + 0.25*h, 0.4125*h);
    if(keyPressed){
      if(key == 10) {
        setWindVel = false;
        windVel = windVel.substring(1);
        tunnelFlowX = -Double.parseDouble(windVel);
        windVel = " " + windVel;
        tunnelFlow = new Vector(tunnelFlowX, tunnelFlowY);
        setLpf = true;
        println("Done setting initial condition");
      }
      else if(key == 9) {
        setWindVel = false;
        condWind = true;
        cW = " ";
        delay(70);
      }
      else if(key == 8) windVel = windVel.substring(0, windVel.length() - 1);
      else windVel += key;
      delay(100);
    }
    fill(0, 255, 0); text(windVel, h3 + 0.222*h, 0.4625*h);
  }
  
  void setLpf(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0, 1.52*h, h); rect(h3 + 1.05*h, 0, 1.4075*h, h);
    ui.rightColumn1();
    fill(255); text("Input loops per frame: ", h3 + 0.25*h, 0.0625*h);
    if(keyPressed){
      if(key == 10) {
        lpframe = lpframe.substring(1);
        lpf = Integer.valueOf(lpframe);
        lpframe = " "+lpframe;
        println("Loops per frame: " + lpf);
        setLpf = false;
        setEndLoop = true;
      }
      else if(key == 8) lpframe = lpframe.substring(0, lpframe.length() - 1);
      else lpframe += key;
      delay(100);
    }
    fill(0, 255, 0); text(lpframe, h3 + 0.222*h, 0.1125*h);
  }
  
  void setEndLoop(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0.1125*h, 1.52*h, h); rect(h3 + 1.05*h, 0, 1.4075*h, h);
    ui.rightColumn1();
    fill(255); text("Input end loop: ", h3 + 0.25*h, 0.2125*h);
               text("Recommended: " + 160*column, h3+0.25*h, 0.2625*h);
    if(keyPressed){
      if(key == 10) {
        endL = endL.substring(1);
        endLoop = Integer.valueOf(endL);
        endL = " "+endL;
        println("End loop: " + endL);
        setEndLoop = false;
        selectPaint = true;
      }
      else if(key == 8) endL = endL.substring(0, endL.length() - 1);
      else if(key == 9) {
        setEndLoop = false;
        setLpf = true;
        lpframe = " ";
        delay(70);
      }
      else endL += key;
      delay(100);
    }
    fill(0, 255, 0); text(endL, h3 + 0.222*h, 0.3125*h);
  }
  
  void selectPaint(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0, 1.52*h, h); rect(h3 + 1.05*h, 0, 1.4075*h, h);
    ui.rightColumn1();
    fill(255); text("Select plot type.", h3 + 0.25*h, 0.0625*h);
               text("Input 0 for top canvas,", h3 + 0.25*h, 0.1125*h);
               text("      1 for bottom canvas.", h3 + 0.25*h, 0.1625*h);
               text("2 or larger will not plot.", h3 + 0.25*h, 0.2125*h);
               text("Can plot maximum two types", h3 + 0.25*h, 0.3125*h);
               text("In order: pressure", h3 + 0.25*h, 0.3625*h);
               text("          flow velocity", h3 + 0.25*h, 0.4125*h);
               text("i.e. 10 will plot", h3 + 0.25*h, 0.4625*h);
               text("flow velocity on top canvas,", h3 + 0.25*h, 0.5125*h);
               text("pressure on bottom canvas.", h3 + 0.25*h, 0.5625*h);
    if(keyPressed){
      if(key == 10) {
        selectPaint = false;
        setContour = true;
        selPaint = selPaint.substring(1);
        sP = Integer.valueOf(selPaint);
        rhoLocate = (int)(sP/10);
        uLocate = (int)(sP%10);
        //pLocate = (int)(sP/10) - 100*rhoLocate - 10*uLocate;
        //ReLocate = (int)(sP%10);
      }
      else if(key == 8) selPaint = selPaint.substring(0, selPaint.length() - 1);
      else selPaint += key;
      delay(100);
    }
    fill(0, 255, 0); text(selPaint, h3 + 0.222*h, 0.6125*h);
  }
  
  void setContour(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0, 1.52*h, h); rect(h3 + 1.05*h, 0, 1.4075*h, h);
    ui.rightColumn1();
    fill(255); text("Plot contour?", h3 + 0.25*h, 0.0625*h);
               text("Input 1 for yes,", h3 + 0.25*h, 0.1125*h);
               text("      else for no.", h3 + 0.25*h, 0.1625*h);
               text("In order: top bottom", h3 + 0.25*h, 0.2125*h);
               text("i.e. 10 will", h3 + 0.25*h, 0.3125*h);
               text("plot contour on top", h3+0.25*h, 0.3625*h);
               text("but not on the bottom.", h3 + 0.252*h, 0.4125*h);
    if(keyPressed){
      if(key == 10) {
        setContour = false;
        setVF = true;
        cont = cont.substring(1);
        ctr = Integer.valueOf(cont);
        contour[0] = (int)(ctr/10) == 1? true:false;
        contour[1] = (int)(ctr%10) == 1? true:false;
      }
      else if(key == 8) cont = cont.substring(0, cont.length() - 1);
      else cont += key;
      delay(100);
    }
    fill(0, 255, 0); text(cont, h3 + 0.222*h, 0.4625*h);
  }
  
  void setVF(){
    shade.gray(0);
    rect(h3 + 0.25*h, 0, 1.52*h, h); rect(h3 + 1.05*h, 0, 1.4075*h, h);
    ui.rightColumn1();
    fill(255); text("Plot vector field?", h3 + 0.25*h, 0.0625*h);
               text("Input 1 for yes,", h3 + 0.25*h, 0.1125*h);
               text("      else for no.", h3 + 0.25*h, 0.1625*h);
               text("In order: top bottom", h3 + 0.25*h, 0.2125*h);
               text("i.e. 10 will", h3 + 0.25*h, 0.3125*h);
               text("plot vector field on top", h3+0.25*h, 0.3625*h);
               text("but not on the bottom.", h3 + 0.252*h, 0.4125*h);
    if(keyPressed){
      if(key == 10) {
        setVF = false;
        //setVF = true;
        vect = vect.substring(1);
        vtrfld = Integer.valueOf(vect);
        vectorField[0] = (int)(vtrfld/10) == 1? true:false;
        vectorField[1] = (int)(vtrfld%10) == 1? true:false;
      }
      else if(key == 8) vect = vect.substring(0, vect.length() - 1);
      else vect += key;
      delay(100);
    }
    fill(0, 255, 0); text(vect, h3 + 0.222*h, 0.4625*h);
  }
  
  void crashDetect(double max){
    shade.gray(0);
    rect(h3 + 0.25*h, 1.5*h, 1.75*h, 0.5*h);
   
    fill(255, 0, 0); 
    if(max > 10){
      textSize(0.05*h);
      text("Simulation collapsed.", h3 - 1.25*h, 1.9*h);
      simulate = false;
      reset();
    }
    else if(max > 0.4){
      textSize(0.05*h);
      text("Warning: Max velocity exceeded 0.4.", h3 - 1.25*h, 1.9*h);
      text("         Simulation might become unstable.", h3 - 1.25*h, 1.95*h);
    }
  }
  
  void success(){   
    shade.gray(0);
    rect(h3, 0, 1.75*h, 1.33*h);
    fill(0, 255, 0);
    textSize(0.05*h);
    text("Simulation successfully reached end loop.", h3 + 0.25*h, 1.9*h);
    simulate = false;
    reset();
  }
  
  void reset(){
    prevKey = " ";
    setColumn = true;             col = " ";
    selectObject = false;         mode = " ";

    selectAirfoil = false;        selectAirfoilSize = false;        selectAOA = false;
    angleAttack = 0;              aoa = " ";
    callibrateX = false;          callibrateY = false;
    airFoil = 0;                  airfoil = " ";
    loX = " ";                    loY = " ";
    afSize = " ";
    confirmAirfoil = false;

    selectRadius = false;
    radius = " ";
    confirmCircle = false;

    confirmObject = false;

    cP = " ";                     cB = " ";                         cW = " ";
    condPeri = false;             condBounce = false;               condWind = false;
    periodic = false;             bounceBack = false;               windTunnel = false;
    
    setWindVel = false;           windVel = " ";

    setLpf = false;               lpframe = " ";
    setEndLoop = false;           endL = " ";

    selectPaint = false;          selPaint = " ";

    setContour = false;           cont = " ";
    setVF = false;                vect = " ";
  }
}
