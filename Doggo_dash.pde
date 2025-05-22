// Main gameplay loop
final float squareWidth = 50;            // Player sprite size
PImage img;                              // Player image
ArrayList<ObstacleBase> obstacles;      // Holds all obstacle types
Player player;
float sprintGround;                      // 75% down the screen
float speed = 4;                         // Scroll speed
int GAME_STATE;
final int GAME_START = 1, GAME_RUN = 2, DIE = 3;

void setup() {
  size(1600,900);
  img = loadImage("sahur.jpg");
  img.resize((int)squareWidth,(int)squareWidth);
  
  player = new Player(width/4, 0, img);
  sprintGround = height * 0.75;
  
  obstacles = new ArrayList<ObstacleBase>();
  createObstacles();
  GAME_STATE = GAME_RUN;
}

void draw(){
  switch(GAME_STATE){
    case GAME_RUN:
      background(200);
      stroke(0);
      line(0, sprintGround, width, sprintGround);
      
      player.update();
      player.display();
      
      for(int i=obstacles.size()-1; i>=0; i--){
        ObstacleBase o = obstacles.get(i);
        o.update();
        o.display();
        
        // unified collision call
        if(o.checkCollision(player)){
          GAME_STATE = DIE;
          noLoop();
        }
        
        // recycle when offscreen
        if(o.x < -100){
          // remember type, then respawn same type at right edge
          if(o instanceof Obstacle1) {
            obstacles.add(new Obstacle1(width, sprintGround));
          } 
          else if(o instanceof Obstacle2) {
            obstacles.add(new Obstacle2(width, sprintGround));
          }
          else if(o instanceof Obstacle3) {
            obstacles.add(new Obstacle3(width, sprintGround));
          }
          obstacles.remove(i);
        }
      }
      break;
      
    case DIE:
      println("Game Over!");
      // wait for 'r' to restart
      break;
  }
}

void keyPressed(){
  // only gate by isJumping—landing logic resets that flag
  if(key==' ' && !player.isJumping){
    player.jump();
  }
  if(key=='r' && GAME_STATE==DIE){
    resetGame();
  }
}

void resetGame(){
  player.reset();
  obstacles.clear();
  createObstacles();
  GAME_STATE = GAME_RUN;
  loop();
}

void createObstacles(){
  // three spikes
  for(int i=0; i<3; i++){
    obstacles.add(new Obstacle1(width + i*800, sprintGround));
  }
  // three solid blocks
  for(int i=0; i<3; i++){
    obstacles.add(new Obstacle2(width + 400 + i*800, sprintGround));
  }
  // three one-way platforms
  for(int i=0; i<3; i++){
    obstacles.add(new Obstacle3(width + 200 + i*800, sprintGround));
  }
}
