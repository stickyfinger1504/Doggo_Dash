#include <iostream>
#include <string>
#include <vector>
using namespace std;

// Crucial Variables
const int worldLength = 50; // Size() untuk world yang kelihatan di screen
const int worldHeight = 20; // Maximum world height

vector<vector<char>> world;
vector<char> worldFraction;

// RWG Variables
bool canChangeElevation = true;
bool canAddObstacle = true;
bool currentlyAddingObstacle = false;
bool inCave = false;

int currElevation = 0;
int postAddingTimer = 0;
int caveLength = 0;
int caveHeight = 0;

int obstacleSize = 0; // RNG for obstacle size
int ravineDepth = 0; // RNG for ravine gap depth

// Clear World Fraction
void clearWorldFraction() {
    for (int i = 0; i < worldHeight; i++) {
        worldFraction[i] = '0';
    }
}

// THE REAL DEAL
void updateWorld() {
    // Variables
    int rng1; // Elevation addjust or not
    int rng2; // Create obstacle or not
    int rng3; // Go to Cave or not

    int elevationType; // Increase or Decrease
    int obstacleType; // Obstacle Type

    // Delete the last part
    clearWorldFraction(); // Clean the world fraction vector to generate new one
    world.erase(world.begin()); // Unload the leftmost fraction

    // Initialize RNG
    rng1 = rand() % 10;
    rng2 = rand() % 10;
    rng3 = rand() % 200;
    elevationType = rand() % 3;

    /*
     * Cave Starts
     */
    if (rng3 == 0 && !inCave) {
        inCave = true;
        caveLength = rand() % 200 + 40;
        caveHeight = rand() % 2 + 3;
    }
    /*
     * Cave Ends
     */

    /*
     * Elevation Adjust Starts
     */
    if (rng1 == 0 && canChangeElevation) {
        // Elevation Decrease
        if (elevationType == 0 && currElevation != 0) {
            if (inCave) {
                obstacleSize = rand() % 2 + 1;
            }
            else {
                obstacleSize = rand() % currElevation;
            }
            currElevation -= obstacleSize;
            postAddingTimer = 3 + obstacleSize;
        }

        // Elevation Increase
        else if (currElevation < 15) {
            obstacleSize = rand() % 5 == 0 ? 2 : 1;
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
        obstacleType = rand() % 5;

        // Gap Jump
        if (obstacleType == 0 && currElevation > 0) {
            obstacleSize = rand() % 5 + 1;
            ravineDepth = rand() % currElevation + 1;
            postAddingTimer = obstacleSize + 1;
        }

        // Spike
        else {
            obstacleSize = rand() % 3 + 1;
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
        worldFraction[currElevation - ravineDepth] = '2';
        obstacleSize--;
    }

    if (obstacleSize <= 0) {
        currentlyAddingObstacle = false;
        obstacleSize = 0;
    }

    // Update Timer
    postAddingTimer--;
    caveLength--;

    if (caveLength <= 0) {
        caveLength = 0;
        caveHeight = 0;
        inCave = false;
    }

    if (postAddingTimer <= 0) {
        canChangeElevation = true;
        canAddObstacle = true;

        ravineDepth = 0;
        postAddingTimer = 0;
    }

    // Generate obstacle 1 based on the elevation
    for (int i = 0; i < currElevation - ravineDepth; i++) {
        worldFraction[i] = '1';
    }

    // Generate obstacle 1 for ceiling if in cave
    if (inCave) {
        for (int i = worldHeight - 1; i > currElevation + caveHeight; i--) {
            worldFraction[i] = '1';
        }
    }

    // Put the generated fraction
    world.push_back(worldFraction);
}

// Print worldnya
void showWorld() {
    for (int i = world[0].size() - 1; i >= 0; i--) {
        for (int j = 0; j < world.size(); j++) {
            if (world[j][i] == '0') {
                cout << " "; // Air
            }
            else if (world[j][i] == '1') {
                cout << "O"; // Block
            }
            else if (world[j][i] == '2') {
                cout << "X"; // Spike
            }
        }

        cout << endl;
    }
}

// Buat initialize worldnya biar empty alias ada ruang buat start
void initializeEmptyAir() {
    for (int i = 0; i < worldHeight; i++) {
        worldFraction.push_back('0');
    }

    for (int i = 0; i < worldLength; i++) {
        world.push_back(worldFraction);
    }
}

int main()
{
    int distance = 0;
    char x;

    initializeEmptyAir();

    do
    {
        system("cls");
        showWorld();
        
        cout << "Distance: " << distance << endl;
        cout << "Press \'Enter\' to generate, press \'e\' and \'Enter\' to stop!";
        x = cin.get();

        updateWorld();
        distance++;
    }
    while (x != 'e');
}
