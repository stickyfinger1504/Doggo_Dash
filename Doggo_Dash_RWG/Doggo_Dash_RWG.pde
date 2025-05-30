// Crucial Variables
final int worldLength = 22; // Size() untuk world yang kelihatan di screen
final int worldHeight = 20; // Maximum world height
final int blockSize = 80;

ArrayList<ArrayList<Integer>> world;

// RWG Variables
boolean canChangeElevation = true;
boolean canAddObstacle = true;
boolean currentlyAddingObstacle = false;

int currElevation = 1;
int postAddingTimer = 0;
int distance = 0;
int speed = 5;

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
void setup() {
  size(1600, 900);
  background(152, 255, 250);
  
  world = new ArrayList<ArrayList<Integer>>();
  initializeEmptyAir();
}

// THE REAL DEAL
void updateWorld() {
    // Variables
    int rng1; // Elevation addjust or not
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

    // Initialize RNG
    rng1 = int(random(0, 10));
    rng2 = int(random(0, 10));
    elevationType = int(random(0, 3));

    /*
     * Elevation Adjust Starts
     */
    if (rng1 == 0 && canChangeElevation) {
        // Elevation Decrease
        if ((elevationType == 0 || (currElevation > 8 && elevationType == 1)) && currElevation >= 2) {
            obstacleSize = int(random(1, currElevation - 1));
            currElevation -= obstacleSize;
            postAddingTimer = 3 + obstacleSize;
        }

        // Elevation Increase
        else if (currElevation < 15) {
            obstacleSize = int(random(0, 5)) == 0 ? 2 : 1;
            currElevation += obstacleSize;
            postAddingTimer = 3;
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
            obstacleSize = int(random(0, 5)) + 1;
            ravineDepth = int(random(0, currElevation)) + 1;
            postAddingTimer = obstacleSize + 1;
        }

        // Spike
        else {
            obstacleSize = int(random(0, 3)) + 1;
            postAddingTimer = obstacleSize + 2;
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
    }

    // Update Timer
    postAddingTimer--;

    if (postAddingTimer <= 0) {
        canChangeElevation = true;
        canAddObstacle = true;

        ravineDepth = 0;
        postAddingTimer = 0;
    }

    // Generate obstacle 1 based on the elevation
    for (int i = 0; i < currElevation - ravineDepth; i++) {
        worldFraction.set(i, 1);
    }

    // Put the generated fraction
    world.add(worldFraction);
}

// Buat initialize worldnya biar empty alias ada ruang buat start
void initializeEmptyAir() {
    for (int i = 0; i < worldLength; i++) {
        ArrayList<Integer> newFraction = new ArrayList<Integer>();
        
        for (int j = 0; j < worldHeight; j++) {
          if (j != 0) {
              newFraction.add(0);
          }
          else {
              newFraction.add(1);
          }
        }
        
        world.add(newFraction);
    }
}

void drawWorld() {
  for (int i = 0; i < 22; i++) {
    for (int j = 0; j < 20; j++) {
      if (world.get(i).get(j) == 1) {
        fill(0, 255, 27);
        rect((i * blockSize) - (distance % 80), (height - ((j + 1) * blockSize)), blockSize, blockSize);
      }
      else if (world.get(i).get(j) == 2) {
        fill(84);
        triangle((i * blockSize) - (distance % 80), (height - (j * blockSize)), ((i + 1) * blockSize) - (distance % 80), (height - (j * blockSize)), (blockSize / 2) + (i * blockSize) - (distance % 80), (height - ((j + 1) * blockSize)));
      }
    }
  }
}

void draw() {
    background(152, 255, 250);
    
    if (distance % 80 == 0) {
      updateWorld();
    }
    
    drawWorld();

    distance += speed;
}
