class Sample {

  boolean filled;
  float x_pos, y_pos;
  PImage rackImg;

  String dnaSequence;
  String type;
  ArrayList<Integer> cutSites;
  ArrayList<String> fragments;
  ArrayList<Integer> bandSizes;

  Cat cat;

  Sample(float x, float y) {
    filled = false;
    x_pos = x;
    y_pos = y;
    cat = null;
    cutSites = new ArrayList<Integer>();
    fragments = new ArrayList<String>();
    bandSizes = new ArrayList<Integer>();

  }

  void drawRack() {
    if (this.filled == false) {
      rackImg = loadImage("holder_1.png"); 
    }
    else {
      rackImg = loadImage("holder_2.png");      
    }
    
    image(rackImg, this.x_pos, this.y_pos, 175, 250);     
  }


  // first draw full DNA sequence
  void drawDNA(float x, float y) {
    if (dnaSequence == null) return;
    fill(255);
    textAlign(LEFT);
    text(dnaSequence, x, y);
  }

  // show red lines between cut fragments
  void drawCutSites(float x, float y) {
    if (dnaSequence == null) return;
    
    fill(255);
    textAlign(LEFT);
    noStroke();

    float currentX = x;
    float cutGapping = 40;

    for (int i = 0; i < dnaSequence.length(); i++) {
      // Check if a restriction cut occurs
      if (cutSites.contains(i) && i > 0) {
        
        // Draw the red vertical line centered at a cut
        stroke(255, 0, 0);
        strokeWeight(3);
        float lineX = currentX + (cutGapping / 2);
        line(lineX, y - 15, lineX, y + 5);
        noStroke();
        
        currentX += cutGapping;
      }

      // draw the base
      String base = String.valueOf(dnaSequence.charAt(i));
      text(base, currentX, y);
      currentX += textWidth(base); 
    }
    strokeWeight(1);
  }

  void drawFragments(float x, float y) {

    if (dnaSequence == null) return;
  
    float currentX = x;
    float cutGap = 40;
  
    ArrayList<Integer> allCuts = new ArrayList<Integer>();
    allCuts.add(0);
  
    for (int c : cutSites) {
      allCuts.add(c);
    }
  
    allCuts.add(dnaSequence.length());
  
    for (int i = 0; i < allCuts.size() - 1; i++) {
  
      int start = allCuts.get(i);
      int end = allCuts.get(i + 1);
  
      float segmentWidth = 0;
  
      for (int j = start; j < end; j++) {
        segmentWidth += textWidth("" + dnaSequence.charAt(j));
      }
  
      fill(100, 200, 255);
      noStroke();
      rect(currentX, y - 15, segmentWidth, 25);
  
      fill(0);
      textAlign(LEFT);
  
      float tx = currentX;
  
      for (int j = start; j < end; j++) {
        String base = "" + dnaSequence.charAt(j);
        text(base, tx, y);
        tx += textWidth(base);
      }
  
      currentX += segmentWidth + cutGap;
    }
  }

  // label fragments
  void drawFragmentLabels(float x, float y) {
    if (fragments == null || fragments.isEmpty()) return;

    fill(0);
    textAlign(LEFT);
    noStroke();

    float currentX = x;
    float fragmentSpacing = 50;

    for (int i = 0; i < fragments.size(); i++) {
      String frag = fragments.get(i);
      String label = "Frag " + (i + 1);
      
      text(label, currentX, y);
      currentX += textWidth(frag) + fragmentSpacing;
    }
  }
    
  void generateBands(Enzyme enzyme) {
  
    bandSizes = enzyme.getFragments(dnaSequence);
  }
}
