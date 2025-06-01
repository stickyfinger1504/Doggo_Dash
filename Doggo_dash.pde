// Crucial Variables
final int worldLength = 22; // Size() untuk world yang kelihatan di screen
final int worldHeight = 9; // Maximum world height
final int blockSize = 80;
final int speed = 5;
int speedTemp = speed; // for slo-mo
long score = 0;
int scoreDistance;
int prevDistance = 0; // NEW: Track previous distance for world update
int frame;

// Decoration Variables
ArrayList<Integer> elevations;

// Background
PImage backgroundImage;

// Obstacle 1
PImage grass_img;
PImage dirt_img;
PImage rock_img;

// Obstacle 2
PImage bee_img;
PImage mud_img;
PImage stream_img;

// Power Ups
PImage double_points_img;
PImage invincibility_img;
PImage slo_mo_img;

// player related
final float squareWidth = 80;       // Player sprite size
PImage img;                         // Player image
PImage[] doggie = new PImage[10];
Player player;

// obstacle
ArrayList<ObstacleBase> obstacles;  // Holds all obstacle types

// power ups
ArrayList<powerUpsBase> powerUpsList;
int activePowerUp = 0;        // 0 = none, 1 = double points, 2 = slow-mo, 3 = invincible
int POWERUP_DURATION = 0;
int incrementValue = 1;       // Score multiplier
boolean gameMovementStoppedByInvincibility = false;
boolean inSlowMo = false;
int powerUpCooldown = 0; // frames to wait before spawning next power-up
final int powerUpCooldownMax = 20; // e.g. must wait 10 columns

// GAME_STATE
int GAME_STATE;
final int GAME_START = 1, GAME_RUN = 2, DIE = 3;

ArrayList<ArrayList<Integer>> world;

// RWG Variables
boolean canChangeElevation = true;
boolean canAddObstacle = true;
boolean currentlyAddingObstacle = false;

int currElevation = 1;
int postAddingTimer = 0;
int distance = 0;

int obstacleSize = 0; // RNG for obstacle size
int ravineDepth = 0; // RNG for ravine gap depth

/*
 * Free Roam World Designs
 */
