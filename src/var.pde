static final int h = 500; // height of a render territory
static final int h3 = 3*h;
static float size; //size of a lattice represented in px

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

UIState state = UIState.SET_COLUMN;

static boolean selectAirfoil = false;        static boolean selectAirfoilSize = false;        static boolean selectAOA = false;
static double angleAttack = 0;               static String aoa = " ";
static boolean callibrateX = false;          static boolean callibrateY = false;              static double locateX, locateY;
static int airFoil = 0;                      static String airfoil = " ";
static String loX = " ";                     static String loY = " ";
static double airfoilSize;                   static String afSize = " ";
static boolean confirmAirfoil = false;

static String cP = " ";
static boolean condPeri = false;
static boolean periodic = false;

static boolean setLpf = false;               static String lpframe = " ";
static boolean setEndLoop = false;           static String endL = " ";
static int lpf = 20;
static int endLoop = 200000;

static boolean selectPaint = false;          static String selPaint = " ";
static int sP;                               static int rhoLocate, uLocate, pLocate;

static boolean setContour = false;           static boolean [] contour = new boolean[2];      static String cont = " ";    static int ctr;
static boolean setVF = true;                 static boolean [] vectorField = new boolean[2];  static String vect = " ";    static int vtrfld;
