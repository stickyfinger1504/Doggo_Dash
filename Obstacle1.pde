class Obstacle1 extends ObstacleBase {
  float triW = 80, triH = 80;
  float hitW = 50, hitH = 20;
  
  Obstacle1(float x, float y) {
    super(x,y);
  }
  
  void display() {
    fill(255,0,0);
    noStroke();
    beginShape();
      vertex(x,          y - triH);
      vertex(x + triW/2, y       );
      vertex(x - triW/2, y       );
    endShape(CLOSE);
  }
  
  boolean checkCollision(Player p) {
    float halfW = hitW/2, halfH = hitH/2;
    float cx = x, cy = y - halfH;
    float left   = cx - halfW, right = cx + halfW;
    float top    = cy - halfH, bottom= cy + halfH;
    float pLeft   = p.x - p.hw, pRight = p.x + p.hw;
    float pTop    = p.y - p.hh, pBottom= p.y + p.hh;
    
    return (pRight>left && pLeft<right &&
            pBottom>top && pTop<bottom);
  }
}
