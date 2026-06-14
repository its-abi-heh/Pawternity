class Sample {
  boolean filled;
  float x_pos, y_pos;
  PImage rackImg;
  String[] dnaSequence;
  String type;
  Cat cat;
  
  Sample(float x, float y) {
    this.filled = false;
    this.x_pos = x;
    this.y_pos = y;
    this.cat = null;
  }
  
  void drawRack() {
    if (this.filled == false) {
      rackImg = loadImage("holder_1.png"); 
    }
    else {
      rackImg = loadImage("holder_2.png");      
    }
    
    image(rackImg, this.x_pos, this.y_pos, 175, 300);     
  }
}
