static final int h = 500;
static final int h3 = 3*h;
static int column; //Number of lattice on a column
static int row; //Number of lattice on a row
static float size; //size of a lattice represented in pixels
static final double dx = 1;
static final double dt = 1;
static final double inDt = 1/dt;
static final double c = Math.sqrt(dx*dx/dt/dt/3d);
static final double inC = 1/c;  //for faster calculations
static final double inCSquare = inC*inC;
static final double inCQuad = inC*inC*inC*inC;

static final double k = 1.380649*Math.pow(10, -23); //Blotzmann constant
static final double R = 8.205737*Math.pow(10, -5); //gas constant
static final double m = 4.65*Math.pow(10, -26); //mass of one nitrogen molecule in kg

static final double omega = 1.2d; //equilibration constant
static final double viscosity = 1d/3d*(1d/omega - 0.5);

static int L;
static double Re;

static Vector [] e = new Vector[9];
static double[] w = new double[9];

static final double initialRho = 1d;
static Vector initialFlow;
static double tunnelFlowX;
static double tunnelFlowY = 0;
static Vector tunnelFlow; //for simulating wind tunnel

static Vector [][] u;
static double meanU;
static double [][] rho, pressure;
static double [][][] oldN, newN, Neq;

static boolean [][] boundary;
static boolean [][] object;
static boolean [][] objectNeighbor;
static boolean [][] boundaryNeighbor;

static int graphEnd;
static double graphStep;

static double lift;
static double liftTemp;
static double liftMax;                       static double liftMin;
static double liftScale;
static double [] liftPoint;// = new double[100];

static double drag;
static double dragTemp;
static double dragMax;                       static double dragMin;
static double dragScale;
static double [] dragPoint;// = new double[100];

static String prevKey = " ";
static boolean setColumn = true;             static String col = " ";
static boolean selectObject = false;         static String mode = " ";

static boolean selectAirfoil = false;        static boolean selectAirfoilSize = false;        static boolean selectAOA = false;
static double angleAttack = 0;               static String aoa = " ";
static boolean callibrateX = false;          static boolean callibrateY = false;              static double locateX, locateY;
static int airFoil = 0;                      static String airfoil = " ";
static String loX = " ";                     static String loY = " ";
static double airfoilSize;                   static String afSize = " ";
static boolean confirmAirfoil = false;

static boolean selectRadius = false;
static int circleRadius;                     static String radius = " ";
static boolean confirmCircle = false;

static boolean confirmObject = false;

static String cP = " ";                      static String cB = " ";                          static String cW = " ";
static boolean condPeri = false;             static boolean condBounce = false;               static boolean condWind = false;
static boolean periodic = false;             static boolean bounceBack = false;               static boolean windTunnel = false;

static boolean setWindVel = false;           static String windVel = " ";

static boolean setLpf = false;               static String lpframe = " ";
static boolean setEndLoop = false;           static String endL = " ";
static int lpf, endLoop;

static boolean selectPaint = false;          static String selPaint = " ";
static int sP;                               static int rhoLocate, uLocate, pLocate, ReLocate;

static boolean setContour = false;           static boolean [] contour = new boolean[2];      static String cont = " ";    static int ctr;
static boolean setVF = false;                static boolean [] vectorField = new boolean[2];  static String vect = " ";    static int vtrfld;