int[][] world1 = {
  {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 1, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 1},
  {1, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 0, 0, 3, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
};

int[][] world2 = {
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 8, 0, 2, 2, 0, 2, 2, 0, 0, 2, 2, 0, 2, 2, 0, 0, 3, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1},
  {1, 0, 0, 2, 2, 0, 2, 2, 0, 0, 2, 2, 0, 2, 2, 0, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 0, 1},
  {1, 3, 0, 2, 1, 2, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1},
  {1, 3, 0, 0, 2, 0, 0, 0, 1, 2, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1},
  {1, 3, 0, 0, 0, 0, 0, 0, 1, 1, 2, 0, 0, 1, 0, 0, 0, 0, 0, 1},
  {1, 3, 0, 0, 2, 0, 0, 0, 1, 1, 1, 2, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 1, 2, 2, 2, 1, 2, 2, 2, 1, 2, 2, 2, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 0, 1},
  {1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 3, 0, 0, 1},
  {1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 3, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1},
  {1, 0, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 0, 1, 1, 2, 1, 2, 2, 2, 2, 3, 0, 1, 1, 0, 0, 1},
  {1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 3, 0, 2, 2, 0, 9, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 2, 2, 0, 1, 0, 0, 0, 0, 3, 0, 2, 2, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
  {1, 2, 2, 1, 2, 2, 1, 2, 2, 1, 2, 2, 1, 0, 0, 0, 0, 0, 3, 1},
  {1, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 2, 2, 2, 2, 3, 1},
  {1, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 3, 1},
  {1, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 0, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 3, 0, 0, 0, 1, 1, 1, 3, 1},
  {1, 0, 9, 0, 1, 1, 2, 0, 0, 1, 1, 3, 1, 2, 0, 0, 1, 1, 3, 1},
  {1, 0, 0, 0, 1, 1, 1, 2, 0, 0, 1, 3, 1, 1, 2, 0, 0, 1, 3, 1},
  {1, 2, 2, 2, 1, 1, 1, 1, 2, 0, 0, 0, 1, 1, 1, 2, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
};
/*
 */

// Setup
// Setup
void setup() {
  String filename;
  
  size(1600, 900, P3D);
  
  backgroundImage = loadImage("Images/background.jpg");
  backgroundImage.resize(1600, 900);
  background(backgroundImage);
  
  img = loadImage("sahur.jpg"); // Make sure player.png is in your data folder!
  img.resize(80, 80);
  
  for (int i = 0; i < 7; i++) {
    filename = "Images/" + (i + 1) + ".PNG";
    doggie[i] = loadImage(filename);
    doggie[i].resize(80, 80);
  }
  
  grass_img = loadImage("Images/grass_block.png");
  dirt_img = loadImage("Images/dirt.png");
  rock_img = loadImage("Images/rock_block.png");
  grass_img.resize(80, 80);
  dirt_img.resize(80, 80);
  rock_img.resize(80, 80);
  
  bee_img = loadImage("Images/rock_spike.png");
  mud_img = loadImage("Images/mud.png");
  stream_img = loadImage("Images/stream.png");
  bee_img.resize(80, 80);
  mud_img.resize(80, 80);
  stream_img.resize(80, 80);

  double_points_img=loadImage("Images/double_points.png");
  invincibility_img=loadImage("Images/invincibility.png");
  slo_mo_img=loadImage("Images/slow_mo_and_jump_boost.png");
  double_points_img.resize(40,40);
  invincibility_img.resize(40,40);
  slo_mo_img.resize(40,40);
  
  elevations = new ArrayList<Integer>();
  powerUpsList = new ArrayList<powerUpsBase>();
  world = new ArrayList<ArrayList<Integer>>();
  player = new Player(width / 4, 0, doggie);
  GAME_STATE = GAME_RUN;
  obstacles = new ArrayList<ObstacleBase>();
  frame = 0;
  initializeEmptyAir();
  //noStroke();
}

// THE REAL DEAL
void updateWorld() {
  // Variables
  int rng1; // Elevation adjust or not
  int rng2; // Create obstacle or not

  int elevationType; // Increase or Decrease
  int obstacleType; // Obstacle Type

  // Initialize world fraction
  ArrayList<Integer> worldFraction = new ArrayList<Integer>();
  for (int i = 0; i < worldHeight; i++) {
    worldFraction.add(0);
  }

  // Delete the last part
  world.remove(0); // Unload the leftmost fraction
  elevations.remove(0);

  // Initialize RNG
  rng1 = int(random(0, 10));
  rng2 = int(random(0, 10));
  elevationType = int(random(0, 3));

  /*
     * Elevation Adjust Starts
   */
  if (rng1 == 0 && canChangeElevation) {
    // Elevation Decrease
    if ((elevationType == 0 || (currElevation > 6 && elevationType == 1)) && currElevation >= 2) {
      obstacleSize = int(random(1, currElevation - 1));
      currElevation -= obstacleSize;
      postAddingTimer = 3 + obstacleSize;
    }

    // Elevation Increase
    else if (currElevation <= 7) {
      //obstacleSize = currElevation == 7 ? 1 : int(random(0, 5)) == 0 ? 2 : 1;
      obstacleSize = 1;
      currElevation += obstacleSize;
      postAddingTimer = 4;
    }

    // Variable Update
    canChangeElevation = false;
    canAddObstacle = false;
  }
  /*
     * Elevation Adjust Ends
   */

  /*
     * Obstacle Creation Starts
   */
  if (rng2 == 0 && canAddObstacle) {
    obstacleType = int(random(0, 5));

    // Gap Jump
    if (obstacleType == 0 && currElevation > 0) {
      obstacleSize = int(random(0, 4)) + 1;
      ravineDepth = int(random(0, currElevation)) + 1;
      postAddingTimer = obstacleSize + 3;
    }

    // Spike
    else {
      obstacleSize = int(random(0, 3)) + 1;
      postAddingTimer = 6;
    }

    // Variable Update
    currentlyAddingObstacle = true;
    canChangeElevation = false;
    canAddObstacle = false;
  }
  /*
     * Obstacle Creation Ends
   */

  // Generate Obstacles
  if (currentlyAddingObstacle) {
    worldFraction.set(currElevation - ravineDepth, 2);
    obstacleSize--;
  }

  if (obstacleSize <= 0) {
    currentlyAddingObstacle = false;
    obstacleSize = 0;
    ravineDepth = 0;
  }

  // Update Timer
  postAddingTimer--;

  if (postAddingTimer <= 0) {
    canChangeElevation = true;
    canAddObstacle = true;
    
    postAddingTimer = 0;
  }

  // Generate obstacle 1 based on the elevation
  for (int i = 0; i < currElevation - ravineDepth; i++) {
    worldFraction.set(i, 1);
  }

  // --- POWER-UP SPAWN LOGIC START ---

  if (powerUpCooldown > 0) {
    powerUpCooldown--;
  } else {
    // Find an obstacle1 with air above in this column to spawn a power-up above it
    for (int j = 0; j < worldHeight - 1; j++) {
      if (worldFraction.get(j) == 1 && worldFraction.get(j + 1) == 0) {
        float x = world.size() * blockSize; // Current new column position
        float y = height - ((j + 1) * blockSize); // One block above obstacle1

        int type = int(random(1, 4)); // Randomly 1, 2 or 3 power-up type

        if (type == 1)
          powerUpsList.add(new powerUp1(x, y,double_points_img));
        else if (type == 2)
          powerUpsList.add(new powerUp2(x, y,slo_mo_img));
        else
          powerUpsList.add(new powerUp3(x, y,invincibility_img));

        powerUpCooldown = powerUpCooldownMax; // Reset cooldown
        break; // Only spawn one power-up per new column
      }
    }
  }
  // --- POWER-UP SPAWN LOGIC END ---

  // Put the generated fraction into the world
  world.add(worldFraction);
  elevations.add(currElevation);
}

// Buat initialize worldnya biar empty alias ada ruang buat start
void initializeEmptyAir() {
  elevations.clear();
  
  for (int i = 0; i < worldLength; i++) {
    ArrayList<Integer> newFraction = new ArrayList<Integer>();
    
    for (int j = 0; j < worldHeight; j++) {
      if (j != 0) {
        newFraction.add(0);
      } else {
        newFraction.add(1);
      }
    }
    
    elevations.add(1);
    world.add(newFraction);
  }
  
  obstacles.clear();
  for (int i = 0; i < world.size(); i++) {
    ArrayList<Integer> col = world.get(i);
    for (int j = 0; j < worldHeight; j++) {
      if (col.get(j) == 1) {
        float x = (i * blockSize) - (distance % blockSize);
        float y = height - (j * blockSize);
        
        if (j == elevations.get(i) - 1) {
          obstacles.add(new Obstacle1(x, y, grass_img));
        }
        else {
          obstacles.add(new Obstacle1(x, y, dirt_img));
        }
      } else if (col.get(j) == 2) {
        float x = (i * blockSize) - (distance % blockSize);
        float y = height - (j * blockSize);
        
        if (j == elevations.get(i)) {
          obstacles.add(new Obstacle2(x, y, bee_img));
        }
        else if (j == elevations.get(i) - 1) {
          obstacles.add(new Obstacle2(x, y, mud_img));
        }
        else {
          obstacles.add(new Obstacle2(x, y, stream_img));
        }
      }
    }
  }
}

void drawWorld() {
  obstacles.clear();
  for (int i = 0; i < world.size(); i++) {
    ArrayList<Integer> col = world.get(i);
    for (int j = 0; j < worldHeight; j++) {
      if (col.get(j) == 1) {
        float x = (i * blockSize) - (distance % blockSize);
        float y = height - (j * blockSize);
        
        if (j == elevations.get(i) - 1) {
          obstacles.add(new Obstacle1(x, y, grass_img));
        }
        else {
          obstacles.add(new Obstacle1(x, y, dirt_img));
        }
      } else if (col.get(j) == 2) {
        float x = (i * blockSize) - (distance % blockSize);
        float y = height - (j * blockSize);
        
        if (j == elevations.get(i)) {
          obstacles.add(new Obstacle2(x, y, bee_img));
        }
        else if (j == elevations.get(i) - 1) {
          obstacles.add(new Obstacle2(x, y, mud_img));
        }
        else {
          obstacles.add(new Obstacle2(x, y, stream_img));
        }
      }
    }
  }

  for (ObstacleBase ob : obstacles) {
    ob.display();
  }

  // Draw existing power-ups
  for (int i = powerUpsList.size() - 1; i >= 0; i--) {
    powerUpsBase pu = powerUpsList.get(i);
    pu.display();
  }
}

void draw() {
  switch (GAME_STATE) {
  case GAME_RUN:
    background(backgroundImage);

    // Score increment logic
    if (player.powerUpActivate && activePowerUp == 1) {
      incrementValue = 2;
    } else {
      incrementValue = 1;
    }
    scoreDistance++;
    if (scoreDistance % 20 == 0) {
      score += incrementValue;
      scoreDistance = 0;
    }

    // Adjust speed for slow motion power-up
    if (player.powerUpActivate && activePowerUp == 2) {
      inSlowMo = true;
    } else {
      inSlowMo = false;
    }

    //check for timer
    if (player.powerUpActivate || frame == 0) {
      if (POWERUP_DURATION > 0) {
        POWERUP_DURATION--;
        
        if (inSlowMo) {
          speedTemp=int(speed*0.75);
          player.gravity=0.2;
          player.jumpStrength=-11;
        }
      } else {
        // Power-up duration ended, reset state
        player.powerUpActivate = false;
        player.powerUps = 0;
        activePowerUp = 0;
        incrementValue = 1;
        inSlowMo = false;
        frameRate(60);  // Reset speed if slow-mo ended
        speedTemp=speed;
        player.gravity=0.3;
        player.jumpStrength=-10;
        // Any other cleanup/reset for power-up effects
      }
    }


    // Update distance and check when to generate new world fraction
    distance += speedTemp;
    if (prevDistance / 80 < distance / 80) {
      updateWorld();
    }
    prevDistance = distance;

    // Player update and display
    player.update();
    player.display(frame);
    drawWorld();

    // Display score and power-up status
    fill(0);
    textSize(32);
    textAlign(LEFT, TOP);
    text("Score: " + score, 20, 20);
    String pName = "";
    if (player.powerUpActivate) {
      switch (activePowerUp) {
      case 1:
        pName = "Double Points";
        break;
      case 2:
        pName = "Slow Motion & Jump Boost";
        break;
      case 3:
        pName = "INVINCIBLE";
        break; // Added Invincible
      }
      if (POWERUP_DURATION > 0) {
        if (!inSlowMo) {
          text("Active: " + pName + " (" + (POWERUP_DURATION / 60) + "s)", 20, 60);
        }
        else {
          text("Active: " + pName + " (" + (POWERUP_DURATION / 30) + "s)", 20, 60);
        }
      }
    } else if (player.powerUps != 0) {
      switch (player.powerUps) {
      case 1:
        pName = "Double Points (Press P)";
        break;
      case 2:
        pName = "Slow Motion & Jump Boost (Press P)";
        break;
      case 3:
        pName = "INVINCIBLE (Press P)";
        break; // Added Invincible
      }
      text("Collected: " + pName, 20, 60);
    }

    // Update and display power-ups
    for (int i = powerUpsList.size() - 1; i >= 0; i--) {
      powerUpsBase pu = powerUpsList.get(i);
      pu.update(); // Move with the world

      if (pu.checkCollected(player)) {
        // Run the onCollect logic for the specific type
        if (pu instanceof powerUp1)
          ((powerUp1) pu).onCollect(player);
        else if (pu instanceof powerUp2)
          ((powerUp2) pu).onCollect(player);
        else if (pu instanceof powerUp3)
          ((powerUp3) pu).onCollect(player);
        powerUpsList.remove(i);
        println("Player collected power-up. Player has type: " + player.powerUps);
      } else if (pu.x < -pu.size) {
        powerUpsList.remove(i); // Remove off-screen power-ups
      }
    }

    // Collision check with obstacles
    for (int i = obstacles.size() - 1; i >= 0; i--) {
      ObstacleBase o = obstacles.get(i);

      if (o instanceof Obstacle1) {
        if (o.checkCollision(player)) {
          if (player.powerUpActivate && activePowerUp == 3) {
            // Teleport player to top of Obstacle1 block
            float top = o.y - o.h;
            player.y = top - player.hh;  // just above block
            player.velocityY = 0;
            player.isJumping = false;
            // No death on teleport
            continue;
          } else {
            // Player dies if no invincibility
            println("Player killed by Obstacle1");
            GAME_STATE = DIE;
            noLoop();
          }
        }
      } else if (o instanceof Obstacle2) {
        if (o.checkCollision(player)) {
          if (player.powerUpActivate && activePowerUp == 3) {
            // Player is invincible, treat Obstacle2 as platform:
            // Mimic Obstacle3's landing logic here:
            float top = o.y - o.h / 2; // adjust based on your Obstacle2 height
            // Only land if falling onto top surface
            if (player.velocityY >= 0 && player.y + player.hh <= top + 5) {
              player.landOn(top);
            }
            // No death on spike while invincible
          } else {
            // Player dies on spike if not invincible
            println("Player killed by Obstacle2");
            GAME_STATE = DIE;
            noLoop();
          }
        }
      }
    }


    break;

  case DIE:
    println("Game Over!");
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(50);
    text("Game Over! Score: " + score, width / 2, height / 2 - 30);
    text("Press 'R' to Restart", width / 2, height / 2 + 30);
    break;
  }
  
  frame++;
}

void keyPressed() {
  if (key == ' ' && !player.isJumping && GAME_STATE == GAME_RUN) {
    player.jump();
  }
  if (key == 'r' && GAME_STATE == DIE) {
    resetGame();
  }
  if (key == 'p' && GAME_STATE == GAME_RUN) {
    if (player.powerUps != 0 && !player.powerUpActivate) {
      activePowerUp = player.powerUps;

      switch (activePowerUp) {
      case 1:
        POWERUP_DURATION = 600;
        break; // Double Points
      case 2:
        POWERUP_DURATION = 240;
        break; // Slow-Mo
      case 3:
        POWERUP_DURATION = 300;
        break; // Invincibility (e.g., 5 seconds)
      }
      player.powerUpActivate = true;
      
      if (!inSlowMo) {
        println("Activated power-up: " + activePowerUp + " for " + (POWERUP_DURATION / 60) + "s");
      }
      else {
        println("Activated power-up: " + activePowerUp + " for " + (POWERUP_DURATION / 30) + "s");
      }
    } else if (player.powerUpActivate) {
      println("A power-up is already active!");
    } else {
      println("You don't have any power-ups to activate!");
    }
  }
}

void resetGame() {
  score = 0;
  scoreDistance = 0;

  POWERUP_DURATION = 0;
  activePowerUp = 0;
  player.powerUps = 0;
  player.powerUpActivate = false;
  inSlowMo = false;
  incrementValue = 1;

  gameMovementStoppedByInvincibility = false; // Reset this flag
  world.clear();
  elevations.clear();
  initializeEmptyAir();    // Fill world with empty air columns

  // Reset obstacles (they will be re-added in drawWorld)
  obstacles.clear();

  // Reset player state and position
  player.reset();

  // Reset RWG & distance scroll
  currElevation = 1;           // Reset elevation to default
  postAddingTimer = 0;
  distance = 0;
  prevDistance = 0;            // Also reset prevDistance
  canChangeElevation = true;
  canAddObstacle = true;
  currentlyAddingObstacle = false;
  obstacleSize = 0;
  ravineDepth = 0;
  frame = 0;

  // Game state and loop
  GAME_STATE = GAME_RUN;
  loop();
}
