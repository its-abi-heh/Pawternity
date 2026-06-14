class Sample {

  boolean filled;
  float x_pos, y_pos;
  PImage rackImg;

  String dnaSequence;
  String type;

  ArrayList<Integer> cutSites;
  ArrayList<String> fragments;

  Cat cat;

  Sample(float x, float y) {
    filled = false;
    x_pos = x;
    y_pos = y;
    cat = null;
    cutSites = new ArrayList<Integer>();
    fragments = new ArrayList<String>();
  }

  void drawRack() {
    rackImg = loadImage(filled ? "holder_2.png" : "holder_1.png");
    image(rackImg, x_pos, y_pos, 175, 300);
  }

  // LINE 1: Full raw DNA sequence string (unbroken)
  void drawDNA(float x, float y) {
    if (dnaSequence == null) return;
    fill(255);
    textAlign(LEFT);
    text(dnaSequence, x, y);
  }

  // LINE 2: DNA bases pushed apart with empty spacing AND red lines at cuts
  void drawCutSites(float x, float y) {
    if (dnaSequence == null) return;
    
    fill(255);
    textAlign(LEFT);
    noStroke();

    float currentX = x;
    float cutGapping = 40.0; // Dynamic space added right inside the cut zone!

    for (int i = 0; i < dnaSequence.length(); i++) {
      // Check if a restriction cut happens BEFORE drawing this character
      if (cutSites.contains(i) && i > 0) {
        
        // Draw the red vertical line centered right in the middle of our new extra space gap
        stroke(255, 0, 0);
        strokeWeight(3);
        float lineX = currentX + (cutGapping / 2.0);
        line(lineX, y - 15, lineX, y + 5);
        noStroke(); // Turn off strokes to draw text again
        
        currentX += cutGapping; // Push coordinate out by the gap size
      }

      // Draw the single character base letter
      String base = String.valueOf(dnaSequence.charAt(i));
      text(base, currentX, y);
      currentX += textWidth(base); // Increment by width of character
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

  // LINE 4: NEW! Number labels placed cleanly underneath each fragment on line 3
  void drawFragmentLabels(float x, float y) {
    if (fragments == null || fragments.isEmpty()) return;

    fill(150, 150, 150); // Muted gray color for labels
    textAlign(LEFT);
    noStroke();

    float currentX = x;
    float fragmentSpacing = 50.0; // MUST match Line 3 spacing exactly!

    for (int i = 0; i < fragments.size(); i++) {
      String frag = fragments.get(i);
      String label = "Frag " + (i + 1); // Label numbers start at 1 (Frag 1, Frag 2...)
      
      text(label, currentX, y);
      currentX += textWidth(frag) + fragmentSpacing; // Moves down using sequence width
    }
  }
}
