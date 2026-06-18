// Sample class
class Sample {
  // FIELDS
  ArrayList<Integer> cutSites;
  ArrayList<String> fragments;
  ArrayList<Integer> bandSizes;

  boolean filled;

  float x_pos, y_pos;
  
  PImage rackImg;

  String dnaSequence;
  String type;

  Cat cat;

  // CONSTRUCTOR
  Sample(float x, float y) {
    filled = false;
    x_pos = x;
    y_pos = y;
    cat = null;
   
    cutSites = new ArrayList<Integer>();
    fragments = new ArrayList<String>();
    bandSizes = new ArrayList<Integer>();
  }
  // METHODS
  
  // method to draw the sample depending on it's state.
  void drawRack() {
    if (this.filled == false) {
      // only the rack
      rackImg = loadImage("holder_1.png"); 
    }
    else {
      // test tube on a rack
      rackImg = loadImage("holder_2.png");      
    }
    
    // draw the image
    image(rackImg, this.x_pos, this.y_pos, 175, 250);     
  }

  // method for animation step #1
  void drawDNA(float x, float y) {
    fill(255);
    textAlign(LEFT);
    
    // draw the full DNA sequence on screen
    text(dnaSequence, x, y);

  }

  // method for animation step #3
  void drawCutSites(float x, float y) {
    fill(255);
    textAlign(LEFT);
    noStroke();

    float currentX = x;
    
    // for each DNA base
    for (int i = 0; i < dnaSequence.length(); i++) {
     
      // check if a restriction cut occurs at the current DNA base
      if (cutSites.contains(i) && i > 0) {
        
        // draw a red vertical line to show a cut made by the restriction enzyme
        float lineX = currentX + 20;

        stroke(255, 0, 0);
        strokeWeight(3);
        line(currentX + 20, y - 15, lineX, y + 5);
        noStroke();
        
        // the x position of the base increments by the spacing between the cut line
        currentX += 40;
      }

      // Use charAt to get the individual character letter at index i and convert it to a string
      String base = String.valueOf(dnaSequence.charAt(i));
      
      // draw the base on screen
      text(base, currentX, y);
      
      // increment x again by the width of the character
      currentX += textWidth(base); 
    }
    
    strokeWeight(1);
  }

  // method for animation step #4
  void drawFragmentLabels(float x, float y) {  
    fill(0, 0, 230);  
    textAlign(LEFT);
    noStroke();
  
    float currentX = x;

    // run through all the fragments
    for (int i = 0; i < fragments.size(); i++) {
      
      // label the fragment using its index
      String label = "Frag " + (i + 1);
      
      // draw the text label
      text(label, currentX, y);
  
      // set the x position of the next label
      currentX += textWidth(fragments.get(i)) + 50;
    }
  }
  
  // this function populates the band sizes integer array list (fragments) using an enzyme
  void generateBands(Enzyme enzyme) {
    bandSizes = enzyme.getFragments(dnaSequence);
    
    // populate the fragments array list so the results don't pull blank/0 data
    fragments = enzyme.digest(dnaSequence);
  }
}
